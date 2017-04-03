/obj/item/weapon/medieval_weapon_part
	name = "medieval weapon part"
	desc = "CONTACT AN ADMIN IF YOU SEE THIS."
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = ""
	force = 5
	throwforce = 5
	w_class = 2
	attack_verb = list("punctured", "pinched")
	block_chance = 0
	var/shaped = 0
	var/hot = 1
	var/finish_product

/obj/item/weapon/medieval_weapon_part/attack_hand(mob/user as mob)
	if(!hot)
		..()
	else
		to_chat(user, "<div class=userdanger> THAT BURNED!! </div>")

		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/affecting = H.get_organ("[user.hand ? "l" : "r" ]_hand")
			if(affecting.take_damage( 0, 5 ))		// 5 burn damage
				H.UpdateDamageIcon()
			H.updatehealth()
			H.drop_item()
			return

		if(istype(user, /mob/living))
			var/mob/living/ARGH = user
			ARGH.adjustFireLoss(10)
			return

/obj/item/weapon/medieval_weapon_part/New()
	..()
	update_icon()

/obj/item/weapon/medieval_weapon_part/update_icon()
	if(hot)
		icon_state = "[icon_state]_hot"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/medieval_weapon_part/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/pincers))
		var/obj/item/weapon/pincers/PINCERS = W
		to_chat(user, "<div class=warning> You grab the [src] with the [PINCERS] </div>")
		src.loc = PINCERS
		PINCERS.HELDPART = src
		return

	if(istype(W, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/MYCONTAINER = W
		for(var/datum/reagent/REAGENT in MYCONTAINER.reagents.reagent_list)
			if(REAGENT.id == "water")
				if(!shaped)
					new /obj/item/weapon/messup (loc)
					qdel(src)
					return
				hot = 0
				update_icon()
				return

	if(istype(W, /obj/item/weapon/blacksmith_hammer))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot shape the [src] here!</div>")
			return


		for(var/obj/structure/anvil/M in loc)
			to_chat(user, "<div class=info> You  shape the [src]!</div>")
			shaped = 1
			return

		to_chat(user, "<div class=warning> You must shape the [src] on top of an anvil! </div>")
		return

/obj/item/weapon/messup
	name = "unshaped whatever-this-is"
	desc = "oops."
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "messup"
	force = 9
	throwforce = 5
	w_class = 2
	attack_verb = list("sliced", "cut")
	block_chance = 0