import 'package:objg/objg.dart';

import 'bluebones.dart';
import 'bonegaps1.dart';
import 'intro.dart';
import 'platforms1.dart';
import 'platforms2.dart';
import 'platforms3.dart';
import 'randombonegaps.dart';

late final List<Attack> attacks;

void initAttacks() {
  attacks = [
    // AttackIntro(),
    // AttackBoneGaps1(),
    // AttackBlueBones(),
    // AttackRandomBoneGaps(),
    // AttackPlatforms1(),
    // AttackPlatforms2()
    AttackPlatforms3()
  ];
  for (int i = 0; i < attacks.length - 1; i++) {
    attacks[i].setThen(attacks[i + 1].run);
  }
  SpawnTrigger(
    onStart: true,
    target: sgroup(attacks.map((att) => att.init).nonNulls.toList()),
  );
}

abstract class Attack {
  abstract final GDObject run;
  abstract final GDObject? init;
  final int thenGroup;

  Attack() : thenGroup = getFreeGroup();

  void setThen(GDObject then) {
    SpawnTrigger(
      target: then,
    ).groups.add(thenGroup);
  }
}
