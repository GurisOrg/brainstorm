import 'package:brainstorm/managers/segment_manager.dart';
import 'package:brainstorm/objects/blocks/ground_block.dart';
import 'package:brainstorm/objects/star/star.dart';
import 'package:brainstorm/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class EmberQuestGame extends Forge2DGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  EmberQuestGame();
  @override
  bool debugMode = true;

  @override
  final world = Forge2DWorld(gravity: Vector2(0, 10.0));
  late final CameraComponent cameraComponent;

  late Player _player;
  double objectSpeed = 0.0;

  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  List<Component> componentsToRemove = [];

  // delta time is the time between frames
  double deltaTime = 0.0;

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'player.png',
      'star.png',
    ]);

    cameraComponent = CameraComponent(world: world);
    // Everything in this tutorial assumes that the position
    // of the `CameraComponent`s viewfinder (where the camera is looking)
    // is in the top left corner, that's why we set the anchor here.
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, world]);

    initializeGame();

    // top left corner
    add(FpsTextComponent(position: Vector2(10, 10)));
  }

  void initializeGame() {
    // Assume that size.x < 3200
    int segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad = segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i < segmentsToLoad; i++) {
      loadGameSegments(i, i * 640);
    }

    _player = Player(
      position: Vector2(128, canvasSize.y - 128),
      size: Vector2(64, 64),
    );
    world.add(_player);
  }

  void resetGame() {
    objectSpeed = 0.0;
    lastBlockXPosition = 0.0;
    lastBlockKey = UniqueKey();

    for (final component in componentsToRemove) {
      // check if component is still in the world
      if (!component.isRemoved) {
        component.removeFromParent();
      }
    }

    componentsToRemove.clear();

    initializeGame();
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          final gBlock = GroundBlock(
            position: block.gridPosition,
            xOffset: xPositionOffset,
          );
          componentsToRemove.add(gBlock);
          add(
            gBlock,
          );
          break;
        case Star:
          final star = Star(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          );
          componentsToRemove.add(star);
          add(
            star,
          );
          break;
      }
    }
  }
}
