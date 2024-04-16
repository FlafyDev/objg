import 'package:objg/gdobject.dart';
import 'package:objg/gdprops.dart';
import 'package:objg/objg_project.dart';
import 'package:objg/triggers/spawn_trigger.dart';

String generateGDString(
  Map<GDProps, String> properties, {
  Map<String, String> rawProperties = const {},
}) {
  final buffer = StringBuffer();

  for (final entry in properties.entries) {
    if (entry.value.trim().isEmpty) continue;
    if (entry.key == GDProps.objectCommonGroups && entry.value.split(".").length > 10) {
      throw Exception("Too many groups");
    }
    buffer.write("${entry.key.id},${entry.value},");
  }

  for (final entry in rawProperties.entries) {
    if (entry.value.trim().isEmpty) continue;
    buffer.write("${entry.key},${entry.value},");
  }

  // https://github.com/dart-lang/sdk/issues/25897
  final str = buffer.toString();
  if (str.isNotEmpty) {
    return str.substring(0, str.length - 1);
  }
  return str;
}

ReferenceGroup sgroup(List<GDObject> children) {
  final group = getFreeGroup();

  void addChild(GDObject child) {
    if (child is ReferenceGroup) {
      if (child.children != null) {
        for (final c in child.children!) {
          addChild(c);
        }
      } else {
        SpawnTrigger(onStart: false, target: child).groups.add(group);
      }
    } else {
      child.groups.add(group);
    }
  }

  for (final child in children) {
    addChild(child);
  }
  return ReferenceGroup(group, children: children);
}

// Ordered sgroup
ReferenceGroup ogroup(List<GDObject> children) {
  final newChildren = [...children];

  for (int i = 0; i < newChildren.length; i++) {
    if (newChildren[i] is ReferenceGroup) {
      newChildren[i] = SpawnTrigger(x: i, target: newChildren[i]);
    }
    newChildren[i].x = i;
  }

  return sgroup(newChildren);
}

class ReferenceGroup extends GDObject {
  int group;
  final List<GDObject>? children;
  ReferenceGroup(this.group, {this.children}) : super(uniqueGroup: group);
  @override
  String toGDString() {
    assert(x == null && y == null, "ReferenceGroup cannot have x or y");
    return "";
  }
}
