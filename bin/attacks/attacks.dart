import 'package:objg/objg.dart';

import 'bonegaps1.dart';
import 'intro.dart';

late final List<Attack> attacks;

void initAttacks() {
  attacks = [
    AttackIntro(),
    AttackBoneGaps1(),
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
