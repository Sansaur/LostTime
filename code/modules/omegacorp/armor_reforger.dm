/obj/structure/armor_reforger
	name = "Armor reforger"
	desc = "Now you'll look 2000 years less fancy... Or you can reinforce your current armor."
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "armor_reforger_0"
	anchored = 1
	density = 1
	opacity = 0
	var/uses = 3
	var/obj/item/clothing/suit/armor/HOLDING_ARMOR

/obj/structure/armor_reforger/New()
	..()
	update_icon()

/obj/structure/armor_reforger/attack_hand(mob/user as mob)
	if(HOLDING_ARMOR)
		if(uses > 0)
			var/choice = input(user, "Choose an action", "Choosing", "Change appearance") in list("Change appearance", "Reinforce", "Take the armor out")
			if(choice == "Change appearance")
				Change_Armor(user)
				update_icon()
			if(choice == "Take the armor out")
				visible_message("[user] takes the [HOLDING_ARMOR] out of the [src]")
				HOLDING_ARMOR.loc = user.loc
				user.put_in_hands(HOLDING_ARMOR)
				HOLDING_ARMOR = null
				update_icon()
			if(choice == "Reinforce")
				if(!HOLDING_ARMOR.been_reinforced)
					Reinforce_Armor(user)
					update_icon()
				else
					to_chat(user, "The armor has already been reinforced, any more metal will make it too unsuitable for wearing")
		else
			to_chat(user, "The armor reforger doesn't have enough metal to work")
			return
	else
		to_chat(user, "There's no armor on the reforger")

/obj/structure/armor_reforger/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/clothing/suit/armor))

		user.drop_item()
		W.loc = src
		HOLDING_ARMOR = W
		update_icon()
		return
	if(istype(W, /obj/item/stack/sheet/metal))
		if(uses == 3)
			return
		var/obj/item/stack/sheet/metal/METAL = W

		if(METAL.amount >= 40)
			METAL.use(40)
			uses++
			update_icon()
		else
			to_chat(user, "There's not enough metal in that stack to make an entire metal plate for this machine")
			return
	update_icon()

/obj/structure/armor_reforger/proc/Change_Armor(mob/user as mob)
	var/possible_armors = list("Chestpiece", "Chestplate")
	var/choice
	choice = input(user, "Choose an armor appearance", "Choosing!", null) in possible_armors
	if(choice)
		uses--
		switch(choice)
			if("Chestpiece")
				flick("armor_reforger_[uses]_process",src)
			if("Chestplate")
				flick("armor_reforger_[uses]_process",src)

/obj/structure/armor_reforger/proc/Reinforce_Armor(mob/user as mob)
	uses--
	flick("armor_reforger_[uses]_process",src)
	/*ori_list = HOLDING_ARMOR.armor.Copy()
	ori_melee = ori_list[0]+4
	ori_bullet = ori_list[1]+5
	ori_laser = ori_list[2]+2
	ori_energy = ori_list[3]+2
	ori_bomb = ori_list[4]+5
	ori_bio = ori_list[5]+1
	ori_rad = ori_list[6]+2 */

	/*	Runtime in armor_reforger.dm,81: list index out of bounds
  proc name: Reinforce Armr */
	//HOLDING_ARMOR.armor = list(melee = ori_melee, bullet = ori_bullet, laser = ori_laser, energy = ori_energy, bomb = ori_bomb, bio = ori_bio, rad = ori_rad)
	/**
	* C.armor[type]
	* LOS TYPES SON STRINGS.
	**/
	HOLDING_ARMOR.armor["melee"] = HOLDING_ARMOR.armor["melee"] + rand(2,6)
	HOLDING_ARMOR.armor["bullet"] = HOLDING_ARMOR.armor["bullet"] + rand(2,6)
	HOLDING_ARMOR.armor["laser"] = HOLDING_ARMOR.armor["laser"] + rand(2,6)
	HOLDING_ARMOR.armor["energy"] = HOLDING_ARMOR.armor["energy"] + rand(2,6)
	HOLDING_ARMOR.armor["bomb"] = HOLDING_ARMOR.armor["bomb"] + rand(2,6)
	HOLDING_ARMOR.desc += " This one has been reinforced with plasteel"
	HOLDING_ARMOR.been_reinforced = 1
	update_icon()

/obj/structure/armor_reforger/update_icon()
	if(HOLDING_ARMOR)
		icon_state = "armor_reforger_[uses]_loaded"
	else
		icon_state = "armor_reforger_[uses]"