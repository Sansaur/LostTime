/*

	This is the medieval defense text.

*	- Chestplate
		- Made by shaping a chestplate mold on an anvil, super easy stuff

*	- Chainmail
		- Made by putting together 10 ore rings (which are handwear)
		- Rings are made by using a hammer and chisel on an anvil while wearing an eye-magnifying glass

*	- Armor
		- Made by putting together a chestplate + greaves on an armor rack, then using leather on it to keep it together, and then adjusting it with the hammer.
		- Chestplate is made as stated before.
		- Greaves are made by making two leg guards (mold) putting them together on an armor rack and then using leather on them.

*	- Heavy armor
		- This is made by putting together an armor, a chestplate, shoulder armor and hand guards putting it all on the armor rack and then using a lot of leather to keep it together, also, you can put the cape if you want it with cape, then finish with hammer.
		- Shoulder armor is made by melting two shoulder pads, and then just putting them together by clicking, no leather for this one

	- Greaves

	- Helmets

	- Hand guards

	- Shields


	HELMETS AND SHIELDS ARE MISSSING!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -SANSAUR
*/


/obj/item/clothing/suit/armor/medieval/chestplate
	name = "chestplate"
	desc = "Chestplate."
	icon_state = "bloody_armor"
	item_state = "bloody_armor"
	species_fit = null
	sprite_sheets = null
	body_parts_covered = UPPER_TORSO
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 5, bomb = 10, bio = 0, rad = 0)
	burn_state = FIRE_PROOF
	var/leg_types = /obj/item/clothing/shoes/medieval/greaves
	var/finish_product = /obj/item/clothing/suit/armor/medieval/full_armor

/obj/item/clothing/suit/armor/medieval/chestplate/silver
	name = "Silver chestplate"
	color = "#C0C0C0"
	leg_types = /obj/item/clothing/shoes/medieval/greaves/silver
	finish_product = /obj/item/clothing/suit/armor/medieval/full_armor/silver

/obj/item/clothing/suit/armor/medieval/chestplate/gold
	name = "Gold chestplate"
	color = "#FFFACD"
	leg_types = /obj/item/clothing/shoes/medieval/greaves/gold
	finish_product = /obj/item/clothing/suit/armor/medieval/full_armor/gold

/obj/item/clothing/suit/armor/medieval/chestplate/mythril
	name = "Mythril chestplate"
	color = "#00FFFF"
	leg_types = /obj/item/clothing/shoes/medieval/greaves/mythril
	finish_product = /obj/item/clothing/suit/armor/medieval/full_armor/mythril

/obj/item/clothing/suit/armor/medieval/chestplate/attackby(obj/item/W, mob/user as mob)
	..()

	if(istype(W, leg_types))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot tie the [src] here!</div>")
			return

		for(var/obj/structure/armor_rack/M in loc)
			to_chat(user, "<div class=info> You make a full armor!</div>")
			new finish_product (loc)
			qdel(W)
			qdel(src)
			return

		to_chat(user, "<div class=warning> You must tie the [src] on top of an armor rack! </div>")
		return


/obj/item/clothing/suit/armor/medieval/chainmail
	name = "chainmail"
	desc = "A vest drenched in the blood of Greytide. It has seen better days."
	icon_state = "bloody_armor"
	item_state = "bloody_armor"
	species_fit = null
	sprite_sheets = null
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 30, bullet = 15, laser = 15, energy = 5, bomb = 15, bio = 0, rad = 0)
	burn_state = FIRE_PROOF


/obj/item/clothing/suit/armor/medieval/chainmail/silver
	name = "Silver chainmail"
	color = "#C0C0C0"

/obj/item/clothing/suit/armor/medieval/chainmail/gold
	name = "Gold chainmail"
	color = "#FFFACD"

/obj/item/clothing/suit/armor/medieval/chainmail/mythril
	name = "Mythril chainmail"
	color = "#00FFFF"


/obj/item/clothing/suit/armor/medieval/full_armor
	name = "armor"
	desc = "A vest drenched in the blood of Greytide. It has seen better days."
	icon_state = "bloody_armor"
	item_state = "bloody_armor"
	species_fit = null
	sprite_sheets = null
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|FEET
	armor = list(melee = 50, bullet = 25, laser = 15, energy = 25, bomb = 35, bio = 0, rad = 0)
	strip_delay = 70
	burn_state = FIRE_PROOF
	var/shoulder_type = /obj/item/weapon/shoulder_pads
	var/chest_type = /obj/item/clothing/suit/armor/medieval/chestplate
	var/hand_type = /obj/item/clothing/gloves/medieval/hand_guards
	var/result_type = /obj/item/clothing/suit/armor/medieval/heavy_armor
	var/shouldered = 0
	var/chested = 0
	var/handed = 0

