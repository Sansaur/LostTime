/obj/structure/medieval_cooking/oven
	name = "stone oven"
	desc = "You use this to cook"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "oven0"
	recipe_type = /datum/recipe/med_oven
	var/lit = 0
	var/wood = 0
/obj/structure/medieval_cooking/oven/New()
	..()
	processing()

/obj/structure/medieval_cooking/oven/update_icon()
	icon_state = "oven[lit]"
	..()

/obj/structure/medieval_cooking/oven/proc/update_desc()
	desc = "You use this to cook, it has <b>[wood]</b> pieces of charcoal inside"

/obj/structure/medieval_cooking/oven/attackby(obj/item/O, mob/user, params)
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
	else if(istype(O,/obj/item/weapon/kitchen/peel))
		var/obj/item/weapon/kitchen/peel/PEEL = O
		to_chat(user, "<span class='info'>You use the [PEEL] to pull the contents out of the [src].</span>")
		removeContents()
		return 1
	else if(istype(O, /obj/item/weapon/wood_plank))
		qdel(O)
		to_chat(user, "<span class='info'>You burn some wood into the oven, adding charcoal.</span>")
		wood++
		update_desc()
		return 1
	else
		to_chat(user, "<span class='alert'>You have no idea what you can cook with this [O].</span>")
		return 1
	updateUsrDialog()

/obj/structure/medieval_cooking/oven/attack_hand(mob/user)
	switchlit()

/obj/structure/medieval_cooking/oven/proc/switchlit()
	lit = !lit
	update_icon()

/obj/structure/medieval_cooking/oven/proc/processing()
	sleep(60)
	//Things get cooked if oven is lit
	if(lit)
		if(wood > 0)
			if(contents.len >= 1)
				playsound(src.loc, 'sound/machines/grilling.ogg', 100, 1)
				flick("ovencook",src)
				cook()
				update_desc()
		else
			switchlit()
			update_desc()
	sleep(60)
	processing()

/obj/structure/medieval_cooking/oven/proc/removeContents()
	if(contents.len >= 1)
		for(var/obj/O in contents)
			O.forceMove(loc)

/obj/structure/medieval_cooking/oven/cook()
	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	var/obj/cooked
	var/obj/byproduct
	if(!recipe)
		var/obj/item/weapon/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
		var/amount = 0
		for(var/obj/O in contents-ffuu)
			amount++
			if(O.reagents)
				var/id = O.reagents.get_master_reagent_id()
				if(id)
					amount+=O.reagents.get_reagent_amount(id)
			qdel(O)
		reagents.clear_reagents()
		ffuu.reagents.add_reagent("carbon", amount)
		ffuu.reagents.add_reagent("????", amount/10)
		ffuu.forceMove(get_turf(src))

	else
		cooked = recipe.make_food(src)
		byproduct = recipe.get_byproduct()
		if(cooked)
			cooked.forceMove(src)
		if(byproduct)
			new byproduct(loc)

	//contents.Cut()

/obj/structure/medieval_cooking/oven/proc/consumeWood(var/woodconsumed)
	src.wood -= woodconsumed
	if(wood <= 0)
		wood = 0

/obj/item/weapon/kitchen/peel
	name = "baker's peel"
	desc = "Just in case you don't want to die a fiery death involving an oven and you."
	icon = 'icons/obj/items.dmi'
	icon_state = "peel" //NEEDS BETTER ICON AND ITEM STATES!!!!!
	throwforce = 1
	w_class = 4
	throw_speed = 4
	throw_range = 5