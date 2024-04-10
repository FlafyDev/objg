enum GDProps {
  objectCommonID(1),
  objectCommonGroups(57),

  triggerCommonSpawnTriggered(62),
  triggerCommonMultiTriggered(87),

  moveTriggerMoveX(28),
  moveTriggerMoveY(29),
  moveTriggerTargetGroup(51),
  moveTriggerTimeSeconds(10),

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

