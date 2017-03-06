/*
* Clubs have low damage but they stun, they also have longer attack cooldown and the special attack
* switches between stuns and damaging strikes.
*/
/obj/item/weapon/medieval/club
	name = "club"
	desc = "Beat their heads!."
	icon_state = "club"
	ori_icon = "club"
	item_state = "club"
	flags = CONDUCT
	hitsound = 'sound/weapons/genhit3.ogg'
	slot_flags = SLOT_BELT
	force = 3
	throwforce = 1
	sharp = 0
	edge = 0
	w_class = 3
	attack_verb = list("attacked", "smashed", "beated")
	block_chance = 0
	special_cooldown = 60

/obj/item/weapon/medieval/club/dropped()
	if(durability <= 0)
		return
	update_icon()
	..()

/obj/item/weapon/medieval/club/attack_self(mob/user)
	if(!special)
		to_chat(user, "<span class=info> You are now going to beat people up </span>")
		special = 1
		if(durability >= 0)
			force = force * 3
		else
			force = initial(force) - 1
		durability_loss = durability_loss * 2
		update_icon()
	else
		to_chat(user, "<span class=info> You will now attempt to stun people instead of beating them up </span>")
		special = 0
		force = initial(force)
		durability_loss = initial(durability_loss)
		update_icon()

/obj/item/weapon/medieval/club/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(special && durability >= 0)
		if(!M)
			return
		if(M == user)
			..()
			return
		else
			..()
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/HUMAN = M
				if(prob(25))
					HUMAN.confused += 15
					HUMAN.Stun(2)
					HUMAN.Weaken(2)
			return
	else
		..()
		if(istype(M, /mob/living/carbon/human))

			var/mob/living/carbon/human/HUMAN = M
			if(durability >= 0)
				HUMAN.confused += 5
				HUMAN.Stun(6)
				HUMAN.Weaken(6)
			else
				HUMAN.Stun(2)
				HUMAN.Weaken(2)

