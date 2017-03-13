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
	if(prob(25))
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
	var/chance_to_success = 70	//Sometimes not even the best support can stop rocks fallin' on top of you

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

/*
*	Friendly kobolds
*	They might give you an item
*
*/

/mob/living/simple_animal/friendly_kobold
	name = "cave kobold"
	desc = "Yap yap!"
	icon = 'icons/mob/npc.dmi'
	health = 25
	maxHealth = 25
	universal_understand = 1
	status_flags = CANPUSH
	icon_state = "cave_kobold0"
	icon_living = "cave_kobold0"
	icon_dead = "cave_kobold_dead"
	icon_resting = "cave_kobold_dead"
	can_rest = 0
	speak = list("IEEEE","Yap yap", "Yaaap!", "Eieierakaka","Wa?")
	speak_chance = 1
	emote_hear = list()	//Hearable emotes
	emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps

	stop_automated_movement = 0 	//Use this to temporarely stop random movement or to if you write special movement code for animals.
	wander = 1 						//Use this to temporarely stop random movement or to if you write special movement code for animals.

	//Interaction
	response_help   = "pokes"
	response_disarm = "shoves"
	response_harm   = "attacks"
	harm_intent_damage = 3

	speed = 9 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster

	deathmessage = "screams painfully as he gets maimed."

	// Will give an item?
	var/will_give_item
	var/list/availible_items = list(
								/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza,
								/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita
								)

/mob/living/simple_animal/friendly_kobold/New()
	..()
	var/i = pick(0,1)
	icon_state = "cave_kobold[i]"
	i = pick(0,1)
	will_give_item = i


/mob/living/simple_animal/friendly_kobold/attack_hand(mob/living/carbon/human/M as mob)

	switch(M.a_intent)

		if(I_HELP)
			if(will_give_item && stat != DEAD)
				var/i = pick(1, availible_items.len)
				var/obj/item/W = availible_items[i]
				new W (M.loc)
				will_give_item = 0
		if(I_GRAB)
			return

		if(I_HARM, I_DISARM)
			M.do_attack_animation(src)
			visible_message("<span class='danger'>[M] [response_harm] [src]!</span>")
			playsound(loc, "punch", 25, 1, -1)
			attack_threshold_check(harm_intent_damage)
			//..()

	return