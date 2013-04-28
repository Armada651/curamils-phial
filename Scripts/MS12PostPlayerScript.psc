Scriptname MS12PostPlayerScript extends ReferenceAlias

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	; Check if item was not dropped in the world or stored in a container
	if (!akItemReference && !akDestContainer)
		; Check if item is a potion
		if (akBaseItem as Potion)
			; Check if the quest is in the realignment state
			MS12PostQuestScript owner = GetOwningQuest() as MS12PostQuestScript
			if (owner.Realign)
				; If the item was actually used
				if ((akBaseItem as Potion).IsHostile())
					int stat = Game.QueryStat("Poisons Used")
					if(stat > owner.PoisonsUsed)
						owner.SetCustomAlignment(akBaseItem as Potion)
					endif
				else
					int stat = Game.QueryStat("Potions Used")
					if(stat > owner.PotionsUsed)
						owner.SetCustomAlignment(akBaseItem as Potion)
					endif
				endif
			endif
		endif
	endif
EndEvent
