
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'model/product.dart';
import 'auth.dart';
import 'colores.dart';
// TODO: Add velocity constant (104)
const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({this.auth, this.onSignOut,
    @required this.currentCategory,
    @required this.frontLayer,
    @required this.backLayer,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(currentCategory != null),
        assert(frontLayer != null),
        assert(backLayer != null),
        assert(frontTitle != null),
        assert(backTitle != null);

  @override
  _BackdropState createState() => _BackdropState();


}

// TODO: Add _BackdropState class (104)
class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  // TODO: Add AnimationController widget (104)
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  // TODO: Add override for didUpdateWidget (104)

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // TODO: Add functions to get and change front layer visibility (104)
  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

// TODO: Add BuildContext and BoxConstraints parameters to _buildStack (104)
  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    // TODO: Create a RelativeRectTween Animation (104)
    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        // TODO: Add a PositionedTransition (104)
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            // TODO: Implement onTap property on _BackdropState (104)
            child: widget.frontLayer,

          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {

    var appBar =AppBar(
      //  brightness: Brightness.dark,
      brightness: Brightness.light,
      elevation: 0.0,
      title: Text('Home'),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: _toggleBackdropLayerVisibility,
      ),

      actions: <Widget>[

         FlatButton(
           // onPressed: _signOut,
            child: new Text('Salir',
                style: new TextStyle(fontSize: 17.0, color: Colors.white))),
        IconButton(
          icon: Icon(
            Icons.search,
            semanticLabel: 'buscar',
          ),
          onPressed: () {
            print('Ha presionado el boton buscar..');
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      // TODO: Return a LayoutBuilder widget (104)
      body: LayoutBuilder(builder: _buildStack),
    );
  }
}

class _FrontLayer extends StatelessWidget {
  // TODO: Add on-tap callback (104)
  const _FrontLayer({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kShrineSurfaceWhite,
      elevation: 16.0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0),  ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // TODO: Add a GestureDetector (104)
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}