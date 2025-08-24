import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:patient_tracker_flutter/providers/patient_provider.dart';
import 'package:patient_tracker_flutter/screens/patient_registration_screen.dart';
import 'package:patient_tracker_flutter/screens/patient_library_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // App Header
              const SizedBox(height: 40),
              _buildAppHeader(),
              
              const SizedBox(height: 60),
              
              // Main Action Buttons
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      context: context,
                      title: 'Register New Patient',
                      subtitle: 'Add a new patient to the system',
                      icon: Icons.person_add_rounded,
                      color: Colors.blue,
                      onTap: () => _navigateToRegistration(context),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildActionButton(
                      context: context,
                      title: 'Patient Library',
                      subtitle: 'Browse and search existing patients',
                      icon: Icons.folder_open_rounded,
                      color: Colors.green,
                      onTap: () => _navigateToLibrary(context),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Statistics Row
              Consumer<PatientProvider>(
                builder: (context, patientProvider, child) {
                  return FutureBuilder<int>(
                    future: patientProvider.getTotalPatientCount(),
                    builder: (context, snapshot) {
                      final patientCount = snapshot.data ?? 0;
                      return _buildStatisticsRow(patientCount);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.health_and_safety_rounded,
            size: 40,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Patient Tracker',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Physiotherapy Progress Management',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsRow(int patientCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$patientCount patient${patientCount == 1 ? '' : 's'} registered',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToRegistration(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PatientRegistrationScreen(),
      ),
    );
  }

  void _navigateToLibrary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PatientLibraryScreen(),
      ),
    );
  }
}
