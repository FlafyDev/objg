import 'package:objg/gdobject.dart';
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class Collision extends GDObject {
  final int blockA;
  final int blockB;
  final GDObject then;
  final bool triggerOnExit;

  Collision({
    required this.blockA,
    required this.blockB,
    required this.then,
    this.triggerOnExit = false,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "1815",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.collisionTriggerBlockA: blockA.toString(),
      GDProps.collisionTriggerBlockB: blockB.toString(),
      GDProps.collisionTriggerTargetID: then.getUniqueGroup().toString(),
      GDProps.collisionTriggerTriggerOnExit: (triggerOnExit ? 1 : 0).toString(),
      GDProps.collisionTriggerActivateGroup: 1.toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}

