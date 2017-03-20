/obj/structure/reagent_dispensers/grape_bucket
	name = "press bucket"
	desc = "Take off your shoes and get mushin'."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "grape_bucket"
	density = 0
	anchored = 0
	amount_per_transfer_from_this = 10



/obj/structure/reagent_dispensers/grape_bucket/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
	// Fruits and vegetables.
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown) || istype(O, /obj/item/weapon/grown))
		user.drop_item(O)
		var/obj/item/weapon/reagent_containers/food/snacks/grown/GROWNTOADD = O
		if(GROWNTOADD.seed.kitchen_tag == "grapes")
			GROWNTOADD.loc = src
	else
		..()

/obj/structure/reagent_dispensers/grape_bucket/attack_hand(var/mob/user as mob)
	Mush_Grapes(user)


/obj/structure/reagent_dispensers/grape_bucket/proc/Mush_Grapes(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/TADA = user

		if(TADA.loc != src.loc)
			to_chat(TADA, "<div class=warning> You must be on top of the bucket for this to work! </div>")
			return

		var/time_to_trample = 50
		if(TADA.get_item_by_slot(slot_shoes))
			to_chat(TADA, "<div class=notice> You begin trampling on the grapes while wearing shoes, yup, nothing wrong there</div>")
		else
			to_chat(TADA, "<div class=notice> You begin trampling on the grapes</div>")
			time_to_trample -= 20

		if(do_after(TADA, time_to_trample, target=src))
			playsound(src, 'sound/items/bubblewrap.ogg', 70,0)	//Change the sound in the future
			for(var/obj/item/weapon/reagent_containers/food/snacks/grown/GROWNTOADD in src)
				if(GROWNTOADD.seed.kitchen_tag == "grapes")
					reagents.add_reagent("grapejuice",10)
					qdel(GROWNTOADD)
	else
		to_chat(user, "Now what?")
