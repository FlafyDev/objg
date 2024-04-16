enum GDProps {
  objectCommonID(1),
  objectCommonGroups(57),
  objectCommonX(2),
  objectCommonY(3),
  objectCommonZLayer(24),
  objectCommonZOrder(25),
  objectCommonHSVEnabled(41),
  objectCommonHSV(43),
  objectCommonScaleX(128),
  objectCommonScaleY(129),

  triggerCommonSpawnTriggered(62),
  triggerCommonMultiTriggered(87),
  triggerCommonEasing(30), // 0 - 18

  rotateTriggerDegrees(68),
  rotateTriggerTargetGroup(51),
  rotateTriggerCenterGroup(71),
  rotateTriggerTimeSeconds(10),

  toggleTriggerGroupID(51),
  toggleTriggerActivateGroup(56),

  alphaTriggerGroupID(51),
  alphaTriggerOpacity(35),
  alphaTriggerTimeSeconds(10),

  collisionBlockBlockID(80),

  scaleTriggerScaleX(150),
  scaleTriggerScaleY(151),
  scaleTriggerTargetGroup(51),
  scaleTriggerCenterGroup(71),
  scaleTriggerTimeSeconds(10),

  moveTriggerMoveX(28),
  moveTriggerMoveY(29),
  moveTriggerTargetGroup(51),
  moveTriggerTimeSeconds(10),
  moveTriggerTargetMode(100),
  moveTriggerTargetToID(71),

  stopTriggerTargetID(51),
  stopTriggerUseControlID(535),
  stopTriggerStopType(580),

  collisionTriggerBlockA(80),
  collisionTriggerBlockB(95),
  collisionTriggerTargetID(51),
  collisionTriggerTriggerOnExit(93),
  collisionTriggerActivateGroup(56),

  instantCollisionTriggerBlockA(80),
  instantCollisionTriggerBlockB(95),
  instantCollisionTrueID(51),
  instantCollisionFalseID(71),

  spawnTriggerTargetID(51),
  spawnTriggerDelay(63),

  pickupTriggerItemID(80),
  pickupTriggerCount(77),
  pickupTriggerOverride(139),
  pickupTriggerMultiplyDivide(88),
  pickupTriggerModifier(449),

  countTriggerItemID(80),
  countTriggerTargetID(51),
  countTriggerTargetCount(77),
  countTriggerActivateGroup(56),
  countTriggerMultiActivate(104),

  instantCountTriggerItemID(80),
  instantCountTriggerTargetID(51),
  instantCountTriggerTargetCount(77),
  instantCountTriggerActivateGroup(56),
  instantCountTriggerCompareType(88),

  eventTriggerGroupID(51),
  eventTriggerExtraID2(525),
  eventTriggerEvents(430);

  const GDProps(this.id);
  final int id;
}

enum TriggerEasing {
  none(0),
  easeIn(2),
  exponentialOut(12);

  const TriggerEasing(this.id);
  final int id;
}