/obj/item/clothing/suit/armor/medieval/full_armor/silver
	name = "Silver armor"
	color = "#C0C0C0"
	shoulder_type = /obj/item/weapon/shoulder_pads/silver
	chest_type = /obj/item/clothing/suit/armor/medieval/chestplate/silver
	hand_type = /obj/item/clothing/gloves/medieval/hand_guards/silver
	result_type = /obj/item/clothing/suit/armor/medieval/heavy_armor/silver

/obj/item/clothing/suit/armor/medieval/full_armor/gold
	name = "Gold armor"
	color = "#FFFACD"
	shoulder_type = /obj/item/weapon/shoulder_pads/gold
	chest_type = /obj/item/clothing/suit/armor/medieval/chestplate/gold
	hand_type = /obj/item/clothing/gloves/medieval/hand_guards/gold
	result_type = /obj/item/clothing/suit/armor/medieval/heavy_armor/gold

/obj/item/clothing/suit/armor/medieval/full_armor/mythril
	name = "Mythril armor"
	color = "#00FFFF"
	shoulder_type = /obj/item/weapon/shoulder_pads/mythril
	chest_type = /obj/item/clothing/suit/armor/medieval/chestplate/mythril
	hand_type = /obj/item/clothing/gloves/medieval/hand_guards/mythril
	result_type = /obj/item/clothing/suit/armor/medieval/heavy_armor/mythril

/obj/item/clothing/suit/armor/medieval/full_armor/attackby(obj/item/W, mob/user as mob)
	..()

	if(istype(W, shoulder_type))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot work the [src] here!</div>")
			return

		for(var/obj/structure/armor_rack/M in loc)
			to_chat(user, "<div class=info> You add the shoulderpads to the [src]!</div>")
			shouldered = 1
			qdel(W)
			check_full_armor()
			return

		to_chat(user, "<div class=warning> You must work with the [src] on top of an armor rack! </div>")
		return

	if(istype(W, hand_type))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot work the [src] here!</div>")
			return

		for(var/obj/structure/armor_rack/M in loc)
			to_chat(user, "<div class=info> You add the hand guards to the [src]!</div>")
			handed = 1
			qdel(W)
			check_full_armor()
			return

		to_chat(user, "<div class=warning> You must work with the [src] on top of an armor rack! </div>")
		return

	if(istype(W, chest_type))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot work the [src] here!</div>")
			return

		for(var/obj/structure/armor_rack/M in loc)
			to_chat(user, "<div class=info> You add the chestplate to the [src]!</div>")
			chested = 1
			qdel(W)
			check_full_armor()
			return

		to_chat(user, "<div class=warning> You must work with the [src] on top of an armor rack! </div>")
		return

/obj/item/clothing/suit/armor/medieval/full_armor/proc/check_full_armor()
	if(shouldered && chested && handed)
		//It deserves this for now
		playsound(loc, 'sound/weapons/shotgunpump.ogg', 50, 1)
		new result_type (loc)
		qdel(src)
	else
		return

/obj/item/clothing/suit/armor/medieval/heavy_armor
	name = "heavy armor"
	desc = "A vest drenched in the blood of Greytide. It has seen better days."
	icon_state = "bloody_armor"
	item_state = "bloody_armor"
	species_fit = null
	sprite_sheets = null
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|FEET|HANDS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|FEET|HANDS
	armor = list(melee = 70, bullet = 35, laser = 35, energy = 35, bomb = 55, bio = 0, rad = 0)
	strip_delay = 140
	burn_state = FIRE_PROOF


/obj/item/clothing/suit/armor/medieval/heavy_armor/silver
	name = "Silver heavy armor"
	color = "#C0C0C0"

/obj/item/clothing/suit/armor/medieval/heavy_armor/gold
	name = "Gold heavy armor"
	color = "#FFFACD"

/obj/item/clothing/suit/armor/medieval/heavy_armor/mythril
	name = "Mythril heavy armor"
	color = "#00FFFF"




