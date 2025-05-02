// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  
  // Initialize provider from SharedPreferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userEmail = prefs.getString('userEmail');
    notifyListeners();
  }
  
  // Register a new user
  Future<void> register(String email, String password) async {
    // Simulate API call to backend for registration
    await Future.delayed(Duration(seconds: 2));
    
    // If registration is successful, save auth state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userEmail', email);
    
    _isAuthenticated = true;
    _userEmail = email;
    notifyListeners();
  }
  
  // Login existing user
  Future<void> login(String email, String password) async {
    // Simulate API call to backend for authentication
    await Future.delayed(Duration(seconds: 2));
    
    // If login is successful, save auth state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userEmail', email);
    
    _isAuthenticated = true;
    _userEmail = email;
    notifyListeners();
  }
  
  // Logout user
  Future<void> logout() async {
    // Simulate API call to backend for logout
    await Future.delayed(Duration(seconds: 1));
    
    // Clear auth state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.remove('userEmail');
    
    _isAuthenticated = false;
    _userEmail = null;
    notifyListeners();
  }
}