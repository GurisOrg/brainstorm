import 'package:flame_forge2d/flame_forge2d.dart';

mixin HasGroundContact on BodyComponent {
  bool _onGround = false;

  bool get onGround => _onGround;

  set onGround(bool value) {
    _onGround = value;
    if (debugMode) {
      print('onGround: $value');
    }
    if (value) {
      onGrounded();
    } else {
      onNotGrounded();
    }
  }

  void onGrounded() {}

  void onNotGrounded() {}
}
