/obj/structure/medieval_cooking
	name = "cauldron"
	desc = "Time to do some magic cooking. (You shouldn't be seeing this, report this to a coder)"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "icecream_vat"
	var/recipe_type = /datum/recipe/cauldron
	var/is_dirty = 0
	var/is_broken = 0
	var/list/datum/recipe/available_recipes
	var/list/acceptable_items // List of the items you can put in
	var/list/acceptable_reagents // List of the reagents you can put in
	var/operating
	var/max_n_of_items = 0
	anchored = 1
	opacity = 0
	density = 1

/obj/structure/medieval_cooking/New()
	reagents = new/datum/reagents(100)
	reagents.my_atom = src
	if(!available_recipes)
		available_recipes = new
		acceptable_items = new
		acceptable_reagents = new
		for(var/type in subtypesof(recipe_type))
			var/datum/recipe/recipe = new type
			if(recipe.result) // Ignore recipe subtypes that lack a result
				available_recipes += recipe
				for(var/item in recipe.items)
					acceptable_items |= item
				for(var/reagent in recipe.reagents)
					acceptable_reagents |= reagent
				if(recipe.items || recipe.fruit)
					max_n_of_items = max(max_n_of_items,recipe.count_n_items())
			else
				qdel(recipe)
		acceptable_items |= /obj/item/weapon/reagent_containers/food/snacks/grown

/obj/structure/medieval_cooking/attackby(obj/item/O, mob/user, params)
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
	else
		to_chat(user, "<span class='alert'>You have no idea what you can cook with this [O].</span>")
		return 1
	updateUsrDialog()

/obj/structure/medieval_cooking/attack_hand(mob/user)
	if(contents)
		cook()


/obj/structure/medieval_cooking/proc/cook()
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
			cooked.forceMove(loc)
		if(byproduct)
			new byproduct(loc)
		return