/////////////////////// GREAVES

/obj/item/clothing/shoes/medieval/greaves //basic syndicate combat boots for nuke ops and mob corpses
	name = "greaves"
	desc = "Greaves."
	can_cut_open = 1
	icon_state = "jackboots"
	item_state = "jackboots"
	armor = list(melee = 15, bullet = 10, laser = 10, energy = 25, bomb = 30, bio = 10, rad = 0)
	strip_delay = 50
	burn_state = FIRE_PROOF


/obj/item/clothing/shoes/medieval/greaves/silver
	name = "Silver greaves"
	color = "#C0C0C0"

/obj/item/clothing/shoes/medieval/greaves/gold
	name = "Gold greaves"
	color = "#FFFACD"

/obj/item/clothing/shoes/medieval/greaves/mythril
	name = "Mythril greaves"
	color = "#00FFFF"




/////////////////////// HELMET

/obj/item/clothing/head/medieval/helmet //basic syndicate combat boots for nuke ops and mob corpses
	name = "helmet"
	desc = "helmet."
	icon_state = "bowler_hat"
	item_state = "bowler_hat"
	armor = list(melee = 15, bullet = 10, laser = 10, energy = 25, bomb = 30, bio = 10, rad = 0)
	strip_delay = 50
	burn_state = FIRE_PROOF
	// List IDs must match with what we want to do
	var/list/ICON_STATES = list("bowler_hat", "gladiator")
	var/list/ITEM_STATES = list("bowler_hat", "gladiator")
	// List IDs must match with what we want to do
	var/chosen_list_id = 1
	var/max_id

/obj/item/clothing/head/medieval/helmet/New()
	..()
	max_id = ICON_STATES.len

/obj/item/clothing/head/medieval/helmet/update_icon()
	..()
	icon_state = ICON_STATES[chosen_list_id]
	item_state = ITEM_STATES[chosen_list_id]

/obj/item/clothing/head/medieval/helmet/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/blacksmith_hammer))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot work the [src] here!</div>")
			return

		for(var/obj/structure/armor_rack/M in loc)
			to_chat(user, "<div class=info> You change the design of [src]!</div>")
			chosen_list_id++
			if(chosen_list_id > max_id)
				chosen_list_id = 1

			update_icon()
			return

/obj/item/clothing/head/medieval/helmet/silver
	name = "Silver helmet"
	color = "#C0C0C0"
	ICON_STATES = list("bunny", "enhead")
	ITEM_STATES = list("bunny", "enhead")

/obj/item/clothing/head/medieval/helmet/gold
	name = "Gold helmet"
	color = "#FFFACD"
	ICON_STATES = list("amp", "pirate")
	ITEM_STATES = list("amp", "pirate")

/obj/item/clothing/head/medieval/helmet/mythril
	name = "Mythril helmet"
	color = "#00FFFF"
	ICON_STATES = list("knight_templar", "winterhood")
	ITEM_STATES = list("knight_templar", "winterhood")



/////////////////////// GLOVES

/obj/item/clothing/gloves/medieval/hand_guards
	desc = "hand_guards."
	name = "hand guards"
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 15, bomb = 10, bio = 10, rad = 0)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	burn_state = FIRE_PROOF


/obj/item/clothing/gloves/medieval/hand_guards/silver
	name = "Silver hand guards"
	color = "#C0C0C0"

/obj/item/clothing/gloves/medieval/hand_guards/gold
	name = "Gold hand guards"
	color = "#FFFACD"

/obj/item/clothing/gloves/medieval/hand_guards/mythril
	name = "Mythril hand guards"
	color = "#00FFFF"


/////////////////////// SHOULDER PADS
/////////////////////// THESE AREN'T ACTUALLY ARMOR, BUT THEY ARE USED TO MAKE ARMOR

/obj/item/weapon/shoulder_pads
	name = "shoulder pad"
	desc = "It's shouldery."
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "shoulder_pads"
	edge = 0
	attack_verb = list("cut", "smashed")

/obj/item/weapon/shoulder_pads/silver
	name = "silver shoulder pad"
	color = "#C0C0C0"
/obj/item/weapon/shoulder_pads/gold
	name = "gold shoulder pad"
	color = "#FFFACD"
/obj/item/weapon/shoulder_pads/mythril
	name = "mythril shoulder pad"
	color = "#00FFFF"