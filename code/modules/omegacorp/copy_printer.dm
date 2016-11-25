/obj/structure/copy_printer
	name = "3D Copy printer"
	desc = "Create fakes of items! They WILL NOT BE AMUSED."
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "copy_printer"
	anchored = 1
	density = 1
	opacity = 0
	var/ink = 100
	var/obj/item/TOCOPY

/obj/structure/copy_printer/attack_hand(mob/user as mob)
	if(TOCOPY)
		Copy()
	else
		to_chat(user, "There's not any items loaded in the machine")

/obj/structure/copy_printer/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/material_cartridge))
		if(ink >= 100)
			to_chat(user, "<span class=info> The machine is full to the brim with ink </span>")
			return
		ink += 50
		playsound(src.loc, 'sound/machines/click.ogg', 100, 1)
		qdel(W)
		return

	if(TOCOPY)
		to_chat(user, "<span class=info> There is already an item inside of the [src] </span>")
		return
	else
		if(W.w_class < 4)
			visible_message("[user] locks the item onto the 3D printer surface")
			user.drop_item()
			W.loc = src
			TOCOPY = W
			icon_state = "copy_printer_loaded"
			update_icon()
		else
			to_chat(user, "<span class=warning> The [W] is too big for this machine! </span>")
			return

/obj/structure/copy_printer/proc/Copy()
	if(ink < 0)
		visible_message("<span class=warning> [bicon(src)] pings, \" Out of ink \". </span>")
		return

	ink -= 25
	flick("copy_printer_copying", src)
	sleep(20)
	var/obj/item/dummy/NEWDUMMY = new(src.loc)
	NEWDUMMY.name = TOCOPY.name
	NEWDUMMY.desc = TOCOPY.desc
	NEWDUMMY.icon = TOCOPY.icon
	NEWDUMMY.icon_state = TOCOPY.icon_state
	NEWDUMMY.color = TOCOPY.color
	NEWDUMMY.layer = 4

/obj/structure/copy_printer/verb/Take_Out()
	set name = "Take out the item"
	set desc = "Take the item out of the copy printer"
	set src in view(1)
	set category = "Object"
	visible_message("<span class=info> User unlocks the [TOCOPY] out of the [src] </span>")
	TOCOPY.loc = loc
	TOCOPY = null
	icon_state = "copy_printer"
	update_icon()
	return

/obj/item/dummy
	name = "DUMMY ITEM"
	desc = "DUMMY ITEM"

/obj/item/weapon/material_cartridge
	name = "3D material cartridge"
	desc = "You won't run out of fun!"
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "material_cartridge"