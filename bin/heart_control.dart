import 'dart:io';

import 'package:objg/objg.dart';
import 'health.dart';
import 'objg.dart';

final gHeartLockArea = 25;
final iHeartPlaying = getFreeItem(1); // 0 = red, 1 = blue
final iJustSlammed = getFreeItem();
const cgPlayerRed = 1;
const gPlayerRedCenter = 31;
const cgPlayerBlue = 50;
const gPlayerBlueCenter = 32;
const cPlayerAttackHitbox = 8;
const cBottomArena = 2;
const cTopArena = 3;
const cLeftArena = 4;
const cRightArena = 5;
const gAnimSlam = 26;
const gAnimFall = 10;
const gAnimJumpMidFall = 9;
const gAnimJumpFullFall = 16;
const gShake = 27;

const _gHeartTeleporter = 29;

enum Direction {
  left,
  right,
  up,
  down,
}

final slamBlueHeartDown = InstantCount(
  itemID: iHeartPlaying,
  targetCount: 1,
  compareType: InstantCountCompareType.equal,
  then: sgroup([
    ReferenceGroup(gAnimSlam),
    Pickup(
      itemID: iJustSlammed,
      type: PickupType.override,
      count: 1,
    ),
  ]),
);

GDObject tpHeartToGroup(int group) {
  return sgroup([
    // Move(
    //   target: ReferenceGroup(_gHeartTeleporter),
    //   targetTo: ReferenceGroup(group),
    //   seconds: 0,
    // ),
    // SpawnTrigger(delay: 0.01, target: _tpHeart),
    InstantCount(
      itemID: iHeartPlaying,
      targetCount: 1,
      compareType: InstantCountCompareType.equal,
      then: Move(
        target: ReferenceGroup(cgPlayerBlue),
        targetTo: ReferenceGroup(group),
        targetToCenter: ReferenceGroup(gPlayerBlueCenter),
        seconds: 0,
      ),
    ),
    InstantCount(
      itemID: iHeartPlaying,
      targetCount: 0,
      compareType: InstantCountCompareType.equal,
      then: Move(
        target: ReferenceGroup(cgPlayerRed),
        targetTo: ReferenceGroup(group),
        targetToCenter: ReferenceGroup(gPlayerRedCenter),
        seconds: 0,
      ),
    ),
  ]);
}

// final _tpHeart = sgroup([
// ]);

final swapToBlue = InstantCount(
  itemID: iHeartPlaying,
  targetCount: 0,
  compareType: InstantCountCompareType.equal,
  then: ogroup([
    Pickup(
      itemID: iHeartPlaying,
      type: PickupType.override,
      count: 1,
    ),
    Move(
      target: ReferenceGroup(cgPlayerBlue),
      targetTo: ReferenceGroup(gPlayerRedCenter),
      targetToCenter: ReferenceGroup(gPlayerBlueCenter),
      seconds: 0,
    ),
    Move(
      target: ReferenceGroup(cgPlayerRed),
      targetTo: ReferenceGroup(gHeartLockArea),
      targetToCenter: ReferenceGroup(gPlayerRedCenter),
      seconds: 0,
    ),
  ]),
);

final swapToRed = InstantCount(
  itemID: iHeartPlaying,
  targetCount: 1,
  compareType: InstantCountCompareType.equal,
  then: ogroup([
    Pickup(
      itemID: iHeartPlaying,
      type: PickupType.override,
      count: 0,
    ),
    Move(
      target: ReferenceGroup(cgPlayerRed),
      targetTo: ReferenceGroup(gPlayerBlueCenter),
      targetToCenter: ReferenceGroup(gPlayerRedCenter),
      seconds: 0,
    ),
    Move(
      target: ReferenceGroup(cgPlayerBlue),
      targetTo: ReferenceGroup(gHeartLockArea),
      targetToCenter: ReferenceGroup(gPlayerBlueCenter),
      seconds: 0,
    ),
  ]),
);

