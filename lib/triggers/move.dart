import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class Move extends GDObject {
  final int? x;
  final int? y;
  final double seconds;
  final GDObject target;
  // final GDObject child;

  Move({
    this.x,
    this.y,
    required this.seconds,
    required this.target,
  });

  @override
  String toGDString() {
    assert(x != null || y != null);
    assert(seconds > 0);
    // final activationGroup = getFreeGroup();
    // child.groups.add(activationGroup);
    return generateGDString({
      GDProps.objectCommonID: "901",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.moveTriggerMoveX: x.toString(),
      if (y != null) GDProps.moveTriggerMoveY: y.toString(),
      GDProps.moveTriggerTimeSeconds: seconds.toString(),
      GDProps.moveTriggerTargetGroup: target.getUniqueGroup().toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });

    // return "$str;${child.toGDString()}";
  }
}

