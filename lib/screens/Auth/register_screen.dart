import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
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
                  maxWidth = 500;
                  titleSize = 28;
                  subtitleSize = 16;
                  buttonHeight = 52;
                } else {
                  // Desktop
                  maxWidth = 550;
                  titleSize = 32;
                  subtitleSize = 18;
                  buttonHeight = 56;
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: screenSize.height * 0.03,
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

                          SizedBox(height: 24),

                          // Create Account title
                          Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Start your career tracking journey',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: subtitleSize,
                              color: Color(0xFF6B7280),
                            ),
                          ),

                          SizedBox(height: 32),

                          // Full Name field
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter your full name',
                              prefixIcon: Icon(Icons.person_outlined, size: 20),
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
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 20),

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

                          // Age field
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
                            decoration: InputDecoration(
                              labelText: 'Age',
                              hintText: 'Enter your age',
                              prefixIcon: Icon(Icons.cake_outlined, size: 20),
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
                                return 'Please enter your age';
                              }
                              int? age = int.tryParse(value);
                              if (age == null || age < 16 || age > 80) {
                                return 'Please enter a valid age (16-80)';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 20),

                          // Status Dropdown
                          Obx(() => DropdownButtonFormField<String>(
                            value: _authService.selectedStatus.value.isEmpty
                                ? null
                                : _authService.selectedStatus.value,
                            style: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
                            decoration: InputDecoration(
                              labelText: 'Current Status',
                              prefixIcon: Icon(Icons.work_outlined, size: 20),
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
                            items: [
                              'Student',
                              'Recent Graduate',
                              'Employed (Looking for Change)',
                              'Unemployed'
                            ].map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            )).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                _authService.selectedStatus.value = value;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your current status';
                              }
                              return null;
                            },
                          )),

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

                          SizedBox(height: 32),

                          // Create Account button
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: _authService.isLoading.value
                                  ? null
                                  : () {
                                if (_formKey.currentState!.validate()) {
                                  _authService.createAccount(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    age: int.parse(_ageController.text),
                                    status: _authService.selectedStatus.value,
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
                                  Icon(Icons.person_add_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),

                          SizedBox(height: 24),

                          // Already have account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.to(() => LoginScreen()),
                                child: Text(
                                  'Sign In',
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
