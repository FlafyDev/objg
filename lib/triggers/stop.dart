import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

enum StopType {
  stop,
  pause,
  resume,
}

class Stop extends GDObject {
  final StopType type;
  final GDObject target;

  Stop({
    required this.type,
    required this.target,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "1616",
      GDProps.objectCommonGroups: groups.join("."),
      GDProps.stopTriggerStopType: type.index.toString(),
      GDProps.stopTriggerTargetID: target.getUniqueGroup().toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}

