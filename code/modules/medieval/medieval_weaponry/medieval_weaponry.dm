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
	var/durability = 100 //DAMN SON!!
	var/durability_loss = 1
	var/NO_SPECIAL = 0

/obj/item/weapon/medieval/attack()
	Use_Durability(durability_loss)
	..()

/obj/item/weapon/medieval/proc/Use_Durability(var/durability_loss)
	durability -= durability_loss
	if(durability < 0)
		Break_Weapon()

/obj/item/weapon/medieval/proc/Break_Weapon()
	visible_message("<span class=warning> The [src] breaks! </span>")
	ori_icon = "[icon_state]_broken"
	icon_state = "[icon_state]"
	force = force * 0.25
	NO_SPECIAL = 1
	update_icon()

/obj/item/weapon/medieval/proc/cooldown(var/cooldown)
	in_cd = 1
	sleep(cooldown)
	in_cd = 0
