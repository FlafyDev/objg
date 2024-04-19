import 'package:objg/gdobject.dart';
import 'package:objg/objg.dart';

import '../arena.dart';
import '../heart_control.dart';
import 'attacks.dart';

class AttackRandomBoneGaps extends Attack {
  AttackRandomBoneGaps() : super() {
    final gBones = 41;
    final gBonesAbove = 58;
    final gDiffBonesRight = [
      42,
      43,
      44,
      55,
      56,
      57,
      45,
      46,
      47,
    ];
    final gDiffBonesLeft = [
      54,
      48,
      49,
      59,
      60,
      61,
      51,
      52,
      53,
    ];
    final bonesDist = [
      0,
      1,
      2,
      0,
      1,
      2,
      3,
      4,
      5,
    ];
    final numOfBones = gDiffBonesRight.length;
    const turns = 6;
    final iTurnResults = List.generate(turns, (index) => getFreeItem());
    final iRandom = getFreeItem();

    final runSet = List.generate(
      numOfBones,
      (index) {
        final time = 63.0 / 30;
        final moveX = 660;
        final regLeftMove = Move(
          x: moveX,
          seconds: time,
          target: ReferenceGroup(gDiffBonesLeft[index]),
        );
        final regRightMove = Move(
          x: -moveX,
          seconds: time,
          target: ReferenceGroup(gDiffBonesRight[index]),
        );
        final fastLeftMove = SpawnTrigger(
          delay: time / 4,
          target: Move(
            x: moveX,
            seconds: time / 2,
            target: ReferenceGroup(gDiffBonesLeft[index]),
          ),
        );
        final fastRightMove = SpawnTrigger(
          delay: time / 4,
          target: Move(
            x: -moveX,
            seconds: time / 2,
            target: ReferenceGroup(gDiffBonesRight[index]),
          ),
        );

        return sgroup([
          AdvancedRandom({
            sgroup([
              regLeftMove,
              regRightMove,
            ]): 2,
            sgroup([
              regLeftMove,
              fastRightMove,
            ]): 1,
            sgroup([
              fastLeftMove,
              regRightMove,
            ]): 1,
          }),
        ]);
      },
    );
    GDObject setRandom(int number, {required GDObject then}) => ogroup([
          Pickup(
            itemID: iRandom,
            count: number,
            type: PickupType.override,
          ),
          then
        ]);

    final runSetPerRandom = sgroup([
      for (int i = 0; i < numOfBones; i++)
        InstantCount(
          itemID: iRandom,
          targetCount: i,
          compareType: InstantCountCompareType.equal,
          then: runSet[i],
        ),
    ]);

    final iLastRandom = getFreeItem();

    GDObject doTurn(int turn) {
      GDObject recurseArr(int t) => ItemComp(
            itemID1: iTurnResults[t],
            itemID2: iRandom,
            compareOp: ItemCompCompareOp.larger,
            then: ogroup([
              for (int j = turn; j >= t + 1; j--)
                ItemEdit(
                  itemIDResult: iTurnResults[j],
                  itemID1: iTurnResults[j - 1],
                ),
              ItemEdit(
                itemIDResult: iTurnResults[t],
                itemID1: iRandom,
              ),
            ]),
            elsee: t == turn
                ? ItemEdit(
                    itemIDResult: iTurnResults[turn],
                    itemID1: iRandom,
                  )
                : recurseArr(t + 1),
          );

      final after = ogroup([
        for (int i = 0; i < turn; i++)
          ItemComp(
            itemID1: iRandom,
            itemID2: iTurnResults[i],
            compareOp: ItemCompCompareOp.largerOrEqual,
            then: Pickup(
              itemID: iRandom,
              count: 1,
              type: PickupType.addition,
            ),
          ),
        SpawnTrigger(
          delay: 0.005,
          target: ogroup([
            recurseArr(0),
            InstantCount(
              itemID: iLastRandom,
              targetCount: 6,
              compareType: InstantCountCompareType.smaller,
              then: runSetPerRandom,
            ),
            SpawnTrigger(
              delay: 0.005,
              target: ItemEdit(
                itemID1: iRandom,
                itemIDResult: iLastRandom,
              ),
            ),
          ]),
        ),
      ]);

      return sgroup([
        AdvancedRandom({
          for (int i = 0; i < (numOfBones - turn); i++)
            setRandom(
              i,
              then: after,
            ): 1,
        }),
      ]);
    }

    _init = sgroup([
      ToggleGroup(group: gBones, enable: false),
      Move(
        x: 0,
        y: -450,
        seconds: 0,
        target: ReferenceGroup(gBonesAbove),
      ),
      Move(
        x: 0,
        y: -2250,
        seconds: 0,
        target: ReferenceGroup(gBones),
      ),
      for (int i = 0; i < gDiffBonesLeft.length; i++)
        Move(
          x: 150 * bonesDist[i],
          y: 0,
          seconds: 0,
          target: ReferenceGroup(gDiffBonesLeft[i]),
        ),
      for (int i = 0; i < gDiffBonesRight.length; i++)
        Move(
          x: -(150 * bonesDist[i]),
          y: 0,
          seconds: 0,
          target: ReferenceGroup(gDiffBonesRight[i]),
        ),
    ]);

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
          for (int i = 0; i < turns; i++)
            SpawnTrigger(
              delay: 27.0 / 30 * i,
              target: sgroup([
                doTurn(i),
                // InstantCount(
                //   itemID: iRandom,
                //   targetCount: 4,
                //   compareType: InstantCountCompareType.smaller,
                //   then: doTurn(i, true),
                // ),
                // InstantCount(
                //   itemID: iRandom,
                //   targetCount: 3,
                //   compareType: InstantCountCompareType.larger,
                //   then: doTurn(i, true),
                // ),
              ]),
            ),
          // Move(
          //   x: (600 * bones).round(),
          //   y: 0,
          //   seconds: 61.0 / 30 * bones,
          //   target: ReferenceGroup(gBonesLeft),
          // ),
          // Move(
          //   x: (-600 * bones).round(),
          //   y: 0,
          //   seconds: 61.0 / 30 * bones,
          //   target: ReferenceGroup(gBonesRight),
          // ),
          // SpawnTrigger(
          //   delay: 61.0 / 30 * bones,
          //   target: sgroup([
          //     ToggleGroup(group: gBones, enable: false),
          //     arenaMove.clear,
          //   ]),
          // ),
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
