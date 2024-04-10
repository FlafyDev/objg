import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

enum PickupType {
  multiply,
  divide,
  addition,
  override,
}

class Pickup extends GDObject {
  final int itemID;
  final int? count;
  final double? modifier;
  final PickupType type;

  Pickup({
    required this.itemID,
    required this.type,
    this.count,
    this.modifier,
  });

  @override
  String toGDString() {
    switch (type) {
      case PickupType.multiply:
      case PickupType.divide:
        assert(modifier != null);

        return generateGDString({
          GDProps.objectCommonID: "1817",
          GDProps.objectCommonGroups: groups.join("."),
          GDProps.pickupTriggerItemID: itemID.toString(),
          GDProps.pickupTriggerModifier: modifier.toString(),
          GDProps.pickupTriggerMultiplyDivide: type == PickupType.multiply ? 1.toString() : 0.toString(),
          GDProps.triggerCommonMultiTriggered: 1.toString(),
          GDProps.triggerCommonSpawnTriggered: 1.toString(),
        });
      case PickupType.addition:
      case PickupType.override:
        assert(count != null);

        return generateGDString({
          GDProps.objectCommonID: "1817",
          GDProps.objectCommonGroups: groups.join("."),
          GDProps.pickupTriggerItemID: itemID.toString(),
          GDProps.pickupTriggerCount: count.toString(),
          GDProps.pickupTriggerOverride: (type == PickupType.override ? 1 : 0).toString(),
          GDProps.triggerCommonMultiTriggered: 1.toString(),
          GDProps.triggerCommonSpawnTriggered: 1.toString(),
        });
    }
  }
}

