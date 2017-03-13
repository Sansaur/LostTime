/mob/living/simple_animal/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps")
	emote_see = list("pecks at the ground","flaps its tiny wings")
	density = 0
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 1)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 3
	maxHealth = 3
	ventcrawler = 2
	var/amount_grown = 0
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	can_hide = 1
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY

/mob/living/simple_animal/chick/New()
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/chick/Life()
	. =..()
	if(.)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			if(prob(50))
				var/mob/living/simple_animal/chicken/C = new /mob/living/simple_animal/chicken(loc)
				if(mind)
					mind.transfer_to(C)
				qdel(src)
			else
				var/mob/living/simple_animal/chicken/cock/C = new /mob/living/simple_animal/chicken/cock(loc)
				if(mind)
					mind.transfer_to(C)
				qdel(src)


var/const/MAX_CHICKENS = 50
var/global/chicken_count = 0

/mob/living/simple_animal/chicken
	name = "chicken"
	desc = "Hopefully the eggs are good this season."
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks")
	emote_see = list("pecks at the ground","flaps its wings viciously")
	density = 0
	gender = "female"
	speak_chance = 2
	turns_per_move = 3
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat = 2)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "kicks"
	health = 10
	maxHealth = 10
	var/eggsleft = 1
	var/chicken_color
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	can_hide = 1
	can_collar = 1
	gold_core_spawnable = CHEM_MOB_SPAWN_FRIENDLY

/mob/living/simple_animal/chicken/cock
	name = "cock"
	desc = "Cocky bastard."
	gender = "male"

/mob/living/simple_animal/chicken/New()
	..()
	if(!chicken_color)
		chicken_color = pick( list("brown","black","white") )
	icon_state = "chicken_[chicken_color]"
	icon_living = "chicken_[chicken_color]"
	icon_dead = "chicken_[chicken_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	chicken_count += 1

/mob/living/simple_animal/chicken/death(gibbed)
	..()
	chicken_count -= 1

/mob/living/simple_animal/chicken/attack_hand()
	..()
	if(stop_automated_movement)
		stop_automated_movement = 0

/mob/living/simple_animal/chicken/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown)) //feedin' dem chickens
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = O
		if(G.seed.kitchen_tag == "wheat")
			if(!stat && eggsleft < 8)
				user.visible_message("\blue [user] feeds [O] to [name]! It clucks happily.","\blue You feed [O] to [name]! It clucks happily.")
				user.drop_item()
				qdel(O)
				eggsleft += rand(1, 4)
//				to_chat(world, eggsleft)
			else
				to_chat(user, "\blue [name] doesn't seem hungry!")
		else
			to_chat(user, "\blue [name] doesn't seem interested in [O]!")
	else
		..()

/mob/living/simple_animal/chicken/Life()
	. = ..()
	if(. && prob(5) && eggsleft > 0)	//Prob set to 100 while testing
		if(istype(src.loc, /obj/structure/hen_house))
			var/obj/structure/hen_house/HOUSE = src.loc
			if(prob(3))
				if(HOUSE.allow_hatching)
					HOUSE.HatchEgg()
			if(HOUSE.allow_breeding)
				var/mob/living/simple_animal/chicken/cock/COCKINHOUSE
				for(COCKINHOUSE in HOUSE.contents)
					if(COCKINHOUSE)
						if(src.gender == "female")
							eggsleft--
							//var/obj/item/weapon/reagent_containers/food/snacks/egg/E = new( src.loc )
							HOUSE.eggs++
							return
		if(isturf(src.loc))
			var/obj/item/nest/Findme = locate() in loc.contents
			if(Findme && src.gender == "female")
				eggsleft--
				visible_message("\blue The [src] gets all comfy on the nest and lays and egg.")
				stop_automated_movement = 1
				new /obj/item/weapon/reagent_containers/food/snacks/egg (src.loc)


	/*
	No, no random egg-laying, the hens will lay eggs inside of hen houses while accompained by a cock or while in a nest
	if(. && prob(3) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/weapon/reagent_containers/food/snacks/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(chicken_count < MAX_CHICKENS && prob(10))
			processing_objects.Add(E)*/

