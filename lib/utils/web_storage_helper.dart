import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:patient_tracker_flutter/models/patient.dart';
import 'package:patient_tracker_flutter/models/progress_entry.dart';

class WebStorageHelper {
  static const String _patientsKey = 'patients_data';
  static const String _progressKey = 'progress_data';

  // Patient operations
  static Future<List<Patient>> getAllPatients() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patientsJson = prefs.getStringList(_patientsKey) ?? [];
      
      return patientsJson.map((jsonStr) {
        final Map<String, dynamic> map = json.decode(jsonStr);
        return Patient.fromMap(map);
      }).toList()
      ..sort((a, b) => b.registrationDate.compareTo(a.registrationDate));
    } catch (e) {
      print('Error loading patients from web storage: $e');
      return [];
    }
  }

  static Future<bool> insertPatient(Patient patient) async {
    try {
      final patients = await getAllPatients();
      patients.add(patient);
      return await _savePatients(patients);
    } catch (e) {
      print('Error inserting patient: $e');
      return false;
    }
  }

  static Future<bool> updatePatient(Patient patient) async {
    try {
      final patients = await getAllPatients();
      final index = patients.indexWhere((p) => p.id == patient.id);
      if (index != -1) {
        patients[index] = patient;
        return await _savePatients(patients);
      }
      return false;
    } catch (e) {
      print('Error updating patient: $e');
      return false;
    }
  }

  static Future<bool> deletePatient(String patientId) async {
    try {
      final patients = await getAllPatients();
      patients.removeWhere((p) => p.id == patientId);
      
      // Also delete associated progress entries
      final progressEntries = await getAllProgressEntries();
      progressEntries.removeWhere((entry) => entry.patientId == patientId);
      await _saveProgressEntries(progressEntries);
      
      return await _savePatients(patients);
    } catch (e) {
      print('Error deleting patient: $e');
      return false;
    }
  }

  static Future<Patient?> getPatient(String patientId) async {
    try {
      final patients = await getAllPatients();
      return patients.firstWhere(
        (patient) => patient.id == patientId,
        orElse: () => throw StateError('Patient not found'),
      );
    } catch (e) {
      print('Error getting patient: $e');
      return null;
    }
  }

  // Progress entry operations
  static Future<List<ProgressEntry>> getAllProgressEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getStringList(_progressKey) ?? [];
      
      return progressJson.map((jsonStr) {
        final Map<String, dynamic> map = json.decode(jsonStr);
        return ProgressEntry.fromMap(map);
      }).toList();
    } catch (e) {
      print('Error loading progress entries from web storage: $e');
      return [];
    }
  }

  static Future<List<ProgressEntry>> getProgressEntriesForPatient(String patientId) async {
    try {
      final allEntries = await getAllProgressEntries();
      return allEntries
          .where((entry) => entry.patientId == patientId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print('Error loading progress entries for patient: $e');
      return [];
    }
  }

  static Future<bool> insertProgressEntry(ProgressEntry entry) async {
    try {
      final entries = await getAllProgressEntries();
      entries.add(entry);
      return await _saveProgressEntries(entries);
    } catch (e) {
      print('Error inserting progress entry: $e');
      return false;
    }
  }

  static Future<bool> updateProgressEntry(ProgressEntry entry) async {
    try {
      final entries = await getAllProgressEntries();
      final index = entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        entries[index] = entry;
        return await _saveProgressEntries(entries);
      }
      return false;
    } catch (e) {
      print('Error updating progress entry: $e');
      return false;
    }
  }

  static Future<bool> deleteProgressEntry(String entryId) async {
    try {
      final entries = await getAllProgressEntries();
      entries.removeWhere((e) => e.id == entryId);
      return await _saveProgressEntries(entries);
    } catch (e) {
      print('Error deleting progress entry: $e');
      return false;
    }
  }

  // Count operations
  static Future<int> getPatientCount() async {
    final patients = await getAllPatients();
    return patients.length;
  }

  static Future<int> getProgressEntriesCount(String patientId) async {
    final entries = await getProgressEntriesForPatient(patientId);
    return entries.length;
  }

  // Helper methods
  static Future<bool> _savePatients(List<Patient> patients) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final patientsJson = patients.map((patient) {
        return json.encode(patient.toMap());
      }).toList();
      return await prefs.setStringList(_patientsKey, patientsJson);
    } catch (e) {
      print('Error saving patients: $e');
      return false;
    }
  }

  static Future<bool> _saveProgressEntries(List<ProgressEntry> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = entries.map((entry) {
        return json.encode(entry.toMap());
      }).toList();
      return await prefs.setStringList(_progressKey, entriesJson);
    } catch (e) {
      print('Error saving progress entries: $e');
      return false;
    }
  }

  // Clear all data (for testing)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_patientsKey);
    await prefs.remove(_progressKey);
  }
}
