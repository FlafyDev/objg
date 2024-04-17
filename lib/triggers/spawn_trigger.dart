import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class SpawnTrigger extends GDObject {
  final bool onStart;
  final double delay;
  final GDObject target;

  SpawnTrigger({
    this.onStart = false,
    int? x,
    int? y,
    this.delay = 0.0,
    required this.target,
  }) {
    this.x = x;
    this.y = y;
  }

  @override
  String toGDString() {
    // final activationGroup = getFreeGroup();
    // child.groups.add(activationGroup);
    return generateGDString({
      GDProps.objectCommonID: "1268",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.spawnTriggerTargetID: target.getUniqueGroup().toString(),
      GDProps.spawnTriggerDelay: delay.toString(),
      GDProps.spawnTriggerPreviewDisable: 1.toString(),
      if (!onStart) GDProps.triggerCommonMultiTriggered: 1.toString(),
      if (!onStart) GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });

    // return "$str;${child.toGDString()}";
  }
}
