//cow
/mob/living/simple_animal/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 6)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 50
	maxHealth = 50
	var/milk_content = 0
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY
	var/preggers = 0
	var/pregger_advance = 0

/mob/living/simple_animal/cow/New()
	..()

/mob/living/simple_animal/cow/attackby(var/obj/item/O as obj, var/mob/user as mob, params, params)
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

/mob/living/simple_animal/cow/Life()
	. = ..()
	if(stat == CONSCIOUS && prob(5))
		milk_content = min(50, milk_content+rand(5, 10))

	if(preggers && prob(20))
		pregger_advance += rand(3,6)
		if(pregger_advance >= 100)
			new /mob/living/simple_animal/calf (src.loc)
			pregger_advance = 0
			preggers = 0

/mob/living/simple_animal/cow/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == I_DISARM && icon_state != icon_dead)
		M.visible_message("<span class='warning'>[M] tips over [src].</span>","<span class='notice'>You tip over [src].</span>")
		Weaken(30)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list(	"[src] looks at you imploringly.",
											"[src] looks at you pleadingly",
											"[src] looks at you with a resigned expression.",
											"[src] seems resigned to its fate.")
				to_chat(M, pick(responses))
	else
		..()

// BULL

/mob/living/simple_animal/bull
	name = "bull"
	desc = "MOOOOOOOOOOO!!."
	// REMEMBER TO CHANGE THIS
	icon_state = "bull"
	icon_living = "bull"
	icon_dead = "bull"
	icon_gib = "bull"
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 6)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 50
	maxHealth = 50
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY
	var/CHARGING = 0
	//Which clothing makes the bull angry?
	var/list/obj/item/clothing/TauntingClothingList = list(
		/obj/item/clothing/head/beret/centcom/officer
	)

/mob/living/simple_animal/bull/adjustHealth(damage)
	..(damage)
	visible_message("<b>[src]</b> moos angrily, \"MOOOOO!!!\" ")
	for(var/direction in cardinal)
		for(var/mob/living/USER in get_step(src,direction))
			sleep(5)	//Gives time to dodge
			if(Adjacent(USER))
				if(istype(USER, /mob/living/carbon/human))
					var/mob/living/carbon/human/N = USER
					visible_message("[src] retaliates!")
					N.adjustBruteLoss(rand(10,15))
				else
					visible_message("[src] retaliates!")
					USER.adjustBruteLoss(rand(10,15))


/mob/living/simple_animal/bull/Life()
	..()
	if(prob(2))
		for(var/mob/living/simple_animal/cow/COW in loc.loc)
			//This will check for all the pigs in the area
			if(get_dist(src, COW.loc) >= 6)
				//If it's too far away, doesn't do anything
				continue
			if(COW.preggers)
				//Ignore pregnant cows
				continue
			var/max_steps = 8
			var/steps_taken = 0
			while(!Adjacent(COW))
				if(steps_taken >= max_steps)
					break
				step_towards(src, COW.loc)
				steps_taken++
				sleep(5)

			visible_message("The [src] breeds [COW]")
			COW.preggers = 1
			return

	// Bull attacking people who wear certain items.
	if(CHARGING)
		return

	for(var/mob/living/carbon/human/TARGET in loc.loc)
		if(get_dist(src, TARGET) >= 6)
			continue

		for(var/obj/item/clothing/TARGETCLOTHING in TARGET.contents)
			if(TARGETCLOTHING.type in TauntingClothingList)
				visible_message("<div class=warning> The [src] huffs at [TARGET] </div>")
				if(prob(85))	//Most of the time the bull won't charge
					return
				var/max_steps = 8
				var/steps_taken = 0
				CHARGING = 1
				visible_message("<div class=userdanger> The [src] charges towards [TARGET]!! </div>")
				while(!Adjacent(TARGET))
					if(steps_taken >= max_steps)
						break
					step_towards(src, TARGET.loc)
					steps_taken++
					sleep(3)

				if(Adjacent(TARGET))
					TARGET.adjustBruteLoss(20)
					TARGET.Weaken(2)
					CHARGING = 0
				else
					visible_message("The [src] stops charging")
					CHARGING = 0
					return
// CALF

/mob/living/simple_animal/calf
	name = "\improper calf"
	desc = "Adorable! ."
	icon_state = "deer"
	icon_living = "deer"
	icon_dead = "deer"
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

/mob/living/simple_animal/calf/New()
	..()
	if(prob(50))
		gender = "male"
	else
		gender = "female"

	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)


/mob/living/simple_animal/calf/Life()
	. =..()
	if(.)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			if(gender == "male")
				var/mob/living/simple_animal/cow/C = new /mob/living/simple_animal/cow(loc)
				if(mind)
					mind.transfer_to(C)
				qdel(src)
			else
				var/mob/living/simple_animal/bull/C = new /mob/living/simple_animal/bull(loc)
				if(mind)
					mind.transfer_to(C)
				qdel(src)