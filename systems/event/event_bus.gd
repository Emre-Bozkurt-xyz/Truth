@warning_ignore_start("UNUSED_SIGNAL")
extends Node

signal DoorEntered(door: Door)
signal RoomEntered(room_name: String)

#region Items
signal ItemPickup(item: Item)
signal ItemUsed(item: Item)
#endregion

#region Quests
signal QuestStart(quest: Quest)
signal QuestComplete(quest: Quest)
signal TaskAdvance(quest: Quest, task: Task)
signal TaskComplete(quest: Quest, task: Task)
#endregion
