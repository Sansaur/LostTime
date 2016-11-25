
/obj/structure/saloon_door
	icon = 'icons/obj/doors/saloon.dmi'
	icon_state = "door_closed"
	opacity = 0
	name = "saloon door"
	desc = "Not the most safe of doors I might say"
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	anchored = 1
	density = 1

/obj/structure/saloon_door/New(location)
	..()

/obj/structure/saloon_door/initialize()
	..()
	air_update_turf(1)

/obj/structure/saloon_door/Destroy()
	density = 0
	air_update_turf(1)
	return ..()

/obj/structure/saloon_door/Move()
	var/turf/T = loc
	..()
	move_update_air(T)

/obj/structure/saloon_door/Bumped(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)
	return

/obj/structure/saloon_door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/saloon_door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/saloon_door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/saloon_door/CanAtmosPass()
	return !density

/obj/structure/saloon_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(world.time - user.last_bumped <= 60) return //NOTE do we really need that?
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /obj/mecha))
		SwitchState()

/obj/structure/saloon_door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/saloon_door/proc/Open()
	isSwitchingStates = 1
	playsound(loc, 'sound/effects/doorcreaky.ogg', 100, 1)
	flick("door_opening",src)
	sleep(10)
	density = 0
	opacity = 0
	state = 1
	update_icon()
	isSwitchingStates = 0
	air_update_turf(1)

/obj/structure/saloon_door/proc/Close()
	isSwitchingStates = 1
	playsound(loc, 'sound/effects/doorcreaky.ogg', 100, 1)
	flick("door_closing",src)
	sleep(10)
	density = 1
	opacity = 0
	state = 0
	update_icon()
	isSwitchingStates = 0
	air_update_turf(1)

/obj/structure/saloon_door/update_icon()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/structure/saloon_door/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	return

/obj/structure/saloon_door/proc/Dismantle(devastated = 0)
	qdel(src)
