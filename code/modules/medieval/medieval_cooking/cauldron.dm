/obj/structure/medieval_cooking/cauldron
	name = "cauldron"
	desc = "You use this to cook"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "cauldron0"
	recipe_type = /datum/recipe/cauldron
	anchored = 0
	density = 0
	var/ready_to_cook = 0
	var/needs_bonfire = 1

/obj/structure/medieval_cooking/cauldron/attackby(obj/item/O, mob/user, params)
	if(operating)
		return

	/**
	** Here we add some "Is_dirty" or "is_broken" checks for our medieval cooking machine
	**/
	else if(is_type_in_list(O,acceptable_items))
		if(contents.len>=max_n_of_items)
			to_chat(user, "<span class='alert'>This [src] is full of ingredients, you cannot put more.</span>")
			return 1
		if(istype(O,/obj/item/stack) && O:amount>1)
			new O.type (src)
			O:use(1)
			user.visible_message( \
				"<span class='notice'>[user] has added one of [O] to \the [src].</span>", \
				"<span class='notice'>You add one of [O] to \the [src].</span>")
		else
			if(!user.drop_item())
				to_chat(user, "<span class='notice'>\The [O] is stuck to your hand, you cannot put it in \the [src]</span>")
				return 0

			O.forceMove(src)
			user.visible_message( \
				"<span class='notice'>[user] has added \the [O] to \the [src].</span>", \
				"<span class='notice'>You add \the [O] to \the [src].</span>")

	else if(istype(O,/obj/item/weapon/reagent_containers/glass) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/drinks) || \
	        istype(O,/obj/item/weapon/reagent_containers/food/condiment) \
		)
		if(!O.reagents)
			return 1
		for(var/datum/reagent/R in O.reagents.reagent_list)
			if(!(R.id in acceptable_reagents))
				to_chat(user, "<span class='alert'>Your [O] contains components unsuitable for cookery.</span>")
				return 1
		//G.reagents.trans_to(src,G.amount_per_transfer_from_this)
	else if(istype(O,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		to_chat(user, "<span class='alert'>This is ridiculous. You can not fit \the [G.affecting] in this [src].</span>")
		return 1

	else if(istype(O, /obj/item/weapon/kitchen/cooking_spoon))
		if(ready_to_cook)
			if(contents.len <= 0)
				to_chat(user, "<span class='warning'>There's nothing to cook inside the [src]!.</span>")
				return 0

			if(needs_bonfire)
				if(!locate_lit_bonfire())
					to_chat(user, "<span class='warning'>You need a bonfire to heat up \the [src].</span>")
					return 0

			var/obj/item/weapon/kitchen/cooking_spoon/COOKSPOON = O
			to_chat(user, "<span class='info'>You start stirring the [src]... cooking the recipe.</span>")
			playsound(loc, 'sound/machines/bubbling.ogg', 50, 1)
			operating = 1
			if(do_after(user, 20, target = src))
				operating = 0
				if(prob(COOKSPOON.dirtyness))
					fail()
					ready_to_cook = 0
					update_icon()
					to_chat(user, "<span class='warning'>That dirty [COOKSPOON] has ruined the cooking.</span>")
					return 1
				else
					cook()
					ready_to_cook = 0
					update_icon()
					COOKSPOON.dirtyness += 20
					COOKSPOON.update_icon()
					return 1
		else
			to_chat(user, "<span class='info'>You start stirring the [src]... preparing the stew.</span>")
			playsound(loc, 'sound/machines/bubbling.ogg', 50, 1)
			operating = 1
			if(do_after(user, 20, target = src))
				operating = 0
				ready_to_cook = 1
				update_icon()
				to_chat(user, "<span class='info'>\The [src] is ready for cooking.</span>")
				return 1
			return 1
	else
		to_chat(user, "<span class='alert'>You have no idea what you can cook with this [O].</span>")
		return 1


/obj/structure/medieval_cooking/cauldron/attack_hand(mob/user)
	if(contents.len >= 1)
		playsound(src.loc, 'sound/effects/slosh.ogg', 55, 1)
		to_chat(user,"<span class=info> you remove the contents of the cauldron carefully</span>")
		for(var/obj/O in contents)
			O.forceMove(loc)

/obj/structure/medieval_cooking/cauldron/update_icon()
	icon_state = "cauldron[ready_to_cook]"
	..()

/obj/structure/medieval_cooking/cauldron/proc/locate_lit_bonfire()
	var/turf/ThisTile = locate(x,y,z)
	var/obj/structure/bonfire/B = locate(/obj/structure/bonfire) in ThisTile
	if(B)
		if(B.lit)
			return 1

	return 0


/obj/item/weapon/kitchen/cooking_spoon
	name = "cooking spoon"
	desc = "Lethal in the hands of a mother."
	icon = 'icons/obj/items.dmi'
	icon_state = "cookingspoon"
	throwforce = 1
	w_class = 1
	throw_speed = 4
	throw_range = 5
	var/dirtyness = 0

/obj/item/weapon/kitchen/cooking_spoon/proc/clean()
	dirtyness = 0
	update_icon()

/obj/item/weapon/kitchen/cooking_spoon/update_icon()
	if(dirtyness > 0)
		icon_state = "cookingspoon_dirty"
	else
		icon_state = "cookingspoon"

/obj/item/weapon/kitchen/cooking_spoon/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	else
		var/list/container_types = typesof(/obj/item/weapon/reagent_containers/glass)
		for(var/pathing in container_types)
			if(istype(target, pathing)) //Cleaning the spoon with whatever is inside for now.
				if(target.reagents.total_volume >= 2)
					//We need to make an additional check here to check that the container has water.
					to_chat(user, "\blue You clean the [src]")
					playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1)
					clean()
					return 1

