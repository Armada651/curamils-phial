Scriptname MS12PostPlayerScript extends ReferenceAlias

Event OnSpellCast(Form akSpell)
	if (akSpell as Potion)
		MS12PostQuestScript owner = GetOwningQuest() as MS12PostQuestScript
		if (owner.Realign)
			owner.SetCustomAlignment(akSpell as Potion)
		endif
	endif
EndEvent
