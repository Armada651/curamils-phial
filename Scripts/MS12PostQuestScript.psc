Scriptname MS12PostQuestScript extends Quest  

Potion Property CustomPhial auto
MiscObject Property EmptyPhial auto

Potion Property Replicated auto

Potion Property HealPotion auto
Potion Property ResistMagicPotion auto
Potion Property ResistDamagePotion auto
Potion Property ImproveMagicPotion auto
Potion Property ImproveDamagePotion auto
Potion Property ImproveSneakPotion auto

Message Property MS12RefillMessage auto
Message Property MS12RealignMessage auto
Message Property MS12AlignedMessage auto
Message Property MS12AlignMessage auto

ReferenceAlias Property PhialAlias auto
ReferenceAlias Property PlayerAlias auto

Function SetReward(string rewardType)
; 	Debug.Trace("MS12: Setting reward to " + rewardType)
	if	 (rewardType == "heal")
		Replicated = HealPotion
	elseif (rewardType == "resist magic")		
		Replicated = ResistMagicPotion
	elseif (rewardType == "resist damage")		
		Replicated = ResistDamagePotion
	elseif (rewardType == "improve magic")		
		Replicated = ImproveMagicPotion
	elseif (rewardType == "improve damage")		
		Replicated = ImproveDamagePotion
	elseif (rewardType == "improve sneak")		
		Replicated = ImproveSneakPotion
	else
; 		Debug.Trace("MS12: Trying to align phial to unknown type.", 2)
	endif
	
	Actor player = Game.GetPlayer()
	
	; remove the current phial and any empty duplicates
	player.RemoveItem(PhialAlias.GetReference(), 1, true)
	player.RemoveItem(EmptyPhial, Game.GetPlayer().GetItemCount(EmptyPhial), true)
	
	ObjectReference rep = player.PlaceAtMe(EmptyPhial, 1)
	PhialAlias.ForceRefTo(rep)
	player.AddItem(rep)
	
	; set the refill timer
    MS12WhitePhialScript phial = (PhialAlias as MS12WhitePhialScript)
	RegisterForSingleUpdateGameTime(phial.RefillTime)
	MS12AlignedMessage.Show()
    
    phial.GoToState("Empty")
EndFunction

Event OnUpdateGameTime()
	RewardCheck()
EndEvent

Function RewardCheck(bool quiet = false)
; 	Debug.Trace("MS12: White phial attempting to refill...")
	if (Replicated)
		if (!quiet && Game.GetPlayer().GetItemCount(EmptyPhial) > 0)
			MS12RefillMessage.Show()
		endif
		(PlayerAlias as MS12PostPlayerScript).GoToState("")
		(PhialAlias as MS12WhitePhialScript).Refill(Replicated)
	endif
EndFunction

Function SetCustomAlignment(Potion alignPotion)
	(PlayerAlias as MS12PostPlayerScript).GoToState("")
	Replicated = CustomPhial
	MS12WhitePhialScript phial = (PhialAlias as MS12WhitePhialScript)
	phial.Alignment = alignPotion
	RegisterForSingleUpdateGameTime(phial.RefillTime)
	MS12AlignedMessage.Show()
EndFunction

Function Realign()
	if (Replicated)
		if (MS12RealignMessage.Show() == 1)
			return
		endif
	endif
	
	UnregisterForUpdateGameTime()
	Replicated = none
	(PlayerAlias as MS12PostPlayerScript).GoToState("Align")
	MS12AlignMessage.Show()
EndFunction
