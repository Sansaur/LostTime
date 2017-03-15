/mob/living/simple_animal/pig
	name = "pig"
	desc = "Oink oink."
	icon_state = "pig"
	icon_living = "pig"
	icon_dead = "pig_dead"
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
	var/fullness = 0

/mob/living/simple_animal/pig/Life()

	. = ..()

	//PROBS ARE 100 WHILE TESTING - SANSAUR
	if(prob(1) && fullness < 100)
		var/obj/structure/animal_feeder/MyFeeder = locate()
		if(get_dist(src.loc, MyFeeder.loc) <= 5)
			visible_message("[src] walks towards the [MyFeeder]")

			var/max_steps = 8
			var/steps_taken = 0
			while(!Adjacent(MyFeeder))
				if(steps_taken >= max_steps)
					break
				step_towards(src, MyFeeder)
				steps_taken++
				sleep(5)

			if(Adjacent(MyFeeder) && MyFeeder.enoughFood())
				//When its adjacent it eats
				visible_message("[src] eats from the [MyFeeder]")
				fullness += 10
				MyFeeder.adjustFood(-10)
				return
			else
				return

	if(fullness >= 100 && prob(1))
		for(var/mob/living/simple_animal/pig/FellowPig in loc.loc)
			//This will check for all the pigs in the area
			if(get_dist(src, FellowPig.loc) >= 8)
				//If it's too far away, doesn't do anything
				continue
			if(FellowPig == src)
				continue

			for(var/mob/living/carbon/human/Human in loc.loc)
				if(get_dist(src, Human.loc) <= 5)
					visible_message("It looked like [src] was going to breed with [FellowPig] but [src] needs privacy")
					return

			new /mob/living/simple_animal/piglet (src.loc)
			fullness = 0
			return




/mob/living/simple_animal/piglet
	name = "\improper piglet"
	desc = "Adorable! They make such a racket though."
	icon_state = "piglet"
	icon_living = "piglet"
	icon_dead = "pig_dead"
	speak = list("oink?","oink","OINK")
	speak_emote = list("oinks")
	emote_see = list("rolls around")
	density = 0
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 1)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 11
	maxHealth = 11
	ventcrawler = 2
	var/amount_grown = 0
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	can_hide = 1
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY

/mob/living/simple_animal/piglet/New()
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)


/mob/living/simple_animal/piglet/Life()
	. =..()
	if(.)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			var/mob/living/simple_animal/pig/C = new /mob/living/simple_animal/pig(loc)
			if(mind)
				mind.transfer_to(C)
			qdel(src)

