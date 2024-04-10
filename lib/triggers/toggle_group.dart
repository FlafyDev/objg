import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class ToggleGroup extends GDObject {
  final int group;
  final bool enable;
  ToggleGroup({required this.group, required this.enable});

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "1049",
      GDProps.objectCommonGroups: groups.join("."),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
      // GDProps.eventTriggerEvents: onEvents.join("."),
      // GDProps.eventTriggerExtraID2: players.index.toString(),
    });
  }
}

