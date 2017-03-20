/obj/structure/leather_drying_rack
	name = "\improper leather drying rack"
	desc = "because silk needs it's own spinner apparently"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "l_dry"
	density = 1
	anchored = 1
	opacity = 0
	var/obj/item/stack/sheet/animalhide/MyHide
	var/obj/item/stack/sheet/wetleather/MyWetLeather
	var/obj/item/stack/sheet/leather/MyFinalLeather

/obj/structure/leather_drying_rack/update_icon()
	if(MyHide)
		icon_state = "l_dry_loaded"
		return
	if(MyWetLeather)
		icon_state = "l_dry_wet"
		return
	if(MyFinalLeather)
		icon_state = "l_dry_final"
		return
	else
		icon_state = "l_dry"
		return

/obj/structure/leather_drying_rack/attack_hand(mob/user as mob)
	if(MyHide)
		to_chat(user, "You take [MyHide] off [src]")
		MyHide.loc = user.loc
		user.put_in_hands(MyHide)
		MyHide = null 
		contents.Cut()
		update_icon()
		return 
	if(MyWetLeather)
		to_chat(user, "You take [MyWetLeather] off [src]")
		MyWetLeather.loc = user.loc
		user.put_in_hands(MyWetLeather)
		MyWetLeather = null 
		contents.Cut()
		update_icon()
		return 
	if(MyFinalLeather)
		to_chat(user, "You take [MyFinalLeather] off [src]")
		MyFinalLeather.loc = user.loc
		user.put_in_hands(MyFinalLeather)
		MyFinalLeather = null 
		contents.Cut()
		update_icon()
		return 
	else	
		to_chat(user, "There's nothing loaded in [src]")
	
/obj/structure/leather_drying_rack/attackby(obj/item/W, mob/user as mob)

	if(istype(W, /obj/item/stack/sheet/animalhide))
		if(isOccupied())
			to_chat(user, "[src] is occupied")
			return

		user.drop_item()
		var/obj/item/stack/sheet/animalhide/N = W
		MyHide = N
		N.loc = src
		update_icon()
		return

	if(istype(W, /obj/item/stack/sheet/wetleather))
		if(isOccupied())
			to_chat(user, "[src] is occupied")
			return

		user.drop_item()
		var/obj/item/stack/sheet/wetleather/N = W
		MyWetLeather = N
		N.loc = src
		update_icon()
		return

	if(istype(W, /obj/item/stack/sheet/leather))
		if(isOccupied())
			to_chat(user, "[src] is occupied")
			return

		user.drop_item()
		var/obj/item/stack/sheet/leather/N = W
		MyFinalLeather = N
		N.loc = src
		update_icon()
		return

	if(istype(W, /obj/item/weapon))
		var/obj/item/weapon/WEAPON = W
		if(WEAPON.edge && MyHide)
			to_chat(user, "You begin dehairing [MyHide] with [WEAPON]")
			if(do_after(user, 70-WEAPON.force, target=src))
				if(MyHide)
					playsound(src, 'sound/weapons/slash.ogg', 80, 0)
					to_chat(user, "You dehaired [MyHide] with [WEAPON]")
					contents.Cut()
					var/obj/item/stack/sheet/wetleather/N = new /obj/item/stack/sheet/wetleather (src)
					MyWetLeather = N
					MyHide = null
					update_icon()
					return
				else
					return
			else
				return

	if(istype(W, /obj/item/weapon/drying_paddle))
		var/obj/item/weapon/drying_paddle/WEAPON = W
		if(WEAPON && MyWetLeather)
			to_chat(user, "You begin drying [MyWetLeather] with [WEAPON]")
			if(do_after(user, 30-WEAPON.force, target=src))
				playsound(src, 'sound/weapons/punchmiss.ogg', 80, 0)
				if(MyWetLeather && MyWetLeather.wetness < 0)
					to_chat(user, "You dried [MyWetLeather] with [WEAPON] fully")
					contents.Cut()
					var/obj/item/stack/sheet/leather/N = new /obj/item/stack/sheet/leather (src)
					N.amount = rand(2,4)
					MyFinalLeather = N
					MyWetLeather = null
					update_icon()
					return
				else 
					to_chat(user, "You dried [MyWetLeather] with [WEAPON] a bit")
					playsound(src, 'sound/weapons/punchmiss.ogg', 80, 0)
					MyWetLeather.wetness -= rand(2,4)

	else
		..()

/obj/structure/leather_drying_rack/proc/isOccupied()
	if(MyHide)
		return 1
	if(MyWetLeather)
		return 1
	if(MyFinalLeather)
		return 1

	return 0