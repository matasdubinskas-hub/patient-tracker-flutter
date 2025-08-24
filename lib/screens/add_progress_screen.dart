import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:patient_tracker_flutter/models/patient.dart';
import 'package:patient_tracker_flutter/models/progress_entry.dart';
import 'package:patient_tracker_flutter/providers/patient_provider.dart';
import 'package:patient_tracker_flutter/providers/assessment_scales_provider.dart';

class AddProgressScreen extends StatefulWidget {
  final Patient patient;
  
  const AddProgressScreen({super.key, required this.patient});

  @override
  State<AddProgressScreen> createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shoulderROMController = TextEditingController();
  final _kneeROMController = TextEditingController();
  final _elbowROMController = TextEditingController();
  final _hipROMController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedAssessmentScale = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scalesProvider = Provider.of<AssessmentScalesProvider>(context, listen: false);
      _selectedAssessmentScale = widget.patient.selectedAssessmentScale.isNotEmpty 
        ? widget.patient.selectedAssessmentScale 
        : scalesProvider.defaultScale;
    });
  }

  @override
  void dispose() {
    _shoulderROMController.dispose();
    _kneeROMController.dispose();
    _elbowROMController.dispose();
    _hipROMController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Progress'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProgress,
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
            _buildPatientInfoCard(),
            const SizedBox(height: 16),
            _buildProgressDateCard(),
            const SizedBox(height: 16),
            _buildAssessmentScaleCard(),
            const SizedBox(height: 16),
            _buildRangeOfMotionCard(),
            const SizedBox(height: 16),
            _buildNotesCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Card(
      color: Colors.blue.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Text(
                widget.patient.name.isNotEmpty 
                  ? widget.patient.name[0].toUpperCase()
                  : '?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.patient.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Adding progress entry',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.trending_up,
              color: Colors.green,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDateCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Date',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.event),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentScaleCard() {
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
                if (!scalesProvider.hasScale(_selectedAssessmentScale) && scalesProvider.availableScales.isNotEmpty) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildRangeOfMotionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Range of Motion Updates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter new measurements to track progress',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            
            // Show baseline values for reference
            if (_hasBaselineROM()) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          'Baseline Values',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [
                        if (widget.patient.shoulderROM > 0) 
                          _buildBaselineChip('Shoulder', widget.patient.shoulderROM),
                        if (widget.patient.kneeROM > 0) 
                          _buildBaselineChip('Knee', widget.patient.kneeROM),
                        if (widget.patient.elbowROM > 0) 
                          _buildBaselineChip('Elbow', widget.patient.elbowROM),
                        if (widget.patient.hipROM > 0) 
                          _buildBaselineChip('Hip', widget.patient.hipROM),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // ROM input fields
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

  Widget _buildNotesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Optional - Add observations, treatment notes, or comments',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter notes about progress, observations, or treatment...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaselineChip(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        '$label: ${value.toStringAsFixed(0)}°',
        style: TextStyle(
          fontSize: 11,
          color: Colors.blue[700],
          fontWeight: FontWeight.w500,
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

  bool _hasBaselineROM() {
    return widget.patient.shoulderROM > 0 ||
           widget.patient.kneeROM > 0 ||
           widget.patient.elbowROM > 0 ||
           widget.patient.hipROM > 0;
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

  void _saveProgress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if at least one ROM value or notes is provided
    final hasROMValue = _shoulderROMController.text.isNotEmpty ||
                       _kneeROMController.text.isNotEmpty ||
                       _elbowROMController.text.isNotEmpty ||
                       _hipROMController.text.isNotEmpty;
    
    final hasNotes = _notesController.text.trim().isNotEmpty;

    if (!hasROMValue && !hasNotes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one ROM value or add notes.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final progressEntry = ProgressEntry(
        id: const Uuid().v4(),
        patientId: widget.patient.id,
        date: _selectedDate,
        selectedAssessmentScale: _selectedAssessmentScale,
        shoulderROM: double.tryParse(_shoulderROMController.text) ?? 0.0,
        kneeROM: double.tryParse(_kneeROMController.text) ?? 0.0,
        elbowROM: double.tryParse(_elbowROMController.text) ?? 0.0,
        hipROM: double.tryParse(_hipROMController.text) ?? 0.0,
        notes: _notesController.text.trim(),
      );

      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      final success = await patientProvider.addProgressEntry(progressEntry);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Progress entry added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add progress entry. Please try again.'),
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
