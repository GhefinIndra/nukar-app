import 'package:flutter/material.dart';
import '../theme/nukar_theme.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DashboardScreen({
    super.key,
    required this.userData,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _balance = 'Rp 0';
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBalance();
  }

  void _loadUserData() {
    setState(() {
      _userName = widget.userData['user']?['fullName'] ??
                  widget.userData['user']?['full_name'] ??
                  'User';
    });
  }

  Future<void> _loadBalance() async {
    try {
      final response = await _apiService.getBalance();
      if (response['success'] == true) {
        setState(() {
          _balance = response['data']['balance_formatted'] ?? 'Rp 0';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat saldo: $e')),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    await _apiService.logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NukarTheme.primaryGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo,',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Wallet Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saldo NUKAR',
                        style: TextStyle(
                          fontSize: 14,
                          color: NukarTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              _balance,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: NukarTheme.primaryGreen,
                              ),
                            ),
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.add_circle_outline,
                              label: 'Top Up',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur Top Up coming soon!'),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.send_outlined,
                              label: 'Transfer',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur Transfer coming soon!'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.history,
                              label: 'Riwayat',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur Riwayat coming soon!'),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.person_outline,
                              label: 'Profil',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fitur Profil coming soon!'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Tagline
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox.shrink();
                              },
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '#BersamaMembangunNegeri',
                              style: TextStyle(
                                color: NukarTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: NukarTheme.paleMint,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: NukarTheme.primaryGreen,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: NukarTheme.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
