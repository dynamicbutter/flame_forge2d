import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart' hide Image;

import 'balls.dart';
import 'boundaries.dart';

class Platform extends BodyComponent {
  final Vector2 position;

  Platform(this.position);

  @override
  Body createBody() {
    PolygonShape shape = PolygonShape()..setAsBoxXY(14.8, 0.125);
    FixtureDef fd = FixtureDef(shape: shape);

    BodyDef bd = BodyDef();
    bd.position = position;
    final body = world.createBody(bd);
    return body..createFixture(fd);
  }
}

class DominoBrick extends BodyComponent {
  final Vector2 position;

  DominoBrick(this.position);

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(0.125, 2.0);
    FixtureDef fixtureDef = FixtureDef(shape: shape)
      ..density = 25.0
      ..friction = .5;

    BodyDef bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class DominoSample extends Forge2DGame with TapDetector {
  @override
  bool debugMode = true;

  DominoSample()
      : super(
          scale: 8.0,
          gravity: Vector2(0, -10.0),
        );

  @override
  Future<void> onLoad() async {
    final boundaries = createBoundaries(worldViewport);
    boundaries.forEach(add);

    for (int i = 0; i < 8; i++) {
      final position = Vector2(0.0, -30.0 + 5 * i);
      add(Platform(position));
    }

    final numberOfRows = 10;
    final numberPerRow = 25;
    for (int i = 0; i < numberOfRows; ++i) {
      for (int j = 0; j < numberPerRow; j++) {
        final position =
            Vector2(-14.75 + j * (29.5 / (numberPerRow - 1)), -27.7 + 5 * i);
        add(DominoBrick(position));
      }
    }
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 screenPosition =
        Vector2(details.localPosition.dx, details.localPosition.dy);
    add(Ball(screenPosition, radius: 1.0));
  }
}
