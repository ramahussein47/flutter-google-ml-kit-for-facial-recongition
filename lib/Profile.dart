import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial/pages/ChangePassword.dart';
import 'package:facial/pages/Login.dart';
import 'package:facial/pages/RegisterStudent.dart';
import 'package:facial/pages/Settings.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [

          const CircleAvatar(
            radius: 50,

            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 16),

          const Center(
            child: Text(
              'UserName',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Change Password Option
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
              );
            },
          ),
          Divider(height: 10,),

          // Settings Option
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
              Divider(height: 10,),
          // Log Out Option
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Log Out"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Log Out"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text("Log Out"),
                    ),
                  ],
                ),
              );
            },
          ),
            ListTile(  leading: const Icon(Icons.center_focus_weak_outlined),
             trailing: const Icon(Icons.arrow_forward_ios_outlined),
               onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterStudentPage()));
               },)
        ],
      ),
    );
  }
}
