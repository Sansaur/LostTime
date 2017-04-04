/obj/structure/blacksmith_furnace
	name = "furnace"
	desc = "smells like burned recipes"
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "blacksmith_furnace"
	opacity = 0
	anchored = 1
	density = 1
	layer = 3
	var/obj/item/weapon/mold/MYMOLD
	var/obj/item/stack/sheet/mineral/MYMINERAL
	var/fuel = 50
	var/fuel_needed = 5
	// This is shitty af - Sansaur
	var/possible_smelt_types = list(

	/obj/item/stack/sheet/mineral/gold,
	/obj/item/stack/sheet/mineral/mythril,
	/obj/item/stack/sheet/mineral/silver,
	/obj/item/stack/sheet/mineral/iron

	)

/obj/structure/blacksmith_furnace/attack_hand(mob/user as mob)
	if(MYMOLD)
		MYMOLD.loc = user.loc
		MYMOLD = null

	if(MYMINERAL)
		MYMINERAL.loc = user.loc
		MYMINERAL = null



/obj/structure/blacksmith_furnace/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/mold))
		var/obj/item/weapon/mold/COMEON = W
		if(MYMOLD)
			to_chat(user, "<div class=warning> There's already a [MYMOLD] loaded! </div>")
			return
		if(COMEON.material_loaded)
			to_chat(user, "<div class=warning> Pull out the [COMEON.material_loaded] first! </div>")
			return
		if(istype(W, /obj/item/weapon/mold/ingot))
			to_chat(user, "<div class=warning> That doesn't go there </div>")
			return

		to_chat(user, "<div class=info> You load the [W] in the [src] </div>")
		user.drop_item()
		W.loc = src
		MYMOLD = W
		return

	if(istype(W, /obj/item/stack/sheet/mineral))
		if(MYMINERAL)
			to_chat(user, "<div class=warning>  [MYMINERAL] is already loaded! </div>")
			return
		to_chat(user, "<div class=info> You load the [W] in the [src] </div>")
		user.drop_item()
		W.loc = src
		MYMINERAL = W
		return

	if(istype(W, /obj/item/weapon/log))
		to_chat(user, "<div class=info> You add some fuel to the [src] </div>")
		user.drop_item()
		qdel(W)
		fuel += 5
		return

	if(istype(W, /obj/item/weapon/wood_plank))
		to_chat(user, "<div class=info> You add some fuel to the [src] </div>")
		user.drop_item()
		qdel(W)
		fuel += 2
		return

	if(istype(W, /obj/item/stack/sheet/kindling))
		var/obj/item/stack/sheet/kindling/KIND = W
		to_chat(user, "<div class=info> You add some fuel to the [src] </div>")
		user.drop_item()
		fuel += KIND.amount / 2
		qdel(KIND)
		return

/obj/structure/blacksmith_furnace/verb/smelt()
	set name = "melt into mold"
	set desc = "You melt item nao"
	set category = "Object"
	set src in oview(1)

	if(fuel >= fuel_needed)
		if(MYMOLD && MYMINERAL)
			if(MYMINERAL.type in possible_smelt_types)
				fuel -= fuel_needed
				to_chat(usr, "<div class=warning> You smelt the [MYMINERAL] into the [MYMOLD] </div>")
				flick("blacksmith_furnace_cook",src)
				sleep(5)
				if(istype(MYMINERAL, /obj/item/stack/sheet/mineral/iron))
					MYMOLD.material_loaded = "metal"
					MYMOLD.update_icon()
				if(istype(MYMINERAL, /obj/item/stack/sheet/mineral/mythril))
					MYMOLD.material_loaded = "mythril"
					MYMOLD.update_icon()
				if(istype(MYMINERAL, /obj/item/stack/sheet/mineral/silver))
					MYMOLD.material_loaded = "silver"
					MYMOLD.update_icon()
				if(istype(MYMINERAL, /obj/item/stack/sheet/mineral/gold))
					MYMOLD.material_loaded = "gold"
					MYMOLD.update_icon()

				MYMOLD.loc = src.loc
				qdel(MYMINERAL)
				MYMOLD = null
				MYMINERAL = null
				return
			else
				to_chat(usr, "<div class=warning> You cannot smelt [MYMINERAL] into the [MYMOLD]! </div>")
				return
		else
			to_chat(usr, "<div class=warning> You're missing either the mold or the minerals </div>")
			return
	else
		to_chat(usr, "<div class=warning> There's not enough fuel in the [src] </div>")