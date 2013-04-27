Scriptname MS12PostPlayerScript extends ReferenceAlias

State Align
	Event OnSpellCast(Form akSpell)
		if (akSpell as Potion)
			(GetOwningQuest() as MS12PostQuestScript).SetCustomAlignment(akSpell as Potion)
		endif
	EndEvent
EndState
