import 'package:chat_gpt_demo/constants/constants.dart';
import 'package:chat_gpt_demo/widgets/drop_down.dart';
import 'package:chat_gpt_demo/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class Services {
  static Future<void> showBottomModalSheet(
      {required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: TextWidget(
                    label: 'Chosen model:',
                    fontSize: 16.0,
                  )),
                  Flexible(flex: 2, child: ModelsDropDownWidget())
                ]),
          );
        });
  }
}
