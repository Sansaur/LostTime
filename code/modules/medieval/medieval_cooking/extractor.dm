/obj/structure/extractor
	name = "extractor"
	desc = "Well, if you squeeze it hard enough some liquid might come out"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "extractor00"
	var/is_dirty = 0
	var/is_broken = 0
	var/list/acceptable_items // List of the items you can put in
	var/operating
	var/obj/item/weapon/reagent_containers/reagentcontainer
	var/obj/item/weapon/reagent_containers/food/snacks/inserted_food
	anchored = 1
	opacity = 0
	density = 1

/obj/structure/extractor/New()
	/*
	Añadimos aqui los items que podemos poner en el extractor
	*/
	acceptable_items = list(
		/obj/item/weapon/reagent_containers/food/snacks/grown/tomato
	)

/obj/structure/extractor/update_icon()
	var/is_reagent_in = 0
	var/is_food_in = 0
	if(reagentcontainer)
		is_reagent_in = 1
	if(inserted_food)
		is_food_in = 1
	icon_state = "extractor[is_reagent_in][is_food_in]"
/obj/structure/extractor/attackby(obj/item/O, mob/user, params)
	if(is_type_in_list(O,acceptable_items))
		if(!inserted_food)
			if(istype(O,/obj/item/stack) && O:amount>1)
				inserted_food = new O.type (src)
				O:use(1)
				user.visible_message( \
					"<span class='notice'>[user] has added one of [O] to \the [src].</span>", \
					"<span class='notice'>You add one of [O] to \the [src].</span>")
				update_icon()
			else
				if(!user.drop_item())
					to_chat(user, "<span class='notice'>\The [O] is stuck to your hand, you cannot put it in \the [src]</span>")
					update_icon()
					return 0

				O.forceMove(src)
				inserted_food = O
				user.visible_message( \
					"<span class='notice'>[user] has added \the [O] to \the [src].</span>", \
					"<span class='notice'>You add \the [O] to \the [src].</span>")
				update_icon()
		else
			to_chat(user, "<span class='notice'>\The [src] already has a food item inside</span>")
			update_icon()
			return 0

	else if(istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/glass))
		if(reagentcontainer)
			to_chat(user, "<span class='alert'>There's already a [reagentcontainer] inside the [src].</span>")
			update_icon()
			return 1
		else
			if(!user.drop_item())
				to_chat(user, "<span class='notice'>\The [O] is stuck to your hand, you cannot put it in \the [src]</span>")
				update_icon()
				return 0
			O.forceMove(src)
			reagentcontainer = O
			user.visible_message( \
				"<span class='notice'>[user] has added \the [O] to \the [src].</span>", \
				"<span class='notice'>You add \the [O] to \the [src].</span>")
			update_icon()

	else if(istype(O,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		to_chat(user, "<span class='alert'>This is ridiculous. You can not fit \the [G.affecting] in this [src].</span>")
		update_icon()
		return 1
	else
		to_chat(user, "<span class='alert'>You have no idea what you can cook with this [O].</span>")
		update_icon()
		return 1

/obj/structure/extractor/attack_hand(mob/user)
	cook()


/obj/structure/extractor/verb/removeReagentContainer()
	set name = "Remove reagent container"
	set desc = "remove reagent container"
	set category = "Object"
	set src in oview(1)

	rReagentContainer()

/obj/structure/extractor/proc/rReagentContainer()
	reagentcontainer.forceMove(get_turf(src))
	reagentcontainer = null
	update_icon()

/obj/structure/extractor/verb/removeInsertedFood()
	set name = "Remove inserted food"
	set desc = "remove inserted food"
	set category = "Object"
	set src in oview(1)

	rInsertedFood()

/obj/structure/extractor/proc/rInsertedFood()
	inserted_food.forceMove(get_turf(src))
	inserted_food = null
	update_icon()

/obj/structure/extractor/proc/cook()
	var/amount = 10
	if(inserted_food && reagentcontainer)
		if(istype(inserted_food,/obj/item/weapon/reagent_containers/food/snacks/grown/tomato))
			reagentcontainer.reagents.add_reagent("tomatojuice", amount)
			rReagentContainer()
		else
			reagentcontainer.reagents.add_reagent("carbon", amount)
			reagentcontainer.reagents.add_reagent("????", amount)
			rReagentContainer()

		qdel(inserted_food)
		inserted_food = null
	update_icon()
