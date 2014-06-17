Scriptname MS12WhitePhialEffectScript extends ActiveMagicEffect  

; fix for 71753: NPCs don't fire OnEquipped when consuming potions,
;   so we need to use this magic effect

ReferenceAlias Property WhitePhial auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
    Debug.Trace("MS12WhitePhialEffect: Target: " + akTarget + "; Caster: " + akCaster)
    MS12WhitePhialScript phial = (WhitePhial as MS12WhitePhialScript)
    
    ; if the phial has a custom alignment drink the aligned potion
    if (phial.Alignment != none)
    	; we already drank the phial, so we should decrement the stat
        if (akTarget == Game.GetPlayer())
            Game.IncrementStat("Potions Used", -1)
        endif
        
        ; we're about to drink the potion, but we may consume it from
        ; the inventory if the player already has it
        int count = akTarget.GetItemCount(phial.Alignment)
        akTarget.EquipItem(phial.Alignment, false, true)
        
        
        ; if we consumed a potion from the inventory, give it back
        int delta = count - akTarget.GetItemCount(phial.Alignment)
        akTarget.AddItem(phial.Alignment, delta, true)
    endif
    
    ; if ( (akTarget != Game.GetPlayer()) )
        phial.SetForRefill(akTarget)
    ; endif
EndEvent
; /71753
