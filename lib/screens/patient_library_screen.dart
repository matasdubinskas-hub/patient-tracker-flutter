import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:patient_tracker_flutter/models/patient.dart';
import 'package:patient_tracker_flutter/providers/patient_provider.dart';
import 'package:patient_tracker_flutter/screens/patient_detail_screen.dart';

class PatientLibraryScreen extends StatefulWidget {
  const PatientLibraryScreen({super.key});

  @override
  State<PatientLibraryScreen> createState() => _PatientLibraryScreenState();
}

class _PatientLibraryScreenState extends State<PatientLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false).refresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Library'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          if (patientProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final patients = patientProvider.filteredPatients;

          if (patients.isEmpty) {
            return _buildEmptyState(patientProvider.searchQuery.isNotEmpty);
          }

          return RefreshIndicator(
            onRefresh: () => patientProvider.refresh(),
            child: Column(
              children: [
                _buildResultsHeader(patients.length, patientProvider.searchQuery.isNotEmpty),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      return _buildPatientCard(patients[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Consumer<PatientProvider>(
      builder: (context, patientProvider, child) {
        return TextField(
          controller: _searchController,
          onChanged: (value) => patientProvider.setSearchQuery(value),
          decoration: InputDecoration(
            hintText: 'Search patients...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      patientProvider.clearSearch();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
        );
      },
    );
  }

  Widget _buildResultsHeader(int count, bool isSearching) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '$count patient${count == 1 ? '' : 's'}',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!isSearching) ...[
            const Spacer(),
            Text(
              'Sorted by most recent',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.people_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              isSearching ? 'No Patients Found' : 'No Patients Registered',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'Try adjusting your search terms'
                  : 'Register your first patient to get started',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (!isSearching) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.add),
                label: const Text('Register Patient'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToPatientDetail(patient),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(
                              icon: Icons.person_outline,
                              label: '${patient.age} years',
                            ),
                            const SizedBox(width: 12),
                            _buildInfoChip(
                              icon: Icons.monitor_weight_outlined,
                              label: '${patient.weight.toStringAsFixed(1)} kg',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Registered',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM dd, yyyy').format(patient.registrationDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (patient.selectedAssessmentScale.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        patient.selectedAssessmentScale,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const Spacer(),
                  FutureBuilder<int>(
                    future: Provider.of<PatientProvider>(context, listen: false)
                        .getProgressEntriesCount(patient.id),
                    builder: (context, snapshot) {
                      final progressCount = snapshot.data ?? 0;
                      if (progressCount > 0) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 14,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$progressCount entr${progressCount == 1 ? 'y' : 'ies'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              
              // Show ROM data if available
              if (_hasROMData(patient)) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    if (patient.shoulderROM > 0)
                      _buildROMChip('Shoulder', patient.shoulderROM),
                    if (patient.kneeROM > 0)
                      _buildROMChip('Knee', patient.kneeROM),
                    if (patient.elbowROM > 0)
                      _buildROMChip('Elbow', patient.elbowROM),
                    if (patient.hipROM > 0)
                      _buildROMChip('Hip', patient.hipROM),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildROMChip(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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

  bool _hasROMData(Patient patient) {
    return patient.shoulderROM > 0 ||
           patient.kneeROM > 0 ||
           patient.elbowROM > 0 ||
           patient.hipROM > 0;
  }

  void _navigateToPatientDetail(Patient patient) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PatientDetailScreen(patient: patient),
      ),
    );
  }
}
