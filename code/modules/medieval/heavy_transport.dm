// Make this better in the future, it's supposed to be a bag that you have to carry with both hands

/obj/item/weapon/storage/heavy
	name = "heavy storage"
	desc = "TELL AN ADMIN IF YOU SEE THIS."
	icon_state = "backpack"
	item_state = "backpack"
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	w_class = 5
	max_w_class = 4
	max_combined_w_class = 35
	storage_slots = 35
	burn_state = FLAMMABLE
	burntime = 60
	species_fit = list("Vox")
	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/back.dmi'
		)
	force = 7

/obj/item/weapon/storage/heavy/bag
	name = "big bag"
	desc = "Carry those potatoes now"
	icon_state = "paperbag_SmileyFace_closed"
	item_state = "bbag"



////////////////////////////////////////////////// CART.

/obj/structure/storage_cart
	name = "\improper cart"
	desc = "put stuffs in here"
	icon = 'icons/obj/storage.dmi'
	icon_state = "cart"
	opacity = 0
	density = 1
	anchored = 0
	var/list/obj/item/ListOfItems = list()	// Contents are different than contained items
	var/max_load = 20

/obj/structure/storage_cart/update_icon()
	if(ListOfItems.len >= 1)
		icon_state = "cart_loaded"
	else
		icon_state = "cart"

/obj/structure/storage_cart/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		ListItems(user)
		return

/obj/structure/storage_cart/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/grab))
		return	// Cant put grabbed stuff in the cart, for now
	// This will give problems later
	if(ListOfItems.len >= max_load)
		to_chat(user, "<span class=warning> [src] is too full! </span>")
		return

	to_chat(user, "You insert [W] inside [src]")
	user.drop_item()
	W.loc = src
	ListOfItems.Add(W)
	return

/obj/structure/storage_cart/proc/ListItems(mob/user as mob)
	user.set_machine(src)
	var/dat

	dat += text(" Cart <br>")
	for(var/i=1;i<ListOfItems.len+1;i++)
		var/obj/item/MyItem = ListOfItems[i]
		dat += text("<A href='?src=[UID()];choice=[i]'>[MyItem.name].</A><br>")

	var/datum/browser/popup = new(user, "cart_window", "Cart", 400, 500)
	popup.set_content(dat)
	popup.open()
	return

/obj/structure/storage_cart/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		ReleaseItems(text2num(href_list["choice"]))
	return

/obj/structure/storage_cart/proc/ReleaseItems(var/ID)
	if(!isturf(src.loc))
		return

	var/obj/item/MyItem = ListOfItems[ID]
	MyItem.loc = src.loc
	ListOfItems.Remove(MyItem)
	return