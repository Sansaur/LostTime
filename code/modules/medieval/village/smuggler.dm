/*
*
*	The smuggler is a kobold that visits the general shop's basement from time to time
*	It'll trade money for goods, mostly food, clothing or weapons.
*	Will give more money to fellow kobolds
*	Will flee if attacked, he'll disappear and reappear 15 minutes later
*	Sex stuff in the future? this is a furry server after all
*	Will give some kobold commentary to his sellers sometimes
*
*/

/mob/living/simple_animal/kobold_smuggler
	name = "kobold smuggler"
	desc = "Now it's time for us to do srs bsns"
	icon = 'icons/mob/npc.dmi'
	health = 9999
	maxHealth = 9999
	universal_understand = 1
	status_flags = CANPUSH
	icon_state = "smuggler"
	icon_living = "smuggler"
	icon_dead = "smuggler"
	icon_resting = "smuggler"
	can_rest = 1
	speak = list("The caves aren't as bad as they seem", "Never trust a troglodyte", "Ouaaaaam, so bored!")
	speak_chance = 5
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

	deathmessage = "The <b> kobold smuggler </b> whimpers, \"N-no.... Why?...\" just before he stops breathing"

	//These get randomized every time the kobold sells something
	var/food_pay = 0
	var/weapon_pay = 0
	var/clothing_pay = 0
	var/magic_pay = 0

	var/max_food_pay = 25
	var/max_weapon_pay = 80
	var/max_clothing_pay = 75
	var/max_magic_pay = 500

	var/annoyance = 0
	var/fleeing_time = 600

/mob/living/simple_animal/kobold_smuggler/New()
	..()
	randomizeMoney()



/mob/living/simple_animal/kobold_smuggler/attack_hand(mob/living/carbon/human/M as mob)

	switch(M.a_intent)

		if(I_HELP)
			var/datum/species/SPECIES = M.species

			if(istype(SPECIES, /datum/species/kobold))
				say(pick(speak))
			else
				annoyance++
				switch(annoyance)
					if(1)
						visible_message("the <b>[src]</b> complains, \"Hey! Don't get too touchy!\"")
					if(2)
						visible_message("the <b>[src]</b> complains, \" Stop it!\"")
					if(3)
						visible_message("the <b>[src]</b> complains, \" Last warning!\"")
					if(4)
						visible_message("the <b>[src]</b> complains, \" Take this!\"")
						annoyance = 0
						punish(M)
					else
						visible_message("the <b>[src]</b> complains, \" HMPF!\"")
						annoyance = 0

		if(I_HARM, I_DISARM, I_GRAB)
			M.do_attack_animation(src)
			visible_message("<span class='danger'>[M] [response_harm] [src]!</span>")
			playsound(loc, "punch", 25, 1, -1)
			attack_threshold_check(harm_intent_damage)
			..()
			flee()

	return

/mob/living/simple_animal/kobold_smuggler/attackby(obj/item/W, mob/living/carbon/human/user as mob)
	// This will need checks in the future for important items.
	// User will only attempt to sell if he's in HELP mode
	wander = 0
	if(user.a_intent == I_HELP)
		if(istype(W, /obj/item/clothing))
			visible_message("the <b>[src]</b> says, \"I'll buy that [W] for [clothing_pay]\"")
			switch(alert("Will you sell that?", "Selling", "Yes", "No"))
				if("Yes")
					qdel(W)
					var/obj/item/weapon/medieval_cash/NEWCASH = new (user.loc)
					NEWCASH.worth = clothing_pay
					NEWCASH.update_icon()
					flick("smuggler_accept",src)
					randomizeMoney()

		if(istype(W, /obj/item/weapon/reagent_containers/food))
			visible_message("the <b>[src]</b> says, \"I'll buy that [W] for [food_pay]\"")
			switch(alert("Will you sell that?", "Selling", "Yes", "No"))
				if("Yes")
					qdel(W)
					var/obj/item/weapon/medieval_cash/NEWCASH = new (user.loc)
					NEWCASH.worth = food_pay
					NEWCASH.update_icon()
					flick("smuggler_accept",src)
					randomizeMoney()

		if(istype(W, /obj/item/weapon/medieval))
			visible_message("the <b>[src]</b> says, \"I'll buy that [W] for [weapon_pay]\"")
			switch(alert("Will you sell that?", "Selling", "Yes", "No"))
				if("Yes")
					qdel(W)
					var/obj/item/weapon/medieval_cash/NEWCASH = new (user.loc)
					NEWCASH.worth = weapon_pay
					NEWCASH.update_icon()
					flick("smuggler_accept",src)
					randomizeMoney()

		/*if(istype(W, /obj/item/clothing))
			say("I'll buy that [W] for [clothing_pay]")
			switch(alert("Will you sell that?", "Yes", "No"))
				if("Yes")
					qdel(W)
					var/obj/item/weapon/medieval_cash/NEWCASH = new (user.loc)
					NEWCASH.worth = clothing_pay
				else
					say("Well, okay then...")*/

	else
		..()
		flee()

	wander = 1
	annoyance = 0

/mob/living/simple_animal/kobold_smuggler/proc/flee()
	flick("smuggler_flee",src)
	sleep(11)
	playsound(loc,'sound/weapons/effects/searwall.ogg',100,1)
	for(var/mob/living/carbon/human/M in view(src))
		M.flash_eyes(affect_silicon = 0)

	src.invisibility = 101
	var/gox = initial(x)
	var/goy = initial(y)
	var/goz = initial(z)
	var/turf/simulated/floor/F = locate(gox,goy,goz)
	src.Move(F)
	src.resting = 1
	src.speak_chance = 0
	sleep(fleeing_time)
	src.resting = 0
	src.invisibility = 0
	src.speak_chance = 6

/mob/living/simple_animal/kobold_smuggler/proc/punish(mob/living/carbon/human/M as mob)
	flick("smuggler_punish",src)
	sleep(4)
	playsound(loc,'sound/weapons/effects/searwall.ogg',100,1)
	M.flash_eyes(affect_silicon = 0)

	var/obj/item/weapon/restraints/handcuffs/cable/zipties/Z = new (src.loc)
	playsound(loc,'sound/weapons/cablecuff.ogg',100,1)
	Z.apply_cuffs(M,src)
	M.Weaken(3)

/mob/living/simple_animal/kobold_smuggler/proc/randomizeMoney()
	food_pay = rand(1, max_food_pay)
	weapon_pay = rand(15, max_weapon_pay)
	clothing_pay = rand(15, max_clothing_pay)
	magic_pay = rand(100, max_magic_pay)