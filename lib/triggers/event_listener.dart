import "package:objg/gdobject.dart";
import 'package:objg/gdprops.dart';
import 'package:objg/utils.dart';

enum Events {
  jumpPush(69),
  jumpRelease(70),
  leftPush(71),
  leftRelease(72),
  rightPush(73),
  rightRelease(74);

  const Events(this.id);
  final int id;
}

enum EventPlayers {
  all,
  p1,
  p2,
}

class EventListener extends GDObject {
  final List<Events> onEvents;
  final int extraID;
  final EventPlayers players;
  final GDObject child;

  EventListener(
    this.onEvents, {
    this.extraID = 0,
    this.players = EventPlayers.all,
    required this.child,
  });

  @override
  String toGDString() {
    // final activationGroup = getFreeGroup();
    // child.groups.add(activationGroup);
    return generateGDString({
      GDProps.objectCommonID: "3604",
      GDProps.objectCommonGroups: groups.join("."),
      GDProps.eventTriggerGroupID: child.getUniqueGroup().toString(),
      GDProps.eventTriggerEvents: onEvents.map((e) => e.id).join("."),
      GDProps.eventTriggerExtraID2: players.index.toString(),
      GDProps.triggerCommonMultiTriggered: 1.toString(),
      GDProps.triggerCommonSpawnTriggered: 1.toString(),
    });

    // return "$str;${child.toGDString()}";
  }
}

