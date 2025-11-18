import 'package:flutter/material.dart';
import '../theme/nukar_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NukarTheme.primaryGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and Brand
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Icon(
                      Icons.change_history,
                      size: 24,
                      color: NukarTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'nukar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '#BersamaMembangunNegeri',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),

              const Spacer(flex: 2),

              // Illustration - Handshake with coin
              Center(
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Left hand (yellow sleeve)
                      Positioned(
                        left: 20,
                        child: Container(
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB800),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      // Right hand (purple sleeve)
                      Positioned(
                        right: 20,
                        child: Container(
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9C88FF),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      // Coin in center
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFB800),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '\$',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Masuk Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NukarTheme.accentOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Terms and Conditions
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'Dengan menggunakan aplikasi ini Saya\nmenyetujui ',
                    ),
                    TextSpan(
                      text: 'Syarat & Ketentuan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '\nyang berlaku'),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
