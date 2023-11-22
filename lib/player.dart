import 'package:brainstorm/game.dart';
import 'package:brainstorm/objects/blocks/ground_block.dart';
import 'package:brainstorm/objects/star/star.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class EmberPlayer extends SpriteComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<EmberQuestGame> {
  EmberPlayer({
    required super.position,
  }) : super(size: Vector2.all(48), anchor: Anchor.center);

  int horizontalDirection = 0;

  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;

  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;

  final double gravity = 1200; // Adjust for a more natural feel
  final double jumpSpeed = -600; // Adjust for a more natural feel
  final double terminalVelocity = 600;

  bool hasJumped = false;

  @override
  void onLoad() {
    sprite = Sprite(gameRef.images.fromCache('player.png'));
    add(CircleHitbox(
      isSolid: true,
    ));
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position += velocity * dt;

    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    applyGravity(dt);

    // Determine if ember has jumped
    if (hasJumped) {
      if (isOnGround) {
        velocity.y = jumpSpeed;
        velocity.x *= 0.5; // Reduce horizontal speed during jump
        isOnGround = false;
      }
      hasJumped = false;
    }

    // Limit the vertical velocity to the terminal velocity
    velocity.y = velocity.y.clamp(-terminalVelocity, terminalVelocity);

    preventOffScreen();

    super.update(dt);
  }

  void applyGravity(double dt) {
    // Calculate time-based acceleration due to gravity
    final gravityAcceleration = gravity * dt;

    // Apply damping factor to reduce velocity over time
    velocity.y *= 0.95;

    // Update the vertical velocity with the calculated acceleration
    velocity.y += gravityAcceleration;
  }

  // method to prevent player from going off-screen
  void preventOffScreen() {
    // Prevent ember from going backward at the screen edge.
    if (position.x < size.x / 2) {
      position.x = size.x / 2;
    }

    // Prevent ember from going forward at the screen edge.
    if (position.x > gameRef.size.x - size.x / 2) {
      position.x = gameRef.size.x - size.x / 2;
    }

    // If ember is below the screen, reset the game.
    if (position.y > gameRef.size.y + size.y) {
      removeFromParent();
      gameRef.resetGame();
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    return true;
  }

  void handleGroundBlockCollision(Set<Vector2> intersectionPoints) {
    if (intersectionPoints.length == 2) {
      final mid =
          (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) /
              2;

      final collisionNormal = absoluteCenter - mid;
      final separationDistance = (size.x / 2) - collisionNormal.length;
      collisionNormal.normalize();

      if (fromAbove.dot(collisionNormal) > 0.9) {
        isOnGround = true;
      }

      position += collisionNormal.scaled(separationDistance);
    }
  }

  void handleStarCollision(Star star) {
    star.removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock) {
      handleGroundBlockCollision(intersectionPoints);
    } else if (other is Star) {
      handleStarCollision(other);
    }

    // Add more else if blocks for other object types if needed.

    super.onCollision(intersectionPoints, other);
  }
}
