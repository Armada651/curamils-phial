Scriptname MS12WhitePhialScript extends ReferenceAlias  

float Property RefillTime auto ; in hours

MiscObject Property EmptyPhial auto
ObjectReference Property CurrentContainer auto
ObjectReference Property SpawnMarker auto
MiscObject Property WhitePhialBaseObject auto

Potion Property Alignment auto

; track where we are
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	Debug.Trace("MS12: White phial changing hands; now in " + akNewContainer)
	CurrentContainer = akNewContainer
EndEvent

Function Refill(Potion fillItem)
 	Debug.Trace("MS12: Refilling white phial...")
	ObjectReference emptyMe = GetReference()
	Clear()
	
	if (CurrentContainer == None)
		; in the world somewhere
 		Debug.Trace("MS12: White Phial sitting somewhere in the world: " + GetReference().GetParentCell())

		ObjectReference newMe = SpawnMarker.PlaceAtMe(fillItem)

		emptyMe.SetMotionType(emptyMe.Motion_Keyframed)
		newMe.SetMotionType(newMe.Motion_Keyframed)

		newMe.MoveTo(emptyMe)
		emptyMe.MoveTo(SpawnMarker)
		emptyMe.Disable()
		emptyMe.Delete()

		newMe.SetMotionType(newMe.Motion_Dynamic)

		ForceRefTo(newMe)

		; emptyMe.SetMotionType(emptyMe.Motion_Keyframed)
		; ObjectReference newMe = SpawnMarker.PlaceAtMe(fillItem)
		; newMe.SetMotionType(newMe.Motion_Keyframed)

		; newMe.SetPosition(emptyMe.X, emptyMe.Y, emptyMe.Z)
		; newMe.SetAngle(emptyMe.GetAngleX(), emptyMe.GetAngleY(), emptyMe.GetAngleZ())

		; ForceRefTo(newMe)
		; emptyMe.Delete()

		; newMe.SetMotionType(newMe.Motion_Dynamic)
	else
		; in a container
 		Debug.Trace("MS12: White Phial in a container: " + CurrentContainer)
		ObjectReference newMe = CurrentContainer.PlaceAtMe(fillItem)
		ForceRefTo(newMe)
		CurrentContainer.AddItem(newMe, 1, true)
;		CurrentContainer.RemoveItem(emptyMe, 1, true)

		; remove all empty phials, it may have been duplicated
		CurrentContainer.RemoveItem(EmptyPhial, CurrentContainer.GetItemCount(EmptyPhial), true)
	endif
    
    GoToState("")
EndFunction

; part of fix for 71753
Function SetForRefill(Actor drinker)
    ; if the phial has a custom alignment
    if (Alignment != none)
        Game.IncrementStat("Potions Used", -1)
        int count = drinker.GetItemCount(Alignment)
        drinker.EquipItem(Alignment, false, true)
        int delta = count - drinker.GetItemCount(Alignment)
        drinker.AddItem(Alignment, delta, true)
    endif
    
    ; add the empty phial and set the refill timer
	ObjectReference empty = drinker.PlaceAtMe(EmptyPhial, 1)
	ForceRefTo(empty)
	drinker.AddItem(empty, 1, true)
	GetOwningQuest().RegisterForSingleUpdateGameTime(RefillTime)
    
    GoToState("Empty")
EndFunction
; /71753

State Empty
    Event OnEquipped(Actor akActor)
        Debug.Trace("MS12: Player equipped white phial.")
        (GetOwningQuest() as MS12PostQuestScript).Realign()
    EndEvent
EndState
