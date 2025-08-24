import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:patient_tracker_flutter/models/patient.dart';
import 'package:patient_tracker_flutter/models/progress_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'patient_tracker.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int version) async {
    // Create patients table
    await db.execute('''
      CREATE TABLE patients(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        weight REAL NOT NULL,
        address TEXT,
        phoneNumber TEXT,
        registrationDate INTEGER NOT NULL,
        selectedAssessmentScale TEXT NOT NULL,
        shoulderROM REAL DEFAULT 0.0,
        kneeROM REAL DEFAULT 0.0,
        elbowROM REAL DEFAULT 0.0,
        hipROM REAL DEFAULT 0.0
      )
    ''');

    // Create progress_entries table
    await db.execute('''
      CREATE TABLE progress_entries(
        id TEXT PRIMARY KEY,
        patientId TEXT NOT NULL,
        date INTEGER NOT NULL,
        selectedAssessmentScale TEXT NOT NULL,
        shoulderROM REAL DEFAULT 0.0,
        kneeROM REAL DEFAULT 0.0,
        elbowROM REAL DEFAULT 0.0,
        hipROM REAL DEFAULT 0.0,
        notes TEXT,
        FOREIGN KEY (patientId) REFERENCES patients (id) ON DELETE CASCADE
      )
    ''');
  }

  // Patient CRUD operations
  Future<bool> insertPatient(Patient patient) async {
    try {
      Database db = await database;
      int result = await db.insert('patients', patient.toMap());
      return result > 0;
    } catch (e) {
      print('Error inserting patient: $e');
      return false;
    }
  }

  Future<List<Patient>> getAllPatients() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'patients',
      orderBy: 'registrationDate DESC',
    );

    return List.generate(maps.length, (i) {
      return Patient.fromMap(maps[i]);
    });
  }

  Future<Patient?> getPatient(String id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Patient.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Patient>> searchPatients(String query) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'patients',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'registrationDate DESC',
    );

    return List.generate(maps.length, (i) {
      return Patient.fromMap(maps[i]);
    });
  }

  Future<bool> updatePatient(Patient patient) async {
    try {
      Database db = await database;
      int result = await db.update(
        'patients',
        patient.toMap(),
        where: 'id = ?',
        whereArgs: [patient.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating patient: $e');
      return false;
    }
  }

  Future<bool> deletePatient(String id) async {
    try {
      Database db = await database;
      // Delete all associated progress entries first
      await db.delete(
        'progress_entries',
        where: 'patientId = ?',
        whereArgs: [id],
      );
      
      // Then delete the patient
      int result = await db.delete(
        'patients',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting patient: $e');
      return false;
    }
  }

  // ProgressEntry CRUD operations
  Future<bool> insertProgressEntry(ProgressEntry progressEntry) async {
    try {
      Database db = await database;
      int result = await db.insert('progress_entries', progressEntry.toMap());
      return result > 0;
    } catch (e) {
      print('Error inserting progress entry: $e');
      return false;
    }
  }

  Future<List<ProgressEntry>> getProgressEntriesForPatient(String patientId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'progress_entries',
      where: 'patientId = ?',
      whereArgs: [patientId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return ProgressEntry.fromMap(maps[i]);
    });
  }

  Future<bool> updateProgressEntry(ProgressEntry progressEntry) async {
    try {
      Database db = await database;
      int result = await db.update(
        'progress_entries',
        progressEntry.toMap(),
        where: 'id = ?',
        whereArgs: [progressEntry.id],
      );
      return result > 0;
    } catch (e) {
      print('Error updating progress entry: $e');
      return false;
    }
  }

  Future<bool> deleteProgressEntry(String id) async {
    try {
      Database db = await database;
      int result = await db.delete(
        'progress_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting progress entry: $e');
      return false;
    }
  }

  // Get patient count
  Future<int> getPatientCount() async {
    Database db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM patients'));
    return count ?? 0;
  }

  // Get progress entries count for a patient
  Future<int> getProgressEntriesCount(String patientId) async {
    Database db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM progress_entries WHERE patientId = ?', [patientId])
    );
    return count ?? 0;
  }

  // Close database
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