/obj/item/weapon/reagent_containers/food/snacks/egg/var/amount_grown = 0
/obj/item/weapon/reagent_containers/food/snacks/egg/process()
	if(isturf(loc))
		var/obj/item/nest/Findme = locate() in loc.contents
		if(Findme)
			amount_grown += rand(1,2)
			if(amount_grown >= 100)
				visible_message("[src] hatches with a quiet cracking sound.")
				new /mob/living/simple_animal/chick(get_turf(src))
				processing_objects.Remove(src)
				qdel(src)
	else
		processing_objects.Remove(src)

/obj/item/nest
	name = "\improper nest"
	desc = "This is a nest, birds do sexy stuff here."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "nest"
	density = 0
	opacity = 0
	anchored = 1
/*

*	 HEN HOUSE

*/

/obj/structure/hen_house
	name = "\improper hen house"
	desc = "Once this is full of hens it WILL get noisy."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "hen_house"
	density = 1
	opacity = 0
	anchored = 1
	var/list/mob/living/simple_animal/chicken/chickenList = list()
	var/eggs = 0
	var/maximum_capacity = 5
	var/allow_breeding = 1
	var/allow_hatching = 1
/obj/structure/hen_house/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		ChickenList(user)
		return

/obj/structure/hen_house/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/MyGrab = W
		var/mob/comparison = MyGrab.affecting
		if(istype(comparison, /mob/living/simple_animal/chicken))
			var/mob/living/simple_animal/chicken/MyChicken = comparison
			if(chickenList.len > maximum_capacity)
				to_chat(user, "<div class=warning> The [src] is full of chickens </div>")
				return
			else
				user.drop_item()
				MyChicken.loc = src
				chickenList.Add(MyChicken)


/obj/structure/hen_house/proc/ChickenList(mob/user as mob)
	user.set_machine(src)
	var/dat

	dat += text(" Hen house <br>")
	for(var/i=1;i<chickenList.len+1;i++)
		var/mob/living/simple_animal/chicken/Chicken = chickenList[i]
		dat += text("<A href='?src=[UID()];choice=[i]'>[Chicken.name].</A><br>")

	dat += text("<A href='?src=[UID()];choice=11'>Eggs: [eggs].</A><br>")
	if(allow_breeding)
		dat += text("Are the chickens allowed to breed? <A href='?src=[UID()];choice=breeding'> Yes.</A><br>")
	else
		dat += text("Are the chickens allowed to breed? <A href='?src=[UID()];choice=breeding'>No.</A><br>")

	if(allow_hatching)
		dat += text("Are the eggs allowed to hatch? <A href='?src=[UID()];choice=hatching'>Yes.</A><br>")
	else
		dat += text("Are the eggs allowed to hatch? <A href='?src=[UID()];choice=hatching'>No.</A><br>")

	var/datum/browser/popup = new(user, "caravan_window", "Caravan", 400, 500)
	popup.set_content(dat)
	popup.open()
	return


/obj/structure/hen_house/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		switch(href_list["choice"])
			if("0")
				ReleaseChicken(0)
			if("1")
				ReleaseChicken(1)
			if("2")
				ReleaseChicken(2)
			if("3")
				ReleaseChicken(3)
			if("4")
				ReleaseChicken(4)
			if("5")
				ReleaseChicken(5)
			if("6")
				ReleaseChicken(6)
			if("7")
				ReleaseChicken(7)
			if("8")
				ReleaseChicken(8)
			if("9")
				ReleaseChicken(9)
			if("11")
				ReleaseEgg()
			if("breeding")
				allow_breeding = !allow_breeding
			if("hatching")
				allow_hatching = !allow_hatching
			else
				message_admins("ERROR ON THE HEN HOUSE!!")
	return

/obj/structure/hen_house/proc/ReleaseChicken(var/ID)
	var/mob/living/simple_animal/chicken/Chicken = chickenList[ID]
	Chicken.loc = src.loc
	chickenList.Remove(Chicken)
	return

/obj/structure/hen_house/proc/ReleaseEgg()
	if(eggs > 0)
		var/obj/item/weapon/reagent_containers/food/snacks/egg/eggy = new (src)
		eggy.loc = src.loc
		eggs--
		return
	else
		return

/obj/structure/hen_house/proc/HatchEgg()
	if(eggs > 0)
		if(chickenList.len > maximum_capacity)
			return
		if(prob(50))
			var/mob/living/simple_animal/chicken/NEW = new (src)
			chickenList.Add(NEW)
		else
			var/mob/living/simple_animal/chicken/cock/NEW = new (src)
			chickenList.Add(NEW)

		eggs--
		return
	else
		return