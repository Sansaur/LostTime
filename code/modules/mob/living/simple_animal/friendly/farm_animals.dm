//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("brays")
	emote_hear = list("brays")
	emote_see = list("shakes its head", "stamps a foot", "glares around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 4)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	faction = list("neutral")
	attack_same = 1
	attacktext = "kicks"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 40
	maxHealth = 40
	melee_damage_lower = 1
	melee_damage_upper = 2
	stop_automated_movement_when_pulled = 1
	var/milk_content = 0
	can_collar = 1

/mob/living/simple_animal/hostile/retaliate/goat/handle_automated_movement()
	..()
	if(!pulledby)
		for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
			var/step = get_step(src, direction)
			if(step)
				if(locate(/obj/effect/plant) in step)
					Move(step, get_dir(src, step))

/mob/living/simple_animal/hostile/retaliate/goat/handle_automated_action()
	//chance to go crazy and start wacking stuff
	if(!enemies.len && prob(1))
		Retaliate()

	if(enemies.len && prob(10))
		enemies = list()
		LoseTarget()
		src.visible_message("\blue [src] calms down.")

	if(locate(/obj/effect/plant) in loc)
		var/obj/effect/plant/SV = locate(/obj/effect/plant) in loc
		qdel(SV)
		if(prob(10))
			say("Nom")

/mob/living/simple_animal/hostile/retaliate/goat/Life()
	. = ..()
	if(stat == CONSCIOUS && prob(5))
		milk_content = min(50, milk_content+rand(5, 10))


/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	src.visible_message("\red [src] gets an evil-looking gleam in their eye.")

/mob/living/simple_animal/hostile/retaliate/goat/Move()
	..()
	if(!stat)
		if(locate(/obj/effect/plant) in loc)
			var/obj/effect/plant/SV = locate(/obj/effect/plant) in loc
			qdel(SV)
			if(prob(10))
				say("Nom")

/mob/living/simple_animal/hostile/retaliate/goat/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
	if(stat == CONSCIOUS && istype(O, /obj/item/weapon/reagent_containers/glass))
		user.changeNext_move(CLICK_CD_MELEE)
		var/obj/item/weapon/reagent_containers/glass/G = O
		var/transfered = min(milk_content, rand(5,10), (G.volume - G.reagents.total_volume))
		if(transfered > 0)
			user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
			G.reagents.add_reagent("milk", transfered)
			milk_content -= transfered
		else if(G.reagents.total_volume >= G.volume)
			to_chat(user, "\red \The [O] is full.")
		else
			to_chat(user, "\red The udder is dry. Wait a bit longer...")
	else
		..()




/mob/living/simple_animal/turkey
	name = "turkey"
	desc = "Benjamin Franklin would be proud."
	icon_state = "turkey"
	icon_living = "turkey"
	icon_dead = "turkey_dead"
	icon_resting = "turkey_rest"
	speak = list("gobble?","gobble","GOBBLE")
	speak_emote = list("gobble")
	emote_see = list("struts around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 4)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "pecks"
	health = 50
	maxHealth = 50
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY

/mob/living/simple_animal/goose
	name = "goose"
	desc = "A pretty goose. Would make a nice comforter."
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"
	speak = list("quack?","quack","QUACK")
	speak_emote = list("quacks")
//	emote_hear = list("brays")
	emote_see = list("flaps it's wings")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 6)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 50
	maxHealth = 50
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY

/mob/living/simple_animal/seal
	name = "seal"
	desc = "A beautiful white seal."
	icon_state = "seal"
	icon_living = "seal"
	icon_dead = "seal_dead"
	speak = list("Urk?","urk","URK")
	speak_emote = list("urks")
//	emote_hear = list("brays")
	emote_see = list("flops around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 6)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 50
	maxHealth = 50
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY

/mob/living/simple_animal/walrus
	name = "walrus"
	desc = "A big brown walrus."
	icon_state = "walrus"
	icon_living = "walrus"
	icon_dead = "walrus_dead"
	speak = list("Urk?","urk","URK")
	speak_emote = list("urks")
//	emote_hear = list("brays")
	emote_see = list("flops around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 6)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 50
	maxHealth = 50
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY
