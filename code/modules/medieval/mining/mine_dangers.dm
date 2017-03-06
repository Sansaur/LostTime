/**

* This file holds the code for natural mine dangers
*
* It should also hold the code for mining special events, like treasure
**/


/*
*	Cave-ins
*	If a mineral wall doesn't have a support nearby in an area it might spawn a rock on an adjacent floor tile
*	When that rock spawns it'll damage all mobs hit by it and it'll weaken the humans hit too
*
*/
/turf/simulated/mineral/proc/cavein()
	for(var/obj/A in range(4,src))									//4 Tiles range
		if(istype(A, /obj/structure/mine_support)) 					//If there's a mine support inside that range
			var/obj/structure/mine_support/SUPPORT = A
			if(prob(SUPPORT.chance_to_success))
				return
	if(prob(20))
		for(var/direction in cardinal)
			var/turf/simulated/edge = get_step(src,direction)
			if(edge)
				if(!edge.density)//If the turf doesn't have density (Walls, mostly)
					if(prob(25))
						playsound(edge,'sound/effects/meteorimpact.ogg',100,0)
						var/obj/structure/rock/rockin = new /obj/structure/rock (edge)
						rockin.cavein()

/obj/structure/rock
	name = "rock"
	desc = "Rockin'"
	icon = 'icons/obj/mining.dmi'
	icon_state = "boulder"
	anchored = 1
	density = 1
	opacity = 1
	var/impact_damage = 25
	//We could improve the icon

/obj/structure/rock/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/PICK = W
		PICK.playDigSound()
		if(do_after(user, PICK.digspeed, target=src))
			mine()

/obj/structure/rock/proc/mine()
	playsound(edge,'sound/effects/break_stone.ogg',100,0)
	if(prob(10))
		new /obj/item/weapon/flint (src.loc)
	qdel(src)

/obj/structure/rock/proc/cavein()
	var/mob/living/M = locate(/mob/living) in loc
	if(M)
		M.adjustBruteLoss(impact_damage)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		H.Weaken(3)


/obj/structure/mine_support
	name = "mine support"
	desc = "This is a mine support to prevent cave-ins, won't work all the time!. Avoid Rockin'... "
	icon = 'icons/obj/mining.dmi'
	icon_state = "wooden_support0"
	anchored = 1
	density = 0
	var/chance_to_success = 60	//Sometimes not even the best support can stop rocks fallin' on top of you

/obj/structure/mine_support/New()
	update_icon()
	..()

/obj/structure/mine_support/update_icon()
	// 2 = both sides, 1 = right, 0 = left
	var/side = 0
	var/turf/simulated/edge = get_step(src,4) //Right
	if(edge.density)
		side++
	if(side == 1) //If there's already something on the right, we check left
		edge = get_step(src,8) //Left
		if(edge.density)
			side++

	icon_state = "wooden_support[side]"
	..()