GDObject generateLinearMovement(Direction direction, int cgPlayer) {
  const speed = 230; // [Whatever unit Move uses per second]
  const cArena = {
    Direction.left: cLeftArena,
    Direction.right: cRightArena,
    Direction.up: cTopArena,
    Direction.down: cBottomArena,
  };
  final x = direction == Direction.left
      ? -100
      : direction == Direction.right
          ? 100
          : 0;
  final y = direction == Direction.up
      ? 100
      : direction == Direction.down
          ? -100
          : 0;
  final move = Move(
    x: x * speed,
    y: y * speed,
    seconds: 100.00,
    target: ReferenceGroup(cgPlayer),
  );
  final stop = Stop(
    type: StopType.stop,
    target: move,
  );

  return sgroup([
    EventListener(
      [
        if (direction == Direction.down) Events.jumpPush,
        if (direction == Direction.up) Events.jumpPush,
        if (direction == Direction.left) Events.leftPush,
        if (direction == Direction.right) Events.rightPush,
      ],
      players: direction == Direction.down ? EventPlayers.p2 : EventPlayers.p1,
      child: InstantCollision(
        blockA: cgPlayer,
        blockB: cArena[direction]!,
        elsee: move,
      ),
    ),
    Collision(
      blockA: cgPlayer,
      blockB: cArena[direction]!,
      // activate: true, <--- must
      triggerOnExit: false,
      then: stop,
    ),
    EventListener(
      [
        if (direction == Direction.down) Events.jumpRelease,
        if (direction == Direction.up) Events.jumpRelease,
        if (direction == Direction.left) Events.leftRelease,
        if (direction == Direction.right) Events.rightRelease,
      ],
      players: direction == Direction.down ? EventPlayers.p2 : EventPlayers.p1,
      child: stop,
    ),
  ]);
}

GDObject generatePlatformMovement(int cgPlayer) {
  const speed = 230; // [Whatever unit Move uses per second]
  // final y = direction == Direction.up
  //     ? 100
  //     : direction == Direction.down
  //         ? -100
  //         : 0;
  // final move = Move(
  //   x: x * speed,
  //   y: y * speed,
  //   seconds: 100.00,
  //   target: ReferenceGroup(gPlayer),
  // );
  // final stop = Stop(
  //   type: StopType.stop,
  //   target: move,
  // );
  final upMoveGroup = getFreeGroup();
  final iJustJumped = getFreeItem();
  final iOnGround = getFreeItem();
  final iJumpCurve = getFreeItem();

  final release = sgroup([
    Stop(type: StopType.stop, target: ReferenceGroup(upMoveGroup)),
    InstantCount(
      itemID: iJustJumped,
      targetCount: 1,
      compareType: InstantCountCompareType.equal,
      then: sgroup(
        [
          Pickup(
            type: PickupType.override,
            itemID: iJustJumped,
            count: 0,
          ),
          InstantCount(
            itemID: iJumpCurve,
            targetCount: 0,
            compareType: InstantCountCompareType.equal,
            then: ReferenceGroup(gAnimJumpMidFall),
          ),
          InstantCount(
            itemID: iJumpCurve,
            targetCount: 1,
            compareType: InstantCountCompareType.equal,
            then: ReferenceGroup(gAnimFall),
          ),
          InstantCount(
            itemID: iJumpCurve,
            targetCount: 2,
            compareType: InstantCountCompareType.equal,
            then: ReferenceGroup(gAnimJumpFullFall),
          ),
          SpawnTrigger(
            delay: 0.01,
            target: Pickup(
              type: PickupType.override,
              itemID: iJumpCurve,
              count: 0,
            ),
          ),
        ],
      ),
    ),
  ]);

  return sgroup([
    Collision(
      blockA: cgPlayer,
      blockB: cBottomArena,
      then: Pickup(
        type: PickupType.override,
        itemID: iOnGround,
        count: 1,
      ),
    ),
    Collision(
      blockA: cgPlayer,
      blockB: cBottomArena,
      triggerOnExit: true,
      then: InstantCount(
        itemID: iOnGround,
        targetCount: 1,
        compareType: InstantCountCompareType.equal,
        then: sgroup([
          Pickup(
            type: PickupType.override,
            itemID: iOnGround,
            count: 0,
          ),
          InstantCount(
            itemID: iJustJumped,
            targetCount: 0,
            compareType: InstantCountCompareType.equal,
            then: SpawnTrigger(onStart: false, target: ReferenceGroup(10)),
          ),
        ]),
      ),
    ),
    EventListener(
      [
        Events.jumpPush,
      ],
      players: EventPlayers.p1,
      child: InstantCollision(
        blockA: cgPlayer,
        blockB: cTopArena,
        elsee: InstantCollision(
          blockA: cgPlayer,
          blockB: cBottomArena,
          then: sgroup([
            Move(
              y: (0.4 * speed * 1.2).round(),
              seconds: 0.4,
              target: ReferenceGroup(cgPlayer),
            )..groups.add(upMoveGroup),
            SpawnTrigger(
              delay: 0.4,
              target: InstantCount(
                itemID: iJustJumped,
                targetCount: 1,
                compareType: InstantCountCompareType.equal,
                then: sgroup([
                  Pickup(
                    type: PickupType.override,
                    itemID: iJumpCurve,
                    count: 2,
                  ),
                  SpawnTrigger(delay: 0.01, target: release),
                ]),
              ),
            ),
            Pickup(
              type: PickupType.override,
              itemID: iJustJumped,
              count: 1,
            ),
          ]),
        ),
      ),
    ),
    Collision(
      blockA: cgPlayer,
      blockB: cTopArena,
      // activate: true, <--- must
      triggerOnExit: false,
      then: sgroup([
        Stop(type: StopType.stop, target: ReferenceGroup(upMoveGroup)),
        Pickup(
          type: PickupType.override,
          itemID: iJumpCurve,
          count: 1,
        ),
        SpawnTrigger(delay: 0.01, target: release),
      ]),
    ),
    Collision(
      blockA: cgPlayer,
      blockB: cBottomArena,
      // activate: true, <--- must
      triggerOnExit: false,
      then: sgroup([
        // stop,
        Stop(type: StopType.stop, target: ReferenceGroup(gAnimJumpMidFall)),
        Stop(type: StopType.stop, target: ReferenceGroup(gAnimFall)),
        Stop(type: StopType.stop, target: ReferenceGroup(gAnimJumpFullFall)),
        Stop(type: StopType.stop, target: ReferenceGroup(gAnimSlam)),
        InstantCount(
          itemID: iJustSlammed,
          targetCount: 1,
          compareType: InstantCountCompareType.equal,
          then: sgroup([
            Pickup(
              type: PickupType.override,
              itemID: iJustSlammed,
              count: 0,
            ),
            SpawnTrigger(target: ReferenceGroup(gShake)),
          ]),
        ),
      ]),
    ),
    EventListener(
      [
        Events.jumpRelease,
      ],
      players: EventPlayers.p1,
      child: release,
    ),
  ]);
}

