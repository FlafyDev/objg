import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class SpawnTrigger extends GDObject {
  final bool onStart;
  final double delay;
  final GDObject target;

  SpawnTrigger({
    this.onStart = false,
    this.delay = 0.0,
    required this.target,
  });

  @override
  String toGDString() {
    // final activationGroup = getFreeGroup();
    // child.groups.add(activationGroup);
    return generateGDString({
      GDProps.objectCommonID: "1268",
      GDProps.objectCommonGroups: groups.join("."),
      GDProps.spawnTriggerTargetID: target.getUniqueGroup().toString(),
      GDProps.spawnTriggerDelay: delay.toString(),
      if (!onStart) GDProps.triggerCommonMultiTriggered: 1.toString(),
      if (!onStart) GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });

    // return "$str;${child.toGDString()}";
  }
}

