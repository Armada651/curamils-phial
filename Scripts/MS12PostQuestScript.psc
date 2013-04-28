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

bool Property Realign = false auto
int Property PoisonsUsed auto
int Property PotionsUsed auto

Function SetReward(string rewardType)
; 	Debug.Trace("MS12: Setting reward to " + rewardType)
	if     (rewardType == "heal")
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
	
	Game.GetPlayer().RemoveItem(PhialAlias.GetReference(), 1)
	
	ObjectReference rep = Game.GetPlayer().PlaceAtMe(Replicated, 1)
	PhialAlias.ForceRefTo(rep)

	Game.GetPlayer().AddItem(rep)
EndFunction

Event OnUpdateGameTime()
	RewardCheck()
EndEvent

Function RewardCheck(bool quiet = false)
; 	Debug.Trace("MS12: White phial attempting to refill...")
	if (!quiet && Game.GetPlayer().GetItemCount(EmptyPhial) > 0)
		MS12RefillMessage.Show()
	endif
	Realign = false
	(PhialAlias as MS12WhitePhialScript).Refill(Replicated)
EndFunction

Function SetCustomAlignment(Potion alignPotion)
	Replicated = CustomPhial
	Realign = false
	
	MS12WhitePhialScript phial = (PhialAlias as MS12WhitePhialScript)
	phial.Alignment = alignPotion
	RegisterForSingleUpdateGameTime(phial.RefillTime)
	MS12AlignedMessage.Show()
EndFunction

Function Realign()
	if (MS12RealignMessage.Show() == 0)
		Realign = true
		PoisonsUsed = Game.QueryStat("Poisons Used")
		PotionsUsed = Game.QueryStat("Potions Used")
		MS12AlignMessage.Show()
	else
		Realign = false
	endif
EndFunction
