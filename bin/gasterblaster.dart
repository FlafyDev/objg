import 'dart:io';
import 'dart:math';
import 'package:objg/objg.dart';

import 'heart_control.dart';
import 'objg.dart';

class _BlasterRestoreRef {
  final int lastX;
  final int lastY;
  final double lastDegrees;

  const _BlasterRestoreRef({
    required this.lastX,
    required this.lastY,
    required this.lastDegrees,
  });
}

class Blaster {
  final int gMove;
  final int gCenter;
  final List<int> gAnimations;
  final int gLaser;
  final int gLaserHitbox;
  final int initialX;
  final int initialY;
  final double scaleX;
  final double scaleY;

  static int _initialXProgress = 0;

  Blaster({
    required this.gMove,
    required this.gCenter,
    required this.gAnimations,
    required this.gLaser,
    required this.gLaserHitbox,
    required this.initialX,
    required this.initialY,
    required this.scaleX,
    required this.scaleY,
  }) : assert(gAnimations.length == 6) {
    SpawnTrigger(
      onStart: true,
      target: _clear(),
    );
  }

  factory Blaster.create({
    required double scaleX,
    required double scaleY,
  }) {
    final gMove = getFreeGroup();
    final gCenter = getFreeGroup();
    final gAnimations = List.generate(6, (index) => getFreeGroup());
    final gLaser = getFreeGroup();
    final gLaserHitbox = getFreeGroup();

    const laserSegments = 40;
    const laserSize = 2000;

    final initialX = 5000 + _initialXProgress;
    final initialY = 1000;

    _initialXProgress += 400;
    const laserWidth = 2;

    {
      final laserScaleX = laserWidth * scaleX * 0.1 * 0.5;
      final laserScaleY = 40 / 30;
      CustomObj(
        id: 211,
        groups: [
          gLaser,
          gMove,
        ],
        props: {
          GDProps.objectCommonX: initialX.toString(),
          GDProps.objectCommonY: (initialY - (laserScaleY * 30) * (0.5) - 80).toString(),
          GDProps.objectCommonScaleX: laserScaleX.toString(),
          GDProps.objectCommonScaleY: laserScaleY.toString(),
          GDProps.objectCommonZLayer: 9.toString(), // T3
        },
      );
    }

    {
      final laserScaleX = laserWidth * scaleX * 0.1 * 0.7;
      final laserScaleY = 40 / 30;
      CustomObj(
        id: 211,
        groups: [
          gLaser,
          gMove,
        ],
        props: {
          GDProps.objectCommonX: initialX.toString(),
          GDProps.objectCommonY: (initialY - (laserScaleY * 30) * (0.5) - 100).toString(),
          GDProps.objectCommonScaleX: laserScaleX.toString(),
          GDProps.objectCommonScaleY: laserScaleY.toString(),
          GDProps.objectCommonZLayer: 9.toString(), // T3
        },
      );
    }

    for (int i = 0; i < laserSegments; i++) {
      final laserScaleX = laserWidth * scaleX * 0.1;
      final laserScaleY = laserSize / 30 / laserSegments;
      CustomObj(
        id: 211,
        groups: [
          gLaser,
          gMove,
        ],
        props: {
          GDProps.objectCommonX: initialX.toString(),
          GDProps.objectCommonY: (initialY - (laserScaleY * 30) * (0.5 + i) - 120).toString(),
          GDProps.objectCommonScaleX: laserScaleX.toString(),
          GDProps.objectCommonScaleY: (laserScaleY).toString(),
          GDProps.objectCommonZLayer: 9.toString(), // T3
        },
      );
      if (i < laserSegments / 3) {
        CustomObj(
          id: 1816,
          groups: [
            gLaser,
            gMove,
            gLaserHitbox,
          ],
          props: {
            GDProps.objectCommonX: initialX.toString(),
            GDProps.objectCommonY: (initialY - (laserScaleY * 30) * (0.5 + i) - 120).toString(),
            GDProps.objectCommonScaleX: (laserScaleX * 0.8).toString(),
            GDProps.objectCommonScaleY: laserScaleY.toString(),
            GDProps.objectCommonZLayer: 9.toString(), // T3
            GDProps.collisionBlockBlockID: 7.toString(),
          },
        );
      }
    }

    for (int i = 0; i < 6; i++) {
      createPixelSpriteFromFile(
        File("/home/flafy/undertalestuff/gaster${i + 1}.png"),
        groups: [
          gMove,
          gAnimations[i],
        ],
        centerGroups: [
          if (i == 0) gCenter
        ],
        x: initialX.toDouble(),
        y: initialY.toDouble(),
        scaleX: scaleX,
        scaleY: scaleY,
        zLayer: 9, // T3
      );
    }

    return Blaster(
      gMove: gMove,
      gCenter: gCenter,
      gAnimations: gAnimations,
      gLaser: gLaser,
      gLaserHitbox: gLaserHitbox,
      initialX: initialX,
      initialY: initialY,
      scaleX: scaleX,
      scaleY: scaleY,
    );
  }

