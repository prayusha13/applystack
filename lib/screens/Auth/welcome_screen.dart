import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
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
                double logoSize;
                double titleSize;
                double subtitleSize;
                double buttonHeight;

                if (constraints.maxWidth < 600) {
                  // Mobile
                  maxWidth = constraints.maxWidth * 0.9;
                  logoSize = 80;
                  titleSize = 28;
                  subtitleSize = 16;
                  buttonHeight = 48;
                } else if (constraints.maxWidth < 1200) {
                  // Tablet
                  maxWidth = 500;
                  logoSize = 100;
                  titleSize = 36;
                  subtitleSize = 18;
                  buttonHeight = 52;
                } else {
                  // Desktop
                  maxWidth = 600;
                  logoSize = 120;
                  titleSize = 42;
                  subtitleSize = 20;
                  buttonHeight = 56;
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: screenSize.height * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenSize.height * 0.1),

                        // Logo
                        Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(logoSize * 0.25),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF2563EB).withOpacity(0.3),
                                offset: Offset(0, 4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.work_outline_rounded,
                            size: logoSize * 0.5,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 32),

                        // App Title
                        Text(
                          'ApplyStack',
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'Track Your Career Journey',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontSize: subtitleSize,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16),

                        // Description
                        Text(
                          'Organize job applications, schedule interviews, and land your dream career with our intuitive tracking platform.',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 48),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: ElevatedButton.icon(
                            onPressed: () => Get.to(() => LoginScreen()),
                            icon: Icon(Icons.login_rounded, size: 20),
                            label: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Color(0xFF2563EB).withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Create Account Button
                        SizedBox(
                          width: double.infinity,
                          height: buttonHeight,
                          child: OutlinedButton.icon(
                            onPressed: () => Get.to(() => RegisterScreen()),
                            icon: Icon(Icons.person_add_rounded, size: 20),
                            label: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFF2563EB),
                              side: BorderSide(color: Color(0xFF2563EB), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 48),

                        // Features Section
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xFFE5E7EB),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF000000).withOpacity(0.05),
                                offset: Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildFeatureItem(
                                Icons.business_center_outlined,
                                'Track Applications',
                                'Monitor job applications across companies',
                              ),
                              SizedBox(height: 20),
                              _buildFeatureItem(
                                Icons.calendar_today_outlined,
                                'Schedule Interviews',
                                'Never miss an important interview',
                              ),
                              SizedBox(height: 20),
                              _buildFeatureItem(
                                Icons.trending_up_outlined,
                                'Career Progress',
                                'Visualize your job search journey',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenSize.height * 0.1),
                      ],
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

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
