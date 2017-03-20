/obj/item/weapon/comb
	name = "comb"
	desc = "Hmmmm~."
	icon = 'icons/obj/items.dmi'
	icon_state = "comb"
	force = 4
	throwforce = 2
	w_class = 2
	attack_verb = list("attacked", "smashed")
	block_chance = 0

/obj/item/weapon/comb/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(!M)
		return
	else if(M.a_intent == I_HELP)
		visible_message("<span class='notice'>[user] is combing [M], remember to make this check for species later.</span>")
		to_chat(M, "<span class=notice>[user] is attempting to comb your hair!</span>")
		if(do_after(user, 15, target = M))
			//var/mob/living/carbon/human/H = M
			visible_message("[user] has combed [M]'s hair.")
			..()
			return
		else
			visible_message("[M] didn't want \his hair combed!")
	else
		..()

/obj/item/weapon/sewing_needle
	name = "sewing needle"
	desc = "Owchies."
	icon = 'icons/obj/items.dmi'
	icon_state = "sewing_needle"
	force = 1
	throwforce = 2
	w_class = 2
	attack_verb = list("punctured", "pinched")
	block_chance = 0

/obj/item/weapon/drying_paddle
	name = "drying paddle"
	desc = "Used by mothers to punish their children."
	icon = 'icons/obj/items.dmi'
	icon_state = "paddle"
	force = 8
	throwforce = 2
	w_class = 2
	attack_verb = list("attacked", "paffed")
	block_chance = 0