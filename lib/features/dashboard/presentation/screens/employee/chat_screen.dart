import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeChatScreen extends StatefulWidget {
  const EmployeeChatScreen({super.key});

  @override
  State<EmployeeChatScreen> createState() => _EmployeeChatScreenState();
}

class _EmployeeChatScreenState extends State<EmployeeChatScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<ChatConversation> _conversations = [
    ChatConversation(
      id: '1',
      type: ChatType.individual,
      name: 'John Doe (Manager)',
      avatar: 'JD',
      lastMessage: 'Great job on the project this week!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
      unreadCount: 1,
      isOnline: true,
      role: 'Manager',
    ),
    ChatConversation(
      id: '2',
      type: ChatType.individual,
      name: 'Michael Chen',
      avatar: 'MC',
      lastMessage: 'Want to grab coffee later?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
      isOnline: true,
      role: 'Colleague',
    ),
    ChatConversation(
      id: '3',
      type: ChatType.group,
      name: 'Development Team',
      avatar: 'DT',
      lastMessage: 'Sarah: Meeting at 3 PM today',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 3,
      isOnline: false,
      participants: ['Michael Chen', 'Emily Rodriguez', 'David Wilson', 'You'],
    ),
    ChatConversation(
      id: '4',
      type: ChatType.group,
      name: 'All Company',
      avatar: 'AC',
      lastMessage: 'HR: Don\'t forget about the team building event!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 4)),
      unreadCount: 0,
      isOnline: false,
      participants: ['Everyone in the company'],
    ),
    ChatConversation(
      id: '5',
      type: ChatType.individual,
      name: 'Emily Rodriguez',
      avatar: 'ER',
      lastMessage: 'Thanks for helping with the presentation',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      isOnline: false,
      role: 'Colleague',
    ),
  ];

  final List<ChatMessage> _currentMessages = [
    ChatMessage(
      id: '1',
      senderId: '1',
      senderName: 'John Doe',
      content: 'Hi Sarah! How\'s the project coming along?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isFromCurrentUser: false,
      senderRole: 'Manager',
    ),
    ChatMessage(
      id: '2',
      senderId: 'current',
      senderName: 'You',
      content: 'It\'s going really well! I\'ve finished the main features and working on testing now.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      isFromCurrentUser: true,
    ),
    ChatMessage(
      id: '3',
      senderId: '1',
      senderName: 'John Doe',
      content: 'That\'s fantastic! The client is going to be very happy. You\'ve been doing excellent work.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      isFromCurrentUser: false,
      senderRole: 'Manager',
    ),
    ChatMessage(
      id: '4',
      senderId: 'current',
      senderName: 'You',
      content: 'Thank you so much! I really appreciate the feedback. Should I schedule a demo for tomorrow?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      isFromCurrentUser: true,
    ),
    ChatMessage(
      id: '5',
      senderId: '1',
      senderName: 'John Doe',
      content: 'Great job on the project this week!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isFromCurrentUser: false,
      senderRole: 'Manager',
    ),
  ];

  ChatConversation? _selectedConversation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedConversation == null
          ? _buildChatList()
          : _buildChatView(),
    );
  }

  Widget _buildChatList() {
    return Column(
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
                        'Messages',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_conversations.where((c) => c.unreadCount > 0).length} unread messages',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _showSearchDialog,
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
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
                  Tab(text: 'All Chats'),
                  Tab(text: 'Groups'),
                ],
              ),
            ],
          ),
        ),
        
        // Quick Actions
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.person,
                  title: 'Message Manager',
                  subtitle: 'John Doe',
                  onTap: () => _messageManager(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.group,
                  title: 'Team Chat',
                  subtitle: 'Development Team',
                  onTap: () => _openTeamChat(),
                ),
              ),
            ],
          ),
        ),
        
        // Chat List
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildConversationList(_conversations),
              _buildConversationList(_conversations.where((c) => c.type == ChatType.group).toList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConversationList(List<ChatConversation> conversations) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: conversations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _ConversationTile(
          conversation: conversation,
          onTap: () => _openConversation(conversation),
        );
      },
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        // Chat Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _selectedConversation = null),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: _selectedConversation!.type == ChatType.group
                    ? Icon(
                        Icons.group,
                        color: Colors.white,
                        size: 20,
                      )
                    : Text(
                        _selectedConversation!.avatar,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedConversation!.name,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (_selectedConversation!.type == ChatType.individual)
                      Text(
                        _selectedConversation!.role ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      )
                    else
                      Text(
                        '${_selectedConversation!.participants?.length ?? 0} members',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _showChatOptions,
                icon: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
        ),
        
        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _currentMessages.length,
            itemBuilder: (context, index) {
              final message = _currentMessages[index];
              return _MessageBubble(message: message);
            },
          ),
        ),
        
        // Message Input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _showAttachmentOptions,
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openConversation(ChatConversation conversation) {
    setState(() {
      _selectedConversation = conversation;
      conversation.unreadCount = 0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _currentMessages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'current',
            senderName: 'You',
            content: _messageController.text.trim(),
            timestamp: DateTime.now(),
            isFromCurrentUser: true,
          ),
        );
        _messageController.clear();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _messageManager() {
    final managerConversation = _conversations.firstWhere(
      (c) => c.role == 'Manager',
    );
    _openConversation(managerConversation);
  }

  void _openTeamChat() {
    final teamConversation = _conversations.firstWhere(
      (c) => c.name == 'Development Team',
    );
    _openConversation(teamConversation);
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: _ChatSearchDelegate(_conversations),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ChatOptionsBottomSheet(
        conversation: _selectedConversation!,
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _AttachmentOptionsBottomSheet(),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
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
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
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
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: conversation.type == ChatType.group 
                          ? Colors.purple.withValues(alpha: 0.1)
                          : conversation.role == 'Manager'
                              ? Colors.orange.withValues(alpha: 0.1)
                              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      child: conversation.type == ChatType.group
                          ? Icon(
                              Icons.group,
                              color: Colors.purple,
                              size: 24,
                            )
                          : Text(
                              conversation.avatar,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: conversation.role == 'Manager'
                                    ? Colors.orange
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                    ),
                    if (conversation.type == ChatType.individual && conversation.isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    if (conversation.role == 'Manager')
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              conversation.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatTime(conversation.lastMessageTime),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.lastMessage,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conversation.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                conversation.unreadCount.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isFromCurrentUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!message.isFromCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.senderRole == 'Manager'
                  ? Colors.orange.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Stack(
                children: [
                  Text(
                    message.senderName.split(' ').map((e) => e[0]).join(''),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: message.senderRole == 'Manager'
                          ? Colors.orange
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (message.senderRole == 'Manager')
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromCurrentUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isFromCurrentUser)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            message.senderName,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: message.senderRole == 'Manager'
                                  ? Colors.orange
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          if (message.senderRole == 'Manager') ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 12,
                            ),
                          ],
                        ],
                      ),
                    ),
                  Text(
                    message.content,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: message.isFromCurrentUser
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMessageTime(message.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: message.isFromCurrentUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
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

  String _formatMessageTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _ChatOptionsBottomSheet extends StatelessWidget {
  final ChatConversation conversation;

  const _ChatOptionsBottomSheet({required this.conversation});

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
          
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Chat Info'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_off_outlined),
            title: const Text('Mute Notifications'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Messages'),
            onTap: () => Navigator.pop(context),
          ),
          if (conversation.role != 'Manager') ...[
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block User', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ],
      ),
    );
  }
}

class _AttachmentOptionsBottomSheet extends StatelessWidget {
  const _AttachmentOptionsBottomSheet();

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
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AttachmentOption(
                icon: Icons.photo,
                label: 'Photo',
                color: Colors.purple,
                onTap: () => Navigator.pop(context),
              ),
              _AttachmentOption(
                icon: Icons.videocam,
                label: 'Video',
                color: Colors.red,
                onTap: () => Navigator.pop(context),
              ),
              _AttachmentOption(
                icon: Icons.insert_drive_file,
                label: 'Document',
                color: Colors.blue,
                onTap: () => Navigator.pop(context),
              ),
              _AttachmentOption(
                icon: Icons.location_on,
                label: 'Location',
                color: Colors.green,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
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
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatSearchDelegate extends SearchDelegate {
  final List<ChatConversation> conversations;

  _ChatSearchDelegate(this.conversations);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = conversations.where((conversation) {
      return conversation.name.toLowerCase().contains(query.toLowerCase()) ||
             conversation.lastMessage.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final conversation = results[index];
        return ListTile(
          leading: CircleAvatar(
            child: conversation.type == ChatType.group
                ? Icon(Icons.group)
                : Text(conversation.avatar),
          ),
          title: Text(conversation.name),
          subtitle: Text(conversation.lastMessage),
          onTap: () => close(context, conversation),
        );
      },
    );
  }
}

// Models
class ChatConversation {
  final String id;
  final ChatType type;
  final String name;
  final String avatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  int unreadCount;
  final bool isOnline;
  final List<String>? participants;
  final String? role;

  ChatConversation({
    required this.id,
    required this.type,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
    this.participants,
    this.role,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isFromCurrentUser;
  final String? senderRole;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isFromCurrentUser,
    this.senderRole,
  });
}

enum ChatType { individual, group }