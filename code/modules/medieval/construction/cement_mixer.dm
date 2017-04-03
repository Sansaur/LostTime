/*
* The mixer is where you make cements and maybe other mixtures in the future
* The mixer needs water to function.
* The idea is that it's like a tiny mill that grinds the stone into dust and mixes it with water.
* First the rocks will have to be made gravel in another crusher though
* Also, the way the cement mixer works is by making you rotate around it as it spins
* When the cement mixer has 100 cement you can make a bag out of it
*/


/obj/structure/cement_mixer
	name = "cement mixer"
	desc = "crush it, boi"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "cement_mixer0"
	opacity = 0
	density = 1
	anchored = 1
	var/pos = 0	// 0 = Gotta be on the sides | 1 = Gotta be on top or bottom
	var/cement = 0
	var/obj/item/stack/sheet/mineral/stone/StoredStone
	var/water = 100
	var/min_efficiency = 8
	var/max_efficiency = 13
	var/max_water = 200
	var/icky = 0	//If you put something that isn't water in the reagents the cement mixer must be cleaned

/obj/structure/cement_mixer/update_icon()
	if(icky)
		icon_state = "cement_mixer_icky"
		return

	icon_state = "cement_mixer[pos]"
	if(cement < 25 && cement > 0)
		desc = "crush it, boi, the [src]'s cement still looks rocky"
	else if(cement >= 25 && cement < 100)
		desc = "crush it, boi, the [src]'s cement looks like it's getting worked"
	else if(cement >= 100)
		desc = "crush it, boi, the [src]'s cement looks ready to get bagged"
	else
		desc = "crush it, boi"

/obj/structure/cement_mixer/attack_hand(mob/user as mob)
	if(icky)
		to_chat(user, "The [src] is in no state to be worked with right now")
		return

	// Monsters cannot mill cement
	if(istype(user, /mob/living/carbon/human))
		if(check_needed(user))
			if(pos==0)
				if(StoredStone)
					if(StoredStone.use(1))
						playsound(src, 'sound/effects/meteorimpact.ogg',60,0)
						to_chat(user, "<div class=info> You mill some stone with the water </div>")
						pos = !pos
						cement += rand(min_efficiency, max_efficiency)
						water -= rand(0, min_efficiency)
						update_icon()
						return
					else
						to_chat(user, "<div class=warning> There's not enough stone in the [src]! </div>")
						return
				else
					to_chat(user, "<div class=warning> There's no stone loaded in the [src]!")
					return
			else
				pos = !pos
				update_icon()
				return


/obj/structure/cement_mixer/attackby(obj/item/W, mob/user as mob)
	if(icky)
		to_chat(user, "The [src] is in no state to be worked with right now")
		return

	if(istype(W, /obj/item/stack/sheet/mineral/stone))
		if(StoredStone)
			to_chat(user, "<div class=warning> [src] already has [StoredStone]! </div>")
			update_icon()
			return
		var/obj/item/stack/sheet/mineral/stone/M = W
		to_chat(user, "You load the [W] in the [src]")
		user.drop_item()
		StoredStone = M
		M.loc = src
		return

	if(istype(W, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/MYCONTAINER = W
		for(var/datum/reagent/REAGENT in MYCONTAINER.reagents.reagent_list)
			if(REAGENT.id == "water")
				if(REAGENT.volume < MYCONTAINER.amount_per_transfer_from_this)
					to_chat(user, "<div class=warning> There's not enough water to transfer! </div>")
					return

				to_chat(user, "<div class=info> you add [MYCONTAINER.amount_per_transfer_from_this] units of water into the [src] </div>")
				water += MYCONTAINER.amount_per_transfer_from_this
				MYCONTAINER.reagents.remove_reagent("water", MYCONTAINER.amount_per_transfer_from_this)
				// Max water
				if(water >= max_water)
					to_chat(user, "<div class=info> some of the water spilled off the [src] </div>")
					water = max_water

				qdel(REAGENT)
				return
			else
				icky = 1
				update_icon()
				continue




/obj/structure/cement_mixer/proc/check_needed(mob/living/carbon/human/user)
	if(water <= 0)
		to_chat(user, "There's not enough water")
		return 0
	if(cement >= 100)
		to_chat(user, "There's cement ready to be bagged")
		return 0
	if(pos == 0)
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(direction == 1 || direction == 2)
				if(user in T)
					to_chat(user, "<div class=warning> Wrong place! </div>")
					return 0
			else
				if(user in T)
					return 1
	else
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(direction == 1 || direction == 2)
				if(user in T)
					return 1
			else
				if(user in T)
					to_chat(user, "<div class=warning> Wrong place! </div>")
					return 0



/obj/structure/cement_mixer/verb/make_cement()
	set name = "Bag cement"
	set desc = "Make some cement bags"
	set category = "Object"
	set src in oview(1)


	// kinda shitty, redo when cement is a chemical
	if(cement >= 100)
		playsound(loc,'sound/effects/shovel_dig.ogg',100,1)
		new /obj/item/weapon/cement_bag (src.loc)
		cement = 0
	else
		to_chat(usr, "<div class=warning> The cement is not ready! </div>")
		return

/obj/structure/cement_mixer/verb/pull_stone()
	set name = "Pull stones"
	set desc = "Just in case you need... stones"
	set category = "Object"
	set src in oview(1)

	// kinda shitty, redo when cement is a chemical
	if(istype(usr, /mob/living/carbon/human))
		if(pos)
			to_chat(usr, "<div class=warning> You must lift the [src] first")
			return

		if(StoredStone)
			to_chat(usr, "<div class=info> You pull the stone out of the [src] </div>")
			StoredStone.loc = usr.loc
			StoredStone = null
			return
		else
			to_chat(usr, "<div class=warning> There's no stone in the [src]</div>")
			return