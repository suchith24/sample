import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'background_container.dart';
import 'editscreen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child("Users");
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if(mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: BackgroundContainer(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder(
          stream: _databaseReference.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorWidget("Something went wrong");
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return _buildEmptyState();
            }

            final Map<dynamic, dynamic> users =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final userKeys = users.keys.toList();

            return ListView.builder(
              itemCount: users.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final userKey = userKeys[index];
                final userData = users[userKey];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      userData['email'] ?? 'No Email',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Password: ${userData['password']}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditScreen(
                                  usersKeys: userKey,
                                  userData: userData,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _showDeleteConfirmation(context, userKey);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String userKey) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _databaseReference.child(userKey).remove();
              if (mounted) Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User deleted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_alt_outlined, size: 60, color: Colors.white),
          const SizedBox(height: 20),
          const Text(
            "No Users Found",
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            "Registered users will appear here",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Go Back"),
          ),
        ],
      ),
    );
  }
}