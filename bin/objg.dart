import 'package:objg/objg.dart';

void main() {
  proj = ObjGProject();
  proj.init();
// print(generatedGroup);
  // final test = EventListener(
  //   [
  //     Events.jumpReleased,
  //   ],
  //   players: EventPlayers.p1,
  //   child: ToggleGroup(group: 1, enable: true),
  //   // child: Group([
  //   //   ToggleGroup(group: 1, enable: true),
  //   //   // Move(1, 10, 0, wait: true),
  //   //   // Move(1, 0, -10, wait: true),
  //   //   // Move(1, -10, 0, wait: true),
  //   //   // Move(1, 0, 10, wait: true),
  //   // ]),
  // );
  SpawnTrigger(
      onStart: true,
      target: sgroup([
        // generateDirection(Direction.down),
        generateLinearMovement(Direction.right),
        generateLinearMovement(Direction.left),
        generatePlatformMovement(),
        // generateDirection(Direction.right),
      ]));

  print(proj.getLevelString());

  // final objs = Group([
  //   EventListener(
  //     on: [ Events.JumpReleased ],
  //     player: EventPlayers.P1,
  //     child: Group([
  //       ToggleGroup(group: 1, enable: true),
  //       // Move(1, 10, 0, wait: true),
  //       // Move(1, 0, -10, wait: true),
  //       // Move(1, -10, 0, wait: true),
  //       // Move(1, 0, 10, wait: true),
  //     ]),
  //   ),
  // ]);
  // final proj = generateProjec(objs);
  // print(proj.code);
}

const gPlayer = 1;
const cPlayer = 1;
const cBottomArena = 2;
const cTopArena = 3;
const cLeftArena = 4;
const cRightArena = 5;

enum Direction {
  left,
  right,
  up,
  down,
}

GDObject generateLinearMovement(Direction direction) {
  const speed = 200; // [Whatever unit Move uses per second]
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
    target: ReferenceGroup(gPlayer),
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
      child: InstantCollision(blockA: cPlayer, blockB: cArena[direction]!, elsee: move),
    ),
    Collision(
      blockA: cPlayer,
      blockB: cArena[direction]!,
      // activate: true, <--- must
      triggerOnExit: false,
      then: stop,
    ),
    EventListener([
      if (direction == Direction.down) Events.jumpRelease,
      if (direction == Direction.up) Events.jumpRelease,
      if (direction == Direction.left) Events.leftRelease,
      if (direction == Direction.right) Events.rightRelease,
    ], players: direction == Direction.down ? EventPlayers.p2 : EventPlayers.p1, child: stop),
  ]);
}

GDObject generatePlatformMovement() {
  const speed = 200; // [Whatever unit Move uses per second]
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
            then: SpawnTrigger(onStart: false, target: ReferenceGroup(9)),
          ),
          InstantCount(
            itemID: iJumpCurve,
            targetCount: 1,
            compareType: InstantCountCompareType.equal,
            then: SpawnTrigger(onStart: false, target: ReferenceGroup(10)),
          ),
          InstantCount(
            itemID: iJumpCurve,
            targetCount: 2,
            compareType: InstantCountCompareType.equal,
            then: SpawnTrigger(onStart: false, target: ReferenceGroup(16)),
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
      blockA: cPlayer,
      blockB: cBottomArena,
      then: Pickup(
        type: PickupType.override,
        itemID: iOnGround,
        count: 1,
      ),
    ),
    Collision(
      blockA: cPlayer,
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
        blockA: cPlayer,
        blockB: cTopArena,
        elsee: InstantCollision(
          blockA: cPlayer,
          blockB: cBottomArena,
          then: sgroup([
            Move(
              y: (0.4 * speed * 1.5).round(),
              seconds: 0.4,
              target: ReferenceGroup(gPlayer),
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
      blockA: cPlayer,
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
      blockA: cPlayer,
      blockB: cBottomArena,
      // activate: true, <--- must
      triggerOnExit: false,
      then: sgroup([
        // stop,
        Stop(type: StopType.stop, target: ReferenceGroup(9)),
        Stop(type: StopType.stop, target: ReferenceGroup(10)),
        Stop(type: StopType.stop, target: ReferenceGroup(16)),
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

// final test = SGroup(children: []);

