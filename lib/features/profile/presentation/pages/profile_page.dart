import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_event.dart';
import '../../../auth/bloc/auth_state.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignInPage()),
                (route) => false,
              );
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.person, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue[100],
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Center(
                            child: Text(
                              state.email,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'User ID: ${state.userId}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          _buildMenuItem(
                            icon: Icons.edit,
                            title: 'Edit Profile',
                            onTap: () {
                              // TODO: edit profile
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Edit profile belum diimplementasi',
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          _buildMenuItem(
                            icon: Icons.history,
                            title: 'Riwayat Transaksi',
                            onTap: () {
                              // TODO: history
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Riwayat transaksi belum diimplementasi',
                                  ),
                                ),
                              );
                            },
                          ),
                          // const Divider(),
                          // _buildMenuItem(
                          //   icon: Icons.settings,
                          //   title: 'Pengaturan',
                          //   onTap: () {
                          //     // TODO: settings
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //         content: Text(
                          //           'Pengaturan belum diimplementasi',
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          const Divider(),
                          _buildMenuItem(
                            icon: Icons.help_outline,
                            title: 'Bantuan',
                            onTap: () {
                              // TODO: help (FAQ)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Bantuan belum diimplementasi'),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                  const SignOutRequested(),
                                );
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[900]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
