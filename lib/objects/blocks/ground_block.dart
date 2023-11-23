import 'package:brainstorm/mixins/has_ground_contact.dart';
import 'package:brainstorm/mixins/sprite.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class GroundBlock extends BodyComponent with ContactCallbacks, SpriteMixin {
  GroundBlock({
    required this.position,
    required this.xOffset,
  });

  @override
  Vector2 position;
  double xOffset;

  late Vector2 _finalPosition;
  final Vector2 size = Vector2.all(64);

  @override
  String get spriteName => 'block.png';

  @override
  Vector2 get spriteSize => size;

  @override
  Anchor get spriteAnchor => Anchor.bottomLeft;

  @mustCallSuper
  @override
  Body createBody() {
    _finalPosition = Vector2(
      position.x * size.x + xOffset,
      game.size.y - position.y * size.y,
    );

    final shape = PolygonShape()
      ..setAsBox(
        size.x / 2,
        size.y / 2,
        Vector2(size.x / 2, -(size.y / 2)),
        0,
      );
    final fixtureDef = FixtureDef(shape)
      ..shape = shape
      ..restitution = 0.0
      ..density = 1.0
      ..friction = 0.0;
    final bodyDef = BodyDef()
      ..position = _finalPosition
      ..type = BodyType.static
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @mustCallSuper
  @override
  void beginContact(Object other, Contact contact) {
    // stops the other object from falling (y down)
    if (other is HasGroundContact) {
      other.onGround = true;
    }
    super.beginContact(other, contact);
  }

  @mustCallSuper
  @override
  void endContact(Object other, Contact contact) {
    if (other is HasGroundContact) {
      other.onGround = false;
    }
    super.endContact(other, contact);
  }
}
