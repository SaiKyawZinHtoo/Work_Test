import 'package:flutter/material.dart';
import 'package:project_test/api_service.dart';
import 'package:project_test/model/user_model.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  // Initialize controllers with initial text value
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers in initState
    _usernameController = TextEditingController(text: widget.user.username);
    _passwordController = TextEditingController(text: widget.user.password);
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed to avoid memory leaks
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedUser = User(
                  userId: widget.user.userId, // Keep the existing user ID
                  username: _usernameController.text,
                  password: _passwordController.text,
                );

                try {
                  ApiService apiService =
                      ApiService(); // Create an instance of ApiService
                  await apiService.editUser(widget.user.userId,
                      updatedUser); // Use instance to call editUser
                  Navigator.pop(context); // Go back to the previous screen
                } catch (e) {
                  // Handle any errors (e.g., show a toast or a dialog)
                  print('Error: $e');
                }
              },
              child: Text("Update User"),
            ),
          ],
        ),
      ),
    );
  }
}
