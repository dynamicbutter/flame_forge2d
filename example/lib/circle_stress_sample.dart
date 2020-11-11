import 'dart:math';

import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart' hide Image;

import 'balls.dart';
import 'boundaries.dart';

class CirlcleShuffler extends BodyComponent {
  @override
  Body createBody() {
    var bd = BodyDef()
      ..type = BodyType.DYNAMIC
      ..position = Vector2(0.0, -25.0);
    double numPieces = 5;
    double radius = 6.0;
    var body = world.createBody(bd);

    for (int i = 0; i < numPieces; i++) {
      double xPos = radius * cos(2 * pi * (i / numPieces));
      double yPos = radius * sin(2 * pi * (i / numPieces));

      var shape = CircleShape()
        ..radius = 1.2
        ..position.setValues(xPos, yPos);

      final fixtureDef = FixtureDef()
        ..shape = shape
        ..density = 50.0
        ..friction = .1
        ..restitution = .9;

      body.createFixture(fixtureDef);
    }
    // Create an empty ground body.
    var bodyDef = BodyDef();
    var groundBody = world.createBody(bodyDef);

    RevoluteJointDef rjd = RevoluteJointDef()
      ..initialize(body, groundBody, body.position)
      ..motorSpeed = pi
      ..maxMotorTorque = 1000000.0
      ..enableMotor = true;

    world.createJoint(rjd);
    return body;
  }
}

class CornerRamp extends BodyComponent {
  @override
  Body createBody() {
    final ChainShape shape = ChainShape();
    List<Vector2> vertices = [
      Vector2.zero(),
      Vector2(20, 20),
      Vector2(35, 35),
    ];
    shape.createLoop(vertices);

    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 0.0
      ..friction = 0.1;

    final bodyDef = BodyDef()
      ..position = Vector2.zero()
      ..type = BodyType.STATIC;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class CircleStressSample extends Forge2DGame with TapDetector {
  CircleStressSample(Vector2 viewportSize)
      : super(
          scale: 8.0,
          gravity: Vector2(0, -10.0),
        ) {
    viewport.resize(viewportSize);
    final boundaries = createBoundaries(viewport);
    boundaries.forEach(add);
    add(CirlcleShuffler());
    add(CornerRamp());
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    final Vector2 screenPosition =
        Vector2(details.localPosition.dx, details.localPosition.dy);
    final Random random = Random();
    List.generate(15, (i) {
      final Vector2 randomVector =
          (Vector2.random() - Vector2.all(-0.5)).normalized();
      add(Ball(screenPosition + randomVector, radius: random.nextDouble()));
    });
  }
}
