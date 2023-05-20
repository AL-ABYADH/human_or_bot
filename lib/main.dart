import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:human_or_bot/providers/chat_partner.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './screens/chat_screen.dart';
import 'providers/chat.dart';
import 'providers/user.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final openAI = OpenAI.instance.build(
    token: dotenv.env['API_KEY'],
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 600)),
  );

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ChatPartner get _chatPartner {
    return ChatPartner(name: 'John', kind: 'Bot', id: 'j1');
  }

  final _user = User(name: 'Ali', id: 'a1');

  Future<void> _startChat(BuildContext ctx) async {
    Uri url = Uri.parse(
        'https://human-or-bot-default-rtdb.firebaseio.com/chats.json');

    final user = json.encode({
      'name': _user.name,
      'id': _user.id,
      'kind': _user.kind,
    });

    final chatPartner = json.encode({
      'name': _chatPartner.name,
      'id': _chatPartner.id,
      'kind': _chatPartner.kind,
    });

    await http.post(url,
        body: json.encode({'user': user, 'chatPartner': chatPartner}));

    Navigator.of(ctx).pushNamed(ChatScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(startChat: _startChat),
      routes: {
        ChatScreen.routeName: (ctx) => ChangeNotifierProvider.value(
              value: Chat(user: _user, chatPartner: _chatPartner),
              builder: (context, child) => const ChatScreen(),
            ),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Future<void> Function(BuildContext) startChat;

  const HomeScreen({super.key, required this.startChat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(
        onPressed: () => startChat(context),
        child: const Text('start chat'),
      ),
    );
  }
}
