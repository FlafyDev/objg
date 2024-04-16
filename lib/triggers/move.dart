import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class Move extends GDObject {
  final int? moveX;
  final int? moveY;
  final GDObject? targetTo;
  final double seconds;
  final GDObject target;
  final TriggerEasing easing;
  // final GDObject child;

  Move({
    int? x,
    int? y,
    this.targetTo,
    this.easing = TriggerEasing.none,
    required this.seconds,
    required this.target,
  })  : moveX = x,
        moveY = y;

  @override
  String toGDString() {
    assert(moveX != null || moveY != null || targetTo != null);
    assert(seconds > 0);
    // final activationGroup = getFreeGroup();
    // child.groups.add(activationGroup);
    return generateGDString({
      GDProps.objectCommonID: "901",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      if (moveX != null) GDProps.moveTriggerMoveX: moveX.toString(),
      if (moveY != null) GDProps.moveTriggerMoveY: moveY.toString(),
      if (targetTo != null) GDProps.moveTriggerTargetToID: targetTo!.getUniqueGroup().toString(),
      if (targetTo != null) GDProps.moveTriggerTargetMode: 1.toString(),
      GDProps.triggerCommonEasing: easing.id.toString(),
      GDProps.moveTriggerTimeSeconds: seconds.toString(),
      GDProps.moveTriggerTargetGroup: target.getUniqueGroup().toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });

    // return "$str;${child.toGDString()}";
  }
}
