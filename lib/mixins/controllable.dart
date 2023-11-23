import 'package:brainstorm/mixins/has_ground_contact.dart';
import 'package:brainstorm/mixins/sprite.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flutter/services.dart';

enum MovingDirection { left, right, none }

enum MovingState { idle, running, jumping, falling }

mixin ControllableMixin
    on KeyboardHandler, BodyComponent, HasGroundContact, SpriteMixin {
  static const double moveSpeed = 200;
  static const double jumpImpulse = -100000000;

  int horizontalDirection = 0;
  bool jumpPressed = false;

  MovingDirection get movingDirection {
    if (horizontalDirection < 0) {
      return MovingDirection.left;
    } else if (horizontalDirection > 0) {
      return MovingDirection.right;
    } else {
      return MovingDirection.none;
    }
  }

  MovingState get movingState {
    if (jumpPressed) {
      return MovingState.jumping;
    } else if (onGround && horizontalDirection != 0) {
      return MovingState.running;
    } else if (onGround && horizontalDirection == 0) {
      return MovingState.idle;
    } else {
      return MovingState.falling;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft)
        ? -1
        : 0;
    horizontalDirection += keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight)
        ? 1
        : 0;

    jumpPressed = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);

    return true;
  }

  void handleHorizontalMovement() {
    body.linearVelocity.x = horizontalDirection * moveSpeed;
    if (onGround) {
      body.linearVelocity.y = 0;
    }

    // inverted sprite when moving left
    if (movingDirection == MovingDirection.left && sprite.scale.x > 0) {
      sprite.flipHorizontally();
    } else if (movingDirection == MovingDirection.right && sprite.scale.x < 0) {
      sprite.flipHorizontally();
    }
  }

  void handleJumping() {
    if (jumpPressed && onGround) {
      body.applyLinearImpulse(Vector2(0, jumpImpulse),
          point: body.position, wake: true);
      onGround =
          false; // Make sure to handle this based on actual collision detection
    }
  }
}
