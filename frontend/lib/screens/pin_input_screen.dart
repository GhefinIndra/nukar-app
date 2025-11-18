import 'package:flutter/material.dart';
import '../theme/nukar_theme.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class PinInputScreen extends StatefulWidget {
  final String? mobilePhone;
  final String? fullName;
  final String? referralCode;
  final bool isRegister; // true = register, false = login

  const PinInputScreen({
    super.key,
    this.mobilePhone,
    this.fullName,
    this.referralCode,
    this.isRegister = true,
  });

  @override
  State<PinInputScreen> createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  final _apiService = ApiService();
  bool _isLoading = false;
  String _pin = '';

  void _onNumberTap(String number) {
    if (_pin.length < 6 && !_isLoading) {
      setState(() {
        _pin += number;
      });

      // Auto submit when 6 digits entered
      if (_pin.length == 6) {
        _submitPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty && !_isLoading) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Future<void> _submitPin() async {
    if (_pin.length != 6) return;

    setState(() => _isLoading = true);

    if (widget.isRegister) {
      await _submitRegister();
    } else {
      await _submitLogin();
    }
  }

  Future<void> _submitRegister() async {
    final result = await _apiService.register(
      mobilePhone: widget.mobilePhone!,
      fullName: widget.fullName!,
      pin: _pin,
      referralCode: widget.referralCode,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registrasi gagal'),
          backgroundColor: Colors.red,
        ),
      );
      _clearPin();
    }
  }

  Future<void> _submitLogin() async {
    final result = await _apiService.login(
      mobilePhone: widget.mobilePhone!,
      pin: _pin,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      // Navigate to Dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(userData: result['data']),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login gagal'),
          backgroundColor: Colors.red,
        ),
      );
      _clearPin();
    }
  }

  void _clearPin() {
    setState(() {
      _pin = '';
    });
  }

  void _handleResetPin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur Reset PIN akan segera hadir'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NukarTheme.primaryGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Title
              const Text(
                '6 digit PIN kamu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // PIN Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < _pin.length
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                  );
                }),
              ),

              const Spacer(),

              // Custom Numpad
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildNumButton('1'),
                  _buildNumButton('2'),
                  _buildNumButton('3'),
                  _buildNumButton('4'),
                  _buildNumButton('5'),
                  _buildNumButton('6'),
                  _buildNumButton('7'),
                  _buildNumButton('8'),
                  _buildNumButton('9'),
                  const SizedBox.shrink(), // Empty space
                  _buildNumButton('0'),
                  _buildBackspaceButton(),
                ],
              ),

              const SizedBox(height: 32),

              // Lupa PIN / Reset PIN Button
              if (!widget.isRegister)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Lupa PIN?',
                        style: TextStyle(
                          color: NukarTheme.textDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _handleResetPin,
                        child: const Text(
                          'Reset PIN',
                          style: TextStyle(
                            color: NukarTheme.primaryGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Loading Indicator
              if (_isLoading)
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberTap(number),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0E6F39), // Dark green
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0E6F39), // Dark green
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
