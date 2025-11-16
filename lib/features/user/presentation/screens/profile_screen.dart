import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../auth/data/providers/auth_providers.dart';
import '../../data/providers/user_providers.dart';

/// User profile screen
/// Displays user information and account management options
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoggingOut = true);

    try {
      await ref.read(authStateNotifierProvider.notifier).logout();

      if (!mounted) return;

      // Router will handle navigation based on auth state
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to logout: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final isLoading = ref.watch(isUserDataLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(CleoSpacing.lg),
              children: [
                // User Avatar
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: CleoColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: user != null && user.fullName.isNotEmpty
                        ? Center(
                            child: Text(
                              user.fullName[0].toUpperCase(),
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                  ),
                ),

                const SizedBox(height: CleoSpacing.lg),

                // User Name
                Center(
                  child: Text(
                    user?.fullName ?? 'Loading...',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: CleoSpacing.xs),

                // User Email
                Center(
                  child: Text(
                    user?.email ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: CleoColors.textSecondary,
                    ),
                  ),
                ),

          const SizedBox(height: CleoSpacing.xxl),

          // Account Section
          _buildSectionHeader('Account'),
          const SizedBox(height: CleoSpacing.md),

          _buildMenuItem(
            icon: Icons.settings,
            title: 'Preferences',
            subtitle: 'Manage your app preferences',
            onTap: () => context.push(AppRoutes.preferences),
          ),

          _buildMenuItem(
            icon: Icons.music_note,
            title: 'Discogs Integration',
            subtitle: 'Manage Discogs API token',
            onTap: () {
              // TODO: Navigate to Discogs settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon')),
              );
            },
          ),

          const SizedBox(height: CleoSpacing.xl),

          // App Section
          _buildSectionHeader('App'),
          const SizedBox(height: CleoSpacing.md),

          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Cleo',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 Cleo',
              );
            },
          ),

          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help using Cleo',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon')),
              );
            },
          ),

          const SizedBox(height: CleoSpacing.xxl),

          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: _isLoggingOut ? null : _handleLogout,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoggingOut
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout),
                        const SizedBox(width: CleoSpacing.sm),
                        Text(
                          'Logout',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: CleoColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: CleoColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: CleoColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: CleoColors.textSecondary,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
