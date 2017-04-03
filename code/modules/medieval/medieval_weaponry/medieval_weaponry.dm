/obj/item/weapon/medieval
	name = "longsword"
	desc = "A powerful tool for various uses, the main one being killing."
	icon = 'icons/obj/medieval_weapons.dmi'
	icon_state = "sword"
	var/ori_icon = "sword"
	item_state = "sword"
	flags = CONDUCT
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	force = 30
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 15
	var/special = 0
	var/special_cooldown = 60
	var/in_cd = 0
	var/max_durability = 100
	var/durability = 100 //DAMN SON!!
	var/durability_loss = 1
	var/NO_SPECIAL = 0
	var/material_for_repair = /obj/item/stack/sheet/metal		//What is used to repair the weapon

/obj/item/weapon/medieval/attack()
	..()
	Use_Durability(durability_loss)

/obj/item/weapon/medieval/proc/Use_Durability(var/durability_loss)
	durability -= durability_loss
	if(durability < 0)
		Break_Weapon()

/obj/item/weapon/medieval/update_icon()
	if(durability <= 0)
		icon_state = "[ori_icon]_broken"
		..()
		return
	if(special && !isturf(loc))
		icon_state = "[ori_icon]_special"
	else
		icon_state = "[ori_icon]"
	..()
/obj/item/weapon/medieval/proc/Break_Weapon()
	if(NO_SPECIAL)
		return
	visible_message("<span class=warning> [src] breaks! </span>")
	icon_state = "[ori_icon]_broken"
	force = force * 0.25
	NO_SPECIAL = 1
	update_icon()

/obj/item/weapon/medieval/proc/cooldown(var/cooldown)
	in_cd = 1
	sleep(cooldown)
	in_cd = 0

/obj/item/weapon/medieval/proc/can_be_repaired()
	if(!isturf(loc))
		return 0
	if(durability >= max_durability)
		return 0
	for(var/obj/item/W in loc)
		if(W.type == material_for_repair)
			return 1

	return 0

/obj/item/weapon/medieval/proc/repair()
	visible_message("<span class=info> [src] is repaired! </span>")
	icon_state = "[ori_icon]"
	force = initial(force)
	NO_SPECIAL = 0
	update_icon()