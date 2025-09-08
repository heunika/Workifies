import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTimeZone = 'EST (UTC-5)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your account and app preferences',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: Text(
                            'JD',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Doe',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Manager • Tech Innovations Inc.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                'john.doe@company.com',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _editProfile,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Settings Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Company Settings
                  _SettingsSection(
                    title: 'Company',
                    children: [
                      _SettingsTile(
                        icon: Icons.business,
                        title: 'Company Information',
                        subtitle: 'Edit company details and branding',
                        onTap: _editCompanyInfo,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _SettingsTile(
                        icon: Icons.qr_code,
                        title: 'Company Code',
                        subtitle: 'WRK12345 • Share with employees',
                        onTap: _manageCompanyCode,
                        trailing: const Icon(Icons.share),
                      ),
                      _SettingsTile(
                        icon: Icons.schedule,
                        title: 'Work Hours',
                        subtitle: 'Set default working hours',
                        onTap: _setWorkHours,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Notifications
                  _SettingsSection(
                    title: 'Notifications',
                    children: [
                      _SwitchTile(
                        icon: Icons.notifications,
                        title: 'All Notifications',
                        subtitle: 'Enable or disable all notifications',
                        value: _notificationsEnabled,
                        onChanged: (value) => setState(() => _notificationsEnabled = value),
                      ),
                      _SwitchTile(
                        icon: Icons.email,
                        title: 'Email Notifications',
                        subtitle: 'Receive notifications via email',
                        value: _emailNotifications,
                        onChanged: _notificationsEnabled 
                            ? (value) => setState(() => _emailNotifications = value)
                            : null,
                      ),
                      _SwitchTile(
                        icon: Icons.phone_android,
                        title: 'Push Notifications',
                        subtitle: 'Receive push notifications on device',
                        value: _pushNotifications,
                        onChanged: _notificationsEnabled 
                            ? (value) => setState(() => _pushNotifications = value)
                            : null,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Appearance & Privacy
                  _SettingsSection(
                    title: 'Appearance & Privacy',
                    children: [
                      _SwitchTile(
                        icon: Icons.dark_mode,
                        title: 'Dark Mode',
                        subtitle: 'Switch to dark theme',
                        value: _darkModeEnabled,
                        onChanged: (value) => setState(() => _darkModeEnabled = value),
                      ),
                      _DropdownTile(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: _selectedLanguage,
                        items: ['English', 'Spanish', 'French', 'German'],
                        value: _selectedLanguage,
                        onChanged: (value) => setState(() => _selectedLanguage = value!),
                      ),
                      _DropdownTile(
                        icon: Icons.access_time,
                        title: 'Time Zone',
                        subtitle: _selectedTimeZone,
                        items: ['EST (UTC-5)', 'PST (UTC-8)', 'CST (UTC-6)', 'MST (UTC-7)'],
                        value: _selectedTimeZone,
                        onChanged: (value) => setState(() => _selectedTimeZone = value!),
                      ),
                      _SwitchTile(
                        icon: Icons.fingerprint,
                        title: 'Biometric Authentication',
                        subtitle: 'Use fingerprint or face ID to unlock',
                        value: _biometricEnabled,
                        onChanged: (value) => setState(() => _biometricEnabled = value),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Data & Storage
                  _SettingsSection(
                    title: 'Data & Storage',
                    children: [
                      _SettingsTile(
                        icon: Icons.download,
                        title: 'Export Data',
                        subtitle: 'Download your company data',
                        onTap: _exportData,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _SettingsTile(
                        icon: Icons.backup,
                        title: 'Backup Settings',
                        subtitle: 'Configure automatic backups',
                        onTap: _configureBackup,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _SettingsTile(
                        icon: Icons.storage,
                        title: 'Storage Usage',
                        subtitle: '2.3 GB of 15 GB used',
                        onTap: _viewStorageUsage,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Support & Legal
                  _SettingsSection(
                    title: 'Support & Legal',
                    children: [
                      _SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        subtitle: 'Get help and support',
                        onTap: _openHelpCenter,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _SettingsTile(
                        icon: Icons.feedback_outlined,
                        title: 'Send Feedback',
                        subtitle: 'Help us improve Workifies',
                        onTap: _sendFeedback,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _SettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                        subtitle: 'View terms and conditions',
                        onTap: _viewTerms,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'View privacy policy',
                        onTap: _viewPrivacy,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _SettingsTile(
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Workifies v1.0.0',
                        onTap: _viewAbout,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Danger Zone
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Danger Zone',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _SettingsTile(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          subtitle: 'Sign out of your account',
                          onTap: _signOut,
                          trailing: const Icon(Icons.chevron_right),
                          textColor: Colors.red,
                        ),
                        _SettingsTile(
                          icon: Icons.delete_forever,
                          title: 'Delete Account',
                          subtitle: 'Permanently delete your account and data',
                          onTap: _deleteAccount,
                          trailing: const Icon(Icons.chevron_right),
                          textColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods
  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening profile editor...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _editCompanyInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening company information editor...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _manageCompanyCode() {
    _showCompanyCodeDialog();
  }

  void _setWorkHours() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening work hours settings...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Preparing data export...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _configureBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening backup settings...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _viewStorageUsage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Loading storage usage details...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening help center...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _sendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening feedback form...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _viewTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Loading terms of service...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _viewPrivacy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Loading privacy policy...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _viewAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'About Workifies',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 8),
            Text(
              'A modern workforce management solution for companies and employees.',
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 Workifies Inc. All rights reserved.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Sign Out',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Account',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. This will permanently delete your account and remove all associated data.',
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 16),
            Text(
              'Are you absolutely sure?',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showCompanyCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Company Code',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'WRK12345',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Share this code with employees so they can join your company.',
              style: GoogleFonts.inter(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Copy Code'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children.map((child) {
              final index = children.indexOf(child);
              return Column(
                children: [
                  child,
                  if (index < children.length - 1)
                    Divider(
                      height: 1,
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? textColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (textColor ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: textColor ?? Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: (textColor ?? Theme.of(context).textTheme.bodyMedium?.color)?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }
}