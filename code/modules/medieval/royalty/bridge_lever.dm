/obj/structure/bridge_lever
	name = "bridge lever"
	desc = "a lever to control the castle bridge"
	icon = 'icons/medieval/structures.dmi'
	icon_state = "bridge_lever_L"
	anchored = 1
	opacity = 0
	density = 1
	var/list/X_LOCS = list()
	var/list/Y_LOCS = list()
	var/list/Y_LOCS_ALREVES = list()
	var/active = 0
	var/Y_LOC_PARED = 145

/obj/structure/bridge_lever/New()
	X_LOCS.Add(126)
	X_LOCS.Add(127)
	X_LOCS.Add(128)
	X_LOCS.Add(129)
	X_LOCS.Add(130)
	X_LOCS.Add(131)

	Y_LOCS.Add(136)
	Y_LOCS.Add(137)
	Y_LOCS.Add(138)
	Y_LOCS.Add(139)
	Y_LOCS.Add(140)
	Y_LOCS.Add(141)
	Y_LOCS.Add(142)
	Y_LOCS.Add(143)
	Y_LOCS.Add(144)

	Y_LOCS_ALREVES.Add(144)
	Y_LOCS_ALREVES.Add(143)
	Y_LOCS_ALREVES.Add(142)
	Y_LOCS_ALREVES.Add(141)
	Y_LOCS_ALREVES.Add(140)
	Y_LOCS_ALREVES.Add(139)
	Y_LOCS_ALREVES.Add(138)
	Y_LOCS_ALREVES.Add(137)
	Y_LOCS_ALREVES.Add(136)

	..()
/obj/structure/bridge_lever/Destroy()
	return

/obj/structure/bridge_lever/attack_hand(mob/user as mob)
	if(!user)
		return
	if(user.stat)
		return

	if(do_after(user, 10, target=src))
		Switch_Bridge()
	/*usr << "Looping through list items:"
		var/p
		for(p in params)
   			usr << "[p] = [params[p]]"*/
/obj/structure/bridge_lever/proc/Switch_Bridge()
	var/X_LUGAR
	var/Y_LUGAR
	playsound(src,'sound/effects/drawbridge.ogg',20,1)
	if(active)
		flick("bridge_lever_RL", src)
		icon_state = "bridge_lever_L"
		update_icon()
		active = 0
		for(X_LUGAR in X_LOCS)
			var/turf/T = locate(X_LUGAR, Y_LOC_PARED, 1)
			T.ChangeTurf(/turf/simulated/floor/stone/big_brick) //turf/simulated/floor/beach/water

		for(Y_LUGAR in Y_LOCS_ALREVES)
			sleep(10)
			for(X_LUGAR in X_LOCS)
				var/turf/T = locate(X_LUGAR, Y_LUGAR, 1)
				T.ChangeTurf(/turf/simulated/floor/wood/plain_wood_tile) //turf/simulated/floor/beach/water


	else
		flick("bridge_lever_LR", src)
		icon_state = "bridge_lever_R"
		update_icon()
		active = 1
		for(Y_LUGAR in Y_LOCS)
			sleep(10)
			for(X_LUGAR in X_LOCS)
				var/turf/T = locate(X_LUGAR, Y_LUGAR, 1)
				T.ChangeTurf(/turf/simulated/floor/beach/water) //turf/simulated/floor/beach/water

		for(X_LUGAR in X_LOCS)
			var/turf/T = locate(X_LUGAR, Y_LOC_PARED, 1)
			T.ChangeTurf(/turf/simulated/wall/mineral/wood) //turf/simulated/floor/beach/water
			var/mob/living/carbon/human/HUMAN
			for(HUMAN in T)
				var/lugar = locate(HUMAN.x, HUMAN.y+1, HUMAN.z)
				HUMAN.forceMove(lugar)
				HUMAN.Stun(2)
				HUMAN.Weaken(2)
				to_chat(HUMAN, "<span class=warning> You got pushed by the closing door! </span>")
