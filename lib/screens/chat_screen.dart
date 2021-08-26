import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  //declare our text controller to send chat messages
  final _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  //add focus node to put focus back on the text field after the chat message
  //has been submitted
  final FocusNode _focusNode = FocusNode();
  //declare a bool for the send button to be enabled if there is text in the
  //field and disabled if there is no text
  bool _isComposing = false;

  //send chat messages widget
  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,

              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
              focusNode: _focusNode,
              //check if there is text in the field
              onChanged: (String text) {
                setState(
                  () {
                    _isComposing = text.isNotEmpty;
                  },
                );
              },
              //check if there is no text in the field and if true then send
              //the message
              onSubmitted: _isComposing ? _handleSubmitted : null,
            ),
          ),
          IconTheme(
            data: IconThemeData(
              color: Theme.of(context).accentColor,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: IconButton(
                //if there is no text in the text field then icon button is
                //disabled and if there is text in the text field then icon
                //button is enabled
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //method to clear our text controller on submitted
  void _handleSubmitted(String text) {
    _textController.clear();
    //set _isComposing to false when the text field is cleared
    setState(() {
      _isComposing = false;
    });
    final ChatMessage message = ChatMessage(
      text: text,
      //add our animation controller
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 700,
        ),
      ),
    );
    //add new message to our list of messages
    setState(() {
      _messages.insert(0, message);
    });
    //request focus on the text field
    _focusNode.requestFocus();
    //attach animation controller to a new message, specifying that the
    //animation should play forward whenever a message is added to the chat list
    message.animationController.forward();
  }

//method to dispose of animationController to prevent errors
  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FriendlyChat'),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          const Divider(
            height: 2,
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key? key,
    required this.text,
    required this.animationController,
  }) : super(key: key);
  final String text;
  //add a variable to store the animation controller
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    const String _name = 'blacky';
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 16,
                ),
                child: CircleAvatar(
                  child: Text(_name[0]),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
