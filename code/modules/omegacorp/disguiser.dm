/**
*
* THERE HAS TO BE A WAY TO RETURN DISGUISED ITEMS TO THEIR DEFUALT ICON
*
**/


/obj/item/weapon/omegacorp_disguiser //This allows an Omegacorp agent to change how an item looks for a period of time
	name = "Item disguiser"
	desc = "A handy piece of technology to hide your dirty... your tools from the eyes of those who don't deserve to see them \
			use an ID on this device to de-map all disguised items, <span class=warning> the disguised items may have appearance crashes. </span>"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "item_disguiser"
	w_class = 2
	var/obj/structure/timetravel/phonebooth/master_booth
	var/obj/item/LOADED
	var/list/obj/item/MAPPED_OBJS_LIST = list()
	var/on_CD
	var/auto_demapping = 1
/*
/obj/item/weapon/omegacorp_disguiser/New()
	..()
	while(auto_demapping)
		process()

/obj/item/weapon/omegacorp_disguiser/process()
	if(MAPPED_OBJS_LIST.len > 0)
		if(prob(5))
			visible_message("[bicon(src)] <span class=warning>FFFSXXXFTTTZZZ</span>")
			Demap_Everything()
	sleep(200)
*/

/obj/item/weapon/omegacorp_disguiser/attack_self(mob/user as mob)
	if(LOADED)
		if(MAPPED_OBJS_LIST.len > 3)
			to_chat(user, "<span class=warning> This disguiser cannot map any more items! </span>")
			return
		Change_Item(user)
	else
		if(MAPPED_OBJS_LIST.len > 0)
			if(!on_CD)
				Show_Distance()
				to_chat(user, "<span class=info> A paper prints out of the machine </span>")
				on_CD = 1
				spawn(100)
				on_CD = 0
				return
			else
				return
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
		if(istype(W, /obj/item/weapon/grenade))
			to_chat(user, "The [src] cannot alter the appearance of grenades!")
			return
		if(istype(W, /obj/item/weapon/omegacorp_disguiser))
			to_chat(user, "The [src] cannot alter the appearance of other disguisers")
			return
		if(istype(W, /obj/item/weapon/card/id))
			Demap_Everything()
			return
		user.drop_item()
		W.loc = src
		LOADED = W
		flick("item_disguiser-loading", src)
		icon_state = "item_disguiser-loaded"
		update_icon()
	else
		to_chat(user, "The item cannot be loaded in the [src]")

/obj/item/weapon/omegacorp_disguiser/proc/Demap_Everything()
	for(var/obj/item/TO_DEMAP in MAPPED_OBJS_LIST)
		TO_DEMAP.icon = initial(TO_DEMAP.icon)
		TO_DEMAP.icon_state = initial(TO_DEMAP.icon_state)
		TO_DEMAP.item_state = initial(TO_DEMAP.item_state)
		TO_DEMAP.name = initial(TO_DEMAP.name)
		MAPPED_OBJS_LIST.Remove(TO_DEMAP)

	visible_message("[bicon(src)] <span class=warning>pings, \"All items disguised by this device have been demapped\"</span>")

/obj/item/weapon/omegacorp_disguiser/proc/Show_Distance()
	var/thisX
	var/thisY
	var/paperinfo
	for(var/obj/item/TO_DEMAP in MAPPED_OBJS_LIST)
		thisX = src.loc.x - TO_DEMAP.x
		thisY = src.loc.y - TO_DEMAP.y
		paperinfo += "Location of [TO_DEMAP.name]: "
		if(TO_DEMAP.z != src.loc.z)
			paperinfo += "ERROR, CANNOT FIND ITEM IN THIS TIMELINE"
			continue
		if(thisX >= 0)
			paperinfo += "[thisX] steps to the west  "
		else
			paperinfo += "[(thisX * -1)] steps to the east  "
		if(thisY >= 0)
			paperinfo += "[thisY] steps to the south  "
		else
			paperinfo += "[(thisY * -1)] steps to the north  "
		paperinfo += "<hr>"

	var/obj/item/weapon/paper/papelito = new(src.loc)
	papelito.info = paperinfo
	papelito.update_icon()
	papelito.loc = src.loc.loc //¿¿ESTO FUNCIONARA???

/obj/item/weapon/omegacorp_disguiser/proc/Change_Item(mob/user as mob)
	var/list/choices = list("Pickaxe", "Claymore") //WE'LL NEED MORE CHOICES
	var/stored_icon
	var/stored_icon_state
	var/stored_item_state
	var/stored_name
	var/selected
	selected = input(user, "Choose the new appearance of the item", "Choosing!", "Pickaxe") in choices
	switch(selected)
		if("Pickaxe")
			stored_icon = 'icons/obj/items.dmi'
			stored_icon_state = "pickaxe"
			stored_item_state = "pickaxe"
			stored_name = "pickaxe"
		if("Claymore")
			stored_icon = 'icons/obj/weapons.dmi'
			stored_icon_state = "claymore"
			stored_item_state = "claymore"
			stored_name = "claymore"

	LOADED.icon = stored_icon
	LOADED.icon_state = stored_icon_state
	if(stored_item_state)
		LOADED.item_state = stored_item_state
	LOADED.name = stored_name
	MAPPED_OBJS_LIST.Add(LOADED)
	to_chat(user, "The mapped object will return to it's normal appearance in 2 minutes")
	Auto_Demap(LOADED) //DO THIS LATER - Sansaur
	return

	//Make a choice list with medieval items and change the item's sprite, name and description to that one.
	//The disguiser should have a way to tell if an item is disguised or not.

/obj/item/weapon/omegacorp_disguiser/proc/Auto_Demap(var/obj/item/TO_DEMAP)
	sleep(1200)
	TO_DEMAP.icon = initial(TO_DEMAP.icon)
	TO_DEMAP.icon_state = initial(TO_DEMAP.icon_state)
	TO_DEMAP.item_state = initial(TO_DEMAP.item_state)
	TO_DEMAP.name = initial(TO_DEMAP.name)
	playsound(TO_DEMAP, 'sound/items/posiping.ogg', 30, 1)
	MAPPED_OBJS_LIST.Remove(TO_DEMAP)
	to_chat(oview(2), "[bicon(src)] <span class=warning>pings, \"[LOADED] has been demapped \"</span>")