/obj/item/weapon/cement_spade
	name = "cement spade"
	desc = "plotch."
	icon = 'icons/obj/items.dmi'
	icon_state = "cement_spade"
	force = 9
	throwforce = 2
	w_class = 2
	attack_verb = list("punctured", "pinched")
	block_chance = 0
	var/cement = 0
	var/max_cement = 10

/obj/item/weapon/cement_spade/proc/lose_cement()
	cement = 0
	return

/obj/item/weapon/cement_spade/proc/update_cement(var/amount)
	if(cement == max_cement)
		return 0
	if((cement+amount) > max_cement)
		cement = max_cement
	else
		cement += amount

	return cement

/obj/item/weapon/cement_bag
	name = "cement bag"
	desc = "Carry those potatoes now"
	icon = 'icons/obj/storage.dmi'
	icon_state = "trashbag_full"
	item_state = "bbag"
	var/open = 0	// After it's open it'll get hard over time until it cannot be used anymore.
	var/cement_amount = 100

/obj/item/weapon/cement_bag/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/cement_spade))
		var/obj/item/weapon/cement_spade/MY = W
		if(cement_amount <= 5)
			to_chat(user, "<span class=warning> There's not enough cement in the [src]! </span>")
			return
		if(MY.cement)
			to_chat(user, "<span class=warning> The [MY] has some cement already </span>")
			return

		to_chat(user, "<span class=info> You scoop up some cement </span>")
		var/quarter = cement_amount / 4 + 5 		//Grabs a quarter + 5
		cement_amount -= MY.update_cement(quarter)
		return

	else
		..()

// MOVE THIS SOMEWHERE ELSE IN THE FUTURE!!!!!!!!! -SANSAUR

/obj/structure/reagent_dispensers/watertank/medieval
	name = "well"
	desc = "A well"
	icon = 'icons/obj/objects.dmi'
	icon_state = "well"
	amount_per_transfer_from_this = 10
	anchored = 1

/obj/structure/reagent_dispensers/watertank/medieval/attackby(obj/item/W, mob/user as mob)
	..()
	update_icon()

/obj/structure/reagent_dispensers/watertank/medieval/update_icon()
	if(reagents.reagent_list.len <= 0)
		icon_state = "well_empty"
	else
		icon_state = "well"