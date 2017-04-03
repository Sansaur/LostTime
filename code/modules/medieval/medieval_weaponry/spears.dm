/*
* Spears have low damage but during their special attack their strikes push the enemy one tile backwards
*
*/
/obj/item/weapon/medieval/spear
	name = "spear"
	desc = "The spear is a weapon mainly used to keep enemies at a distance and pierce their defenses."
	icon_state = "spear"
	ori_icon = "spear"
	item_state = "spear"
	flags = CONDUCT
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	force = 18
	throwforce = 10
	sharp = 1
	edge = 0
	w_class = 4
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	block_chance = 0
	special_cooldown = 60
	durability_loss = 3

/obj/item/weapon/medieval/spear/dropped()
	if(durability <= 0)
		return
	update_icon()
	..()

/obj/item/weapon/medieval/spear/attack_self(mob/user)
	if(NO_SPECIAL)
		to_chat(user, "<span class=warning> You cannot use an special attack right now! </span>")
		return
	if(in_cd)
		to_chat(user, "<span class=warning> You cannot focus on a pushing move right now! </span>")
		return

	to_chat(user, "<span class=info> You prepare a pushing move </span>")
	special = 1
	update_icon()
	cooldown(special_cooldown)
	to_chat(user, "<span class=info> You lost the focus for your pushing move </span>")
	special = 0
	update_icon()
	cooldown(special_cooldown)

/obj/item/weapon/medieval/spear/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(special)
		if(!M)
			return
		if(M.lying)
			..()
			return
		if(M == user)
			..()
			return
		else
			visible_message("<span class='danger'>[user] Pushes [M] backwards!.</span>")
			//to_chat(M, "<span class=userdanger>[user] has pushed you backwards!</span>")
			..()
			M.Move(get_step(M, user.dir))
			return
	else
		..()

/////// TYPES
/// These need new icons, stats, color, etc.

/obj/item/weapon/medieval/spear/silver
	name = "Silver spear"
	color = "#C0C0C0"

/obj/item/weapon/medieval/spear/gold
	name = "Gold spear"
	color = "#FFFACD"

/obj/item/weapon/medieval/spear/mythril
	name = "Mythril spear"
	color = "#00FFFF"