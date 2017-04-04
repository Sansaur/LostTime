////////////////////////////////////////////////////////// SWORD BLADE

/obj/item/weapon/medieval_weapon_part/sword_blade
	name = "sword blade"
	desc = "It's sharp and has an edge."
	icon_state = "sword_blade"
	edge = 1
	attack_verb = list("slashed", "cut")
	finish_product = /obj/item/weapon/medieval/sword

/obj/item/weapon/medieval_weapon_part/sword_blade/silver
	finish_product = /obj/item/weapon/medieval/sword/silver

/obj/item/weapon/medieval_weapon_part/sword_blade/gold
	finish_product = /obj/item/weapon/medieval/sword/gold

/obj/item/weapon/medieval_weapon_part/sword_blade/mythril
	finish_product = /obj/item/weapon/medieval/sword/mythril

////////////////////////////////////////////////////////// SPEAR PIKE

/obj/item/weapon/medieval_weapon_part/spear_pike
	name = "spear pike"
	desc = "It's pointy."
	icon_state = "spear_pike"
	edge = 1
	attack_verb = list("poked", "pinched")
	finish_product = /obj/item/weapon/medieval/spear

/obj/item/weapon/medieval_weapon_part/spear_pike/silver
	finish_product = /obj/item/weapon/medieval/spear/silver

/obj/item/weapon/medieval_weapon_part/spear_pike/gold
	finish_product = /obj/item/weapon/medieval/spear/gold

/obj/item/weapon/medieval_weapon_part/spear_pike/mythril
	finish_product = /obj/item/weapon/medieval/spear/mythril

//////////////////////////////////////////////////////////	AXE HEAD

/obj/item/weapon/medieval_weapon_part/axe_head
	name = "axe head"
	desc = "It's smashy."
	icon_state = "axe_head"
	edge = 1
	attack_verb = list("cut", "smashed")
	finish_product = /obj/item/weapon/medieval/axe

/obj/item/weapon/medieval_weapon_part/axe_head/silver
	finish_product = /obj/item/weapon/medieval/axe/silver

/obj/item/weapon/medieval_weapon_part/axe_head/gold
	finish_product = /obj/item/weapon/medieval/axe/gold

/obj/item/weapon/medieval_weapon_part/axe_head/mythril
	finish_product = /obj/item/weapon/medieval/axe/mythril

//////////////////////////////////////////////////////////	LEG GUARDS

/obj/item/weapon/medieval_weapon_part/leg_guard
	name = "leg guard"
	desc = "It's leggy."
	icon_state = "leg_guard"
	edge = 0
	attack_verb = list("cut", "smashed")
	finish_product = /obj/item/clothing/shoes/medieval/greaves	// These don't work like that
	var/leather = 0
	var/needed_leather = 4

/obj/item/weapon/medieval_weapon_part/leg_guard/silver
	finish_product = /obj/item/clothing/shoes/medieval/greaves/silver	// These don't work like that

/obj/item/weapon/medieval_weapon_part/leg_guard/gold
	finish_product = /obj/item/clothing/shoes/medieval/greaves/gold	// These don't work like that

/obj/item/weapon/medieval_weapon_part/leg_guard/mythril
	finish_product = /obj/item/clothing/shoes/medieval/greaves/mythril	// These don't work like that

/obj/item/weapon/medieval_weapon_part/leg_guard/attackby(obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/stack/sheet/leather))
		if(leather >= needed_leather)
			to_chat(user, "<div class=warning> The [src] doesn't need anymore leather! </div>")
			return

		var/obj/item/stack/sheet/leather/LEATHER = W
		to_chat(user, "<div class=info> You start tying one of [LEATHER] pieces into a cord </div>")
		if(do_after(user, 30, target=src))
			LEATHER.use(1)
			to_chat(user, "<div class=info> You tied the [LEATHER] piece into a cord, keeping the armor pieces in place </div>")
			leather++
			return

	if(istype(W, src.type))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot tie the [src] here!</div>")
			return
		if(!(leather >= needed_leather))
			to_chat(user, "<div class=warning> The [src] needs more leather! </div>")
			return
		for(var/obj/structure/armor_rack/M in loc)
			var/obj/item/weapon/medieval_weapon_part/leg_guard/MY = W
			to_chat(user, "<div class=info> You tie the [src] and the [MY]!</div>")
			new finish_product (loc)
			qdel(MY)
			qdel(src)
			return

		to_chat(user, "<div class=warning> You must tie the [src] on top of an armor rack! </div>")
		return

////////////////////////////////////////////////////////// SHOULDER PADS

/obj/item/weapon/medieval_weapon_part/shoulder_pad
	name = "shoulder pad"
	desc = "It's shouldery."
	icon_state = "shoulder_pad"
	edge = 0
	attack_verb = list("cut", "smashed")
	finish_product = /obj/item/weapon/shoulder_pads

/obj/item/weapon/medieval_weapon_part/shoulder_pad/silver
	finish_product = /obj/item/weapon/shoulder_pads/silver