void attacksInit() {
  final loop = sgroup([
    InstantCollision(
      blockA: cPlayerAttackHitbox,
      blockB: 7,
      then: lowerHealth1Karma,
    ),
  ]);
  SpawnTrigger(delay: 1.0 / 30, target: loop).groups.add(loop.group);
  SpawnTrigger(onStart: true, target: loop);

  createPixelSpriteFromFile(
    File("/home/flafy/undertalestuff/blueheart.png"),
    groups: [
      cgPlayerBlue
    ],
    centerGroups: [],
    x: 3670.27.toDouble(),
    y: 360.665.toDouble(),
    scaleX: 1,
    scaleY: 1,
    zLayer: 9, // T3
  );
  createPixelSpriteFromFile(
    File("/home/flafy/undertalestuff/redheart.png"),
    groups: [
      cgPlayerRed
    ],
    centerGroups: [],
    x: 3711.63.toDouble(),
    y: 383.502.toDouble(),
    scaleX: 1,
    scaleY: 1,
    zLayer: 9, // T3
  );
}

void swapInit() {
  final loopGroup = getFreeGroup();

  SpawnTrigger(
    onStart: true,
    target: sgroup([
      SpawnTrigger(
        delay: 0.1,
        target: sgroup([
          InstantCount(
            itemID: iHeartPlaying,
            targetCount: 1,
            compareType: InstantCountCompareType.equal,
            then: Move(
              target: ReferenceGroup(cgPlayerRed),
              targetTo: ReferenceGroup(gHeartLockArea),
              targetToCenter: ReferenceGroup(gPlayerRedCenter),
              seconds: 0,
            ),
          ),
          SpawnTrigger(
            target: ReferenceGroup(loopGroup),
          ),
        ]),
      )..groups.add(loopGroup),
    ]),
  );
}

// GDObject _swapHearts() {
//   return sgroup([
//     
//
//   ]);
// }
