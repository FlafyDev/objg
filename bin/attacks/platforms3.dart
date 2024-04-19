import 'package:objg/objg.dart';

import '../arena.dart';
import '../heart_control.dart';
import '../platforms.dart';
import 'attacks.dart';

class AttackPlatforms3 extends Attack {
  AttackPlatforms3() : super() {
    final platMiddle1 = registerPlatform(
      group: 102,
      bottomCollisionGroup: 106,
      topDetectionCollision: 25,
      speed: 203.2258,
    );
    final platMiddle2 = registerPlatform(
      group: 103,
      bottomCollisionGroup: 107,
      topDetectionCollision: 26,
      speed: 203.2258,
    );
    final platMiddle3 = registerPlatform(
      group: 104,
      bottomCollisionGroup: 108,
      topDetectionCollision: 28,
      speed: 203.2258,
    );
    final platMiddle4 = registerPlatform(
      group: 105,
      bottomCollisionGroup: 109,
      topDetectionCollision: 25,
      speed: 203.2258,
    );

    final platBottom1 = registerPlatform(
      group: 90,
      bottomCollisionGroup: 91,
      topDetectionCollision: 20,
      speed: -203.2258,
    );
    final platBottom2 = registerPlatform(
      group: 92,
      bottomCollisionGroup: 96,
      topDetectionCollision: 21,
      speed: -203.2258,
    );
    final platBottom3 = registerPlatform(
      group: 93,
      bottomCollisionGroup: 97,
      topDetectionCollision: 22,
      speed: -203.2258,
    );
    final platBottom4 = registerPlatform(
      group: 94,
      bottomCollisionGroup: 98,
      topDetectionCollision: 23,
      speed: -203.2258,
    );
    final platBottom5 = registerPlatform(
      group: 95,
      bottomCollisionGroup: 100,
      topDetectionCollision: 24,
      speed: -203.2258,
    );
    final gAll = 89;
    final gBonesRightToLeft = 99;
    final gBonesLeftToRight = 101;
    _init = sgroup([
      ToggleGroup(group: gAll, enable: false),
      // Move(
      //   y: -23 * 5 * 30,
      //   seconds: 0,
      //   target: ReferenceGroup(gAll),
      // ),
    ]);

    final arenaMove = moveArenaAndClear(55 * 3, 0, anim: true, animClear: true, then: ReferenceGroup(thenGroup));
    const gArenaSpawn = 36;

    // 91

    _run = sgroup([
      arenaMove.run,
      tpHeartToGroup(gArenaSpawn),
      SpawnTrigger(delay: 0.01, target: swapToBlue),
      ToggleGroup(group: gAll, enable: true),
      SpawnTrigger(
        delay: 1,
        target: sgroup([
          platBottom1,
          platBottom2,
          platBottom3,
          platBottom4,
          platBottom5,
          platMiddle1,
          platMiddle2,
          platMiddle3,
          platMiddle4,
          Move(
            x: (-203.2258 * 20).round(),
            y: 0,
            seconds: 20,
            target: ReferenceGroup(gBonesRightToLeft),
          ),
          Move(
            x: (203.2258 * 20).round(),
            y: 0,
            seconds: 20,
            target: ReferenceGroup(gBonesLeftToRight),
          ),
          SpawnTrigger(
            delay: 7.5,
            target: sgroup([
              ToggleGroup(group: gAll, enable: false),
              arenaMove.clear,
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