  RunAndClear shoot({
    required int startX,
    required int startY,
    required int targetX,
    required int targetY,
    required double targetRotation,
  }) {
    final shootMoveX = (1000 * cos((90 - targetRotation) / 360 * 2 * pi)).toInt();
    final shootMoveY = (1000 * sin((90 - targetRotation) / 360 * 2 * pi)).toInt();
    final restoreRef = _BlasterRestoreRef(
      lastX: (targetX + shootMoveX) - initialX,
      lastY: (targetY + shootMoveY) - initialY,
      lastDegrees: targetRotation,
    );
    return RunAndClear(
      ogroup([
        ToggleGroup(group: gAnimations[0], enable: true),
        Move(
          target: ReferenceGroup(gMove),
          x: startX - initialX,
          y: startY - initialY,
          seconds: 0,
        ),
        Rotate(
          degrees: targetRotation,
          target: ReferenceGroup(gMove),
          center: ReferenceGroup(gCenter),
          seconds: 0.8,
          easing: TriggerEasing.exponentialOut,
        ),
        Move(
          target: ReferenceGroup(gMove),
          x: targetX - startX,
          y: targetY - startY,
          seconds: 0.8,
          easing: TriggerEasing.exponentialOut,
        ),
        SpawnTrigger(
          delay: 20.0 / 30,
          target: _runShootAnim,
        ),
        SpawnTrigger(
          delay: 24.0 / 30,
          target: _runLaserAnim,
        ),
        SpawnTrigger(
          delay: 25.0 / 30,
          target: sgroup([
            Move(
              target: ReferenceGroup(gMove),
              x: shootMoveX,
              y: shootMoveY,
              seconds: 0.7,
              easing: TriggerEasing.easeIn,
            ),
          ]),
        ),
      ]),
      _clear(restoreRef),
    );
  }

  late final GDObject _toggleOffAnimations = sgroup(
    List.generate(
      gAnimations.length,
      (index) => ToggleGroup(group: gAnimations[index], enable: false),
    ),
  );

  late final _runLaserAnim = sgroup([
    AlphaTrigger(
      target: ReferenceGroup(gLaser),
      seconds: 0,
      opacity: 1,
    ),
    SpawnTrigger(target: ReferenceGroup(gShake)),
    Scale(
      target: ReferenceGroup(gLaser),
      seconds: 4.0 / 30,
      scaleX: 10 * 1.1,
    ),
    ToggleGroup(group: gLaserHitbox, enable: true),
    SpawnTrigger(
      delay: 4.0 / 30,
      target: sgroup([
        Scale(
          target: ReferenceGroup(gLaser),
          seconds: 4.0 / 30,
          scaleX: 0.9,
        ),
        SpawnTrigger(
          delay: 4.0 / 30,
          target: sgroup([
            Scale(
              target: ReferenceGroup(gLaser),
              seconds: 4.0 / 30,
              scaleX: 1.1,
            ),
            SpawnTrigger(
              delay: 4.0 / 30,
              target: sgroup([
                ToggleGroup(group: gLaserHitbox, enable: false),
                Scale(
                  target: ReferenceGroup(gLaser),
                  seconds: 8.0 / 30,
                  scaleX: 0.9 * 0.1,
                ),
                AlphaTrigger(
                  target: ReferenceGroup(gLaser),
                  seconds: 10.0 / 30,
                  opacity: 0,
                ),
              ]),
            ),
          ]),
        ),
      ]),
    ),
  ]);

  late final GDObject _runShootAnim = (() {
    final gAnimLoop = getFreeGroup();
    final iAnimCounter = getFreeItem();

    return sgroup([
      Pickup(
        itemID: iAnimCounter,
        type: PickupType.override,
        count: 10,
      ),
      ToggleGroup(group: gAnimations[0], enable: false),
      ToggleGroup(group: gAnimations[1], enable: true),
      SpawnTrigger(
        delay: 1.0 / 30,
        target: sgroup([
          ToggleGroup(group: gAnimations[1], enable: false),
          ToggleGroup(group: gAnimations[2], enable: true),
          SpawnTrigger(
            delay: 1.0 / 30,
            target: sgroup([
              ToggleGroup(group: gAnimations[2], enable: false),
              ToggleGroup(group: gAnimations[3], enable: true),
              SpawnTrigger(
                delay: 1.0 / 30,
                target: sgroup([
                  ToggleGroup(group: gAnimations[5], enable: false),
                  ToggleGroup(group: gAnimations[3], enable: false),
                  ToggleGroup(group: gAnimations[4], enable: true),
                  SpawnTrigger(
                    delay: 1.0 / 30,
                    target: ogroup([
                      ToggleGroup(group: gAnimations[4], enable: false),
                      ToggleGroup(group: gAnimations[5], enable: true),
                      InstantCount(
                        itemID: iAnimCounter,
                        compareType: InstantCountCompareType.larger,
                        targetCount: 0,
                        then: ReferenceGroup(gAnimLoop),
                      ),
                      Pickup(
                        itemID: iAnimCounter,
                        type: PickupType.addition,
                        count: -1,
                      ),
                    ]),
                  ),
                ]),
              )..groups.add(gAnimLoop),
            ]),
          ),
        ]),
      ),
    ]);
  })();

  // Must be called before reshooting the blaster again.
  // Must be called after the blaster has finished shooting(let's say 3 seconds).
  GDObject _clear([_BlasterRestoreRef? restoreRef]) {
    return sgroup([
      _toggleOffAnimations,
      ToggleGroup(group: gLaserHitbox, enable: false),
      AlphaTrigger(
        target: ReferenceGroup(gLaser),
        seconds: 0,
        opacity: 0,
      ),
      if (restoreRef != null)
        Move(
          target: ReferenceGroup(gMove),
          x: -restoreRef.lastX,
          y: -restoreRef.lastY,
          seconds: 0,
        ),
      if (restoreRef != null)
        Rotate(
          degrees: -restoreRef.lastDegrees,
          target: ReferenceGroup(gMove),
          center: ReferenceGroup(gCenter),
          seconds: 0,
        ),
    ]);
  }
}

late final List<Blaster> regularBlasters;
late final List<Blaster> largeBlasters;

void initBlasters() {
  regularBlasters = List.generate(8, (index) => Blaster.create(scaleX: 2, scaleY: 2));
  largeBlasters = List.generate(2, (index) => Blaster.create(scaleX: 3, scaleY: 3));
}
