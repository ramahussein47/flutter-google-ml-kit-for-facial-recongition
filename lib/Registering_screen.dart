import 'package:facial/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Register the user in Firebase Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Store additional user info in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': Timestamp.now(),
        });

        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),


        );
         Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));

        // Navigate to another page or clear the form
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
          // navigation back to the Login page


      }  on FirebaseAuthException  catch (e) {
       if(e.code=='email-already-in-use'){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This email is already in use!',style: TextStyle(
                  fontStyle: FontStyle.italic,
              ),))
          );
       } else {ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed: ")),
        );

       }

      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const Icon(Icons.face_6_outlined,

                  size: 100,
                    ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    border: UnderlineInputBorder(),
                    hintText: 'Enter your name',
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    border: UnderlineInputBorder(),
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 7) {
                      return 'Password must be at least 7 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(

                  onPressed: _registerUser,
                  child: Text("Register",style: TextStyle(
                    color: Colors.black,
                  ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
           fixedSize:Size(200, 50),
           shape: BeveledRectangleBorder(
borderRadius: BorderRadius.circular(6),

           )

                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
