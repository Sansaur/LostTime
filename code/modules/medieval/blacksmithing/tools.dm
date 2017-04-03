/obj/item/weapon/pincers
	name = "pincers"
	desc = "pinchy piinchy."
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "pincers"
	force = 6
	throwforce = 6
	w_class = 2
	attack_verb = list("punctured", "pinched")
	block_chance = 0
	var/obj/item/weapon/medieval_weapon_part/HELDPART

/obj/item/weapon/pincers/attack_self(mob/user as mob)
	if(HELDPART)
		HELDPART.loc = user.loc
		to_chat(user, "<div class=warning> You dropped the [HELDPART] </div>")
		HELDPART = null
		return

/obj/item/weapon/blacksmith_hammer
	name = "blacksmith hammer"
	desc = "the hammer used by the blacksmith to do his smithy smithing."
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "blacksmith_hammer"
	force = 6
	throwforce = 6
	w_class = 2
	attack_verb = list("punctured", "pinched")
	block_chance = 0