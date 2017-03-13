/*
*
*	Animals cannot go through this door
*/


/obj/structure/saloon_door
	icon = 'icons/obj/doors/saloon.dmi'
	icon_state = "door_closed"
	opacity = 0
	name = "saloon door"
	desc = "Not the most safe of doors I might say"
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/locked = 0
	var/original_dir = ""
	var/animating = 0
	anchored = 1
	density = 0

/obj/structure/saloon_door/New(location)
	..()
	if(dir == 1 || dir == 2)
		original_dir = "top_bottom"
	else
		original_dir = "left_right"


/obj/structure/saloon_door/prelocked/New()
	..()
	sleep(1)
	SwitchLocked()

/obj/structure/saloon_door/initialize()
	..()
	air_update_turf(1)

/obj/structure/saloon_door/attackby(obj/item/W, mob/user as mob)
	//Here we add chains or something like that, to lock the door

/obj/structure/saloon_door/Destroy()
	density = 0
	air_update_turf(1)
	return ..()

/obj/structure/saloon_door/Move()
	var/turf/T = loc
	..()
	move_update_air(T)

/obj/structure/saloon_door/proc/SwitchLocked()
	locked = !locked
	if(locked)
		src.overlays += /obj/effect/overlay/saloon_door_lock
	else
		src.overlays -= /obj/effect/overlay/saloon_door_lock

/obj/effect/overlay/saloon_door_lock
	icon = 'icons/obj/doors/saloon.dmi'
	icon_state = "locked_overlay"

/obj/structure/saloon_door/Crossed(atom/movable/AM as mob|obj)
	spawn( 0 )
		if(ismob(AM))
			var/mob/living/C = AM
			var/stored_dir = dir
			var/direccion = C.dir
			//If our door faces to the top and bottom, it won't do the opening and closing animation if it gets crossed from a person going
			//From left to right, and viceversa.
			if(original_dir == "top_bottom" && (direccion == 4 || direccion == 8))
				return
			if(original_dir == "left_right" && (direccion == 1 || direccion == 2))
				return
			if(animating)
				return

			src.dir = direccion
			if(locked)
				src.overlays -= /obj/effect/overlay/saloon_door_lock

			flick("door_opening",src)
			sleep(6)
			flick("door_closing",src)
			sleep(6)
			src.dir = stored_dir
			icon_state = "door_closed"
			if(locked)
				src.overlays += /obj/effect/overlay/saloon_door_lock
				if(src.overlays.len > 1)
					src.overlays.Cut()
					src.overlays += /obj/effect/overlay/saloon_door_lock
			return


/obj/structure/saloon_door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover, /mob/living/simple_animal))
		if(locked)
			return 0
	if(air_group) return 0
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/saloon_door/CanAtmosPass()
	return !density
