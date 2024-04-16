import 'package:objg/gdobject.dart';
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

class CustomObj extends GDObject {
  final int id;
  final Map<GDProps, String> props;
  final Map<String, String> rawProps;

  CustomObj({
    required this.id,
    List<int> groups = const [],
    this.props = const {},
    this.rawProps = const {},
  }) {
    this.groups.addAll(groups);
  }

  @override
  String toGDString() {
    return generateGDString({
      GDProps.objectCommonID: "$id",
      GDProps.objectCommonGroups: groups.join("."),
      ...props,
    }, rawProperties: rawProps);
  }
}


