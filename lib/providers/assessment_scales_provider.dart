import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssessmentScalesProvider extends ChangeNotifier {
  List<String> _availableScales = [
    "Lovett's Scale",
    "Modified Ashworth Scale",
    "Berg Balance Scale",
  ];

  static const String _scalesKey = 'assessment_scales';

  List<String> get availableScales => _availableScales;

  AssessmentScalesProvider() {
    _loadScales();
  }

  Future<void> _loadScales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedScales = prefs.getStringList(_scalesKey);
      
      if (savedScales != null && savedScales.isNotEmpty) {
        _availableScales = savedScales;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading assessment scales: $e');
    }
  }

  Future<void> _saveScales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_scalesKey, _availableScales);
    } catch (e) {
      debugPrint('Error saving assessment scales: $e');
    }
  }

  Future<void> addScale(String scale) async {
    if (scale.trim().isEmpty || _availableScales.contains(scale)) {
      return;
    }
    
    _availableScales.add(scale.trim());
    await _saveScales();
    notifyListeners();
  }

  Future<void> removeScale(String scale) async {
    _availableScales.remove(scale);
    await _saveScales();
    notifyListeners();
  }

  Future<void> updateScale(int index, String newScale) async {
    if (index < 0 || index >= _availableScales.length || newScale.trim().isEmpty) {
      return;
    }
    
    _availableScales[index] = newScale.trim();
    await _saveScales();
    notifyListeners();
  }

  String get defaultScale => _availableScales.isNotEmpty ? _availableScales.first : '';

  bool hasScale(String scale) => _availableScales.contains(scale);

  Future<void> resetToDefault() async {
    _availableScales = [
      "Lovett's Scale",
      "Modified Ashworth Scale",
      "Berg Balance Scale",
    ];
    await _saveScales();
    notifyListeners();
  }
}
