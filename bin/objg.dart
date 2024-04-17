import 'dart:math';
import 'package:image/image.dart';

import 'package:objg/objg.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';

import 'attack1.dart';
import 'gasterblaster.dart';
import 'health.dart';
import 'health_numbers.dart';
import 'heart_control.dart';

// void main() {
// }

class RunAndClear {
  final GDObject run;
  final GDObject clear;

  const RunAndClear(this.run, this.clear);
}

void main() {
  // final File input = File('/home/flafy/Documents/bones.png');
  // final Image image = decodeImage(input.readAsBytesSync())!;
  // final rectangles = findRectangles(image);
  // rectangles.insert(0, RectangleWithColor(Rectangle(0, 0, image.width, image.height), ColorInt32.rgba(0, 0, 0, 255)));
  //
  // // RectangleWithColor{rectangle: Rectangle (0, 40) 110 x 2, color: (255, 127, 39, 255)}
  // String str = "";
  // // str += rectToGDObject(Rectangle(0, 40, 110, 2), ColorInt32.rgba(255, 127, 39, 255)) + ";";
  // for (final rect in rectangles) {
  //   str += rectToGDObject(rect.rectangle, rect.color) + ";";
  // }
  // print(str.substring(0, str.length - 1));
  // exit(0);

  proj = ObjGProject();
  proj.init();
  swapInit();
  initHealthNumbers();
  initHealth();
  attacksInit();
  initBlasters();
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
  final linear = sgroup([
    generateLinearMovement(Direction.right, cgPlayerRed),
    generateLinearMovement(Direction.left, cgPlayerRed),
    generateLinearMovement(Direction.up, cgPlayerRed),
    generateLinearMovement(Direction.down, cgPlayerRed),
  ]);
  final platformer = sgroup([
    generateLinearMovement(Direction.right, cgPlayerBlue),
    generateLinearMovement(Direction.left, cgPlayerBlue),
    generatePlatformMovement(cgPlayerBlue),
  ]);

  SpawnTrigger(
    onStart: true,
    target: AlphaTrigger(target: ReferenceGroup(gSpriteCenter), opacity: 0, seconds: 0),
  );

  createPixelSpriteFromFile(
    File("/home/flafy/undertalestuff/kr.png"),
    groups: [ ],
    centerGroups: [ ],
    x: 500.toDouble(),
    y: 100.toDouble(),
    scaleX: 1,
    scaleY: 1,
    zLayer: 9, // T3
  );

  // final shoot = regularBlasters[0].shoot(
  //   startX: 528,
  //   startY: 830,
  //   targetX: 1125,
  //   targetY: 675,
  //   targetRotation: 90,
  // );
  //
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 1,
  //   target: shoot.$1,
  // );
  //
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 4,
  //   target: regularBlasters[0].clear(shoot.$2),
  // );
  //
  // final shoot2 = regularBlasters[0].shoot(
  //   startX: 528,
  //   startY: 830,
  //   targetX: 1125,
  //   targetY: 675,
  //   targetRotation: 180,
  // );
  //
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 5,
  //   target: shoot2.$1,
  // );

  SpawnTrigger(
    onStart: true,
    target: sgroup([
      platformer,
      linear,
      // slamBlueHeartDown,
      attack1(),
      // SpawnTrigger(delay: 1, target: ToggleGroup(group: linear.group, enable: false)),
      // Collision(
      //   blockA: cPlayer,
      //   blockB: 7,
      //   then: sgroup([
      //     ToggleGroup(group: platformer.group, enable: true),
      //     ToggleGroup(group: linear.group, enable: false),
      //   ]),
      // ),
      // Collision(
      //   blockA: cPlayer,
      //   blockB: 8,
      //   then: sgroup([
      //     ToggleGroup(group: platformer.group, enable: false),
      //     ToggleGroup(group: linear.group, enable: true),
      //   ]),
      // )
    ]),
  );
  // SpawnTrigger(
  //     onStart: true,
  //     target: sgroup([
  //       // generateDirection(Direction.down),
  //       // generateDirection(Direction.right),
  //     ]));

  final level = proj.getLevelString();
  File("/home/flafy/undertalestuff/level.txt").writeAsStringSync(level);

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

// const gPlayer = 1;
// const gPlayer = 10;

// final test = SGroup(children: []);
