import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHoursScreen extends StatefulWidget {
  const MyHoursScreen({super.key});

  @override
  State<MyHoursScreen> createState() => _MyHoursScreenState();
}

class _MyHoursScreenState extends State<MyHoursScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Week';
  
  final List<DailyHours> _thisWeekHours = [
    DailyHours(
      date: DateTime.now().subtract(const Duration(days: 6)),
      dayName: 'Mon',
      clockIn: DateTime.now().subtract(const Duration(days: 6, hours: 15)),
      clockOut: DateTime.now().subtract(const Duration(days: 6, hours: 7)),
      totalHours: 8.0,
      status: HoursStatus.completed,
    ),
    DailyHours(
      date: DateTime.now().subtract(const Duration(days: 5)),
      dayName: 'Tue',
      clockIn: DateTime.now().subtract(const Duration(days: 5, hours: 16)),
      clockOut: DateTime.now().subtract(const Duration(days: 5, hours: 8)),
      totalHours: 8.0,
      status: HoursStatus.completed,
    ),
    DailyHours(
      date: DateTime.now().subtract(const Duration(days: 4)),
      dayName: 'Wed',
      clockIn: DateTime.now().subtract(const Duration(days: 4, hours: 15, minutes: 30)),
      clockOut: DateTime.now().subtract(const Duration(days: 4, hours: 7, minutes: 15)),
      totalHours: 8.25,
      status: HoursStatus.completed,
    ),
    DailyHours(
      date: DateTime.now().subtract(const Duration(days: 3)),
      dayName: 'Thu',
      clockIn: DateTime.now().subtract(const Duration(days: 3, hours: 16, minutes: 15)),
      clockOut: DateTime.now().subtract(const Duration(days: 3, hours: 7, minutes: 45)),
      totalHours: 8.5,
      status: HoursStatus.completed,
    ),
    DailyHours(
      date: DateTime.now().subtract(const Duration(days: 2)),
      dayName: 'Fri',
      clockIn: DateTime.now().subtract(const Duration(days: 2, hours: 15)),
      clockOut: DateTime.now().subtract(const Duration(days: 2, hours: 9)),
      totalHours: 6.0,
      status: HoursStatus.completed,
    ),
    DailyHours(
      date: DateTime.now().subtract(const Duration(days: 1)),
      dayName: 'Sat',
      clockIn: null,
      clockOut: null,
      totalHours: 0.0,
      status: HoursStatus.absent,
    ),
    DailyHours(
      date: DateTime.now(),
      dayName: 'Today',
      clockIn: DateTime.now().subtract(const Duration(hours: 6, minutes: 30)),
      clockOut: null,
      totalHours: 6.5,
      status: HoursStatus.active,
    ),
  ];

  final List<WeeklyStats> _weeklyStats = [
    WeeklyStats(
      weekStart: DateTime.now().subtract(const Duration(days: 21)),
      totalHours: 42.5,
      daysWorked: 5,
      avgDaily: 8.5,
    ),
    WeeklyStats(
      weekStart: DateTime.now().subtract(const Duration(days: 14)),
      totalHours: 38.0,
      daysWorked: 5,
      avgDaily: 7.6,
    ),
    WeeklyStats(
      weekStart: DateTime.now().subtract(const Duration(days: 7)),
      totalHours: 40.0,
      daysWorked: 5,
      avgDaily: 8.0,
    ),
    WeeklyStats(
      weekStart: DateTime.now(),
      totalHours: 38.75,
      daysWorked: 5,
      avgDaily: 7.75,
    ),
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

  double get totalWeekHours {
    return _thisWeekHours.fold(0.0, (sum, day) => sum + day.totalHours);
  }

  int get daysWorked {
    return _thisWeekHours.where((day) => day.totalHours > 0).length;
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
                          'My Hours',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Track your work time',
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
                
                // Quick Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _QuickStatCard(
                        title: 'This Week',
                        value: '${totalWeekHours.toStringAsFixed(1)}h',
                        subtitle: '$daysWorked days worked',
                        color: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickStatCard(
                        title: 'Today',
                        value: '${_thisWeekHours.last.totalHours.toStringAsFixed(1)}h',
                        subtitle: _thisWeekHours.last.status == HoursStatus.active ? 'Active' : 'Not working',
                        color: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
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
                    Tab(text: 'Daily'),
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
                _buildDailyTab(),
                _buildWeeklyTab(),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTab() {
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
                'Daily Hours',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: _selectedPeriod,
                items: ['This Week', 'Last Week', 'This Month', 'Last Month'].map((period) {
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
          
          // Daily Hours List
          ...(_thisWeekHours.map((dayHours) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _DailyHoursCard(dayHours: dayHours),
          )).toList()),
          
          const SizedBox(height: 24),
          
          // Week Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  const Color(0xFF10B981).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week Summary',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        label: 'Total Hours',
                        value: totalWeekHours.toStringAsFixed(1),
                        unit: 'h',
                        icon: Icons.access_time,
                      ),
                    ),
                    Expanded(
                      child: _SummaryItem(
                        label: 'Days Worked',
                        value: daysWorked.toString(),
                        unit: 'days',
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        label: 'Daily Average',
                        value: daysWorked > 0 ? (totalWeekHours / daysWorked).toStringAsFixed(1) : '0.0',
                        unit: 'h/day',
                        icon: Icons.trending_up,
                      ),
                    ),
                    Expanded(
                      child: _SummaryItem(
                        label: 'Target Progress',
                        value: '${((totalWeekHours / 40) * 100).toStringAsFixed(0)}%',
                        unit: 'of 40h',
                        icon: Icons.track_changes,
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

  Widget _buildWeeklyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Overview',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Weekly Chart Placeholder
          Container(
            height: 200,
            padding: const EdgeInsets.all(20),
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
                  'Hours Trend',
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
                    children: _weeklyStats.map((week) {
                      final maxHeight = 120.0;
                      final maxHours = 45.0;
                      final barHeight = (week.totalHours / maxHours) * maxHeight;
                      
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 20,
                            height: barHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  const Color(0xFF10B981),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'W${_weeklyStats.indexOf(week) + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${week.totalHours.toStringAsFixed(0)}h',
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
          
          // Weekly Stats Cards
          ...(_weeklyStats.asMap().entries.map((entry) {
            final index = entry.key;
            final week = entry.value;
            final isCurrentWeek = index == _weeklyStats.length - 1;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _WeeklyStatsCard(
                weekStats: week,
                isCurrentWeek: isCurrentWeek,
                weekNumber: index + 1,
              ),
            );
          }).toList()),
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
            'Time Reports',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Generate detailed reports of your work hours',
            style: GoogleFonts.inter(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Report Types
          _ReportCard(
            title: 'Daily Timesheet',
            description: 'Detailed daily work hours with clock-in/out times',
            icon: Icons.today,
            color: Colors.blue,
            onTap: () => _generateReport('daily'),
          ),
          
          const SizedBox(height: 16),
          
          _ReportCard(
            title: 'Weekly Summary',
            description: 'Weekly hours summary with trends and averages',
            icon: Icons.view_week,
            color: Colors.green,
            onTap: () => _generateReport('weekly'),
          ),
          
          const SizedBox(height: 16),
          
          _ReportCard(
            title: 'Monthly Report',
            description: 'Comprehensive monthly work analysis',
            icon: Icons.calendar_view_month,
            color: Colors.purple,
            onTap: () => _generateReport('monthly'),
          ),
          
          const SizedBox(height: 16),
          
          _ReportCard(
            title: 'Overtime Tracking',
            description: 'Track and report overtime hours worked',
            icon: Icons.schedule,
            color: Colors.orange,
            onTap: () => _generateReport('overtime'),
          ),
          
          const SizedBox(height: 32),
          
          // Export Options
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
                  'Export Options',
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
                        onPressed: () => _exportData('pdf'),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Export PDF'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _exportData('csv'),
                        icon: const Icon(Icons.file_download),
                        label: const Text('Export CSV'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  void _generateReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating $type report...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _exportData(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting data as ${format.toUpperCase()}...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final Color backgroundColor;

  const _QuickStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyHoursCard extends StatelessWidget {
  final DailyHours dayHours;

  const _DailyHoursCard({required this.dayHours});

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
        border: dayHours.status == HoursStatus.active
            ? Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              )
            : null,
      ),
      child: Row(
        children: [
          // Date Section
          Container(
            width: 60,
            child: Column(
              children: [
                Text(
                  dayHours.dayName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: dayHours.status == HoursStatus.active
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
                Text(
                  '${dayHours.date.day}',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: dayHours.status == HoursStatus.active
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Time Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dayHours.totalHours.toStringAsFixed(1)}h',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: dayHours.status == HoursStatus.active
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    _HoursStatusChip(status: dayHours.status),
                  ],
                ),
                const SizedBox(height: 8),
                
                if (dayHours.status != HoursStatus.absent) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.login,
                        size: 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(dayHours.clockIn!),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      Icon(
                        Icons.logout,
                        size: 14,
                        color: dayHours.clockOut != null ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dayHours.clockOut != null ? _formatTime(dayHours.clockOut!) : 'Active',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: dayHours.clockOut != null ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    'No work recorded',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
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

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _HoursStatusChip extends StatelessWidget {
  final HoursStatus status;

  const _HoursStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    
    switch (status) {
      case HoursStatus.completed:
        text = 'Completed';
        color = Colors.green;
        break;
      case HoursStatus.active:
        text = 'Active';
        color = Theme.of(context).colorScheme.primary;
        break;
      case HoursStatus.absent:
        text = 'Absent';
        color = Colors.grey;
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
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  children: [
                    TextSpan(
                      text: ' $unit',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeeklyStatsCard extends StatelessWidget {
  final WeeklyStats weekStats;
  final bool isCurrentWeek;
  final int weekNumber;

  const _WeeklyStatsCard({
    required this.weekStats,
    required this.isCurrentWeek,
    required this.weekNumber,
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
        border: isCurrentWeek
            ? Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCurrentWeek ? 'This Week' : 'Week $weekNumber',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCurrentWeek ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              Text(
                '${weekStats.totalHours.toStringAsFixed(1)}h',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCurrentWeek ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: Text(
                  '${weekStats.daysWorked} days worked',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ),
              Text(
                '${weekStats.avgDaily.toStringAsFixed(1)}h avg/day',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
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
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
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
class DailyHours {
  final DateTime date;
  final String dayName;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final double totalHours;
  final HoursStatus status;

  DailyHours({
    required this.date,
    required this.dayName,
    required this.clockIn,
    required this.clockOut,
    required this.totalHours,
    required this.status,
  });
}

class WeeklyStats {
  final DateTime weekStart;
  final double totalHours;
  final int daysWorked;
  final double avgDaily;

  WeeklyStats({
    required this.weekStart,
    required this.totalHours,
    required this.daysWorked,
    required this.avgDaily,
  });
}

enum HoursStatus { completed, active, absent }