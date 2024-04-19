import 'package:objg/objg.dart';

import '../arena.dart';
import '../heart_control.dart';
import '../platforms.dart';
import 'attacks.dart';

class AttackPlatforms2 extends Attack {
  AttackPlatforms2() : super() {
    final plat1 = registerPlatform(
      group: 72,
      bottomCollisionGroup: 71,
      topDetectionCollision: 13,
      speed: -255.4054,
    );
    final plat2 = registerPlatform(
      group: 74,
      bottomCollisionGroup: 73,
      topDetectionCollision: 14,
      speed: -255.4054,
    );
    final plat3 = registerPlatform(
      group: 76,
      bottomCollisionGroup: 75,
      topDetectionCollision: 15,
      speed: -255.4054,
    );
    final plat4 = registerPlatform(
      group: 78,
      bottomCollisionGroup: 77,
      topDetectionCollision: 16,
      speed: -255.4054,
    );
    final plat5 = registerPlatform(
      group: 79,
      bottomCollisionGroup: 80,
      topDetectionCollision: 17,
      speed: -255.4054,
    );
    final plat6 = registerPlatform(
      group: 81,
      bottomCollisionGroup: 82,
      topDetectionCollision: 18,
      speed: -255.4054,
    );
    final plat7 = registerPlatform(
      group: 85,
      bottomCollisionGroup: 84,
      topDetectionCollision: 19,
      speed: -103.8461,
    );
    final gAll = 69;
    final gPlatformBones = 83;
    final gBonesMovingLeft = 70;
    final gBonesBottom = 88;
    final gBoneRight = 86; // 9450/23, approx. 410.8695
    final gBoneLeft = 87; // 4725/31, approx. 152.4193
    // final gBonesDown = 0;
    _init = sgroup([
      ToggleGroup(group: gAll, enable: false),
      Move(
        y: -23 * 5 * 30,
        seconds: 0,
        target: ReferenceGroup(gAll),
      ),
    ]);

    final arenaMove = moveArenaAndClear(55 * 3, 0, anim: true, animClear: true, then: ReferenceGroup(thenGroup));
    const gArenaSpawn = 36;

    // 91

    _run = sgroup([
      arenaMove.run,
      tpHeartToGroup(gArenaSpawn),
      SpawnTrigger(delay: 0.01, target: swapToBlue),
      SpawnTrigger(
        delay: 1,
        target: sgroup([
          plat1,
          plat2,
          plat3,
          plat4,
          plat5,
          plat6,
          plat7,
          Move(
            x: (-255.4054 * 20).round(),
            y: 0,
            seconds: 20,
            target: ReferenceGroup(gPlatformBones),
          ),
          Move(
            x: -(207.6923 * 20).round(),
            y: 0,
            seconds: 20,
            target: ReferenceGroup(gBonesBottom),
          ),
          ToggleGroup(group: gAll, enable: true),
          SpawnTrigger(
            delay: 5.5,
            target: sgroup([
              Move(
                x: (152.4193 * 20).round(),
                y: 0,
                seconds: 20,
                target: ReferenceGroup(gBoneLeft),
              ),
              SpawnTrigger(
                delay: 23.0 / 30,
                target: Move(
                  x: -(410.8695 * 20).round(),
                  y: 0,
                  seconds: 20,
                  target: ReferenceGroup(gBoneRight),
                ),
              ),
            ]),
          ),
        ]),
      ),
    ]);
  }

  late final GDObject _run;
  @override
  GDObject get run => _run;

  late final GDObject _init;
  @override
  GDObject? get init => _init;
}
