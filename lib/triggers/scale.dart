import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class Scale extends GDObject {
  final GDObject target;
  final GDObject? center;
  final double seconds;
  final double scaleX;
  final double scaleY;
  final TriggerEasing easing;

  Scale({
    required this.target,
    this.center,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.easing = TriggerEasing.none,
    required this.seconds,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "2067",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.triggerCommonEasing: easing.id.toString(),
      GDProps.scaleTriggerScaleX: scaleX.toString(),
      GDProps.scaleTriggerScaleY: scaleY.toString(),
      GDProps.scaleTriggerTargetGroup: target.getUniqueGroup().toString(),
      if (center != null) GDProps.scaleTriggerCenterGroup: center!.getUniqueGroup().toString(),
      GDProps.scaleTriggerTimeSeconds: seconds.toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}
