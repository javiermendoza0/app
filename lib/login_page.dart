import 'package:flutter/material.dart';
import 'auth.dart';
import 'colores.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

enum FormType { login, register }

// TODO: Add AccentColorOverride (103)
class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(accentColor: color),
    );
  }
}

class _MyHomePageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
          title: Text('Login'),
        ),*/
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Center(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                                key: formkey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: _buildInputs() + _buildButtons(),
                                ))),
                      ])),
                  hintText()
                ]))),
      ),
    );
  }

  List<Widget> _buildInputs() {
    return [
      padded(
          child: Image.asset(
        '0-0.jpg',
        package: 'shrine_images',
        fit: BoxFit.fitWidth,
        // TODO: Adjust the box size (102)
      )),
      padded(
          child: TextFormField(
        decoration: InputDecoration(
          labelText: 'E-mail',
        ),
        validator: (value) => value.isEmpty ? 'Ingrese su e-mail' : null,
        onSaved: (value) => _email = value,
      )),
      padded(
          child: TextFormField(
        decoration: InputDecoration(

          labelText: 'Contraseña',
        ),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Ingrese la contraseña' : null,
        onSaved: (value) => _password = value,
      )),
      _confContras(),
    ];
  }

  Widget _confContras() {
    if (_formType != FormType.login) {
      return padded(
          child: TextFormField(

        decoration: InputDecoration(

          labelText: 'Confirma la contraseña',
        ),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Ingrese la contraseña' : null,
        onSaved: (value) => _password = value,
      ));
    }
    return Center();
  }

  List<Widget> _buildButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          elevation: 4.0,
          color: Theme.of(context).buttonColor,
          //splashColor: Colors.blueGrey,
          child: Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 24.0,color: Theme.of(context).accentColor
            ),
          ),
          onPressed: _valida_envia,
        ),
        OutlineButton(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: _moveCrear,
          child: Text(
            'Crear cuenta',
            style: TextStyle(
                fontSize: 16.0,color: Theme.of(context).accentColor),
          ),
        )
      ];
    } else {
      return [
        RaisedButton(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          elevation: 4.0,
          color: Theme.of(context).buttonColor,
        //  splashColor: Colors.blueGrey,
          child: Text(
            'Crear cuenta',
            style: TextStyle( fontSize: 24.0,color: Theme.of(context).accentColor),
          ),
          onPressed: _valida_envia,
        ),
        OutlineButton(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: _moveIniciar,
          child: Text(
            'Inicie Sesión',
            style: TextStyle(
                fontSize: 16.0, color: Theme.of(context).accentColor),
          ),
        )
      ];
    }
  }

  void _moveCrear() async {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void _moveIniciar() async {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  bool _valida_inicio() {
    final form = formkey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  void _valida_envia() async {
    if (_valida_inicio()) {
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        widget.onSignIn();
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: child,
    );
  }

  Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center));
  }
}
