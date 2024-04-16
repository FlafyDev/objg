import 'dart:io';

import 'package:objg/gdobject.dart';
import 'package:objg/objg.dart';
import 'package:objg/triggers/pickup.dart';

class ObjGProject {
  final groupOffset = 1000;
  late final generatedGroup = groupOffset;
  late int _lastGroup = groupOffset + 1;

  final int itemOffset = 1000;
  late int _lastItem = itemOffset;
  late final int itemsGroup = getFreeGroup();

  final List<GDObject> objects = [];

  ObjGProject();

  void init() {
    assert(proj == this, "This project must be the global project.");

    SpawnTrigger(onStart: true, target: ReferenceGroup(itemsGroup));
  }

  int getFreeGroup() {
    return _lastGroup++;
  }

  int getFreeItem([int? defaultValue]) {
    final itemID = _lastItem++;
    if (defaultValue != null && defaultValue != 0) {
      Pickup(
        itemID: itemID,
        type: PickupType.override,
        count: defaultValue,
      ).groups.add(itemsGroup);
    }
    return itemID;
  }

  String getLevelString() {
    for (final obj in objects) {
      obj.toGDString();
    }

    stderr.writeln("objects: ${objects.length}");
    return objects
        .map((obj) {
          return obj.toGDString();
        })
        .where((objStr) => objStr.isNotEmpty)
        .join(";");
  }
}

int getFreeGroup() => proj.getFreeGroup();
int getFreeItem([int? defaultValue]) => proj.getFreeItem(defaultValue);
String getLevelString() => proj.getLevelString();

late final ObjGProject proj;
