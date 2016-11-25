/obj/structure/fence
	name = "fence"
	desc = "A fence."
	icon = 'icons/obj/smooth_structures/fence.dmi'
	icon_state = "fence-TOTAL"
	density = 1
	layer = 3.2//Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER
	var/health = 14.0
	var/ini_dir = null // Number of sheets needed to build this window (determines how much shit is spawned by destroy())
//	var/silicate = 0 // number of units of silicate
//	var/icon/silicateIcon = null // the silicated icon



/obj/structure/fence/New(Loc,re=0)
	..()
	ini_dir = dir
	update_nearby_icons()
	return

/obj/structure/fence/initialize()
	air_update_turf(1)
	return ..()

/obj/structure/fence/Destroy()
	density = 0
	air_update_turf(1)
	if(loc)
		playsound(get_turf(src), 'sound/effects/grillehit.ogg', 70, 1)
	return ..()


/obj/structure/fence/Move()
	return

/obj/structure/fence/CanAtmosPass(turf/T)
	return 1

//This proc is used to update the icons of nearby windows.
/obj/structure/fence/proc/update_nearby_icons()
	if(!loc) return 0
	update_icon()
	for(var/direction in cardinal)
		for(var/obj/structure/fence/W in get_step(src,direction))
			W.update_icon()

/obj/structure/fence/update_icon()
	icon_state = "fence"
	var/adjacencies = calculate_adjacencies(src)
	var/norte = 0
	var/sur = 0
	var/este = 0
	var/oeste = 0


	if(adjacencies & N_NORTH)
		norte = 1
	if(adjacencies & N_SOUTH)
		sur = 1
	if(adjacencies & N_EAST)
		este = 1
	if(adjacencies & N_WEST)
		oeste = 1

	if(norte)
		icon_state = "fence-top"
	if(sur)
		icon_state = "fence-bottom"
	if(este)
		icon_state = "fence-right"
	if(oeste)
		icon_state = "fence-left"

	if(norte && sur)
		icon_state = "fence-TB"
	if(este && oeste)
		icon_state = "fence-LR"

	if(norte && este)
		icon_state = "fence-TR"
	if(norte && oeste)
		icon_state = "fence-TL"
	if(sur && este)
		icon_state = "fence-BR"
	if(sur && oeste)
		icon_state = "fence-BL"

	if(norte && sur && este)
		icon_state = "fence-TRB"
	if(norte && sur && oeste)
		icon_state = "fence-TLB"
	if(norte && este && oeste)
		icon_state = "fence-LRT"
	if(sur && oeste && este)
		icon_state = "fence-LRB"

	if(norte && sur && este && oeste)
		icon_state = "fence-TOTAL"

	return oeste


/obj/structure/fence/wooden
	name = "wooden fence"
	desc = "A fence."
	icon = 'icons/obj/smooth_structures/wooden_fence.dmi'
	icon_state = "fence-TOTAL"
	density = 1
	layer = 3.2//Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER
	health = 11
	ini_dir = null


/*** METAL BARS ***/

/obj/structure/grille/metal_bars
	name = "metal bars"
	desc = "some metal bars"
	icon = 'icons/obj/structures.dmi'
	icon_state = "metal_bars"