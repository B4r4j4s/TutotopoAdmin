import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<ChatMessage> chatMessages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  return ChatMessageWidget(message: chatMessages[index]);
                },
              ),
            ),
            ChatInputWidget(
              onMessageSubmitted: (text) {
                addMessage(text, isUser: true);
                // Aquí puedes manejar la lógica del chatbot y agregar respuestas
              },
            ),
          ],
        ),
      ),
    );
  }

  void addMessage(String text, {bool isUser = false}) {
    setState(() {
      chatMessages.add(ChatMessage(text: text, isUser: isUser));
    });
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, this.isUser = false});
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  ChatMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class ChatInputWidget extends StatelessWidget {
  final ValueChanged<String> onMessageSubmitted;

  ChatInputWidget({required this.onMessageSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (text) {
                onMessageSubmitted(text);
              },
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding: EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Agregar lógica para enviar el mensaje
            },
          ),
        ],
      ),
    );
  }
}
