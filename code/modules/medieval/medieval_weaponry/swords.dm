/*****

/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	var/discrete = 0 // used in item_attack.dm to make an item not show an attack message to viewers
	var/no_embed = 0 // For use in item_attack.dm
	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/blood_overlay_color = null
	var/item_state = null
	var/lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	var/righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	//Dimensions of the lefthand_file and righthand_file vars
	//eg: 32x32 sprite, 64x64 sprite, etc.
	var/inhand_x_dimension = 32
	var/inhand_y_dimension = 32

	var/r_speed = 1.0
	var/health = null
	var/hitsound = null
	var/w_class = 3
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	pass_flags = PASSTABLE
	pressure_resistance = 3
//	causeerrorheresoifixthis
	var/obj/item/master = null

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/list/actions = list() //list of /datum/action's that this item has.
	var/list/actions_types = list() //list of paths of action datums to give to the item on New().

	var/list/materials = list()
	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	var/flags_inv //This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/item_color = null
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags
	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	var/armour_penetration = 0 //percentage of armour effectiveness to remove
	var/list/allowed = null //suit storage stuff.
	var/obj/item/device/uplink/hidden/hidden_uplink = null // All items can have an uplink hidden inside, just remember to add the triggers.

	var/needs_permit = 0			//Used by security bots to determine if this item is safe for public use.

	var/strip_delay = DEFAULT_ITEM_STRIP_DELAY
	var/put_on_delay = DEFAULT_ITEM_PUTON_DELAY
	var/breakouttime = 0

	var/flags_size = 0 //flag, primarily used for clothing to determine if a fatty can wear something or not.

	var/block_chance = 0
	var/hit_reaction_chance = 0 //If you want to have something unrelated to blocking/armour piercing etc. Maybe not needed, but trying to think ahead/allow more freedom

	/* Species-specific sprites, concept stolen from Paradise//vg/.
	ex:
	sprite_sheets = list(
		"Tajaran" = 'icons/cat/are/bad'
		)
	If index term exists and icon_override is not set, this sprite sheet will be used.
	*/
	var/list/sprite_sheets = null
	var/icon_override = null  //Used to override hardcoded clothing dmis in human clothing proc.
	var/sprite_sheets_obj = null //Used to override hardcoded clothing inventory object dmis in human clothing proc.
	var/list/species_fit = null //This object has a different appearance when worn by these species
*******/

/**
	SWORDS GET THE SLICING STRIKE ATTACK

	- While on Slicing Strike the chance of blocking is 0
	- While on Slicing Strike the attacks take 0.8 seconds to be performed
	- The attacks while on Slicing Strike deal 15 extra damage.
**/


/obj/item/weapon/medieval/sword
	name = "longsword"
	desc = "A powerful tool for various uses, the main one being killing."
	icon_state = "sword"
	ori_icon = "sword"
	item_state = "sword"
	flags = CONDUCT
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	force = 25
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 15
	special_cooldown = 60

/obj/item/weapon/medieval/sword/dropped()
	icon_state = "[ori_icon]"
	update_icon()
	..()

/obj/item/weapon/medieval/sword/attack_self(mob/user)
	if(NO_SPECIAL)
		to_chat(user, "<span class=warning> You cannot use an special attack right now! </span>")
		return
	if(in_cd)
		to_chat(user, "<span class=warning> You cannot focus on a slicing strike right now! </span>")
		return

	to_chat(user, "<span class=info> You prepare a slicing strike </span>")
	block_chance = 0
	special = 1
	icon_state = "[ori_icon]_special"
	src.force += 15
	update_icon()
	cooldown(special_cooldown)
	to_chat(user, "<span class=info> You lost the focus for your slicing strike </span>")
	src.force -= 15
	block_chance = 15
	special = 0
	icon_state = "[ori_icon]"
	update_icon()

/obj/item/weapon/medieval/sword/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(special)
		if(!M)
			return
		else
			visible_message("<span class='danger'>[user] is attempting to perform a slicing strike on [M]!.</span>")
			to_chat(M, "<span class=userdanger>[user] is attempting to slicing strike you!!</span>")
			if(do_after(user, 13, target = M))
				//var/mob/living/carbon/human/H = M
				visible_message("<span class='danger'>[user] has sliced [M]!.</span>")
				..()
				return
			else
				visible_message("[user] misses his slicing strike!")
	else
		..()
