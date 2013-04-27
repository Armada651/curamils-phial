Scriptname MS12WhitePhialEffectScript extends ActiveMagicEffect  

; fix for 71753: NPCs don't fire OnEquipped when consuming potions,
;   so we need to use this magic effect

ReferenceAlias Property WhitePhial auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    Debug.Trace("MS12WhitePhialEffect: Target: " + akTarget + "; Caster: " + akCaster)
    MS12WhitePhialScript phial = (WhitePhial as MS12WhitePhialScript)
    
    ; if the phial has a custom alignment
    if (phial.Alignment != none)
        if (akTarget == Game.GetPlayer())
            Game.IncrementStat("Potions Used", -1)
        endif
        int count = akTarget.GetItemCount(phial.Alignment)
        akTarget.EquipItem(phial.Alignment, false, true)
        int delta = count - akTarget.GetItemCount(phial.Alignment)
        akTarget.AddItem(phial.Alignment, delta, true)
    endif
    
	; if ( (akTarget != Game.GetPlayer()) )
			phial.SetForRefill(akTarget)
	; endif
EndEvent
; /71753
