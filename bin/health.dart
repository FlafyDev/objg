import 'package:objg/objg.dart';

import 'health_numbers.dart';

// index 0 = 1 hp
final healthBarGroupList = <int>[];
final karmaBarGroupList = <int>[];
final gKarmaBars = getFreeGroup();
final iHealth = getFreeItem(92);
final iKarma = getFreeItem(1);
final gCurrentHealthBar = getFreeGroup();
final gPurpleMaxHPText = 18;

final GDObject _showHealthBar = (() {
  final objs = <GDObject>[];
  objs.addAll([
    InstantCount(
      itemID: iKarma,
      targetCount: 0,
      compareType: InstantCountCompareType.equal,
      then: AlphaTrigger(
        target: ReferenceGroup(gPurpleMaxHPText),
        opacity: 0,
        seconds: 0,
      ),
    ),
    InstantCount(
      itemID: iKarma,
      targetCount: 0,
      compareType: InstantCountCompareType.larger,
      then: AlphaTrigger(
        target: ReferenceGroup(gPurpleMaxHPText),
        opacity: 1,
        seconds: 0,
      ),
    ),
  ]);
  for (int i = 0; i < healthBarGroupList.length; i++) {
    final percent = (i + 1) / 92;
    const fullScaleX = 6.159;
    final scaleX = fullScaleX * percent;
    objs.add(
      InstantCount(
        itemID: iHealth,
        targetCount: i + 1,
        compareType: InstantCountCompareType.equal,
        then: sgroup([
          InstantCount(
            itemID: iKarma,
            targetCount: 0,
            compareType: InstantCountCompareType.equal,
            then: setHealth(i + 1, false),
          ),
          InstantCount(
            itemID: iKarma,
            targetCount: 0,
            compareType: InstantCountCompareType.larger,
            then: setHealth(i + 1, true),
          ),
          Move(
            x: 0,
            y: -1000,
            seconds: 0,
            target: ReferenceGroup(healthBarGroupList[i]),
          ),
          Move(
            x: -((fullScaleX - scaleX) * 30).floor(),
            y: 0,
            seconds: 0,
            target: ReferenceGroup(gKarmaBars),
          ),
        ]),
      ),
    );
  }
  return sgroup([
    _showKarmaBar,
    sgroup(objs),
  ]);
}());

final GDObject _showKarmaBar = (() {
  final objs = <GDObject>[];
  for (int i = 0; i < karmaBarGroupList.length; i++) {
    objs.add(
      InstantCount(
        itemID: iKarma,
        targetCount: i + 1,
        compareType: InstantCountCompareType.equal,
        then: sgroup([
          Move(
            x: 0,
            y: -1000,
            seconds: 0,
            target: ReferenceGroup(karmaBarGroupList[i]),
          ),
        ]),
      ),
    );
  }
  return sgroup(objs);
}());

final GDObject _hideHealthBar = (() {
  final objs = <GDObject>[];
  for (int i = 0; i < healthBarGroupList.length; i++) {
    final percent = (i + 1) / 92;
    const fullScaleX = 6.159;
    final scaleX = fullScaleX * percent;
    objs.add(
      InstantCount(
        itemID: iHealth,
        targetCount: i + 1,
        compareType: InstantCountCompareType.equal,
        then: sgroup([
          InstantCount(
            itemID: iKarma,
            targetCount: 0,
            compareType: InstantCountCompareType.equal,
            then: clearHealth(i + 1, false),
          ),
          InstantCount(
            itemID: iKarma,
            targetCount: 0,
            compareType: InstantCountCompareType.larger,
            then: clearHealth(i + 1, true),
          ),
          Move(
            x: 0,
            y: 1000,
            seconds: 0,
            target: ReferenceGroup(healthBarGroupList[i]),
          ),
          Move(
            x: ((fullScaleX - scaleX) * 30).floor(),
            y: 0,
            seconds: 0,
            target: ReferenceGroup(gKarmaBars),
          ),
        ]),
      ),
    );
  }
  return sgroup([
    _hideKarmaBar,
    sgroup(objs),
  ]);
}());

final GDObject _hideKarmaBar = (() {
  final objs = <GDObject>[];
  for (int i = 0; i < karmaBarGroupList.length; i++) {
    objs.add(
      InstantCount(
        itemID: iKarma,
        targetCount: i + 1,
        compareType: InstantCountCompareType.equal,
        then: sgroup([
          Move(
            x: 0,
            y: 1000,
            seconds: 0,
            target: ReferenceGroup(karmaBarGroupList[i]),
          ),
        ]),
      ),
    );
  }
  return sgroup(objs);
}());

