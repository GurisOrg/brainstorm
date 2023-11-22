import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class GroundBlock extends BodyComponent {
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
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await game.loadSprite('block.png');
    // renderBody = false;

    add(
      SpriteComponent(
        sprite: sprite,
        size: size,
        anchor: Anchor.bottomLeft,
      ),
    );
  }

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

  // final Vector2 gridPosition;
  // double xOffset;

  // final UniqueKey _blockKey = UniqueKey();
  // final Vector2 velocity = Vector2.zero();

  // GroundBlock({
  //   required this.gridPosition,
  //   required this.xOffset,
  // }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  // @override
  // void onLoad() {
  //   final groundImage = game.images.fromCache('block.png');
  //   sprite = Sprite(groundImage);
  //   position = Vector2(
  //     gridPosition.x * size.x + xOffset,
  //     game.size.y - gridPosition.y * size.y,
  //   );

  //   // Set hitbox size to match GroundBlock size
  //   add(
  //     RectangleHitbox(
  //       size: size,
  //       anchor: Anchor.topLeft,
  //       collisionType: CollisionType.passive,
  //     ),
  //   );

  //   if (gridPosition.x == 9 && position.x > game.lastBlockXPosition) {
  //     game.lastBlockKey = _blockKey;
  //     game.lastBlockXPosition = position.x + size.x;
  //   }
  // }

  // @override
  // void update(double dt) {
  //   velocity.x = game.objectSpeed;
  //   position += velocity * dt;

  //   if (position.x < -size.x) {
  //     removeFromParent();
  //     if (gridPosition.x == 0) {
  //       game.loadGameSegments(
  //         Random().nextInt(segments.length),
  //         game.lastBlockXPosition,
  //       );
  //     }
  //   }
  //   if (gridPosition.x == 9) {
  //     if (game.lastBlockKey == _blockKey) {
  //       game.lastBlockXPosition = position.x + size.x - 10;
  //     }
  //   }

  //   super.update(dt);
  // }
}
