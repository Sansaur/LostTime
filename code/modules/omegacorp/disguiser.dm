/**
*
* THERE HAS TO BE A WAY TO RETURN DISGUISED ITEMS TO THEIR DEFUALT ICON
*
**/


/obj/item/weapon/omegacorp_disguiser //This allows an Omegacorp agent to change how an item looks for a period of time
	name = "Item disguiser"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "item_disguiser"
	w_class = 2
	var/obj/structure/timetravel/phonebooth/master_booth
	var/obj/item/LOADED

/obj/item/weapon/omegacorp_disguiser/attack_self(mob/user as mob)
	if(LOADED)
		Change_Item()
	//If it's not loaded it'll print a paper with the distance to the disguised items and their characteristics.

/obj/item/weapon/omegacorp_disguiser/attack_hand(mob/user as mob)
	if(LOADED && src.loc == user)
		LOADED.loc = user.loc
		user.put_in_hands(LOADED)
		LOADED = null
		icon_state = "item_disguiser"
		update_icon()
	else
		..()
/obj/item/weapon/omegacorp_disguiser/attackby(obj/item/W, mob/user as mob)
	if(W.w_class <= 3 && !LOADED)
		if(istype(W, /obj/item/clothing))
			to_chat(user, "The [src] cannot alter the appearance of clothing items")
			return
		if(istype(W, /obj/item/weapon/card/id))
			to_chat(user, "The [src] cannot alter the appearance of IDs")
			return
		user.drop_item()
		W.loc = src
		LOADED = W
		flick("item_disguiser-loading", src)
		icon_state = "item_disguiser-loaded"
		update_icon()
	else
		to_chat(user, "The item cannot be loaded in the [src]")

/obj/item/weapon/omegacorp_disguiser/proc/Change_Item()
	var/list/choices = list()
	//Make a choice list with medieval items and change the item's sprite, name and description to that one.
	//The disguiser should have a way to tell if an item is disguised or not.