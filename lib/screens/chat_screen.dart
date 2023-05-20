import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_list.dart';
import '../providers/chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static var routeName = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: const Text('title'),
    );
    final TextEditingController textController = TextEditingController();

    void _send(String message) {
      textController.clear();
      Provider.of<Chat>(context, listen: false).sendMessage(message);
    }

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            constraints: const BoxConstraints(maxHeight: 155),
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color.fromARGB(255, 120, 120, 120),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 330,
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Enter your message',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 20,
                            ),
                          ),
                          style: const TextStyle(fontSize: 20),
                          cursorHeight: 25,
                        ),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 63,
                  width: 63,
                  child: ElevatedButton(
                    onPressed: () => _send(textController.text),
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll<double?>(0),
                      backgroundColor: MaterialStatePropertyAll<Color?>(
                          Theme.of(context).colorScheme.secondary),
                      shape: MaterialStatePropertyAll<OutlinedBorder?>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    child: const Icon(
                      size: 25,
                      Icons.send,
                      color: Colors.white,
                    ),
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
