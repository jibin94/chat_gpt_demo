import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt_demo/constants/constants.dart';
import 'package:chat_gpt_demo/services/assets_manager.dart';
import 'package:chat_gpt_demo/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});
  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30.0,
                  width: 30.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(child: chatIndex == 0 ? TextWidget(label: msg):DefaultTextStyle(
                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16.0),
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    repeatForever: false,
                    displayFullTextOnTap: true,
                    totalRepeatCount: 1,
                    animatedTexts: [TyperAnimatedText(
                    msg.trim())])),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
