import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final TextEditingController _searchQuery;
  final List<Message> _messages = [
    Message(
        'assets/images/P1.png', 'John Doe', 'Hey, how are you?', '08:48 AM'),
    Message(
        'assets/images/P2.png', 'Jane Smith', 'See you tomorrow!', 'Yesterday'),
    Message('assets/images/P3.png', 'HR Jesica', 'Don\'t forget the meeting.',
        'Today'),
    Message('assets/images/P4.png', 'Alice Brown', 'Let\'s catch up soon.',
        '10:30 AM'),
    Message('assets/images/P5.png', 'Bob White',
        'Project deadline is approaching.', '11:00 AM'),
    Message('assets/images/P6.png', 'Charlie Green',
        'Meeting rescheduled to next week.', '2:15 PM'),
    Message('assets/images/P7.png', 'Diana Blue',
        'Can you review the document?', '4:45 PM'),
    Message(
        'assets/images/P8.png', 'Eve Black', 'Happy birthday!', 'Yesterday'),
    Message('assets/images/P9.png', 'Frank Gray', 'Lunch at noon?', '09:00 AM'),
    Message('assets/images/P10.png', 'Grace Gold', 'Thanks for your help!',
        '3:30 PM'),
    Message('assets/images/P11.png', 'Henry Silver',
        'Don\'t forget the code review.', '5:00 PM'),
    Message('assets/images/P1.png', 'Ivy Bronze', 'How was your weekend?',
        'Yesterday'),
    Message('assets/images/P5.png', 'Jack Purple',
        'Reminder for the presentation.', '11:30 AM'),
    Message('assets/images/P4.png', 'Kara Orange', 'Let\'s have a call later.',
        '1:00 PM'),
    Message('assets/images/P3.png', 'Liam Red', 'Good job on the report!',
        '6:00 PM'),
  ];

  List<Message> _filteredMessages = [];

  @override
  void initState() {
    super.initState();
    _searchQuery = TextEditingController();
    _filteredMessages = _messages;
    _searchQuery.addListener(_filterMessages);
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  void _filterMessages() {
    final query = _searchQuery.text.toLowerCase();
    setState(() {
      _filteredMessages = _messages.where((message) {
        return message.name.toLowerCase().contains(query) ||
            message.recentMessage.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Messages", style: TextStyle(fontSize: 25)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _searchQuery,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 242, 242, 247),
                hintText: "Search for shops & messages",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _filteredMessages.map((message) {
                return MessageTile(
                  profileImage: message.profileImage,
                  name: message.name,
                  recentMessage: message.recentMessage,
                  time: message.time,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String profileImage;
  final String name;
  final String recentMessage;
  final String time;

  Message(this.profileImage, this.name, this.recentMessage, this.time);
}

class MessageTile extends StatelessWidget {
  final String profileImage;
  final String name;
  final String recentMessage;
  final String time;

  const MessageTile({
    super.key,
    required this.profileImage,
    required this.name,
    required this.recentMessage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(profileImage),
          radius: 25,
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recentMessage,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
