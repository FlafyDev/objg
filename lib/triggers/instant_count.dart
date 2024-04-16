import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

enum InstantCountCompareType {
  equal,
  larger,
  smaller,
}

class InstantCount extends GDObject {
  final int itemID;
  final int targetCount;
  final InstantCountCompareType compareType;
  final GDObject then;

  InstantCount({
    required this.itemID,
    required this.targetCount,
    required this.compareType,
    required this.then,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "1811",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.instantCountTriggerItemID: itemID.toString(),
      GDProps.instantCountTriggerTargetCount: targetCount.toString(),
      GDProps.instantCountTriggerTargetID: then.getUniqueGroup().toString(),
      GDProps.instantCountTriggerActivateGroup: 1.toString(),
      GDProps.instantCountTriggerCompareType: compareType.index.toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}

