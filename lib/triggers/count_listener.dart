import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class CountListener extends GDObject {
  final int itemID;
  final int targetCount;
  final GDObject then;

  CountListener({
    required this.itemID,
    required this.targetCount,
    required this.then,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "1611",
      GDProps.objectCommonGroups: groups.join("."),
      GDProps.countTriggerItemID: itemID.toString(),
      GDProps.countTriggerTargetCount: targetCount.toString(),
      GDProps.countTriggerTargetID: then.getUniqueGroup().toString(),
      GDProps.countTriggerActivateGroup: 1.toString(),
      GDProps.countTriggerMultiActivate: 1.toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}

