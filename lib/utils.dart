import 'package:objg/gdobject.dart';
import 'package:objg/gdprops.dart';
import 'package:objg/objg_project.dart';
import 'package:objg/triggers/spawn_trigger.dart';

String generateGDString(Map<GDProps, String> properties) {
  final buffer = StringBuffer();

  for (final entry in properties.entries) {
    if (entry.value.trim().isEmpty) continue;
    buffer.write("${entry.key.id},${entry.value},");
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
  for (final child in children) {
    if (child is ReferenceGroup) {
      SpawnTrigger(onStart: false, target: child).groups.add(group);
    } else {
      child.groups.add(group);
    }
  }
  return ReferenceGroup(group);
}

class ReferenceGroup extends GDObject {
  int group;
  ReferenceGroup(this.group) : super(uniqueGroup: group);
  @override
  String toGDString() {
    return "";
  }
}
