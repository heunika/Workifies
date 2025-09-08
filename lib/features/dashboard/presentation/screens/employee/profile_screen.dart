import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            // Header Section with Profile
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
                children: [
                  // Profile Header
                  Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: Text(
                              'SJ',
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: GestureDetector(
                                onTap: _changeProfilePicture,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sarah Johnson',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Software Developer',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            Text(
                              'Tech Innovations Inc.',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Quick Stats
                            Row(
                              children: [
                                _ProfileStat(
                                  icon: Icons.calendar_today,
                                  value: '8 months',
                                  label: 'with company',
                                ),
                                const SizedBox(width: 20),
                                _ProfileStat(
                                  icon: Icons.access_time,
                                  value: '38.5h',
                                  label: 'this week',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Profile Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Personal Information
                  _ProfileSection(
                    title: 'Personal Information',
                    children: [
                      _ProfileTile(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: 'sarah.johnson@company.com',
                        onTap: _editEmail,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        subtitle: '+1 (555) 123-4567',
                        onTap: _editPhone,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        subtitle: '123 Main St, New York, NY',
                        onTap: _editAddress,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.cake_outlined,
                        title: 'Birthday',
                        subtitle: 'March 15, 1995',
                        onTap: _editBirthday,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Work Information
                  _ProfileSection(
                    title: 'Work Information',
                    children: [
                      _ProfileTile(
                        icon: Icons.badge_outlined,
                        title: 'Employee ID',
                        subtitle: 'EMP-2024-001',
                        onTap: null,
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: _copyEmployeeId,
                        ),
                      ),
                      _ProfileTile(
                        icon: Icons.calendar_today_outlined,
                        title: 'Start Date',
                        subtitle: 'January 15, 2024',
                        onTap: null,
                      ),
                      _ProfileTile(
                        icon: Icons.schedule_outlined,
                        title: 'Work Schedule',
                        subtitle: 'Monday - Friday, 9:00 AM - 5:00 PM',
                        onTap: _viewSchedule,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.supervisor_account_outlined,
                        title: 'Manager',
                        subtitle: 'John Doe',
                        onTap: _contactManager,
                        trailing: const Icon(Icons.message),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // App Preferences
                  _ProfileSection(
                    title: 'App Preferences',
                    children: [
                      _SwitchTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Receive app notifications',
                        value: _notificationsEnabled,
                        onChanged: (value) => setState(() => _notificationsEnabled = value),
                      ),
                      _SwitchTile(
                        icon: Icons.email_outlined,
                        title: 'Email Notifications',
                        subtitle: 'Receive notifications via email',
                        value: _emailNotifications,
                        onChanged: _notificationsEnabled 
                            ? (value) => setState(() => _emailNotifications = value)
                            : null,
                      ),
                      _SwitchTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Use dark theme',
                        value: _darkModeEnabled,
                        onChanged: (value) => setState(() => _darkModeEnabled = value),
                      ),
                      _SwitchTile(
                        icon: Icons.fingerprint,
                        title: 'Biometric Lock',
                        subtitle: 'Use fingerprint to unlock',
                        value: _biometricEnabled,
                        onChanged: (value) => setState(() => _biometricEnabled = value),
                      ),
                      _DropdownTile(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: _selectedLanguage,
                        items: ['English', 'Spanish', 'French', 'German'],
                        value: _selectedLanguage,
                        onChanged: (value) => setState(() => _selectedLanguage = value!),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Performance & Stats
                  _ProfileSection(
                    title: 'Performance & Stats',
                    children: [
                      _ProfileTile(
                        icon: Icons.trending_up,
                        title: 'Performance Review',
                        subtitle: 'Last review: Excellent (Dec 2024)',
                        onTap: _viewPerformance,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.access_time,
                        title: 'Hours This Month',
                        subtitle: '152.5 hours worked',
                        onTap: _viewDetailedHours,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.emoji_events_outlined,
                        title: 'Achievements',
                        subtitle: '3 badges earned',
                        onTap: _viewAchievements,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Support & Help
                  _ProfileSection(
                    title: 'Support & Help',
                    children: [
                      _ProfileTile(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        subtitle: 'Get help and support',
                        onTap: _openHelpCenter,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.feedback_outlined,
                        title: 'Send Feedback',
                        subtitle: 'Help us improve the app',
                        onTap: _sendFeedback,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.bug_report_outlined,
                        title: 'Report a Bug',
                        subtitle: 'Let us know if something\'s wrong',
                        onTap: _reportBug,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      _ProfileTile(
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Workifies v1.0.0',
                        onTap: _showAbout,
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _exportPersonalData,
                          icon: const Icon(Icons.download),
                          label: const Text('Export Data'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _signOut,
                          icon: const Icon(Icons.logout),
                          label: const Text('Sign Out'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
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
  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ImagePickerBottomSheet(),
    );
  }

  void _editEmail() {
    _showEditDialog('Email', 'sarah.johnson@company.com');
  }

  void _editPhone() {
    _showEditDialog('Phone', '+1 (555) 123-4567');
  }

  void _editAddress() {
    _showEditDialog('Address', '123 Main St, New York, NY');
  }

  void _editBirthday() {
    showDatePicker(
      context: context,
      initialDate: DateTime(1995, 3, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
  }

  void _copyEmployeeId() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Employee ID copied to clipboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _viewSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening work schedule...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _contactManager() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening chat with manager...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _viewPerformance() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening performance review...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _viewDetailedHours() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening detailed hours view...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _viewAchievements() {
    showDialog(
      context: context,
      builder: (context) => _AchievementsDialog(),
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

  void _reportBug() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening bug report form...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showAbout() {
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
              'A modern workforce management solution designed for employees and managers.',
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

  void _exportPersonalData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Preparing personal data export...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
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

  void _showEditDialog(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Edit $field',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$field updated successfully'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ProfileStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({
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

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
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

class _ImagePickerBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Change Profile Picture',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ImagePickerOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () => Navigator.pop(context),
              ),
              _ImagePickerOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => Navigator.pop(context),
              ),
              _ImagePickerOption(
                icon: Icons.person,
                label: 'Avatar',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ImagePickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImagePickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsDialog extends StatelessWidget {
  final List<Achievement> achievements = [
    Achievement(
      title: 'Early Bird',
      description: 'Clocked in early 10 days in a row',
      icon: Icons.wb_sunny,
      color: Colors.orange,
      earned: true,
      earnedDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Achievement(
      title: 'Perfect Week',
      description: 'Worked all 5 days with perfect attendance',
      icon: Icons.star,
      color: Colors.amber,
      earned: true,
      earnedDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Achievement(
      title: 'Team Player',
      description: 'Helped 5 colleagues this month',
      icon: Icons.group,
      color: Colors.blue,
      earned: true,
      earnedDate: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Achievement(
      title: 'Overtime Hero',
      description: 'Worked 10 hours of overtime',
      icon: Icons.access_time_filled,
      color: Colors.purple,
      earned: false,
    ),
    Achievement(
      title: 'Monthly Champion',
      description: 'Top performer of the month',
      icon: Icons.emoji_events,
      color: Colors.amber,
      earned: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final earnedAchievements = achievements.where((a) => a.earned).toList();
    final availableAchievements = achievements.where((a) => !a.earned).toList();
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${earnedAchievements.length} of ${achievements.length} earned',
              style: GoogleFonts.inter(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (earnedAchievements.isNotEmpty) ...[
                      Text(
                        'Earned',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...earnedAchievements.map((achievement) => _AchievementTile(
                        achievement: achievement,
                      )),
                      const SizedBox(height: 24),
                    ],
                    
                    if (availableAchievements.isNotEmpty) ...[
                      Text(
                        'Available',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...availableAchievements.map((achievement) => _AchievementTile(
                        achievement: achievement,
                      )),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;

  const _AchievementTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: achievement.earned
                  ? achievement.color.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              achievement.icon,
              color: achievement.earned ? achievement.color : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: achievement.earned ? null : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: (achievement.earned 
                        ? Theme.of(context).textTheme.bodyMedium?.color 
                        : Colors.grey)?.withValues(alpha: 0.7),
                  ),
                ),
                if (achievement.earned && achievement.earnedDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Earned ${_formatDate(achievement.earnedDate!)}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: achievement.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return 'on ${date.day}/${date.month}/${date.year}';
    }
  }
}

// Models
class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool earned;
  final DateTime? earnedDate;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.earned,
    this.earnedDate,
  });
}