import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class Rotate extends GDObject {
  final double degrees;
  final GDObject target;
  final GDObject center;
  final double seconds;
  final TriggerEasing easing;

  Rotate({
    required this.degrees,
    required this.target,
    required this.center,
    this.easing = TriggerEasing.none,
    required this.seconds,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "1346",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.triggerCommonEasing: easing.id.toString(),
      GDProps.rotateTriggerDegrees: degrees.toString(),
      GDProps.rotateTriggerTargetGroup: target.getUniqueGroup().toString(),
      GDProps.rotateTriggerCenterGroup: center.getUniqueGroup().toString(),
      GDProps.rotateTriggerTimeSeconds: seconds.toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}
