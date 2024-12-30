import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/bottom_button.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    final String password = passwordController.text.trim();
    final String confirmedPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    if (password != confirmedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    try {
      // Check if the email exists in Firebase Authentication
      final List<String> userSignInMethods =
          await _auth.fetchSignInMethodsForEmail(widget.email);

      if (userSignInMethods.isNotEmpty) {
        // Sign in user anonymously for password update
        await _auth.signInWithEmailAndPassword(
          email: widget.email,
          password: 'temporaryPassword', // You may need to set a temp password
        );

        // Update the password
        User? user = _auth.currentUser;
        if (user != null) {
          await user.updatePassword(password);
          await _auth.signOut(); // Sign out after update
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password updated successfully!")),
          );
          Navigator.popAndPushNamed(context, '/login');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email not found in the system.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update password: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Set a new password for your account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  BottomButton(
                    buttonTitle: "SUBMIT",
                    onTap: updatePassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
