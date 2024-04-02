import 'dart:developer';
import 'package:chat_gpt_demo/constants/constants.dart';
import 'package:chat_gpt_demo/providers/chat_provider.dart';
import 'package:chat_gpt_demo/providers/models_provider.dart';
import 'package:chat_gpt_demo/services/services.dart';
import 'package:chat_gpt_demo/widgets/chat_widget.dart';
import 'package:chat_gpt_demo/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../services/assets_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    _scrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    final chatListProvider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showBottomModalSheet(context: context);
              },
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white))
        ],
        elevation: 2,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.asset(AssetsManager.openaiLogo),)),
        title: const Text('Chat GPT'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      chatListProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                        msg: chatListProvider
                            .getChatList[index].msg, //chatList[index].msg,
                        chatIndex: chatListProvider.getChatList[index]
                            .chatIndex //chatList[index].chatIndex,
                        );
                  }),
            ),
            if (isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18.0,
              ),
            ],
            const SizedBox(
              height: 15.0,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      focusNode: focusNode,
                      style: const TextStyle(color: Colors.white),
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        await sendMessageFCT(modelsProvider, chatListProvider);
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: 'How can I help you?',
                          hintStyle: TextStyle(color: Colors.grey)),
                    )),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(modelsProvider, chatListProvider);
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      ModelsProvider modelsProvider, ChatProvider chatListProvider) async {
    if (isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
            label:
                "You couldn't send multiple messages at a time, please wait."),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: "Please type a message."),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        isTyping = true;
        chatListProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatListProvider.sendMessageAndGetAnswers(
          chosenModelId: modelsProvider.getCurrentModel, msg: msg);
      setState(() {});
    } catch (e) {
      log('$e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: e.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isTyping = false;
        scrollListToEnd();
      });
    }
  }
}
