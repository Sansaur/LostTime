/*
* Katanas have amazing damage but they lose their durability super quick
* Their special attack has a great chance to tear limbs
*/
/obj/item/weapon/medieval/katana
	name = "katana"
	desc = "Time to show them what a true warrior is."
	icon_state = "katana"
	ori_icon = "katana"
	item_state = "katana"
	flags = CONDUCT
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	force = 30
	throwforce = 1
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "cut", "diced")
	block_chance = 0
	special_cooldown = 25
	durability_loss = 10
	var/long_cooldown = 120

/obj/item/weapon/medieval/katana/dropped()
	if(durability <= 0)
		return
	update_icon()
	..()

/obj/item/weapon/medieval/katana/attack_self(mob/user)
	if(NO_SPECIAL)
		to_chat(user, "<span class=warning> You cannot use an special attack right now! </span>")
		return
	if(in_cd)
		to_chat(user, "<span class=warning> You cannot focus on a tearing strike right now! </span>")
		return

	playsound(loc, 'sound/weapons/katana_unsheath.ogg',75,1)
	to_chat(user, "<span class=info> You prepare a tearing strike </span>")
	special = 1
	update_icon()
	cooldown(special_cooldown)
	to_chat(user, "<span class=info> You lost the focus for your tearing strike </span>")
	special = 0
	update_icon()
	cooldown(long_cooldown)

/obj/item/weapon/medieval/katana/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	update_icon()
	if(special && durability >= 0)
		if(!M)
			return
		if(M == user)
			..()
			return
		else
			..()
			if(istype(M, /mob/living/carbon/human) && istype(user, /mob/living/carbon/human))
				var/mob/living/carbon/human/TARGET = M
				var/mob/living/carbon/human/USER = user
				var/obj/item/organ/external/affecting = TARGET.get_organ(ran_zone(user.zone_sel.selecting))
				if(prob(durability)) //The better state the katana is, the better chance it has to intantly kill
					var/obj/item/organ/external/TO_CUT = TARGET.get_limb_by_name(affecting.limb_name) //Nombre del limb
					visible_message("<span class=danger> [TARGET]'s [TO_CUT] is torn apart by [USER]'s [src] </span>")
					TO_CUT.droplimb(-1, DROPLIMB_EDGE, 0, 0)
			return
	else
		..()

