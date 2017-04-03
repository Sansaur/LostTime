/obj/item/weapon/mold
	name = "mold"
	desc = "CONTACT AN ADMIN IF YOU SEE THIS."
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "cement_spade"
	force = 6
	throwforce = 6
	w_class = 2
	attack_verb = list("punctured", "pinched")
	block_chance = 0
	var/obj/item/stack/sheet/mineral/LOADED_INGOT
	//Possibilities, it's an associative list.
	var/list/yield_list = list()
	var/material_loaded = ""

/obj/item/weapon/mold/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/pincers))
		if(!material_loaded)
			to_chat(user, "<div class=warning> The [src] is empty! </div>")
			return
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot pull items out of the [src] if it's not on the floor or a table </div>")
			return

		var/obj/item/weapon/medieval_weapon_part/RESULT = yield_list[material_loaded]
		to_chat(user, "<div class=warning> You pull the part out of the [src] </div>")
		new RESULT (user.loc)
		material_loaded = null
		color = initial(color)
		update_icon()

/obj/item/weapon/mold/update_icon()
	if(material_loaded)
		icon_state = "[icon_state]_[material_loaded]"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/mold/ingot
	name = "Ingot mold"
	desc = "time to hot-foot it"
	icon_state = "ingot_mold"

/obj/item/weapon/mold/ingot/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/pincers))
		if(!LOADED_INGOT)
			to_chat(user, "<div class=warning> The [src] is empty! </div>")
			return
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot pull items out of the [src] if it's not on the floor or a table </div>")
			return

		to_chat(user, "<div class=info> You pull the [LOADED_INGOT] out of the [src] </div>")
		LOADED_INGOT.loc = user.loc
		LOADED_INGOT = null
		return


