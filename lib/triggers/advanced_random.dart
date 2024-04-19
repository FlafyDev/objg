import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class AdvancedRandom extends GDObject {
  final Map<GDObject, int> items;

  AdvancedRandom(this.items);

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "2068",
      GDProps.objectCommonGroups: groups.join("."),
      if (x != null) GDProps.objectCommonX: x.toString(),
      if (y != null) GDProps.objectCommonY: y.toString(),
      GDProps.advancedRandomList: items.entries.map((e) => "${e.key.getUniqueGroup()}.${e.value}").join("."),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });
  }
}
