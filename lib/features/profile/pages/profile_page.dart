import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlock_flutter/features/auth/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmationDialog(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.user == null) {
            return const Center(child: Text('User data not available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Profile picture
                // CircleAvatar(
                //   radius: 60,
                //   backgroundImage: state.user!.profilePicture!.isNotEmpty
                //       ? NetworkImage(state.user!.profilePicture!)
                //       : null,
                //   child: state.user!.profilePicture!.isEmpty
                //       ? Text(
                //           state.user!.name.isNotEmpty
                //               ? state.user!.name[0].toUpperCase()
                //               : '?',
                //           style: const TextStyle(fontSize: 40),
                //         )
                //       : null,
                // ),
                const SizedBox(height: 16),

                // User name
                Text(
                  state.user!.id,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // User email
                Text(
                  state.user!.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),

                const SizedBox(height: 32),

                // Profile options
                _buildProfileOption(
                  context,
                  icon: Icons.person,
                  title: 'Edit Profile',
                  onTap: () {
                    // Navigate to profile edit page
                  },
                ),

                _buildProfileOption(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    // Navigate to settings page
                  },
                ),

                _buildProfileOption(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    // Navigate to help page
                  },
                ),

                _buildProfileOption(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    // Navigate to about page
                  },
                ),

                const SizedBox(height: 24),

                // Logout button
                ElevatedButton.icon(
                  onPressed: () => _showLogoutConfirmationDialog(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(SignOutRequestedEvent());
                },
                child: const Text('Logout'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }
}
