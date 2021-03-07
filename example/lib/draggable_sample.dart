import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/gestures.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';

import 'balls.dart';
import 'boundaries.dart';

class DraggableSample extends Forge2DGame with HasDraggableComponents {
  @override
  bool debugMode = true;

  DraggableSample()
      : super(
          scale: 4.0,
          gravity: Vector2(0, 0.0),
        );

  @override
  Future<void> onLoad() async {
    final boundaries = createBoundaries(worldViewport);
    boundaries.forEach(add);
    add(DraggableBall(viewport.effectiveSize / 2));
  }
}

class DraggableBall extends Ball with Draggable {
  DraggableBall(Vector2 position) : super(position, radius: 20) {
    originalPaint = BasicPalette.white.paint;
    paint = originalPaint;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateDetails details) {
    paint = randomPaint();
    final worldDelta = details.delta.toVector2()..multiply(Vector2(1.0, -1.0));
    body.applyLinearImpulse(worldDelta * 1000);
    return true;
  }
}
