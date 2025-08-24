import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:patient_tracker_flutter/providers/assessment_scales_provider.dart';

class AssessmentScalesEditorScreen extends StatefulWidget {
  const AssessmentScalesEditorScreen({super.key});

  @override
  State<AssessmentScalesEditorScreen> createState() => _AssessmentScalesEditorScreenState();
}

class _AssessmentScalesEditorScreenState extends State<AssessmentScalesEditorScreen> {
  final _newScaleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Scales'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore, size: 20),
                    SizedBox(width: 8),
                    Text('Reset to Default'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<AssessmentScalesProvider>(
        builder: (context, scalesProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildCurrentScalesCard(scalesProvider),
                    const SizedBox(height: 16),
                    _buildAddScaleCard(scalesProvider),
                    const SizedBox(height: 16),
                    _buildInfoCard(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentScalesCard(AssessmentScalesProvider scalesProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assessment_outlined, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Current Assessment Scales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${scalesProvider.availableScales.length} scale${scalesProvider.availableScales.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (scalesProvider.availableScales.isEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assessment_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No assessment scales configured',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              ...scalesProvider.availableScales.asMap().entries.map(
                (entry) => _buildScaleItem(
                  entry.value,
                  entry.key,
                  scalesProvider,
                  entry.key == 0, // First item is default
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScaleItem(String scale, int index, AssessmentScalesProvider scalesProvider, bool isDefault) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: isDefault ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDefault ? Colors.blue : Colors.grey[600],
              ),
            ),
          ),
          title: Text(
            scale,
            style: TextStyle(
              fontWeight: isDefault ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: isDefault 
            ? const Text(
                'Default scale',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
          trailing: scalesProvider.availableScales.length > 1 
            ? IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmDeleteScale(scale, scalesProvider),
                tooltip: 'Delete scale',
              )
            : null,
        ),
      ),
    );
  }

  Widget _buildAddScaleCard(AssessmentScalesProvider scalesProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_circle_outline, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Add New Scale',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _newScaleController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Scale Name',
                        hintText: 'e.g., Manual Muscle Testing',
                        prefixIcon: Icon(Icons.assessment),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a scale name';
                        }
                        if (scalesProvider.availableScales.contains(value.trim())) {
                          return 'This scale already exists';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _addScale(scalesProvider),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _addScale(scalesProvider),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'How Assessment Scales Work',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• Assessment scales help standardize patient evaluations\n'
              '• The first scale in your list is used as the default\n'
              '• Custom scales are saved and available across the app\n'
              '• You can add scales specific to your practice needs\n'
              '• Each progress entry can use a different scale if needed',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.amber, size: 16),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Tip: Keep at least one scale for patient registration',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addScale(AssessmentScalesProvider scalesProvider) {
    if (_formKey.currentState!.validate()) {
      final scaleName = _newScaleController.text.trim();
      scalesProvider.addScale(scaleName);
      _newScaleController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assessment scale "$scaleName" added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _confirmDeleteScale(String scale, AssessmentScalesProvider scalesProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assessment Scale'),
        content: Text('Are you sure you want to delete "$scale"?\n\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteScale(scale, scalesProvider);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteScale(String scale, AssessmentScalesProvider scalesProvider) {
    scalesProvider.removeScale(scale);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assessment scale "$scale" deleted'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'reset':
        _confirmResetScales();
        break;
    }
  }

  void _confirmResetScales() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Default Scales'),
        content: const Text(
          'This will replace all current assessment scales with the default ones:\n\n'
          '• Lovett\'s Scale\n'
          '• Modified Ashworth Scale\n'
          '• Berg Balance Scale\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetScales();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetScales() {
    final scalesProvider = Provider.of<AssessmentScalesProvider>(context, listen: false);
    scalesProvider.resetToDefault();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assessment scales reset to default'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
