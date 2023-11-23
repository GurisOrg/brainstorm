import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';

mixin SpriteMixin on BodyComponent {
  late SpriteComponent sprite;
  Vector2 get spriteSize;

  String get spriteName;

  Anchor get spriteAnchor => Anchor.center;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final playerSprite = await game.loadSprite(spriteName);
    renderBody = false;
    sprite = SpriteComponent(
      sprite: playerSprite,
      size: spriteSize,
      anchor: spriteAnchor,
    );
    add(sprite);
  }
}
