import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for text fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to free resources
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle login submission
  void _login() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement login logic (e.g., API call)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
      // Navigate to home screen or dashboard after successful login
       //Navigator.pushReplacementNamed(context, 
      // '/home',
      // arguments: _usernameController.text,
       //); // Uncomment and adjust route
    }
  }

  // Handle Google sign-in
  void _signInWithGoogle() {
    // TODO: Implement Google sign-in logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In Coming Soon!')),
    );
  }

  // Handle Apple sign-in
  void _signInWithApple() {
    // TODO: Implement Apple sign-in logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple Sign-In Coming Soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for modern feel
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome text
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You've been missed",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration('Username'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your username' : null,
                ),
                const SizedBox(height: 20),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: _inputDecoration('Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter your password';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Login button with gesture
                GestureDetector(
                  onTap: _login,
                  onLongPress: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Long press detected!')),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.blueAccent],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider with "OR"
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[400])),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('OR', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Colors.grey[400])),
                  ],
                ),
                const SizedBox(height: 20),

                // Google sign-in button
                GestureDetector(
                  onTap: _signInWithGoogle,
                  child: _socialButton(
                    'Sign in with Google',
                    Colors.white,
                    Colors.black87,
                    Icons.g_mobiledata,
                  ),
                ),
                const SizedBox(height: 15),

                // Apple sign-in button
                GestureDetector(
                  onTap: _signInWithApple,
                  child: _socialButton(
                    'Sign in with Apple',
                    Colors.black,
                    Colors.white,
                    Icons.apple,
                  ),
                ),
                const SizedBox(height: 20),

                // Link to registration screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/registration'),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable input decoration for text fields
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  // Reusable social button widget
  Widget _socialButton(String text, Color bgColor, Color textColor, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}