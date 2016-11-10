/obj/structure/floor_tp
	name = "Floor teleporter"
	desc = "Because the future makes you lazy"
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "floor_tp"
	var/set_dest
	opacity = 0
	anchored = 1
	density = 0
	var/obj/effect/step_trigger/teleport_fancy/omegacorp_floor/my_tp
	//We use tags on map edition to differentiate our floor_tps

/obj/structure/floor_tp/New()
	my_tp = new(src.loc)


/obj/structure/floor_tp_controller
	name = "Floor teleporter controller"
	desc = "This controls where you will end up"
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "tp_controller_0"
	anchored = 1
	density = 1
	opacity = 0
	var/obj/structure/floor_tp/my_floor_tp
	var/selected_destination = 0
	// 0 = None, 1 = Bedroom, 2 = Medical, 3 = Museum, 4 = Tools, 5 = RD, 6 = Command

	New()
		..()
		detect_floor_tp()

/obj/structure/floor_tp_controller/attack_hand(mob/user as mob)
	if(!my_floor_tp)
		to_chat(user, "<span class=info> The [src] is now set up </span>")
		detect_floor_tp()
	else
		if(selected_destination != 6)
			selected_destination++
		else
			selected_destination = 0

		update_tp_target()
		update_icon()

/obj/structure/floor_tp_controller/update_icon()
	icon_state = "tp_controller_[selected_destination]"
	..()

/obj/structure/floor_tp_controller/proc/update_tp_target()
	var/THETAG
	switch(selected_destination)
		if(0)
			THETAG = null
		if(1)
			THETAG = "Bedroom"
		if(2)
			THETAG = "Medical"
		if(3)
			THETAG = "Museum"
		if(4)
			THETAG = "Tools"
		if(5)
			THETAG = "RD"
		if(6)
			THETAG = "Command"

	my_floor_tp.my_tp.searching_tag = THETAG

/obj/structure/floor_tp_controller/proc/detect_floor_tp()
	for(var/card in cardinal)
		var/turf/T
		T = get_step(src, card)
		for(var/obj/structure/W in T)
			if(istype(W, /obj/structure/floor_tp))
				if(!my_floor_tp)
					my_floor_tp = W

/obj/effect/step_trigger/teleport_fancy/omegacorp_floor
	invisibility = 101
	var/searching_tag

/obj/effect/step_trigger/teleport_fancy/omegacorp_floor/New()

/obj/effect/step_trigger/teleport_fancy/omegacorp_floor/Trigger(mob/M as mob)
	var/obj/structure/floor_tp/TP_TOFIND
	if(!searching_tag)
		return 0
	//if(!Anti_Permaloop)
		//return 0
	for(TP_TOFIND in world)
		if(TP_TOFIND.tag == searching_tag)
			var/locx = TP_TOFIND.x
			var/locy = TP_TOFIND.y
			var/locz = TP_TOFIND.z
			var/dest = locate(locx, locy, locz)
			sleep(3)
			playsound(loc, 'sound/machines/oldschool_teleport.ogg', 70, 1)
			playsound(dest, 'sound/machines/oldschool_teleport.ogg', 70, 1)
			//M.forceMove(dest) This causes TIME PARADOXES
			M.loc = dest //Let's test this!!

		else
			continue
	return 1
/*
/obj/effect/step_trigger/teleport_fancy/omegacorp_floor/proc/Anti_Permaloop()
	var/obj/effect/step_trigger/teleport_fancy/omegacorp_floor/TP_TOFIND
	if(!searching_tag)
		return 0
	var/list/used_tags = list()
	for(TP_TOFIND in world)
		if(!TP_TOFIND.searching_tag in used_tags)
			used_tags.Add(searching_tag)
		else
			continue

	if(used_tags.len >= 6)
		return 0
	else
		return 1*/