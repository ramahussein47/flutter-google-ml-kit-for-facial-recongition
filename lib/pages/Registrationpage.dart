/*import 'package:facial/pages/Loginpage.dart';
import 'package:facial/pages/Passwordviewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

Future<void> registerUser(String email, String password) async {
  try {
    // Hash the password before sending it to Supabase
    final hashedPassword = await hashPassword(password);

    final AuthResponse res = await Supabase.instance.client.auth.signUp(
      email: email,
      password: hashedPassword,
    );

    if (res.error != null) {
      // Handle registration error (e.g., display an error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${res.error!.message}'),
        ),
      );
      return;
    }/

    final Session? session = res.session;
    final User? user = res.user;

    if (session != null) {
      // User successfully registered and authenticated
      // ... handle successful registration (e.g., navigate to a home screen)
    } else {
      // User successfully registered, but may need to verify email
      if (user!.emailConfirmedAt == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please check your email to verify your account.')),
        );
      } else {
        // Handle successful registration without immediate authentication
        // ... (e.g., redirect to a login page)
      }
    }
  } catch (error) {
    // Handle unexpected errors during registration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An unexpected error occurred.')),
    );
  }
}

// Replace with your actual password hashing implementation
Future<String> hashPassword(String password) async {
  // Implement secure password hashing using bcrypt or Argon2
  return password;  // Placeholder for now
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.face_5, size: 100),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your Email',
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Consumer<Passwordviewer>(
                builder: (context, passwordProvider, child) {
                  return TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter your password',
                      hintText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: passwordProvider.toggleVisibility,
                        icon: Icon(
                          passwordProvider.isvisible ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: !passwordProvider.isvisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 7) {
                        return 'Password must be at least 7 characters';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
