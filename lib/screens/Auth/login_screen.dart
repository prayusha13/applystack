import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_screen.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive width constraints
                double maxWidth;
                double titleSize;
                double subtitleSize;
                double buttonHeight;

                if (constraints.maxWidth < 600) {
                  // Mobile
                  maxWidth = constraints.maxWidth * 0.9;
                  titleSize = 24;
                  subtitleSize = 14;
                  buttonHeight = 48;
                } else if (constraints.maxWidth < 1200) {
                  // Tablet
                  maxWidth = 450;
                  titleSize = 28;
                  subtitleSize = 16;
                  buttonHeight = 52;
                } else {
                  // Desktop
                  maxWidth = 500;
                  titleSize = 32;
                  subtitleSize = 18;
                  buttonHeight = 56;
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: screenSize.height * 0.05,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back button
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(Icons.arrow_back_ios_rounded),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              padding: EdgeInsets.all(12),
                            ),
                          ),

                          SizedBox(height: 32),

                          // Welcome back title
                          Text(
                            'Welcome Back!',
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Sign in to continue your career journey',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: subtitleSize,
                              color: Color(0xFF6B7280),
                            ),
                          ),

                          SizedBox(height: 40),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: Icon(Icons.email_outlined, size: 20),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF2563EB), width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 20),

                          // Password field
                          Obx(() => TextFormField(
                            controller: _passwordController,
                            obscureText: _authService.hidePassword.value,
                            style: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: Icon(Icons.lock_outlined, size: 20),
                              suffixIcon: IconButton(
                                onPressed: () => _authService.hidePassword.toggle(),
                                icon: Icon(
                                  _authService.hidePassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFD1D5DB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF2563EB), width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          )),

                          SizedBox(height: 12),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.snackbar(
                                  'Coming Soon',
                                  'Forgot password feature will be available soon',
                                  backgroundColor: Color(0xFF2563EB).withOpacity(0.1),
                                  colorText: Color(0xFF2563EB),
                                  borderRadius: 8,
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 32),

                          // Sign in button
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: _authService.isLoading.value
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate()) {
                                  _authService.signInWithEmail(
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _authService.isLoading.value
                                  ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),

                          SizedBox(height: 32),

                          // Don't have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.to(() => RegisterScreen()),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenSize.height * 0.05),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
