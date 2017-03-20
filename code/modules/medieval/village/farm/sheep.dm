/mob/living/simple_animal/sheep
	name = "\improper sheep"
	desc = "BA A A A A A A."
	icon_state = "sheep"
	icon_living = "sheep"
	icon_dead = "sheep_dead"
	icon_gib = "chick_gib"
	speak = list("BABAAAA.","BAAA?","BAAAAAAAAA.","BAAA!")
	speak_emote = list("baas")
	emote_hear = list("brays")
	emote_see = list("eats some food","chews")
	density = 1
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 1)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 66
	maxHealth = 66
	can_hide = 1
	can_collar = 1
	var/icon_shaved = "sheep_shaved"
	var/wool = 1

/mob/living/simple_animal/sheep/New()
	..()

/mob/living/simple_animal/sheep/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/scissors))
		var/mob/living/carbon/human/A = user
		if(A.a_intent == I_HELP && !stat)
			A.visible_message("[A] starts cutting [src]'s wool", "you start shearing [src]")
			if(do_after(A, 25, target = src))
				playsound(src, 'sound/goonstation/misc/Scissor.ogg',100,0)
				Shear()
		else	
			..()
	else
		..()

/mob/living/simple_animal/sheep/proc/Shear()
	while(wool)
		new /obj/item/wool (src.loc)
		wool--

	icon_state = icon_shaved





/mob/living/simple_animal/sheep/Life()
	. =..()
	if(.)
		if(istype(loc, /turf/simulated/floor/grass))	//Eats some grass
			if(prob(15))	//This might be made better in the future
				if(prob(1))
					GrowWool()

/mob/living/simple_animal/sheep/proc/GrowWool()
	icon_state = icon_living
	visible_message("[src] grows some wool")
	wool++