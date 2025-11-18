import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Register dengan Phone + PIN
  Future<Map<String, dynamic>> register({
    required String mobilePhone,
    required String fullName,
    required String pin,
    String? referralCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobilePhone': mobilePhone,
          'fullName': fullName,
          'pin': pin,
          'referralCode': referralCode,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Login dengan Phone + PIN
  Future<Map<String, dynamic>> login({
    required String mobilePhone,
    required String pin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobilePhone': mobilePhone,
          'pin': pin,
        }),
      );

      final data = jsonDecode(response.body);
      
      // Save token if login success
      if (data['success'] == true && data['data']['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['data']['token']);
        await prefs.setString('userData', jsonEncode(data['data']['user']));
      }
      
      return data;
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Get Token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Balance
  Future<Map<String, dynamic>> getBalance() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'No token found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/wallet/balance'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}