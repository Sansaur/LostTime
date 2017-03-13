/obj/effect/step_trigger/teleport_fancy/medieval_map_edge/NOTYETDONE
	invisibility = 101
	icon = 'icons/obj/medieval/map_control.dmi'
	icon_state = "bugtesting_landmark"


/obj/effect/step_trigger/teleport_fancy/medieval_map_edge/Trigger(mob/M as mob)
/*
	//MANUAL FOR NOW, IT CAN BE IMPROVED IN THE FUTURE

	var/locx = 104
	var/locy = 105
	var/locz = 5
	var/dest = locate(locx, locy, locz)
	M.loc = dest //Let's test this!!
	return 1*/

	if(istype(M, /mob/living/simple_animal/caravan))
		var/mob/living/simple_animal/caravan/MC = M
		MC.RandomizeItems()
		MC.finishTrip()
		return
