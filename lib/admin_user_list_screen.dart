import 'package:flutter/material.dart';
import 'package:project_test/create_user_screen.dart';
import 'package:project_test/model/user_model.dart';
import 'package:project_test/updated_user_screen.dart';
import 'api_service.dart'; // Import your ApiService class

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> userList = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch users when the screen loads
  }

  // Fetches the list of users
  Future<void> fetchUsers() async {
    try {
      List<User> users = await apiService.getUsers();
      setState(() {
        userList = users;
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  // Deletes a user and refreshes the list
  Future<void> deleteUser(int userId) async {
    try {
      await apiService.deleteUser(userId);
      fetchUsers(); // Refresh list after deleting
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // Displays a confirmation dialog before deletion
  void confirmDelete(int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser(userId);
              },
            ),
          ],
        );
      },
    );
  }

  // Renders the list of users in a ListView
  Widget buildUserList() {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        User user = userList[index];
        return ListTile(
          title: Text(user.username),
          subtitle: Text("User ID: ${user.userId}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Navigate to the edit user screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserScreen(user: user),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => confirmDelete(user.userId),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to the create user screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateUserScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : buildUserList(),
    );
  }
}
