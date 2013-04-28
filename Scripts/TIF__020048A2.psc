;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__020048A2 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
MS12PostQuest.Start()
(MS12PostQuest as MS12PostQuestScript).SetReward("empty")

(GetOwningQuest() as MS12QuestScript).ShadowQuest.SetStage(100)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property MS12PostQuest  Auto  

MiscObject Property WhitePhial  Auto  
