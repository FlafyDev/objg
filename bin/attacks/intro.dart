import 'package:objg/objg.dart';

import '../arena.dart';
import '../gasterblaster.dart';
import '../heart_control.dart';
import 'attacks.dart';

final _gBonesUp = 22;
final _gBonesWarn = 23;
final _gBonesSide = 24;

class AttackIntro extends Attack {
  AttackIntro() : super() {
    _init = sgroup([
      ToggleGroup(group: _gBonesUp, enable: false),
      ToggleGroup(group: _gBonesSide, enable: false),
    ]);

    final bonesUpMoveX = 8 * 5 * 30;
    final bonesUpMoveY = 3 * 30;

    final bonesSideMoveX = 7 * 5 * 30;

    const gArenaCenter = 28;

    final shoot1 = regularBlasters[0].shoot(
      startX: 1694,
      startY: 114,
      targetX: 1388,
      targetY: 307,
      targetRotation: 90,
    );

    final shoot2 = regularBlasters[1].shoot(
      startX: 1694,
      startY: 114,
      targetX: 1261,
      targetY: 174,
      targetRotation: 180,
    );

    final shoot3 = regularBlasters[2].shoot(
      startX: 634,
      startY: 913,
      targetX: 1065,
      targetY: 638,
      targetRotation: 0,
    );

    final shoot4 = regularBlasters[3].shoot(
      startX: 634,
      startY: 913,
      targetX: 950,
      targetY: 511,
      targetRotation: -90,
    );

    ////

    final shoot5 = regularBlasters[4].shoot(
      startX: 634,
      startY: 913,
      targetX: 947,
      targetY: 631,
      targetRotation: -45,
    );

    final shoot6 = regularBlasters[5].shoot(
      startX: 1694,
      startY: 913,
      targetX: 1370,
      targetY: 631,
      targetRotation: 45,
    );

    final shoot7 = regularBlasters[6].shoot(
      startX: 1694,
      startY: 114,
      targetX: 1370,
      targetY: 202,
      targetRotation: 135,
    );

    final shoot8 = regularBlasters[7].shoot(
      startX: 634,
      startY: 114,
      targetX: 947,
      targetY: 202,
      targetRotation: -135,
    );

    ////

    final shoot9 = largeBlasters[0].shoot(
      startX: 627,
      startY: 521,
      targetX: 861,
      targetY: 418,
      targetRotation: -90,
    );

    final shoot10 = largeBlasters[1].shoot(
      startX: 1964,
      startY: 521,
      targetX: 1455,
      targetY: 418,
      targetRotation: 90,
    );

    // final shoot9 = regularBlasters[0].shoot(
    //   startX: 1694,
    //   startY: 114,
    //   targetX: 1388,
    //   targetY: 307,
    //   targetRotation: 90,
    // );
    //
    // final shoot10 = regularBlasters[1].shoot(
    //   startX: 1694,
    //   startY: 114,
    //   targetX: 1261,
    //   targetY: 174,
    //   targetRotation: 180,
    // );
    //
    // final shoot11 = regularBlasters[2].shoot(
    //   startX: 634,
    //   startY: 913,
    //   targetX: 1065,
    //   targetY: 638,
    //   targetRotation: 0,
    // );
    //
    // final shoot12 = regularBlasters[3].shoot(
    //   startX: 634,
    //   startY: 913,
    //   targetX: 950,
    //   targetY: 511,
    //   targetRotation: -90,
    // );

    // SpawnTrigger(
    //   onStart: true,
    //   delay: 1,
    //   target: shoot1.$1,
    // );
    //
    // SpawnTrigger(
    //   onStart: true,
    //   delay: 1,
    //   target: shoot2.$1,
    // );
    //
    // SpawnTrigger(
    //   onStart: true,
    //   delay: 1,
    //   target: shoot3.$1,
    // );
    //
    // SpawnTrigger(
    //   onStart: true,
    //   delay: 1,
    //   target: shoot4.$1,
    // );

    final arenaMove = moveArenaAndClear(115 * 3, 13 * 3, anim: false, animClear: true, then: ReferenceGroup(thenGroup));

    _run = sgroup([
      arenaMove.run,
      tpHeartToGroup(gArenaCenter),
      ToggleGroup(group: _gBonesUp, enable: true),
      ToggleGroup(group: _gBonesSide, enable: true),
      SpawnTrigger(delay: 0.01, target: swapToRed),
      SpawnTrigger(
        delay: 8.0 / 30,
        target: sgroup([
          swapToBlue,
          SpawnTrigger(delay: 0.01, target: slamBlueHeartDown),
          SpawnTrigger(
            delay: 15.0 / 30,
            target: sgroup([
              Move(
                target: ReferenceGroup(_gBonesUp),
                x: bonesUpMoveX.toInt(),
                y: 0,
                seconds: 0,
              ),
              Move(
                target: ReferenceGroup(_gBonesWarn),
                x: bonesUpMoveX.toInt(),
                y: 0,
                seconds: 0,
              ),
              SpawnTrigger(
                delay: 0.166,
                target: sgroup([
                  ToggleGroup(group: _gBonesWarn, enable: false),
                  Move(
                    target: ReferenceGroup(_gBonesUp),
                    x: 0,
                    y: bonesUpMoveY.toInt(),
                    seconds: 0.133,
                  ),
                  // 16 frames -> red
                  SpawnTrigger(
                    delay: 16.0 / 30,
                    target: swapToRed,
                  ),
                  // 29 frames -> side
                  SpawnTrigger(
                    delay: 29.0 / 30,
                    target: sgroup([
                      Move(
                        target: ReferenceGroup(_gBonesSide),
                        x: bonesSideMoveX.toInt(),
                        y: 0,
                        seconds: 0,
                      ),
                      Move(
                        target: ReferenceGroup(_gBonesSide),
                        x: 35 * 30,
                        y: 0,
                        seconds: 1.76,
                      ),
                    ]),
                  ),
                  SpawnTrigger(
                    delay: 60.0 / 30,
                    target: sgroup([
                      shoot1.run,
                      shoot2.run,
                      shoot3.run,
                      shoot4.run,
                      SpawnTrigger(
                        delay: 25.0 / 30,
                        target: sgroup([
                          shoot5.run,
                          shoot6.run,
                          shoot7.run,
                          shoot8.run,
                          SpawnTrigger(
                            delay: 25.0 / 30,
                            target: ogroup([
                              shoot1.clear,
                              shoot2.clear,
                              shoot3.clear,
                              shoot4.clear,
                              shoot1.run,
                              shoot2.run,
                              shoot3.run,
                              shoot4.run,
                              SpawnTrigger(
                                delay: 25.0 / 30,
                                target: sgroup([
                                  shoot5.clear,
                                  shoot6.clear,
                                  shoot7.clear,
                                  shoot8.clear,
                                  shoot9.run,
                                  shoot10.run,
                                  SpawnTrigger(
                                    delay: 97.0 / 30,
                                    target: sgroup([
                                      shoot9.clear,
                                      shoot10.clear,
                                      shoot1.clear,
                                      shoot2.clear,
                                      shoot3.clear,
                                      shoot4.clear,
                                      arenaMove.clear,
                                      ToggleGroup(group: _gBonesUp, enable: false),
                                      ToggleGroup(group: _gBonesSide, enable: false),
                                    ]),
                                  ),
                                ]),
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                  SpawnTrigger(
                    delay: 40.0 / 30,
                    target: Move(
                      target: ReferenceGroup(_gBonesUp),
                      x: 0,
                      y: -bonesUpMoveY.toInt(),
                      seconds: 0.133,
                    ),
                  ),
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