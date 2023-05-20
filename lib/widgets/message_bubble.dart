import 'package:flutter/material.dart';

import '../providers/chat.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        alignment:
            message.mode == Mode.send ? WrapAlignment.end : WrapAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            constraints: const BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.amber,
            ),
            child: Text(
              message.content,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
