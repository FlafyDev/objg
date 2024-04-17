import 'dart:io';

import 'package:objg/gdobject.dart';
import 'package:objg/objg.dart';

late final List<List<_Digit>> _numberGroups;
late final List<List<_Digit>> _numberPurpleGroups;

const _leftDigitX = 1324;
const _leftDigitY = 243;
const _rightDigitX = 1349;
const _rightDigitY = 243;

GDObject clearHealth(int health, bool kr) {
  health = health.clamp(0, 99);

  final objs = <GDObject>[];

  int leftDigit = health ~/ 10;
  int rightDigit = health % 10;

  final _numGroups = kr ? _numberPurpleGroups : _numberGroups;

  objs.add(_numGroups[0][leftDigit].clear(_leftDigitX, _leftDigitY));
  objs.add(_numGroups[1][rightDigit].clear(_rightDigitX, _rightDigitY));
  return sgroup(objs);
}

GDObject setHealth(int health, bool kr) {
  health = health.clamp(0, 99);

  final objs = <GDObject>[];

  int leftDigit = health ~/ 10;
  int rightDigit = health % 10;

  final _numGroups = kr ? _numberPurpleGroups : _numberGroups;

  objs.add(_numGroups[0][leftDigit].use(_leftDigitX, _leftDigitY));
  objs.add(_numGroups[1][rightDigit].use(_rightDigitX, _rightDigitY));

  return sgroup(objs);
}

class _Digit {
  final int digit;
  final int group;
  final int initialX;
  final int initialY;

  _Digit({
    required this.digit,
    required this.group,
    required this.initialX,
    required this.initialY,
  });

  GDObject clear(int wasX, int wasY) {
    return Move(
      x: initialX - wasX,
      y: initialY - wasY,
      target: ReferenceGroup(group),
      seconds: 0,
    );
  }

  GDObject use(int newX, int newY) {
    return Move(
      x: newX - initialX,
      y: newY - initialY,
      target: ReferenceGroup(group),
      seconds: 0,
    );
  }
}

void initHealthNumbers() {
  _numberGroups = List.generate(2, (i) {
    final groups = List.generate(10, (j) {
      final group = getFreeGroup();
      final x = 4000;
      final y = (500 + 100 * (i * 10 + j));
      createPixelSpriteFromFile(
        File("/home/flafy/undertalestuff/num$j.png"),
        groups: [
          group
        ],
        centerGroups: [],
        x: x.toDouble(),
        y: y.toDouble(),
        scaleX: 1,
        scaleY: 1,
        zLayer: 9, // T3
      );
      return _Digit(
        digit: j,
        group: group,
        initialX: x,
        initialY: y,
      );
    });
    return groups;
  });

  _numberPurpleGroups = List.generate(2, (i) {
    final groups = List.generate(10, (j) {
      final group = getFreeGroup();
      final x = 4200;
      final y = (500 + 100 * (i * 10 + j));
      createPixelSpriteFromFile(
        File("/home/flafy/undertalestuff/num$j-kr.png"),
        groups: [
          group
        ],
        centerGroups: [],
        x: x.toDouble(),
        y: y.toDouble(),
        scaleX: 1,
        scaleY: 1,
        zLayer: 9, // T3
      );
      return _Digit(
        digit: j,
        group: group,
        initialX: x,
        initialY: y,
      );
    });
    return groups;
  });
}
