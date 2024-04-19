import 'dart:io';

import 'package:objg/objg.dart';
import 'health.dart';
import 'heart_control.dart';
import 'objg.dart';

GDObject registerPlatform({
  required int group,
  required int bottomCollisionGroup,
  required int topDetectionCollision,
  required double speed,
}) {
  SpawnTrigger(
    onStart: true,
    target: sgroup([
      ToggleGroup(group: group, enable: false),
      ToggleGroup(group: bottomCollisionGroup, enable: false),
      Collision(
        blockA: cgPlayerBlue,
        blockB: topDetectionCollision,
        then: ToggleGroup(
          group: bottomCollisionGroup,
          enable: true,
        ),
      ),
      Collision(
        blockA: cgPlayerBlue,
        blockB: topDetectionCollision,
        triggerOnExit: true,
        then: ToggleGroup(
          group: bottomCollisionGroup,
          enable: false,
        ),
      ),
      CountListener(
        itemID: iOnGround,
        targetCount: 1,
        then: InstantCollision(
          blockA: cgPlayerBlue,
          blockB: topDetectionCollision,
          then: ogroup([
            Stop(
              type: StopType.stop,
              target: ReferenceGroup(iMovingPlatformMove),
            ),
            Move(
              x: (speed * 20).round(),
              seconds: 20,
              target: ReferenceGroup(cgPlayerBlue),
            )..groups.add(iMovingPlatformMove)
          ]),
        ),
      ),
    ]),
  );
  return sgroup([
    ToggleGroup(group: group, enable: true),
    Move(
      x: (speed * 20).round(),
      y: 0,
      seconds: 20,
      target: ReferenceGroup(group),
    ),
    SpawnTrigger(
      delay: 20,
      target: sgroup([
        ToggleGroup(group: group, enable: false),
        Move(
          x: -(speed * 20).round(),
          y: 0,
          seconds: 0,
          target: ReferenceGroup(group),
        ),
      ]),
    ),
  ]);
}
