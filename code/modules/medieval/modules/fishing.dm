/****

* La idea es hacer que las cañas tengan "Pescados que pueden pescar", al atacar un agua, se mirará en que zona
está el agua (Si es en el castillo, no se pesca nada), si el agua esta en un lugar correcto, se vuelve a una
funcion de la caña en la que la caña elige un pescado de los disponibles.

* También hay que hacer que en las zonas de buena pesca no es que siempre salgan pescados raros, sino que
exista la posibilidad de que salgan.

* Aparte tiene que haber peligros en la pesca, o si no, nos la pasaremos con el hatefarming

****/
var/list/Generic_Fish = list(
						/obj/item/weapon/reagent_containers/food/snacks/fish/salmon,
						/obj/item/weapon/reagent_containers/food/snacks/fish/goldfish
						)



/obj/item/weapon/fishing_rod
	name = "fishing rod"
	desc = "A rod to fish"
	icon = 'icons/medieval/fishing.dmi'
	icon_state = "wood_rod"
	item_state = "fishing_rod"
	force = 9
	w_class = 4
	throwforce = 8
	throw_range = 4
	var/list/obj/item/weapon/reagent_containers/food/snacks/fish/ALLOWED_FISH = list()
	var/is_fishing = 0
	var/obj/item/weapon/reagent_containers/food/snacks/BAIT
	var/time_to_fish = 80
	var/ori_time_to_fish = 80
	var/hook_flight = 0

/obj/item/weapon/fishing_rod/update_icon()
	if(BAIT)
		icon_state = "wood_rod_bait"
	else
		icon_state = "wood_rod"
	if(hook_flight)
		icon_state = "wood_rod_hook"

/obj/item/weapon/fishing_rod/New()
	..()
	ALLOWED_FISH += Generic_Fish

/obj/item/weapon/fishing_rod/attack_self(mob/user as mob)
	if(hook_flight)
		return
	//var/mob/living/fishing_reel/FISH_REEL = new(get_step(user, user.dir))
	var/mob/living/fishing_reel/FISH_REEL = new(user.loc)
	FISH_REEL.SEND_TARGET_HERE = user
	hook_flight = 1
	update_icon()
	if(BAIT)
		to_chat(user, "<span class=warning> the bait was lost!</span>")
		BAIT = null
		qdel(BAIT)

	FISH_REEL.Fly()
	sleep(40)
	hook_flight = 0
	update_icon()
	return

/obj/item/weapon/fishing_rod/attack_hand(mob/user as mob)
	if(BAIT)
		if(isturf(src.loc))
			BAIT.loc = src.loc
			user.put_in_hands(BAIT)
			BAIT = null
			update_icon()
			return
		else
			BAIT.loc = user.loc
			user.put_in_hands(BAIT)
			BAIT = null
			update_icon()
			return
	else
		..()

/obj/item/weapon/fishing_rod/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/TO_BAIT = W
		user.unEquip(TO_BAIT)
		BAIT = TO_BAIT
		TO_BAIT.loc = src
		update_icon()
		return

/obj/item/weapon/fishing_rod/proc/attempt_fish(mob/user as mob, var/turf/SUELO)
	//This is the method that attempts to fish
	if(!user)
		return
	if(!user.loc)
		return
	if(istype(user.loc, /turf/simulated/floor/beach/water))
		to_chat(user, "You cannot fish while swimming")
		return
	if(is_fishing)
		return
	if(BAIT)
		if(time_to_fish == ori_time_to_fish)
			time_to_fish = time_to_fish / 2
	else
		time_to_fish = ori_time_to_fish

	visible_message("[user] begins fishing...")
	is_fishing = 1
	if(do_after(user, time_to_fish, target=SUELO))
		if(prob(50))
			visible_message("The fish escaped!")
			if(BAIT)
				if(prob(50))
					to_chat(user, "<span class=warning> the bait was lost!</span>")
					BAIT = null
					qdel(BAIT)
					update_icon()
			is_fishing = 0
			return
		else
			var/FISH = pick(ALLOWED_FISH)
			new FISH(user.loc)
			visible_message("[user] managed to catch a fish!")
			if(BAIT)
				to_chat(user, "<span class=warning> the bait was consumed in the process</span>")
			BAIT = null
			qdel(BAIT)
			update_icon()
			is_fishing = 0
			return


//IF YOU ACTIVATE THE FISHING ROD IN YOUR HAND IT SENDS A REEL THAT SNATCHES PEOPLE

/mob/living/fishing_reel
	see_invisible = SEE_INVISIBLE_LIVING
	maxHealth = 1
	health = 1
	name = "fishing hook"
	desc = "hook"
	icon = 'icons/medieval/fishing.dmi'
	icon_state = "hook"
	var/mob/living/carbon/human/SEND_TARGET_HERE
	var/stored_dir

/mob/living/fishing_reel/proc/Fly()
	stored_dir = SEND_TARGET_HERE.dir
	var/number_of_steps = 4
	while(number_of_steps)
		src.Move(get_step(src,stored_dir))
		number_of_steps--
		sleep(1)
	qdel(src)
	return 1


/mob/living/fishing_reel/Bump(atom/movable/AM as mob|obj, yes)
	spawn( 0 )
		if(istype(AM, /mob/living/carbon/human))
			var/result = pick(1,2) // 1 = Snatches person, 2 = Disarms item from person's hand
			switch(result)
				if(1)
					AM.forceMove(get_step(SEND_TARGET_HERE, SEND_TARGET_HERE.dir))
					visible_message("<span class=danger>[AM] gets snatched!</span>")
					var/mob/living/carbon/human/Stunned_Human = AM
					Stunned_Human.Weaken(1)
					qdel(src)
					return
				if(2)
					var/mob/living/carbon/human/Stunned_Human = AM
					Stunned_Human.drop_item()
					qdel(src)
					return
		else
			qdel(src)



// A PARTIR DE AQUI VAN LOS PECES

/obj/item/weapon/reagent_containers/food/snacks/fish
	name = "a fish!"
	desc = "YOU SHOULDN'T BE SEEING THIS FISH, TELL A CODER, QUICK!!!"
	icon = 'icons/medieval/fishing.dmi'
	icon_state = "fish_base"
	filling_color = "#FFDEFE"
	bitesize = 6
	list_reagents = list("protein" = 3, "nutriment" = 3)

/obj/item/weapon/reagent_containers/food/snacks/fish/salmon
	name = "salmon"
	desc = "It's red and pink"
	icon_state = "salmon"
	w_class = 4

/obj/item/weapon/reagent_containers/food/snacks/fish/goldfish
	name = "goldfish"
	desc = "It's so tiny"
	icon_state = "goldfish"
	w_class = 1