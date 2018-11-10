import 'package:flutter/material.dart';
import 'auth.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'backdrop.dart';
import 'colores.dart';
import 'model/product.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          title: 'Flutter Login',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        return Backdrop(
          // TODO: Make currentCategory field take _currentCategory (104)
          currentCategory: Category.all,
          // TODO: Pass _currentCategory for frontLayer (104)
          frontLayer: HomePage(auth: widget.auth,
              onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)),
          // TODO: Change backLayer field value to CategoryMenuPage (104)
          backLayer: Container(color: kShrinePink100),
          frontTitle: Text('SHRINE'),
          backTitle: Text('MENU'),
        ); /*HomePage(
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));*/

    }
  }
}
