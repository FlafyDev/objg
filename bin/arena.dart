import 'dart:math';

import 'package:objg/objg.dart';

import 'objg.dart';

final gArenaLeft = 19;
final gArenaRight = 21;
final gArenaTop = 20;

RunAndClear moveArenaAndClear(int x, int y, {GDObject? then, bool anim = true, bool animClear = true}) {
  return RunAndClear(
    moveArena(x, y, anim),
    moveArena(-x, -y, animClear, then: then),
  );
}

GDObject moveArena(int x, int y, bool anim, {GDObject? then}) {
  final xSeconds = anim ? x.abs() / 24.6 / 30 : 0.0;
  final ySeconds = anim ? y.abs() / 24.6 / 30 : 0.0;
  return sgroup([
    Move(
      x: x,
      seconds: xSeconds,
      target: ReferenceGroup(gArenaLeft),
    ),
    Move(
      x: -x,
      seconds: xSeconds,
      target: ReferenceGroup(gArenaRight),
    ),
    Move(
      y: y,
      seconds: ySeconds,
      target: ReferenceGroup(gArenaTop),
    ),
    if (then != null)
      SpawnTrigger(
        delay: max(xSeconds, ySeconds),
        target: then,
      ),
  ]);
}
