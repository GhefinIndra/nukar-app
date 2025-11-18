import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'register_screen.dart';
import '../theme/nukar_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: NukarTheme.heroGradient),
        child: Stack(
          children: [
            const _BackgroundIllustrations(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    _buildBrandHeader(),
                    const SizedBox(height: 16),
                    Text(
                      '#BersamaMembangunNegeri',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 0.85),
                        fontSize: 16,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const Spacer(),
                    _buildHeroCard(context),
                    const Spacer(),
                    _buildActions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -10,
            child: Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.12),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Dompet Digital UMKM',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.payments_outlined,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  'Transaksi aman dan cepat\nuntuk setiap pelaku usaha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 0.85),
                    height: 1.4,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Masuk'),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
          },
          child: const Text('Belum punya akun? Daftar Sekarang'),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to Terms & Conditions
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 12),
              children: [
                TextSpan(
                  text: 'Dengan menggunakan aplikasi ini saya menyetujui ',
                ),
                TextSpan(
                  text: 'Syarat & Ketentuan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' yang berlaku.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.change_history,
                size: 32,
                color: NukarTheme.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'nukar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 46,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BackgroundIllustrations extends StatelessWidget {
  const _BackgroundIllustrations();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -40,
          child: _bubble(180, Color.fromRGBO(255, 255, 255, 0.08)),
        ),
        Positioned(
          top: 120,
          right: -50,
          child: _bubble(140, Color.fromRGBO(255, 255, 255, 0.05)),
        ),
        Positioned(
          bottom: -30,
          left: -20,
          child: _bubble(160, Color.fromRGBO(255, 255, 255, 0.09)),
        ),
        Positioned(
          bottom: 80,
          right: 24,
          child: _bubble(70, Color.fromRGBO(255, 255, 255, 0.12)),
        ),
      ],
    );
  }

  Widget _bubble(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
