import 'package:objg/objg.dart';

import '../arena.dart';
import '../heart_control.dart';
import 'attacks.dart';

class AttackBoneGaps1 extends Attack {
  AttackBoneGaps1() : super() {
    final gBones = 33;
    final gBonesLeft = 35;
    final gBonesRight = 34;

    _init = sgroup([
      ToggleGroup(group: gBones, enable: false),
      ToggleGroup(group: gBonesLeft, enable: false),
      ToggleGroup(group: gBonesRight, enable: false),
    ]);

    const bones = 3.2;
    final arenaMove = moveArenaAndClear(55 * 3, 0, anim: true, animClear: true, then: ReferenceGroup(thenGroup));
    const gArenaSpawn = 36;

    _run = sgroup([
      arenaMove.run,
      tpHeartToGroup(gArenaSpawn),
      SpawnTrigger(delay: 0.01, target: swapToBlue),
      ToggleGroup(group: gBones, enable: true),
      ToggleGroup(group: gBonesLeft, enable: true),
      ToggleGroup(group: gBonesRight, enable: true),
      Move(
        x: 0,
        y: -1500,
        seconds: 0,
        target: ReferenceGroup(gBones),
      ),
      Move(
        x: (600 * bones).round(),
        y: 0,
        seconds: 61.0 / 30 * bones,
        target: ReferenceGroup(gBonesLeft),
      ),
      Move(
        x: (-600 * bones).round(),
        y: 0,
        seconds: 61.0 / 30 * bones,
        target: ReferenceGroup(gBonesRight),
      ),
      SpawnTrigger(
        delay: 61.0 / 30 * bones,
        target: sgroup([
          ToggleGroup(group: gBones, enable: false),
          arenaMove.clear,
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
