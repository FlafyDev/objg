import 'package:objg/gdprops.dart';
import 'package:objg/objg_project.dart';

abstract class GDObject {
  GDObject({int? uniqueGroup}) {
    proj.objects.add(this);
    _uniqueGroup = uniqueGroup;
  }
  int? x;
  int? y;
  int? _uniqueGroup;
  final List<int> groups = [
    proj.generatedGroup
  ];

  int getUniqueGroup() {
    if (_uniqueGroup == null) {
      _uniqueGroup = getFreeGroup();
      groups.add(_uniqueGroup!);
    }
    return _uniqueGroup!;
  }

  String toGDString();
}

