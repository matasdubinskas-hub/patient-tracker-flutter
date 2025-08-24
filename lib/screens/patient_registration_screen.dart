import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:patient_tracker_flutter/models/patient.dart';
import 'package:patient_tracker_flutter/providers/patient_provider.dart';
import 'package:patient_tracker_flutter/providers/assessment_scales_provider.dart';
import 'package:patient_tracker_flutter/screens/assessment_scales_editor_screen.dart';

class PatientRegistrationScreen extends StatefulWidget {
  final Patient? patient; // For editing existing patient
  
  const PatientRegistrationScreen({super.key, this.patient});

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shoulderROMController = TextEditingController();
  final _kneeROMController = TextEditingController();
  final _elbowROMController = TextEditingController();
  final _hipROMController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedAssessmentScale = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final scalesProvider = Provider.of<AssessmentScalesProvider>(context, listen: false);
    _selectedAssessmentScale = scalesProvider.defaultScale;
    
    // If editing existing patient, populate form
    if (widget.patient != null) {
      final patient = widget.patient!;
      _nameController.text = patient.name;
      _ageController.text = patient.age.toString();
      _weightController.text = patient.weight.toString();
      _addressController.text = patient.address;
      _phoneController.text = patient.phoneNumber;
      _selectedDate = patient.registrationDate;
      _selectedAssessmentScale = patient.selectedAssessmentScale;
      
      if (patient.shoulderROM > 0) _shoulderROMController.text = patient.shoulderROM.toString();
      if (patient.kneeROM > 0) _kneeROMController.text = patient.kneeROM.toString();
      if (patient.elbowROM > 0) _elbowROMController.text = patient.elbowROM.toString();
      if (patient.hipROM > 0) _hipROMController.text = patient.hipROM.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _shoulderROMController.dispose();
    _kneeROMController.dispose();
    _elbowROMController.dispose();
    _hipROMController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient != null ? 'Edit Patient' : 'New Patient'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _savePatient,
            child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildPersonalInfoSection(),
            const SizedBox(height: 24),
            _buildAssessmentScaleSection(),
            const SizedBox(height: 24),
            _buildRangeOfMotionSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Registration Date
            _buildDateField(),
            const SizedBox(height: 16),
            
            // Name
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the patient\'s name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Age and Weight in a row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age *',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(),
                      suffixText: 'years',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age <= 0 || age > 150) {
                        return 'Invalid age';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Weight *',
                      prefixIcon: Icon(Icons.monitor_weight_outlined),
                      border: OutlineInputBorder(),
                      suffixText: 'kg',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Address
            TextFormField(
              controller: _addressController,
              textCapitalization: TextCapitalization.words,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Phone Number
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Registration Date',
          prefixIcon: Icon(Icons.event),
          border: OutlineInputBorder(),
        ),
        child: Text(
          DateFormat('MMM dd, yyyy').format(_selectedDate),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildAssessmentScaleSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assessment Scale',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Consumer<AssessmentScalesProvider>(
              builder: (context, scalesProvider, child) {
                if (!scalesProvider.hasScale(_selectedAssessmentScale)) {
                  _selectedAssessmentScale = scalesProvider.defaultScale;
                }
                
                return DropdownButtonFormField<String>(
                  value: _selectedAssessmentScale.isEmpty ? null : _selectedAssessmentScale,
                  decoration: const InputDecoration(
                    labelText: 'Select Assessment Scale',
                    prefixIcon: Icon(Icons.assessment_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: scalesProvider.availableScales.map((scale) {
                    return DropdownMenuItem(
                      value: scale,
                      child: Text(scale),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedAssessmentScale = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an assessment scale';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            
            TextButton.icon(
              onPressed: () => _navigateToScalesEditor(),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Manage Assessment Scales'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeOfMotionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Range of Motion (degrees)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Optional - Leave empty if not measured',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            
            // ROM fields in a grid
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildROMField('Shoulder', _shoulderROMController, Icons.accessibility_new)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildROMField('Knee', _kneeROMController, Icons.accessibility)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildROMField('Elbow', _elbowROMController, Icons.pan_tool_outlined)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildROMField('Hip', _hipROMController, Icons.directions_walk)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildROMField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        suffixText: '°',
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final rom = double.tryParse(value);
          if (rom == null || rom < 0 || rom > 360) {
            return 'Invalid';
          }
        }
        return null;
      },
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _navigateToScalesEditor() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AssessmentScalesEditorScreen(),
      ),
    );
    setState(() {}); // Refresh to update dropdown
  }

  void _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final patient = Patient(
        id: widget.patient?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        registrationDate: _selectedDate,
        selectedAssessmentScale: _selectedAssessmentScale,
        shoulderROM: double.tryParse(_shoulderROMController.text) ?? 0.0,
        kneeROM: double.tryParse(_kneeROMController.text) ?? 0.0,
        elbowROM: double.tryParse(_elbowROMController.text) ?? 0.0,
        hipROM: double.tryParse(_hipROMController.text) ?? 0.0,
      );

      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      bool success;
      
      if (widget.patient != null) {
        success = await patientProvider.updatePatient(patient);
      } else {
        success = await patientProvider.addPatient(patient);
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.patient != null 
                  ? 'Patient updated successfully!' 
                  : 'Patient registered successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save patient. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
