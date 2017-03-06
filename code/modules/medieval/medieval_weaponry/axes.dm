/*
* Dual wielded axes don't have durability and deal crazy damage when wielded
* Problem is carrying them
*/

/obj/item/weapon/twohanded/fireaxe/medieval_combat_axe  // DEM AXES MAN, marker -Agouri
	icon_state = "combatAxe0"
	name = "two-handed axe"
	desc = "RRAAAAAAAARRRRRRGGHGHGHGHGH"
	force = 5
	throwforce = 15
	sharp = 1
	edge = 1
	w_class = 5
	slot_flags = SLOT_BACK
	force_unwielded = 5
	force_wielded = 40
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/twohanded/fireaxe/medieval_combat_axe/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "combatAxe[wielded]"
	return

/*
* Regular one handed combat axes have a Power Throw ability that stuns and deals more damage if an axe is thrown while in power throw
*/
/obj/item/weapon/medieval/axe
	name = "axe"
	desc = "Chop their heads!."
	icon_state = "axe"
	ori_icon = "axe"
	item_state = "axe"
	flags = CONDUCT
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	force = 18
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "smashed", "beated")
	durability_loss = 5
	block_chance = 0
	special_cooldown = 30
	var/special_throwforce = 33
	var/stunned_time = 2.4

/obj/item/weapon/medieval/axe/dropped()
	if(durability <= 0)
		return
	update_icon()
	..()

/obj/item/weapon/medieval/axe/attack_self(mob/user)
	if(NO_SPECIAL)
		to_chat(user, "<span class=warning> You cannot use an special attack right now! </span>")
		return
	if(in_cd)
		to_chat(user, "<span class=warning> You cannot focus on a special attack right now! </span>")
		return

	to_chat(user, "<span class=info> You prepare a power throw </span>")
	special = 1
	throwforce = special_throwforce
	update_icon()
	cooldown(special_cooldown)
	to_chat(user, "<span class=info> You lost the focus for your power throw </span>")
	special = 0
	throwforce = initial(throwforce)
	update_icon()
	cooldown(special_cooldown)

/obj/item/weapon/medieval/axe/throw_impact(atom/hit_atom)
	if(..() || !iscarbon(hit_atom))//if it gets caught or the target can't be cuffed,
		return//abort
	if(!special)
		return

	var/mob/living/carbon/human/C = hit_atom
	C.Weaken(stunned_time)
	visible_message("<span class='danger'>[src] hits [C] with massive force!</span>")
	to_chat(C, "<span class='userdanger'>[src] ensnares you!</span>")
	//..()