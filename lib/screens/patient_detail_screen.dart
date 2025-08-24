import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:patient_tracker_flutter/models/patient.dart';
import 'package:patient_tracker_flutter/models/progress_entry.dart';
import 'package:patient_tracker_flutter/providers/patient_provider.dart';
import 'package:patient_tracker_flutter/screens/patient_registration_screen.dart';
import 'package:patient_tracker_flutter/screens/add_progress_screen.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false)
          .loadProgressForPatient(widget.patient.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit Patient'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'add_progress',
                child: Row(
                  children: [
                    Icon(Icons.add_chart, size: 20),
                    SizedBox(width: 8),
                    Text('Add Progress'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildPatientInfoCard(),
              const SizedBox(height: 16),
              _buildRangeOfMotionCard(),
              const SizedBox(height: 16),
              _buildProgressSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProgress,
        icon: const Icon(Icons.add_chart),
        label: const Text('Add Progress'),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    final dateFormatter = DateFormat('MMM dd, yyyy');
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Text(
                    widget.patient.name.isNotEmpty 
                      ? widget.patient.name[0].toUpperCase()
                      : '?',
                    style: const TextStyle(
                      fontSize: 24,
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Registered: ${dateFormatter.format(widget.patient.registrationDate)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                icon: Icons.person_outline,
                label: 'Age',
                value: '${widget.patient.age} years',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoItem(
                icon: Icons.monitor_weight_outlined,
                label: 'Weight',
                value: '${widget.patient.weight.toStringAsFixed(1)} kg',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                icon: Icons.assessment_outlined,
                label: 'Assessment Scale',
                value: widget.patient.selectedAssessmentScale,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoItem(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: widget.patient.phoneNumber.isEmpty 
                  ? 'Not provided' 
                  : widget.patient.phoneNumber,
              ),
            ),
          ],
        ),
        if (widget.patient.address.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildInfoItem(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: widget.patient.address,
            fullWidth: true,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.blue),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeOfMotionCard() {
    final hasROMData = widget.patient.shoulderROM > 0 ||
                      widget.patient.kneeROM > 0 ||
                      widget.patient.elbowROM > 0 ||
                      widget.patient.hipROM > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Range of Motion',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (!hasROMData) ...[
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.accessibility_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No ROM measurements recorded',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildROMItem('Shoulder', widget.patient.shoulderROM, Icons.accessibility_new)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildROMItem('Knee', widget.patient.kneeROM, Icons.accessibility)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildROMItem('Elbow', widget.patient.elbowROM, Icons.pan_tool_outlined)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildROMItem('Hip', widget.patient.hipROM, Icons.directions_walk)),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildROMItem(String label, double value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value > 0 ? Colors.blue.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value > 0 ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: value > 0 ? Colors.blue : Colors.grey[400],
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value > 0 ? '${value.toStringAsFixed(1)}°' : 'Not measured',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: value > 0 ? Colors.blue : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Consumer<PatientProvider>(
      builder: (context, patientProvider, child) {
        final progressEntries = patientProvider.currentPatientProgress;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Progress History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (progressEntries.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${progressEntries.length} ${progressEntries.length == 1 ? 'entry' : 'entries'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (progressEntries.isEmpty) ...[
                  _buildEmptyProgressState(),
                ] else ...[
                  ...progressEntries.map((entry) => _buildProgressEntryCard(entry)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyProgressState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(
              Icons.timeline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No progress entries yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add the first progress entry to start tracking',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addProgress,
              icon: const Icon(Icons.add),
              label: const Text('Add Progress'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressEntryCard(ProgressEntry entry) {
    final dateFormatter = DateFormat('MMM dd, yyyy');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dateFormatter.format(entry.date),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if (entry.selectedAssessmentScale.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.selectedAssessmentScale,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              
              if (_hasProgressROMData(entry)) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (entry.shoulderROM > 0) _buildProgressROMChip('Shoulder', entry.shoulderROM),
                    if (entry.kneeROM > 0) _buildProgressROMChip('Knee', entry.kneeROM),
                    if (entry.elbowROM > 0) _buildProgressROMChip('Elbow', entry.elbowROM),
                    if (entry.hipROM > 0) _buildProgressROMChip('Hip', entry.hipROM),
                  ],
                ),
              ],
              
              if (entry.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    entry.notes,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressROMChip(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(0)}°',
        style: const TextStyle(
          fontSize: 11,
          color: Colors.orange,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool _hasProgressROMData(ProgressEntry entry) {
    return entry.shoulderROM > 0 ||
           entry.kneeROM > 0 ||
           entry.elbowROM > 0 ||
           entry.hipROM > 0;
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        _editPatient();
        break;
      case 'add_progress':
        _addProgress();
        break;
    }
  }

  void _editPatient() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PatientRegistrationScreen(patient: widget.patient),
      ),
    ).then((_) => _refreshData());
  }

  void _addProgress() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddProgressScreen(patient: widget.patient),
      ),
    ).then((_) => _refreshData());
  }

  Future<void> _refreshData() async {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    await patientProvider.loadProgressForPatient(widget.patient.id);
    await patientProvider.refresh();
  }
}
