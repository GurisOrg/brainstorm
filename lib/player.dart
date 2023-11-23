import 'package:brainstorm/mixins/controllable.dart';
import 'package:brainstorm/mixins/has_ground_contact.dart';
import 'package:brainstorm/mixins/sprite.dart';
import 'package:brainstorm/objects/star/star.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Player extends BodyComponent
    with KeyboardHandler, HasGroundContact, SpriteMixin, ControllableMixin {
  Player({
    required this.position,
    required this.size,
  });

  @override
  Vector2 position;

  final Vector2 size;

  @override
  String get spriteName => 'player.png';

  @override
  Vector2 get spriteSize => size;

  @override
  Body createBody() {
    final shape = CircleShape()
      ..radius = size.x / 2
      ..position.setFrom(Vector2.zero());
    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.0
      ..density = 1.0
      ..friction = 0.0;
    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.dynamic
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void handleStarCollision(Star star) {
    star.removeFromParent();
  }

  @override
  void update(double dt) {
    // Handle horizontal movement
    handleHorizontalMovement();

    handleJumping();
  }
}
