import 'package:flutter/material.dart';
import '../theme/nukar_theme.dart';
import 'pin_input_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _referralController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _continueToPin() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    // Navigate to PIN input screen with register data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PinInputScreen(
          isRegister: true,
          mobilePhone: _phoneController.text.trim(),
          fullName: _nameController.text.trim(),
          referralCode: _referralController.text.trim().isEmpty
              ? null
              : _referralController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Green header with "Sudah punya akun"
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/login'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  color: NukarTheme.primaryGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: const [
                    Text(
                      'Sudah punya akun',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Siap menikmati fitur\nunggulan kami?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: NukarTheme.textDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Phone Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'No HP/Whatsapp',
                            hintStyle: TextStyle(
                              color: NukarTheme.textMuted,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan No HP/Whatsapp';
                            }
                            if (value.length < 9) {
                              return 'Nomor terlalu pendek';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Name Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Nama Lengkap',
                            hintStyle: TextStyle(
                              color: NukarTheme.textMuted,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan Nama Lengkap';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Referral Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: TextFormField(
                          controller: _referralController,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Kode Referal (Optional)',
                            hintStyle: TextStyle(
                              color: NukarTheme.textMuted,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Daftar Sekarang Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _continueToPin,
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
                            'Daftar Sekarang',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Terms text
                      const Text(
                        'Saya menyetujui Syarat & Ketentuan\nyang berlaku',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: NukarTheme.textDark,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
