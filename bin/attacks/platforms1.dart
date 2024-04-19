import 'package:objg/objg.dart';

import '../arena.dart';
import '../heart_control.dart';
import '../platforms.dart';
import 'attacks.dart';

class AttackPlatforms1 extends Attack {
  AttackPlatforms1() : super() {
    final plat1 = registerPlatform(
      group: 62,
      bottomCollisionGroup: 13,
      topDetectionCollision: 6,
      speed: 206,
    );
    final plat2 = registerPlatform(
      group: 64,
      bottomCollisionGroup: 13,
      topDetectionCollision: 11,
      speed: 255.4054,
    );
    final plat3 = registerPlatform(
      group: 65,
      bottomCollisionGroup: 13,
      topDetectionCollision: 12,
      speed: 304.8388,
    );
    final gBones = 67;
    final gBonesUp = 66;
    final gBonesDown = 63;
    final gBonesLeft = 68;
    _init = sgroup([
      ToggleGroup(group: gBones, enable: false),
      for (final g in [
        gBones,
        62,
        64,
        65
      ])
        Move(
          y: -21 * 5 * 30,
          seconds: 0,
          target: ReferenceGroup(g),
        ),
    ]);

    // const bones = 3.2;
    final arenaMove = moveArenaAndClear(55 * 3, 0, anim: true, animClear: true, then: ReferenceGroup(thenGroup));
    const gArenaSpawn = 36;

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
          ToggleGroup(group: gBones, enable: true),
          Move(
            x: 206 * 20,
            y: 0,
            seconds: 20,
            target: ReferenceGroup(gBonesDown),
          ),
          Move(
            x: (363.4615 * 20).round(),
            y: 0,
            seconds: 20,
            target: ReferenceGroup(gBonesUp),
          ),
          SpawnTrigger(
            delay: 1.2,
            target: Move(
              x: (472.5 * 20).round(),
              y: 0,
              seconds: 20,
              target: ReferenceGroup(gBonesLeft),
            ),
          ),
          SpawnTrigger(
            delay: 3,
            target: sgroup([
              ToggleGroup(group: gBones, enable: false),
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
