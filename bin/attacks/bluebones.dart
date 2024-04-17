import 'package:objg/objg.dart';

import '../arena.dart';
import '../heart_control.dart';
import 'attacks.dart';

class AttackBlueBones extends Attack {
  AttackBlueBones() : super() {
    final gBones = 38;
    final gBonesLeft = 39;
    final gBonesRight = 40;

    _init = sgroup([
      ToggleGroup(group: gBones, enable: false),
    ]);

    const bones = 3.2;
    final arenaMove = moveArenaAndClear(55 * 3, 0, anim: true, animClear: true, then: ReferenceGroup(thenGroup));
    const gArenaSpawn = 36;

    _run = sgroup([
      arenaMove.run,
      tpHeartToGroup(gArenaSpawn),
      SpawnTrigger(delay: 0.01, target: swapToBlue),
      ToggleGroup(group: gBones, enable: true),
      SpawnTrigger(
        delay: 1,
        target: sgroup([
          Move(
            x: 0,
            y: -1950,
            seconds: 0,
            target: ReferenceGroup(gBones),
          ),
          Move(
            x: (-635 * bones).round(),
            y: 0,
            seconds: 38.0 / 30 * bones,
            target: ReferenceGroup(gBonesRight),
          ),
          SpawnTrigger(
            delay: 79.0 / 30,
            target: sgroup([
              Move(
                x: (635 * bones).round(),
                y: 0,
                seconds: 38.0 / 30 * bones,
                target: ReferenceGroup(gBonesLeft),
              ),
              SpawnTrigger(
                delay: 106.0 / 30,
                target: sgroup([
                  ToggleGroup(group: gBones, enable: false),
                  arenaMove.clear,
                ]),
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
