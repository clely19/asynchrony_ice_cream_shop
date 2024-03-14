import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({
    Key? key,
    this.message = "",
    required this.chatBoxColor,
    this.textColor = Colors.black,
    this.imageURL = "",
  }) : super(key: key);

  final String message;
  final Color chatBoxColor;
  final Color textColor;
  final String imageURL;

  // void verifyconditions() {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 250,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 2 / 3,
        minWidth: MediaQuery.of(context).size.width / 4,
        minHeight: MediaQuery.of(context).size.height / 15,
      ),
      decoration: BoxDecoration(
        color: chatBoxColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextBox(
            message: message,
            textColor: textColor,
          )),
    );
  }
}

class TextBox extends StatefulWidget {
  const TextBox({
    Key? key,
    required String message,
    required Color textColor,
  })  : _message = message,
        _textColor = textColor,
        super(key: key);

  final String _message;
  final Color _textColor;

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  String url = "";

  @override
  Widget build(BuildContext context) {

    return RichText(
      text: TextSpan(
        text: widget._message != "" ? "${widget._message}\n" : "\n",
        style: TextStyle(
          color: widget._textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}