import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class AlphaTrigger extends GDObject {
  final GDObject target;
  final double seconds;
  final double opacity;

  AlphaTrigger({
    required this.target,
    required this.opacity,
    required this.seconds,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "1007",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.alphaTriggerOpacity: opacity.toString(),
      GDProps.alphaTriggerGroupID: target.getUniqueGroup().toString(),
      GDProps.alphaTriggerTimeSeconds: seconds.toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}

