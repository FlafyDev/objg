import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class InstantCollision extends GDObject {
  final int blockA;
  final int blockB;
  final GDObject? then;
  final GDObject? elsee;
  final bool triggerOnExit;

  InstantCollision({
    required this.blockA,
    required this.blockB,
    this.then,
    this.elsee,
    this.triggerOnExit = false,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "3609",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.instantCollisionTriggerBlockA: blockA.toString(),
      GDProps.instantCollisionTriggerBlockB: blockB.toString(),
      GDProps.instantCollisionTrueID: (then?.getUniqueGroup() ?? 0).toString(),
      GDProps.instantCollisionFalseID: (elsee?.getUniqueGroup() ?? 0).toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}

