import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:patient_tracker_flutter/models/patient.dart';
import 'package:patient_tracker_flutter/models/progress_entry.dart';
import 'package:patient_tracker_flutter/utils/database_helper.dart';
import 'package:patient_tracker_flutter/utils/web_storage_helper.dart';

class PatientProvider with ChangeNotifier {
  List<Patient> _patients = [];
  List<ProgressEntry> _currentPatientProgress = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  // Check if running on web platform
  bool get _isWebPlatform => kIsWeb;

  List<Patient> get patients => _patients;
  List<ProgressEntry> get currentPatientProgress => _currentPatientProgress;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<Patient> get filteredPatients {
    if (_searchQuery.isEmpty) {
      return _patients;
    }
    return _patients.where((patient) {
      return patient.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  PatientProvider() {
    loadPatients();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Load all patients from storage
  Future<void> loadPatients() async {
    _setLoading(true);
    try {
      if (_isWebPlatform) {
        _patients = await WebStorageHelper.getAllPatients();
      } else {
        _patients = await _databaseHelper.getAllPatients();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading patients: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add new patient
  Future<bool> addPatient(Patient patient) async {
    try {
      bool success;
      if (_isWebPlatform) {
        success = await WebStorageHelper.insertPatient(patient);
      } else {
        success = await _databaseHelper.insertPatient(patient);
      }
      
      if (success) {
        await loadPatients(); // Reload to get updated list
      }
      return success;
    } catch (e) {
      debugPrint('Error adding patient: $e');
      return false;
    }
  }

  // Update existing patient
  Future<bool> updatePatient(Patient patient) async {
    try {
      bool success;
      if (_isWebPlatform) {
        success = await WebStorageHelper.updatePatient(patient);
      } else {
        success = await _databaseHelper.updatePatient(patient);
      }
      
      if (success) {
        await loadPatients(); // Reload to get updated list
      }
      return success;
    } catch (e) {
      debugPrint('Error updating patient: $e');
      return false;
    }
  }

  // Delete patient
  Future<bool> deletePatient(String patientId) async {
    try {
      bool success;
      if (_isWebPlatform) {
        success = await WebStorageHelper.deletePatient(patientId);
      } else {
        success = await _databaseHelper.deletePatient(patientId);
      }
      
      if (success) {
        await loadPatients(); // Reload to get updated list
      }
      return success;
    } catch (e) {
      debugPrint('Error deleting patient: $e');
      return false;
    }
  }

  // Get single patient
  Future<Patient?> getPatient(String patientId) async {
    try {
      if (_isWebPlatform) {
        return await WebStorageHelper.getPatient(patientId);
      } else {
        return await _databaseHelper.getPatient(patientId);
      }
    } catch (e) {
      debugPrint('Error getting patient: $e');
      return null;
    }
  }

  // Search patients
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Progress entries methods
  Future<void> loadProgressForPatient(String patientId) async {
    try {
      if (_isWebPlatform) {
        _currentPatientProgress = await WebStorageHelper.getProgressEntriesForPatient(patientId);
      } else {
        _currentPatientProgress = await _databaseHelper.getProgressEntriesForPatient(patientId);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading progress entries: $e');
    }
  }

  Future<bool> addProgressEntry(ProgressEntry progressEntry) async {
    try {
      bool success;
      if (_isWebPlatform) {
        success = await WebStorageHelper.insertProgressEntry(progressEntry);
      } else {
        success = await _databaseHelper.insertProgressEntry(progressEntry);
      }
      
      if (success) {
        await loadProgressForPatient(progressEntry.patientId);
      }
      return success;
    } catch (e) {
      debugPrint('Error adding progress entry: $e');
      return false;
    }
  }

  Future<bool> updateProgressEntry(ProgressEntry progressEntry) async {
    try {
      bool success;
      if (_isWebPlatform) {
        success = await WebStorageHelper.updateProgressEntry(progressEntry);
      } else {
        success = await _databaseHelper.updateProgressEntry(progressEntry);
      }
      
      if (success) {
        await loadProgressForPatient(progressEntry.patientId);
      }
      return success;
    } catch (e) {
      debugPrint('Error updating progress entry: $e');
      return false;
    }
  }

  Future<bool> deleteProgressEntry(String progressEntryId, String patientId) async {
    try {
      bool success;
      if (_isWebPlatform) {
        success = await WebStorageHelper.deleteProgressEntry(progressEntryId);
      } else {
        success = await _databaseHelper.deleteProgressEntry(progressEntryId);
      }
      
      if (success) {
        await loadProgressForPatient(patientId);
      }
      return success;
    } catch (e) {
      debugPrint('Error deleting progress entry: $e');
      return false;
    }
  }

  // Get progress entries count for a patient
  Future<int> getProgressEntriesCount(String patientId) async {
    try {
      if (_isWebPlatform) {
        return await WebStorageHelper.getProgressEntriesCount(patientId);
      } else {
        return await _databaseHelper.getProgressEntriesCount(patientId);
      }
    } catch (e) {
      debugPrint('Error getting progress entries count: $e');
      return 0;
    }
  }

  // Get total patient count
  Future<int> getTotalPatientCount() async {
    try {
      if (_isWebPlatform) {
        return await WebStorageHelper.getPatientCount();
      } else {
        return await _databaseHelper.getPatientCount();
      }
    } catch (e) {
      debugPrint('Error getting patient count: $e');
      return 0;
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await loadPatients();
  }
}
