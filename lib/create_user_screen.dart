import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your ApiService class
import 'package:project_test/model/user_model.dart'; // Import your User model

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  // Function to create a user
  Future<void> createUser() async {
    try {
      User newUser = User(
        userId: 0, // User ID will be assigned by the backend
        username: _usernameController.text,
        password: _passwordController.text,
      );
      await apiService.createUser(newUser);
      Navigator.pop(context); // Go back after successful user creation
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: createUser,
              child: Text("Create User"),
            ),
          ],
        ),
      ),
    );
  }
}