final limitKarma = (() {
  final objs = <GDObject>[];
  for (int i = 0; i < karmaBarGroupList.length; i++) {
    objs.add(
      InstantCount(
        itemID: iHealth,
        targetCount: i + 1,
        compareType: InstantCountCompareType.equal,
        then: InstantCount(
          itemID: iKarma,
          targetCount: i,
          compareType: InstantCountCompareType.larger,
          then: Pickup(
            itemID: iKarma,
            type: PickupType.override,
            count: i,
          ),
        ),
      ),
    );
  }
  objs.add(
    InstantCount(
      itemID: iKarma,
      targetCount: karmaBarGroupList.length,
      compareType: InstantCountCompareType.larger,
      then: Pickup(
        itemID: iKarma,
        type: PickupType.override,
        count: karmaBarGroupList.length,
      ),
    ),
  );
  objs.add(
    InstantCount(
      itemID: iKarma,
      targetCount: 0,
      compareType: InstantCountCompareType.smaller,
      then: Pickup(
        itemID: iKarma,
        type: PickupType.override,
        count: 0,
      ),
    ),
  );
  return sgroup(objs);
})();

GDObject _lowerHealthXKarma(int karma) => ogroup([
      _hideHealthBar,
      Pickup(
        itemID: iHealth,
        type: PickupType.addition,
        count: -1,
      ),
      Pickup(
        itemID: iKarma,
        type: PickupType.addition,
        count: karma,
      ),
      limitKarma,
      _showHealthBar,
    ]);

