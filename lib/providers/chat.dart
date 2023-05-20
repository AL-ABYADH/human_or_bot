import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:retry/retry.dart';

import 'chat_partner.dart';
import 'user.dart';
import '../main.dart';

class Chat with ChangeNotifier {
  final User user;
  final ChatPartner chatPartner;

  Chat({required this.chatPartner, required this.user});

  final List<Message> _messages = [
    // Message(
    //   content: 'hi',
    //   chatPartner: User(name: 'Yahya', id: 'y1'),
    //   mode: Mode.send,
    // ),
    // Message(
    //   content: 'hello, how can I help you?',
    //   chatPartner: ChatPartner(name: 'Bob', kind: 'Bot', id: 'b1'),
    //   mode: Mode.receive,
    // ),
    // Message(
    //   content: 'give me a joke',
    //   chatPartner: User(name: 'Yahya', id: 'y1'),
    //   mode: Mode.send,
    // ),
  ];

  Future<void> sendMessage(String message) async {
    _messages
        .add(Message(content: message, chatPartner: user, mode: Mode.send));

    notifyListeners();

    final OpenAI openAI = MyApp.openAI;
    String result = '';
    final request = ChatCompleteText(messages: [
      Map.of({
        "role": "user",
        "content": '''Your name is ${chatPartner.name}.
            You're a chat partner at a random chatting game where you must try to figure out whether you're talking to a human or a bot.
            You must text like a human to deceive the other partner.
            A real human wouldn't offer assistance, wouldn't chat formally, and wouldn't send long messages, so keep your messages chatty, informal, and short.
            You must talk informally like humans do in their online text messages,
            and you shouldn't care about the correct punctuation and capitalization.
            $_chatHistory Me: $message <-- This is a current message
            You:'''
      })
    ], maxToken: 200, model: ChatModel.gptTurbo0301);

    try {
      const r = RetryOptions(maxAttempts: 5);
      final response = await r
          .retry(() => openAI.onChatCompletion(request: request))
          .timeout(const Duration(seconds: 30));
      for (var element in response!.choices) {
        result = result + (element.message?.content)!;
      }

      _messages.add(Message(
          content: result, chatPartner: chatPartner, mode: Mode.receive));
    } catch (err) {
      print(err);
    }

    notifyListeners();
  }

  String get _chatHistory {
    String history = '';
    for (Message message in _messages) {
      history =
          '$history ${(message.chatPartner.kind == 'human' ? 'Me: ${message.content}' : 'You: ${message.content}')}\n';
    }
    return history;
  }

  List<Message> get messages {
    return [..._messages];
  }
}

class Message with ChangeNotifier {
  final String content;
  final ChatPartner chatPartner;
  final Mode mode;

  Message(
      {required this.content, required this.chatPartner, required this.mode});
}

enum Mode {
  send,
  receive,
}
