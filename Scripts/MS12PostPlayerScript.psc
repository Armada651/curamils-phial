Scriptname MS12PostPlayerScript extends ReferenceAlias

bool Property HasPoison auto

Event OnSpellCast(Form akSpell)
	Debug.Notification("We cast something.")
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	Debug.Notification("We equipped something.")
EndEvent

State Align
	Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		; Check if item is a potion
		if (akBaseItem as Potion)
			; Check if the quest is in the realignment state
			MS12PostQuestScript owner = GetOwningQuest() as MS12PostQuestScript
			
			; If the item was actually used
			if ((akBaseItem as Potion).IsHostile())
				int stat = Game.QueryStat("Poisons Used")
				if(stat > owner.PoisonsUsed)
					owner.SetCustomAlignment(akBaseItem as Potion)
					GotoState("")
				endif
			else
				int stat = Game.QueryStat("Potions Used")
				if(stat > owner.PotionsUsed)
					owner.SetCustomAlignment(akBaseItem as Potion)
					GotoState("")
				endif
			endif
		endif
	EndEvent
EndState

State Poison
	Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		Debug.Notification("Poison State")
		MS12PostQuestScript owner = (GetOwningQuest() as MS12PostQuestScript)
		MS12WhitePhialScript phial = (owner.PhialAlias as MS12WhitePhialScript)
		
		int stat = Game.QueryStat("Poisons Used")
		if(stat > owner.PoisonsUsed)
			Debug.Notification("Phial poison was used")
			Actor akActor = Game.GetPlayer()
			if (HasPoison)
				akActor.AddItem(akBaseItem, 1, true)
			endif
			akActor.RemoveItem(owner.CustomPhial, 1, true)
			
			ObjectReference empty = akActor.PlaceAtMe(owner.EmptyPhial, 1)
			phial.ForceRefTo(empty)
			akActor.AddItem(empty, 1, true)
			
			owner.RegisterForSingleUpdateGameTime(phial.RefillTime)
		endif
		GotoState("")
	EndEvent
EndState
