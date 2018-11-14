import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(ChatScreen());
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  //primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

const String _name = "Javier mendoza";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        //new
        sizeFactor: new CurvedAnimation(
            //new
            parent: animationController,
            curve: Curves.easeOut), //new
        axisAlignment: 0.0, //new
        child: new Container(
          //modified
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(_name[0])),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              )
            ],
          ),
        ) //new
        );
  }
}

class ChatScreen extends StatefulWidget {


  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat"), //modified
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Container(
          //modified
          child: new Column(
            //modified
            children: <Widget>[
              //new
              new Flexible(
                //new
                child: new ListView.builder(
                  //new
                  padding: new EdgeInsets.all(8.0), //new
                  reverse: true, //new
                  itemBuilder: (_, int index) => _messages[index], //new
                  itemCount: _messages.length, //new
                ), //new
              ), //new
              new Divider(
                height: 4.0,
                color: Colors.grey[500],
              ), //new
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor), //new
                child: _buildTextComposer(), //modified
              ), //new
            ], //new
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS //new
              ? new BoxDecoration(
                  //new
                  border: new Border(
                    //new
                    top: new BorderSide(color: Colors.grey[400]), //new
                  ), //new
                ) //new
              : null),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: Center(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String text) {
                    //new
                    setState(() {
                      //new
                      _isComposing = text.length > 0; //new
                    }); //new
                  }, //new
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Escribe un mensaje...",
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? //modified
                    new CupertinoButton(
                        //new
                        child: new Text("Enviar"), //new
                        onPressed: _isComposing //new
                            ? () => _handleSubmitted(_textController.text) //new
                            : null,
                      )
                    : //new
                    new IconButton(
                        //modified
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      _textController.clear();
      setState(() {
        //new
        _isComposing = false; //new
      }); //new
      ChatMessage message = new ChatMessage(
        text: text,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 300),
          vsync: this,
        ),
      );
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
    }
  }
}
