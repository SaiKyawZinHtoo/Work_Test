import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project_test/model/user_model.dart';

class ApiService {
  final String baseUrl = 'http://103.215.194.85:6006';
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  // Register User Function
  Future<String> registerUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/user/register'),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }), // Body is now JSON encoded
      );

      print('Status Code: ${response.statusCode}'); // Debugging
      print('Response Body: ${response.body}'); // Debugging

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        return data['message'] ?? 'Registration Successful';
      } else {
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      return 'Error: Unable to connect to the server';
    }
  }

  // Register Admin Function
  Future<String> registerAdmin(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/user/register'),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }), // Body is now JSON encoded
      );

      print('Status Code: ${response.statusCode}'); // Debugging
      print('Response Body: ${response.body}'); // Debugging

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        return data['message'] ?? 'Admin Registration Successful';
      } else {
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      return 'Error: Unable to connect to the server';
    }
  }

// Login Method
  Future<String> loginUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      final role = data['role']; // Ensure role is included in the response

      await _storage.write(key: 'auth_token', value: token);
      await _storage.write(key: 'role', value: role); // Save role in storage

      return 'Login successful';
    } else {
      return 'Login failed: ${response.body}';
    }
  }

  // Fetch Users Method
  Future<List<User>> getUsers() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception("Token not found. Please log in.");
    }

    final url = Uri.parse('$baseUrl/api/user/all');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> usersJson = jsonResponse['users'];
      return usersJson.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<void> createUser(User user) async {
    final token = await _storage.read(key: 'auth_token');

    // Debug: print token or error if not found
    if (token == null) {
      print('Error: Token not found.');
      throw Exception("Token not found. Please log in.");
    } else {
      print('Token found: $token');
    }

    final url = Uri.parse('$baseUrl/api/user/register');

    // Debug: print the request URL
    print('Request URL: $url');

    // Debug: print the request body
    print('Request Body: ${json.encode(user.toJson())}');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json
          .encode(user.toJson()), // Pass the user details in the request body
    );

    // Debug: check status code and response body
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      print('User created successfully');
    } else {
      print('Failed to create user');
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  Future<void> editUser(int userId, User user) async {
    final token = await _storage.read(key: 'auth_token');

    // Debug: print token or error if not found
    if (token == null) {
      print('Error: Token not found.');
      throw Exception("Token not found. Please log in.");
    } else {
      print('Token found: $token');
    }

    final url = Uri.parse(
        '$baseUrl/api/user/update/$userId'); // Assuming the endpoint needs userId

    // Debug: print the request URL
    print('Request URL: $url');

    // Debug: print the request body
    print('Request Body: ${json.encode(user.toJson())}');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()), // Convert the user to JSON
    );

    // Debug: check status code and response body
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print("User updated successfully");
    } else {
      print('Failed to update user');
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<void> deleteUser(int userId) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception("Token not found. Please log in.");
    }

    final url = Uri.parse('$baseUrl/api/user/delete/$userId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('User deleted successfully');
    } else {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }
}
