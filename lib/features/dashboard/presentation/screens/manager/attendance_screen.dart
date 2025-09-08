import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  String _selectedPeriod = 'This Week';
  
  final List<AttendanceRecord> _todayRecords = [
    AttendanceRecord(
      employeeId: '1',
      employeeName: 'Sarah Johnson',
      position: 'Software Developer',
      avatar: 'SJ',
      clockIn: DateTime.now().subtract(const Duration(hours: 6, minutes: 30)),
      clockOut: null,
      totalHours: 6.5,
      status: AttendanceStatus.present,
    ),
    AttendanceRecord(
      employeeId: '2',
      employeeName: 'Michael Chen',
      position: 'UX Designer',
      avatar: 'MC',
      clockIn: DateTime.now().subtract(const Duration(hours: 8)),
      clockOut: DateTime.now().subtract(const Duration(minutes: 5)),
      totalHours: 8.0,
      status: AttendanceStatus.present,
    ),
    AttendanceRecord(
      employeeId: '3',
      employeeName: 'Emily Rodriguez',
      position: 'Project Manager',
      avatar: 'ER',
      clockIn: null,
      clockOut: null,
      totalHours: 0.0,
      status: AttendanceStatus.absent,
    ),
    AttendanceRecord(
      employeeId: '4',
      employeeName: 'David Wilson',
      position: 'Data Analyst',
      avatar: 'DW',
      clockIn: DateTime.now().subtract(const Duration(hours: 7, minutes: 15)),
      clockOut: null,
      totalHours: 7.25,
      status: AttendanceStatus.present,
    ),
    AttendanceRecord(
      employeeId: '5',
      employeeName: 'Lisa Thompson',
      position: 'Marketing Specialist',
      avatar: 'LT',
      clockIn: DateTime.now().subtract(const Duration(hours: 5, minutes: 45)),
      clockOut: null,
      totalHours: 5.75,
      status: AttendanceStatus.late,
    ),
  ];

  final List<WeeklySummary> _weeklySummary = [
    WeeklySummary(day: 'Mon', present: 5, absent: 0, late: 0),
    WeeklySummary(day: 'Tue', present: 4, absent: 1, late: 0),
    WeeklySummary(day: 'Wed', present: 5, absent: 0, late: 0),
    WeeklySummary(day: 'Thu', present: 3, absent: 1, late: 1),
    WeeklySummary(day: 'Fri', present: 5, absent: 0, late: 0),
    WeeklySummary(day: 'Sat', present: 2, absent: 3, late: 0),
    WeeklySummary(day: 'Sun', present: 1, absent: 4, late: 0),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _formatDate(DateTime.now()),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _showCalendar,
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatsCard(
                        title: 'Present',
                        value: '${_todayRecords.where((r) => r.status == AttendanceStatus.present).length}',
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatsCard(
                        title: 'Absent',
                        value: '${_todayRecords.where((r) => r.status == AttendanceStatus.absent).length}',
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatsCard(
                        title: 'Late',
                        value: '${_todayRecords.where((r) => r.status == AttendanceStatus.late).length}',
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Tab Bar
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                  labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'Today'),
                    Tab(text: 'Weekly'),
                    Tab(text: 'Reports'),
                  ],
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodayTab(),
                _buildWeeklyTab(),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _todayRecords.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final record = _todayRecords[index];
        return _AttendanceCard(record: record);
      },
    );
  }

  Widget _buildWeeklyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Overview',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: _selectedPeriod,
                items: ['This Week', 'Last Week', 'This Month'].map((period) {
                  return DropdownMenuItem(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedPeriod = value!);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Weekly Chart
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
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
              children: [
                Text(
                  'Attendance Overview',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _weeklySummary.map((summary) {
                      final maxHeight = 120.0;
                      final totalEmployees = 5;
                      final presentHeight = (summary.present / totalEmployees) * maxHeight;
                      
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 24,
                            height: presentHeight,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            summary.day,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${summary.present}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Weekly Stats
          Row(
            children: [
              Expanded(
                child: _WeeklyStatsCard(
                  title: 'Average Daily',
                  value: '4.2',
                  subtitle: 'employees present',
                  icon: Icons.people,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _WeeklyStatsCard(
                  title: 'Total Hours',
                  value: '168',
                  subtitle: 'this week',
                  icon: Icons.access_time,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _WeeklyStatsCard(
                  title: 'Punctuality',
                  value: '94%',
                  subtitle: 'on-time rate',
                  icon: Icons.schedule,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _WeeklyStatsCard(
                  title: 'Attendance',
                  value: '87%',
                  subtitle: 'average rate',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generate Reports',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Create detailed attendance reports for your team',
            style: GoogleFonts.inter(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Report Types
          _ReportTypeCard(
            title: 'Daily Report',
            description: 'Get attendance summary for a specific day',
            icon: Icons.today,
            onTap: () => _generateReport('daily'),
          ),
          
          const SizedBox(height: 16),
          
          _ReportTypeCard(
            title: 'Weekly Report',
            description: 'Weekly attendance summary with trends',
            icon: Icons.view_week,
            onTap: () => _generateReport('weekly'),
          ),
          
          const SizedBox(height: 16),
          
          _ReportTypeCard(
            title: 'Monthly Report',
            description: 'Comprehensive monthly attendance analysis',
            icon: Icons.calendar_view_month,
            onTap: () => _generateReport('monthly'),
          ),
          
          const SizedBox(height: 16),
          
          _ReportTypeCard(
            title: 'Employee Report',
            description: 'Individual employee attendance history',
            icon: Icons.person,
            onTap: () => _generateReport('employee'),
          ),
          
          const SizedBox(height: 32),
          
          // Quick Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _exportData(),
                        icon: const Icon(Icons.download),
                        label: const Text('Export CSV'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _sendReport(),
                        icon: const Icon(Icons.share),
                        label: const Text('Share Report'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCalendar() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        setState(() => _selectedDate = date);
      }
    });
  }

  void _generateReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating $type report...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exporting attendance data...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _sendReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Preparing report to share...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final AttendanceRecord record;

  const _AttendanceCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Text(
              record.avatar,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Employee Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      record.employeeName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _AttendanceStatusChip(status: record.status),
                  ],
                ),
                Text(
                  record.position,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(
                      Icons.login,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.clockIn != null ? _formatTime(record.clockIn!) : '--:--',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    Icon(
                      Icons.logout,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.clockOut != null ? _formatTime(record.clockOut!) : 'Active',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: record.clockOut != null ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${record.totalHours}h',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _AttendanceStatusChip extends StatelessWidget {
  final AttendanceStatus status;

  const _AttendanceStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    
    switch (status) {
      case AttendanceStatus.present:
        color = Colors.green;
        text = 'Present';
        break;
      case AttendanceStatus.absent:
        color = Colors.red;
        text = 'Absent';
        break;
      case AttendanceStatus.late:
        color = Colors.orange;
        text = 'Late';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _WeeklyStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _WeeklyStatsCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ReportTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Models
class AttendanceRecord {
  final String employeeId;
  final String employeeName;
  final String position;
  final String avatar;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final double totalHours;
  final AttendanceStatus status;

  AttendanceRecord({
    required this.employeeId,
    required this.employeeName,
    required this.position,
    required this.avatar,
    required this.clockIn,
    required this.clockOut,
    required this.totalHours,
    required this.status,
  });
}

class WeeklySummary {
  final String day;
  final int present;
  final int absent;
  final int late;

  WeeklySummary({
    required this.day,
    required this.present,
    required this.absent,
    required this.late,
  });
}

enum AttendanceStatus { present, absent, late }