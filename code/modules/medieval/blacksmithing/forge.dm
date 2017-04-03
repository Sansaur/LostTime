/obj/structure/forge
	name = "forge"
	desc = "A fucking forge"
	icon = 'icons/medieval/32x48.dmi'
	icon_state = "forge"
	opacity = 1
	anchored = 1
	density = 1
	layer = 3
	var/open = 0
	var/fuel_needed = 5
	var/smelting = 0
	var/fuel = 50	//Fuel gets restored with wood and birch, evetually coal
	var/list/obj/item/weapon/ore/ORES = list()		// A list with all raw ores loaded
	var/list/obj/item/weapon/mold/ingot/MOLDS = list()	// A list wil all molds
	var/max_molds = 5
	//	refined_type = /obj/item/stack/sheet/mineral/diamond this is for ores to then get smelted

/obj/structure/forge/New()
	..()
	var/obj/structure/forge_lever/MYLEVER = new /obj/structure/forge_lever (loc)
	MYLEVER.MYFORGE = src
	return

/obj/structure/forge/update_icon()
	if(smelting)
		icon_state = "forge_smelting"
		return
	if(open)
		icon_state = "forge_open"
		return
	else
		icon_state = "forge"
		return

/obj/structure/forge/attack_hand(mob/user as mob)
	if(smelting)
		burnUser(user)
		return

	open = !open
	update_icon()

//////////////////////////// HREF

// QUITAMOS mob/user as mob

/obj/structure/forge/verb/ShowList()
	set name = "Show ores"
	set desc = "A list with the ores inside"
	set category = "Object"
	set src in oview(1)


	if(!open)
		to_chat(usr, "<div class=warning> The [src] is closed! </div>")
		return

	usr.set_machine(src)
	var/dat

	dat += text(" Forge <br>")
	dat += text("ORES <hr> ")
	for(var/i=1;i<ORES.len+1;i++)
		var/obj/item/weapon/ore/ORE = ORES[i]
		dat += text("<A href='?src=[UID()];choice=[i]'>[ORE.name].</A><br>")


	dat += text("<hr> MOLDS <hr> ")

	for(var/i=1;i<MOLDS.len+1;i++)
		var/obj/item/weapon/mold/ingot/MYMOLD = MOLDS[i]
		dat += text("<A href='?src=[UID()];choice_2=[i]'>[MYMOLD.name].</A><br>")

	var/datum/browser/popup = new(usr, "forge_window", "Forge", 400, 500)
	popup.set_content(dat)
	popup.open()
	return


/obj/structure/forge/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		ReleaseOre(text2num(href_list["choice"]))
	if(href_list["choice_2"])
		ReleaseMold(text2num(href_list["choice_2"]))
	return

/obj/structure/forge/proc/ReleaseOre(var/ID)
	var/obj/item/weapon/ore/MYORE = ORES[ID]
	MYORE.loc = src.loc
	ORES.Remove(MYORE)
	return

/obj/structure/forge/proc/ReleaseMold(var/ID)
	var/obj/item/weapon/mold/ingot/MYMOLD = MOLDS[ID]
	MYMOLD.loc = src.loc
	MOLDS.Remove(MYMOLD)
	return


//////////////////////////// BURNING IF YOU FUCK UP!!

/obj/structure/forge/proc/burnArea()
	flick("forge_fire",src)
	visible_message("<div class=danger> WHAAAAM!! </div>")
	// THIS DOES NOTHIGN FOR NOW - SANSAUR

/obj/structure/forge/proc/burnUser(mob/user)
	to_chat(user, "<div class=userdanger> THAT BURNED!! </div>")

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ("[user.hand ? "l" : "r" ]_hand")
		if(affecting.take_damage( 0, 15 ))		// 15 burn damage
			H.UpdateDamageIcon()
		H.updatehealth()
		return

	if(istype(user, /mob/living))
		var/mob/living/ARGH = user
		ARGH.adjustFireLoss(10)
		return

/////////////////////////////////// SMELTING THE ORES

/obj/structure/forge/proc/smelt()
	if(open)
		burnArea()
		return

	set_light(9, 2, LIGHT_COLOR_ORANGE)
	smelting = 1
	update_icon()
	sleep(50)
	set_light(0)
	smelting = 0
	update_icon()

	smelt_ores()

/obj/structure/forge/proc/smelt_ores()
	for(var/obj/item/weapon/ore/MYORE in ORES)
		for(var/obj/item/weapon/mold/ingot/MYMOLD in MOLDS)
			if(MYMOLD.LOADED_INGOT)
				continue
			else
				MYMOLD.LOADED_INGOT = new MYORE.refined_type ()
				ORES.Remove(MYORE)
				qdel(MYORE)


/obj/structure/forge/attackby(obj/item/W, mob/user as mob)
	if(!open)
		to_chat(user, "<div class=warning> The [src] is closed! </div>")
		return

	if(istype(W, /obj/item/weapon/mold/ingot))
		if(MOLDS.len >= max_molds)
			to_chat(user, "<div class=warning> There are already too many molds in the [src]</div>")
			return

		to_chat(user, "<div class=info> You load the [W] in the [src] </div>")
		user.drop_item()
		W.loc = src
		MOLDS.Add(W)
		return

	if(istype(W, /obj/item/weapon/ore))
		to_chat(user, "<div class=info> You load the [W] in the [src] </div>")
		user.drop_item()
		W.loc = src
		ORES.Add(W)
		return

	if(istype(W, /obj/item/weapon/log))
		to_chat(user, "<div class=info> You add some fuel to the [src] </div>")
		user.drop_item()
		qdel(W)
		fuel += 5
		return

	if(istype(W, /obj/item/weapon/wood_plank))
		to_chat(user, "<div class=info> You add some fuel to the [src] </div>")
		user.drop_item()
		qdel(W)
		fuel += 2
		return

	if(istype(W, /obj/item/stack/sheet/kindling))
		var/obj/item/stack/sheet/kindling/KIND = W
		to_chat(user, "<div class=info> You add some fuel to the [src] </div>")
		user.drop_item()
		fuel += KIND.amount / 2
		qdel(KIND)
		return


/obj/structure/forge_lever
	name = "forge"
	desc = "A fucking forge lever"
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "forge_lever"
	opacity = 0
	anchored = 1
	density = 0
	layer = 3
	var/obj/structure/forge/MYFORGE

/obj/structure/forge_lever/attack_hand(mob/user as mob)
	if(MYFORGE)
		if(MYFORGE.fuel >= MYFORGE.fuel_needed)
			MYFORGE.fuel -= MYFORGE.fuel_needed
			to_chat(user, "<div class=warning> You start smelting! </div>")
			MYFORGE.smelt()
			return
		else
			to_chat(user, "<div class=warning> The [MYFORGE] doesn't have enough fuel! </div>")
			return