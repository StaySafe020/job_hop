import 'package:flutter/material.dart';

class MessagingScreen extends StatefulWidget {
  final String username; // Pass username to identify the user

  const MessagingScreen({super.key, required this.username});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  int _selectedIndex = 2; // Default to Messages (index 2)
  int _unreadMessageCount = 0; // Track total unread messages across conversations

  // Sample conversation data (replace with real data from database)
  final List<Map<String, dynamic>> _conversations = [
    {
      'contact': 'TechCorpHR',
      'lastMessage': 'We’d like to discuss your application.',
      'time': '10:30 AM',
      'unread': 2,
    },
    {
      'contact': 'DesignifyTeam',
      'lastMessage': 'Thanks for applying!',
      'time': 'Yesterday',
      'unread': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateUnreadMessageCount(); // Initialize unread count
    // TODO: Fetch initial conversations from backend and listen for real-time updates
    // Example: FirebaseFirestore.instance.collection('conversations').where('participants', arrayContains: widget.username).snapshots().listen((snapshot) {
    //   setState(() {
    //     _conversations = snapshot.docs.map((doc) => doc.data()).toList();
    //     _updateUnreadMessageCount();
    //   });
    // });
  }

  // Update unread message count
  void _updateUnreadMessageCount() {
    setState(() {
      _unreadMessageCount = _conversations.fold(0, (sum, conv) => sum + (conv['unread'] as int));
    });
  }

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home', arguments: widget.username);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
      case 2:
        // Already on Messages
        break;
      case 3:
        Navigator.pushNamed(context, '/settings', arguments: widget.username);
        break;
    }
  }

  // Open chat screen and mark messages as read
  void _openChat(String contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          currentUser: widget.username,
          contact: contact,
        ),
      ),
    ).then((_) {
      setState(() {
        final convIndex = _conversations.indexWhere((c) => c['contact'] == contact);
        if (convIndex != -1) {
          _conversations[convIndex]['unread'] = 0; // Mark all messages in this conversation as read
          _updateUnreadMessageCount();
          // TODO: Update conversation unread count in backend
          // Example: await FirebaseFirestore.instance.collection('conversations').doc('${widget.username}_$contact').update({'unread': 0});
        }
      });
    });
  }

  // Simulate adding a new message (for testing)
  void _addNewMessage() {
    setState(() {
      final existingConvIndex = _conversations.indexWhere((c) => c['contact'] == 'TechCorpHR');
      if (existingConvIndex != -1) {
        _conversations[existingConvIndex]['lastMessage'] = 'New message received!';
        _conversations[existingConvIndex]['time'] = 'Just now';
        _conversations[existingConvIndex]['unread'] = (_conversations[existingConvIndex]['unread'] as int) + 1;
      } else {
        _conversations.add({
          'contact': 'NewEmployer',
          'lastMessage': 'Hello, interested in your profile.',
          'time': 'Just now',
          'unread': 1,
        });
      }
      _updateUnreadMessageCount();
    });
    // TODO: This would typically be triggered by a backend push event
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          // Temporary button to test adding a new message
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            onPressed: _addNewMessage,
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? const Center(
              child: Text(
                'No messages yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        conversation['contact'][0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      conversation['contact'],
                      style: TextStyle(
                        fontWeight: conversation['unread'] > 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(conversation['lastMessage']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(conversation['time'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        if (conversation['unread'] > 0)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              conversation['unread'].toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    onTap: () => _openChat(conversation['contact']),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.message),
                if (_unreadMessageCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_unreadMessageCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// Chat Screen
class ChatScreen extends StatefulWidget {
  final String currentUser;
  final String contact;

  const ChatScreen({super.key, required this.currentUser, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Sample messages (replace with real data from database)
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'TechCorpHR', 'text': 'Hi, we’d like to discuss your application.', 'time': '10:30 AM'},
    {'sender': 'User', 'text': 'Great, I’m available tomorrow!', 'time': '10:32 AM'},
  ];

  @override
  void initState() {
    super.initState();
    // TODO: Fetch real chat history from database/API
    // Example: _messages = await fetchChatHistory(widget.currentUser, widget.contact);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Send message
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': widget.currentUser,
          'text': _messageController.text,
          'time': DateTime.now().toString().substring(11, 16), // HH:MM format
        });
        // TODO: Save message to database and notify recipient
        // Example: await FirebaseFirestore.instance.collection('messages').add({
        //   'conversationId': '${widget.currentUser}_${widget.contact}',
        //   'sender': widget.currentUser,
        //   'text': _messageController.text,
        //   'timestamp': FieldValue.serverTimestamp(),
        // });
        // await FirebaseFirestore.instance.collection('conversations').doc('${widget.currentUser}_${widget.contact}').set({
        //   'participants': [widget.currentUser, widget.contact],
        //   'lastMessage': _messageController.text,
        //   'lastMessageTime': FieldValue.serverTimestamp(),
        //   'unread': FieldValue.increment(1), // Increment unread for recipient
        // }, SetOptions(merge: true));
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(widget.contact),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == widget.currentUser;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(message['text'], style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(message['time'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}