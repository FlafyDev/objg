import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

enum ItemCompCompareOp {
  equal,
  larger,
  largerOrEqual,
  smaller,
  smallerOrEqual,
  notEqual,
}

class ItemComp extends GDObject {
  final int itemID1;
  final int itemID2;
  final GDObject? then;
  final GDObject? elsee;
  final ItemCompCompareOp? compareOp;

  ItemComp({
    required this.itemID1,
    required this.itemID2,
    this.compareOp,
    this.then,
    this.elsee,
  });

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "3620",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.itemCompItemID1: itemID1.toString(),
      GDProps.itemCompItemID2: itemID2.toString(),
      if (then != null) GDProps.itemCompTrueID: then!.getUniqueGroup().toString(),
      if (elsee != null) GDProps.itemCompFalseID: elsee!.getUniqueGroup().toString(),
      if (compareOp != null) GDProps.itemCompCompareOp: compareOp!.index.toString(),
      GDProps.itemCompType1: 1.toString(),
      GDProps.itemCompType2: 1.toString(),
      GDProps.itemCompMod1: 1.toString(),
      GDProps.itemCompMod2: 1.toString(),
      GDProps.itemCompOp1: 3.toString(),
      GDProps.itemCompOp2: 3.toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}
