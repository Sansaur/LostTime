/mob/living/simple_animal/horse
	name = "horse"
	desc = "Neigh."
	icon_state = "samak"
	icon_living = "samak"
	icon_dead = "samak"
	speak = list("oink?","oink","OINK")
	speak_emote = list("oinks")
//	emote_hear = list("brays")
	emote_see = list("rolls around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/ham = 6)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 50
	maxHealth = 50
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY

	speed = -2

	var/fullness = 0
	var/ridden = 0	//Is the horse being ridden right now?
	var/mob/living/carbon/human/JOCKEY

/mob/living/simple_animal/horse/attack_hand(mob/living/carbon/human/M as mob)

	switch(M.a_intent)

		if(I_HELP)
			if(M == JOCKEY)
				stopRide(M)
				return
			if(ridden)
				return
			else
				Ride(M)

		if(I_GRAB)
			//Cannot grab a horse
			return

		if(I_HARM, I_DISARM)
			//M.do_attack_animation(src)
			//visible_message("<span class='danger'>[M] [response_harm] [src]!</span>")
			//playsound(loc, "punch", 25, 1, -1)
			//attack_threshold_check(harm_intent_damage)
			..()

	return



/mob/living/simple_animal/horse/proc/Ride(mob/living/carbon/human/M as mob)
	// We insert the person inside the horse, we put an overlay of the person on top of the horse
	JOCKEY = M
	M.pixel_y += 16
	src.underlays.Add(M)
	M.loc = src
	src.mind = M.mind
	src.ckey = M.ckey
	M.pixel_y -= 16
	stop_automated_movement = 1
	ridden = 1
	return

/mob/living/simple_animal/horse/verb/stopRide()
	set name = "Stop riding"
	set desc = "AHOY."
	set category = "Animal"
	set src = view(0)	//HARDCORE TESTING!!!! -SANSAUR

	StopRide()
	return

/mob/living/simple_animal/horse/proc/StopRide()
	// We insert the person inside the horse, we put an overlay of the person on top of the horse

	src.underlays.Cut()	//This is a bad idea, to use Cut, but we're testing
	JOCKEY.loc = src.loc
	JOCKEY.mind = src.mind
	JOCKEY.ckey = src.ckey
	stop_automated_movement = 0
	ridden = 0
	JOCKEY = null
	return

/mob/living/simple_animal/horse/proc/FallRide()
	// We insert the person inside the horse, we put an overlay of the person on top of the horse

	src.underlays.Cut()	//This is a bad idea, to use Cut, but we're testing
	JOCKEY.loc = src.loc
	JOCKEY.mind = src.mind
	JOCKEY.ckey = src.ckey
	stop_automated_movement = 0
	ridden = 0
	JOCKEY.Weaken(2)
	JOCKEY = null
	return

/mob/living/simple_animal/horse/adjustHealth(damage)
	..(damage)
	FallRide()
	return

//If the human who mounted the horse had a weapon, he'll override the horse's attack
/mob/living/simple_animal/horse/attack_animal(mob/living/simple_animal/M as mob)



	if(M.melee_damage_upper == 0)
		M.custom_emote(1, "[M.friendly] [src]")
	else
		M.do_attack_animation(src)
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 50, 1, 1)
		visible_message("<span class='danger'>\The [M] [M.attacktext] [src]!</span>", \
				"<span class='userdanger'>\The [M] [M.attacktext] [src]!</span>")
		add_logs(M, src, "attacked", admin=0)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		attack_threshold_check(damage,M.melee_damage_type)

// Here we'll make it so whoever's riding the horse can click while inside the horse
/mob/living/simple_animal/horse/ClickOn(A,params)
	if(JOCKEY)
		JOCKEY.ClickOn(A,params)
	else
		..()