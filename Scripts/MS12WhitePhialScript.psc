Scriptname MS12WhitePhialScript extends ReferenceAlias  

float Property RefillTime auto ; in hours

Potion Property CustomPhial auto
MiscObject Property EmptyPhial auto
ObjectReference Property CurrentContainer auto
ObjectReference Property SpawnMarker auto

Potion Property Alignment auto

; track where we are
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
; 	Debug.Trace("MS12: White phial changing hands; now in " + akNewContainer)
	CurrentContainer = akNewContainer
EndEvent

Function Refill(Potion fillItem)
; 	Debug.Trace("MS12: Refilling white phial...")
	ObjectReference emptyMe = GetReference()
	Clear()
	
	if (CurrentContainer == None)
		; in the world somewhere
; 		Debug.Trace("MS12: White Phial sitting somewhere in the world: " + GetReference().GetParentCell())

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
; 		Debug.Trace("MS12: White Phial in a container: " + CurrentContainer)
		ObjectReference newMe = CurrentContainer.PlaceAtMe(fillItem)
		ForceRefTo(newMe)
		CurrentContainer.AddItem(newMe, 1, true)
;		CurrentContainer.RemoveItem(emptyMe, 1, true)

		; remove all empty phials, it may have been duplicated
		CurrentContainer.RemoveItem(EmptyPhial, CurrentContainer.GetItemCount(EmptyPhial), true)
	endif
EndFunction

Event OnEquipped(Actor akActor)
; 	Debug.Trace("MS12: Player drinking white phial.")
	ObjectReference me = GetReference()
	
	; check if phial is empty
	if (me.GetBaseObject() == EmptyPhial)
		(GetOwningQuest() as MS12PostQuestScript).Realign()
	else
		; if the phial has a custom alignment
		if (me.GetBaseObject() == CustomPhial)
			akActor.AddItem(Alignment, 1, true)
			akActor.EquipItem(Alignment, false, true)
		endif
		
		; add the empty phial and set the refill timer
		ObjectReference empty = akActor.PlaceAtMe(EmptyPhial, 1)
		ForceRefTo(empty)
		akActor.AddItem(empty, 1, true)
		GetOwningQuest().RegisterForSingleUpdateGameTime(RefillTime)
	endif
EndEvent
