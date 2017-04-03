/obj/item/weapon/medieval_weapon_accesory
	name = "medieval weapon accesory"
	desc = "CONTACT AN ADMIN IF YOU SEE THIS."
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = ""
	force = 5
	throwforce = 5
	w_class = 2
	attack_verb = list("punctured", "pinched")
	block_chance = 0

	// guard solo is not used for anything

/obj/item/weapon/medieval_weapon_accesory/guard
	name = "guard"
	desc = "Now you won't be cutting yourself anymore."
	icon_state = "guard"

// GRIP!

/obj/item/weapon/medieval_weapon_accesory/grip
	name = "grip"
	desc = "A grip without a guard or blade... Or another grip."
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "grip"

/obj/item/weapon/medieval_weapon_accesory/grip/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/medieval_weapon_accesory/grip))
		user.drop_item()
		var/obj/item/weapon/medieval_weapon_accesory/double_grip/MY = new /obj/item/weapon/medieval_weapon_accesory/double_grip (loc)
		user.put_in_hands(MY)
		to_chat(user, "<div class=info> You crafted a [MY] </div>")
		qdel(W)
		qdel(src)
		return

	if(istype(W, /obj/item/weapon/medieval_weapon_accesory/guard))
		user.drop_item()
		var/obj/item/weapon/medieval_weapon_accesory/grip_guard/MY = new /obj/item/weapon/medieval_weapon_accesory/grip_guard (loc)
		user.put_in_hands(MY)
		to_chat(user, "<div class=info> You crafted  [MY] </div>")
		qdel(W)
		qdel(src)
		return

	if(istype(W, /obj/item/weapon/medieval_weapon_part/axe_head))
		var/obj/item/weapon/medieval_weapon_part/axe_head/MY = W
		user.drop_item()
		// This is shitty af - Sansaur
		var/obj/item/RESULT = MY.finish_product
		new RESULT (user.loc)
		to_chat(user, "<div class=info> You crafted something! </div>")
		qdel(src)
		qdel(W)
		return




// GRIP + GUARD !!

/obj/item/weapon/medieval_weapon_accesory/grip_guard
	name = "grip with a guard"
	desc = "Now it only needs a blade."
	icon_state = "grip_guard"

/obj/item/weapon/medieval_weapon_accesory/grip_guard/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/medieval_weapon_part/sword_blade))
		var/obj/item/weapon/medieval_weapon_part/sword_blade/MY = W
		user.drop_item()
		// This is shitty af - Sansaur
		var/obj/item/RESULT = MY.finish_product
		new RESULT (user.loc)
		to_chat(user, "<div class=info> You crafted something! </div>")
		qdel(src)
		qdel(W)
		return


// DOUBLE GRIP !!

/obj/item/weapon/medieval_weapon_accesory/double_grip
	name = "double grip"
	desc = "Now it only needs a blade."
	icon_state = "double_grip"

/obj/item/weapon/medieval_weapon_accesory/double_grip/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/medieval_weapon_part/spear_pike))
		var/obj/item/weapon/medieval_weapon_part/spear_pike/MY = W
		user.drop_item()
		// This is shitty af - Sansaur
		var/obj/item/RESULT = MY.finish_product
		new RESULT (user.loc)
		to_chat(user, "<div class=info> You crafted something! </div>")
		qdel(src)
		qdel(W)
		return