void initHealth() {
  for (int i = 0; i < 92; i++) {
    final percent = (i + 1) / 92;
    final group = getFreeGroup();
    const fullScaleX = 6.159;
    final scaleX = fullScaleX * percent;
    CustomObj(
      id: 211,
      groups: [
        group,
      ],
      props: {
        GDProps.objectCommonX: (1140.44 - (fullScaleX - scaleX) * 30 / 2).toString(),
        GDProps.objectCommonY: (243.282 + 1000).toString(),
        GDProps.objectCommonHSVEnabled: 1.toString(),
        GDProps.objectCommonHSV: "62a0.76a1a1a0",
        GDProps.objectCommonScaleX: scaleX.toString(),
        GDProps.objectCommonScaleY: "1.14",
      },
      rawProps: {
        "155": "5",
        "24": "5",
      },
    );
    healthBarGroupList.add(group);
  }

  for (int i = 0; i < 40; i++) {
    final percent = (i + 1) / 92;
    final group = getFreeGroup();
    const fullScaleX = 6.159;
    final scaleX = fullScaleX * percent;
    CustomObj(
      id: 211,
      groups: [
        group,
        gKarmaBars,
      ],
      props: {
        GDProps.objectCommonX: (1140.44 + (fullScaleX - scaleX) * 30 / 2).toString(),
        GDProps.objectCommonY: (243.282 + 1000).toString(),
        GDProps.objectCommonHSVEnabled: 1.toString(),
        GDProps.objectCommonHSV: hsvToGDHSV(300.0 / 360, 1.0, 1.0),
        GDProps.objectCommonScaleX: scaleX.toString(),
        GDProps.objectCommonScaleY: "1.14",
      },
      rawProps: {
        "155": "5",
        "24": "5",
      },
    );
    karmaBarGroupList.add(group);
  }

  SpawnTrigger(
    onStart: true,
    target: _showHealthBar,
  );

  final lowerKarma = ogroup([
    _hideHealthBar,
    InstantCount(
      itemID: iKarma,
      targetCount: 0,
      compareType: InstantCountCompareType.larger,
      then: sgroup([
        Pickup(
          itemID: iKarma,
          type: PickupType.addition,
          count: -1,
        ),
        Pickup(
          itemID: iHealth,
          type: PickupType.addition,
          count: -1,
        ),
      ]),
    ),
    limitKarma,
    _showHealthBar,
  ]);
  // KARMA == 40 --> 1 frame
  // 30 =< KARMA =< 39 --> 2 frame
  // 20 =< KARMA =< 29 --> 5 frame
  // 10 =< KARMA =< 19 --> 15 frame
  // 0 =< KARMA =< 9 --> 30 frame
  final i30Frames = getFreeItem(0);
  final i15Frames = getFreeItem(0);
  final i5Frames = getFreeItem(0);
  final i2Frames = getFreeItem(0);
  final loop = ogroup([
    Pickup(itemID: i30Frames, type: PickupType.addition, count: 1),
    Pickup(itemID: i15Frames, type: PickupType.addition, count: 1),
    Pickup(itemID: i5Frames, type: PickupType.addition, count: 1),
    Pickup(itemID: i2Frames, type: PickupType.addition, count: 1),
    InstantCount(
      itemID: i30Frames,
      targetCount: 30 - 1,
      compareType: InstantCountCompareType.larger,
      then: sgroup([
        Pickup(
          itemID: i30Frames,
          type: PickupType.override,
          count: 0,
        ),
        InstantCount(
          itemID: iKarma,
          targetCount: -1,
          compareType: InstantCountCompareType.larger,
          then: InstantCount(
            itemID: iKarma,
            targetCount: 10,
            compareType: InstantCountCompareType.smaller,
            then: lowerKarma,
          ),
        ),
      ]),
    ),
    InstantCount(
      itemID: i15Frames,
      targetCount: 15 - 1,
      compareType: InstantCountCompareType.larger,
      then: sgroup([
        Pickup(
          itemID: i15Frames,
          type: PickupType.override,
          count: 0,
        ),
        InstantCount(
          itemID: iKarma,
          targetCount: 9,
          compareType: InstantCountCompareType.larger,
          then: InstantCount(
            itemID: iKarma,
            targetCount: 20,
            compareType: InstantCountCompareType.smaller,
            then: lowerKarma,
          ),
        ),
      ]),
    ),
    InstantCount(
      itemID: i5Frames,
      targetCount: 5 - 1,
      compareType: InstantCountCompareType.larger,
      then: sgroup([
        Pickup(
          itemID: i5Frames,
          type: PickupType.override,
          count: 0,
        ),
        InstantCount(
          itemID: iKarma,
          targetCount: 19,
          compareType: InstantCountCompareType.larger,
          then: InstantCount(
            itemID: iKarma,
            targetCount: 30,
            compareType: InstantCountCompareType.smaller,
            then: lowerKarma,
          ),
        ),
      ]),
    ),
    InstantCount(
      itemID: i2Frames,
      targetCount: 2 - 1,
      compareType: InstantCountCompareType.larger,
      then: sgroup([
        Pickup(
          itemID: i2Frames,
          type: PickupType.override,
          count: 0,
        ),
        InstantCount(
          itemID: iKarma,
          targetCount: 29,
          compareType: InstantCountCompareType.larger,
          then: InstantCount(
            itemID: iKarma,
            targetCount: 40,
            compareType: InstantCountCompareType.smaller,
            then: lowerKarma,
          ),
        ),
      ]),
    ),
    InstantCount(
      itemID: iKarma,
      targetCount: 40,
      compareType: InstantCountCompareType.equal,
      then: lowerKarma,
    ),
  ]);
  SpawnTrigger(delay: 1.0 / 30, target: loop).groups.add(loop.group);
  SpawnTrigger(onStart: true, target: loop);

  // final agroup = getFreeGroup();

  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.5,
  //   target: _hideKarmaBar,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.8,
  //   target: Pickup(itemID: iKarma, type: PickupType.addition, count: -20),
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 1,
  //   target: _showKarmaBar,
  // );
  // SpawnTrigger(target: lowerHealth).groups.add(agroup);
  // SpawnTrigger(
  //   delay: 0.1,
  //   target: ReferenceGroup(agroup),
  // ).groups.add(agroup);
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.1,
  //   target: ReferenceGroup(agroup),
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.2,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.3,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.4,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.5,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.6,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.7,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.8,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 0.9,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 1.0,
  //   target: lowerHealth,
  // );
  // SpawnTrigger(
  //   onStart: true,
  //   delay: 1.1,
  //   target: lowerHealth,
  // );
}

// Bone vertical loop: 5
final lowerHealth5Karma = _lowerHealthXKarma(5);
// Gaster Blaster: 10
final lowerHealth10Karma = _lowerHealthXKarma(10);
// Single menu bone (top left): 2
final lowerHealth2Karma = _lowerHealthXKarma(2);
// Four menu bones (bottom): 1
final lowerHealth1Karma = _lowerHealthXKarma(1);
// Other: 6
final lowerHealth6Karma = _lowerHealthXKarma(6);
