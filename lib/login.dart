import 'package:flutter/material.dart';

class login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => statelogin();
}

class statelogin extends State<login> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('App '),
      ),
      body: new Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'images/name.jpg',
                width: 100.0,
                height: 100.0,
              ),

              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                        key: null,
                        onPressed: buttonPressed,
                        color: const Color(0xFF0099ed),
                        child: new Text("BUTTON 1",
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: const Color(0xFFffffff),
                                fontWeight: FontWeight.w200,
                                fontFamily: "Roboto"))),
                    new RaisedButton(
                        key: null,
                        onPressed: buttonPressed,
                        color: const Color(0xFF0099ed),
                        child: new Text("BUTTON 2",
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: const Color(0xFFffffff),
                                fontWeight: FontWeight.w200,
                                fontFamily: "Roboto")))
                  ])
            ]),
      ),
    );
  }

  void buttonPressed() {}
}
