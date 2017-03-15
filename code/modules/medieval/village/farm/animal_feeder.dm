/obj/structure/animal_feeder
	name = "\improper feeder"
	desc = "You feed the animals here."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "animal_feeder"
	density = 0
	opacity = 0
	anchored = 1
	var/food_availible = 0
	var/toxic_food = 0
	var/list/obj/item/weapon/reagent_containers/food/snacks/toxic_food_list = list()
	//If you put something from this list inside the feeder, it increases it's toxicity.

/obj/structure/animal_feeder/attackby(obj/item/W, mob/user as mob)
	// We add the nutriments of food to the animal_feeder
	// If the snack itself has toxins, then they get added as toxicity too
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/MYSNACK = W
		var/datum/reagents/this_reagents = MYSNACK.reagents
		if(this_reagents)
			to_chat(user, "You add [MYSNACK] to the food pile mix of [src]")
			for(var/datum/reagent/REAGENT in this_reagents.reagent_list)
				if(istype(REAGENT, /datum/reagent/nutriment))
					if(MYSNACK in toxic_food_list)
						adjustToxicity(REAGENT.volume)
						qdel(MYSNACK)
					else
						adjustFood(REAGENT.volume)
						qdel(MYSNACK)
				else
					adjustToxicity(REAGENT.volume)
					qdel(MYSNACK)

/obj/structure/animal_feeder/proc/adjustFood(var/amount)
	food_availible += amount
	update_icon()
	return

/obj/structure/animal_feeder/proc/adjustToxicity(var/amount)
	toxic_food += amount
	update_icon()
	return

/obj/structure/animal_feeder/proc/enoughFood()
	if(food_availible > 10)
		return 1
	else
		return 0

/obj/structure/animal_feeder/update_icon()
	if(food_availible <= 0)
		icon_state = "animal_feeder"
	else if (food_availible > 0 && food_availible <= 100)
		icon_state = "animal_feeder_half"
	else if (food_availible > 100)
		icon_state = "animal_feeder_full"

	..()