/obj/item/weapon/medieval_weapon_part/shoulder_pad/gold
	finish_product = /obj/item/weapon/shoulder_pads/gold

/obj/item/weapon/medieval_weapon_part/shoulder_pad/mythril
	finish_product = /obj/item/weapon/shoulder_pads/mythril

/obj/item/weapon/medieval_weapon_part/shoulder_pad/attackby(obj/item/W, mob/user as mob)
	..()

	if(istype(W, src.type))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot tie the [src] here!</div>")
			return

		for(var/obj/structure/armor_rack/M in loc)
			var/obj/item/weapon/medieval_weapon_part/shoulder_pad/MY = W
			to_chat(user, "<div class=info> You tie the [src] and the [MY]!</div>")
			new finish_product (loc)
			qdel(MY)
			qdel(src)
			return

		to_chat(user, "<div class=warning> You must tie the [src] on top of an armor rack! </div>")
		return

////////////////////////////////////////////////////////// HAND GUARD GLOVE

/obj/item/weapon/medieval_weapon_part/hand_guard_glove
	name = "hand guard "
	desc = "It's shouldery."
	icon_state = "hand_guard_glove"
	edge = 0
	attack_verb = list("cut", "smashed")
	finish_product = /obj/item/clothing/gloves/medieval/hand_guards
	var/leather = 0
	var/needed_leather = 2

/obj/item/weapon/medieval_weapon_part/hand_guard_glove/silver
	finish_product = /obj/item/clothing/gloves/medieval/hand_guards/silver

/obj/item/weapon/medieval_weapon_part/hand_guard_glove/gold
	finish_product = /obj/item/clothing/gloves/medieval/hand_guards/gold

/obj/item/weapon/medieval_weapon_part/hand_guard_glove/mythril
	finish_product = /obj/item/clothing/gloves/medieval/hand_guards/mythril

/obj/item/weapon/medieval_weapon_part/hand_guard_glove/attackby(obj/item/W, mob/user as mob)
	..()

	if(istype(W, /obj/item/stack/sheet/leather))
		if(leather >= needed_leather)
			to_chat(user, "<div class=warning> The [src] doesn't need anymore leather! </div>")
			return

		var/obj/item/stack/sheet/leather/LEATHER = W
		to_chat(user, "<div class=info> You start tying one of [LEATHER	] pieces into a cord </div>")
		if(do_after(user, 15, target=src))
			LEATHER.use(1)
			to_chat(user, "<div class=info> You tied the [LEATHER] piece into a cord, keeping the armor pieces in place </div>")
			leather++
			return

	if(istype(W, src.type))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot tie the [src] here!</div>")
			return
		if(!(leather >= needed_leather))
			to_chat(user, "<div class=warning> The [src] needs more leather! </div>")
			return
		for(var/obj/structure/armor_rack/M in loc)
			var/obj/item/weapon/medieval_weapon_part/hand_guard_glove/MY = W
			to_chat(user, "<div class=info> You tie the [src] and the [MY]!</div>")
			new finish_product (loc)
			qdel(MY)
			qdel(src)
			return

		to_chat(user, "<div class=warning> You must tie the [src] on top of an armor rack! </div>")
		return

////////////////////////////////////////////////////////// CHESTPLATE

/obj/item/weapon/medieval_weapon_part/chestplate
	name = "chestplate mold"
	desc = "About to protect."
	icon_state = "chestplate"
	edge = 1
	attack_verb = list("slashed", "cut")
	finish_product = /obj/item/clothing/suit/armor/medieval/chestplate

/obj/item/weapon/medieval_weapon_part/chestplate/silver
	finish_product = /obj/item/clothing/suit/armor/medieval/chestplate/silver

/obj/item/weapon/medieval_weapon_part/chestplate/gold
	finish_product = /obj/item/clothing/suit/armor/medieval/chestplate/gold

/obj/item/weapon/medieval_weapon_part/chestplate/mythril
	finish_product = /obj/item/clothing/suit/armor/medieval/chestplate/mythril

/obj/item/weapon/medieval_weapon_part/chestplate/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/pincers))
		var/obj/item/weapon/pincers/PINCERS = W
		to_chat(user, "<div class=warning> You grab the [src] with the [PINCERS] </div>")
		src.loc = PINCERS
		PINCERS.HELDPART = src
		return

	if(istype(W, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/MYCONTAINER = W
		for(var/datum/reagent/REAGENT in MYCONTAINER.reagents.reagent_list)
			if(REAGENT.id == "water")
				if(!shaped)
					new /obj/item/weapon/messup (loc)
					qdel(src)
					return
				hot = 0
				update_icon()
				return

	if(istype(W, /obj/item/weapon/blacksmith_hammer))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot shape the [src] here!</div>")
			return

		for(var/obj/structure/anvil/M in loc)
			if(!hot)
				new finish_product (loc)
				to_chat(user, "<div class=info> You shape the chestplate!</div>")
				qdel(src)
				return

			to_chat(user, "<div class=info> You  shape the [src]!</div>")
			shaped = 1
			return

		to_chat(user, "<div class=warning> You must shape the [src] on top of an anvil! </div>")
		return