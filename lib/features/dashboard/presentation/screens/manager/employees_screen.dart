import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  
  final List<Employee> _employees = [
    Employee(
      id: '1',
      name: 'Sarah Johnson',
      position: 'Software Developer',
      email: 'sarah.johnson@company.com',
      phone: '+1 (555) 123-4567',
      status: EmployeeStatus.active,
      joinDate: DateTime(2023, 3, 15),
      avatar: 'SJ',
      hoursToday: 6.5,
      totalHours: 158.5,
    ),
    Employee(
      id: '2',
      name: 'Michael Chen',
      position: 'UX Designer',
      email: 'michael.chen@company.com',
      phone: '+1 (555) 234-5678',
      status: EmployeeStatus.active,
      joinDate: DateTime(2023, 1, 22),
      avatar: 'MC',
      hoursToday: 8.0,
      totalHours: 172.0,
    ),
    Employee(
      id: '3',
      name: 'Emily Rodriguez',
      position: 'Project Manager',
      email: 'emily.rodriguez@company.com',
      phone: '+1 (555) 345-6789',
      status: EmployeeStatus.inactive,
      joinDate: DateTime(2022, 11, 8),
      avatar: 'ER',
      hoursToday: 0.0,
      totalHours: 145.5,
    ),
    Employee(
      id: '4',
      name: 'David Wilson',
      position: 'Data Analyst',
      email: 'david.wilson@company.com',
      phone: '+1 (555) 456-7890',
      status: EmployeeStatus.active,
      joinDate: DateTime(2023, 5, 3),
      avatar: 'DW',
      hoursToday: 7.2,
      totalHours: 98.3,
    ),
    Employee(
      id: '5',
      name: 'Lisa Thompson',
      position: 'Marketing Specialist',
      email: 'lisa.thompson@company.com',
      phone: '+1 (555) 567-8901',
      status: EmployeeStatus.active,
      joinDate: DateTime(2023, 2, 14),
      avatar: 'LT',
      hoursToday: 5.8,
      totalHours: 142.7,
    ),
  ];

  List<Employee> get filteredEmployees {
    List<Employee> filtered = _employees;
    
    if (_selectedFilter != 'All') {
      filtered = filtered.where((employee) {
        return employee.status.toString().split('.').last.toLowerCase() == 
               _selectedFilter.toLowerCase();
      }).toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((employee) {
        return employee.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
               employee.position.toLowerCase().contains(_searchController.text.toLowerCase()) ||
               employee.email.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
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
                          'Team Members',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${_employees.length} total employees',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _showAddEmployeeDialog,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    style: GoogleFonts.inter(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search employees...',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', 'Active', 'Inactive'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedFilter = filter);
                          },
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          labelStyle: GoogleFonts.inter(
                            color: isSelected 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey.shade600,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Employee List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: filteredEmployees.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final employee = filteredEmployees[index];
                return _EmployeeCard(
                  employee: employee,
                  onTap: () => _showEmployeeDetails(employee),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Add New Employee',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Send them the company code to join:\nWRK12345',
          style: GoogleFonts.inter(),
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

  void _showEmployeeDetails(Employee employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return _EmployeeDetailsBottomSheet(
            employee: employee,
            scrollController: scrollController,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const _EmployeeCard({
    required this.employee,
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
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    employee.avatar,
                    style: GoogleFonts.inter(
                      fontSize: 16,
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
                          Expanded(
                            child: Text(
                              employee.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _StatusChip(status: employee.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee.position,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Today: ${employee.hoursToday}h',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Total: ${employee.totalHours}h',
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
                
                Icon(
                  Icons.chevron_right,
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

class _StatusChip extends StatelessWidget {
  final EmployeeStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == EmployeeStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.green : Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _EmployeeDetailsBottomSheet extends StatelessWidget {
  final Employee employee;
  final ScrollController scrollController;

  const _EmployeeDetailsBottomSheet({
    required this.employee,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Employee Header
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                child: Text(
                  employee.avatar,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      employee.position,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _StatusChip(status: employee.status),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Details Section
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailSection(
                    title: 'Contact Information',
                    items: [
                      _DetailItem(
                        icon: Icons.email,
                        label: 'Email',
                        value: employee.email,
                      ),
                      _DetailItem(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: employee.phone,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _DetailSection(
                    title: 'Work Information',
                    items: [
                      _DetailItem(
                        icon: Icons.calendar_today,
                        label: 'Join Date',
                        value: _formatDate(employee.joinDate),
                      ),
                      _DetailItem(
                        icon: Icons.access_time,
                        label: 'Hours Today',
                        value: '${employee.hoursToday}h',
                      ),
                      _DetailItem(
                        icon: Icons.bar_chart,
                        label: 'Total Hours',
                        value: '${employee.totalHours}h',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Send message
                          },
                          icon: const Icon(Icons.message),
                          label: const Text('Message'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: View details
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('View Hours'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<_DetailItem> items;

  const _DetailSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Employee Model
class Employee {
  final String id;
  final String name;
  final String position;
  final String email;
  final String phone;
  final EmployeeStatus status;
  final DateTime joinDate;
  final String avatar;
  final double hoursToday;
  final double totalHours;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.email,
    required this.phone,
    required this.status,
    required this.joinDate,
    required this.avatar,
    required this.hoursToday,
    required this.totalHours,
  });
}

enum EmployeeStatus { active, inactive }