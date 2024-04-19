import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

enum ItemEditModifier {
  multiply(3),
  divide(4),
  add(1),
  subtract(2);

  const ItemEditModifier(this.id);
  final int id;
}

class ItemEdit extends GDObject {
  final int itemID1;
  final int itemIDResult;
  final int? itemID2;
  // final int? modCount;
  final ItemEditModifier? modifier;

  ItemEdit({
    required this.itemID1,
    required this.itemIDResult,
    this.itemID2,
    // this.modCount,
    this.modifier,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "3619",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.itemEditItemID1: itemID1.toString(),
      if (itemID2 != null) GDProps.itemEditItemID2: itemID2!.toString(),
      if (itemID2 != null) GDProps.itemEditOp1: modifier!.id.toString(),
      GDProps.itemEditTargetItemID: itemIDResult.toString(),
      GDProps.itemEditType1: 1.toString(),
      GDProps.itemEditType2: 1.toString(),
      GDProps.itemEditTargetType: 1.toString(),
      GDProps.itemEditMod: 1.toString(),
      // GDProps.itemEditMod(479),
      // GDProps.itemEditAssignOp(480),
      // GDProps.itemEditOp2(482),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}
