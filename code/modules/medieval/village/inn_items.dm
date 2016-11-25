
/obj/structure/reagent_dispensers/beerkeg/medieval
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "beerkeg"
	amount_per_transfer_from_this = 10

/obj/structure/key_holder
	name = "key holder"
	desc = "Goddamnit I lost me keys again!."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "key_holder0"
	burn_state = FLAMMABLE
	burntime = 20
	var/list/obj/item/weapon/locking_key/inn/KEYS = list()

/obj/structure/key_holder/New()
	..()
	var/obj/item/weapon/locking_key/inn/R = new(src)
	var/obj/item/weapon/locking_key/inn/room1/R1 = new(src)
	var/obj/item/weapon/locking_key/inn/room2/R2 = new(src)
	var/obj/item/weapon/locking_key/inn/room3/R3 = new(src)
	var/obj/item/weapon/locking_key/inn/room4/R4 = new(src)
	var/obj/item/weapon/locking_key/inn/room5/R5 = new(src)

	KEYS.Add(R)
	KEYS.Add(R1)
	KEYS.Add(R2)
	KEYS.Add(R3)
	KEYS.Add(R4)
	KEYS.Add(R5)
	update_icon()

/obj/structure/key_holder/attack_hand(mob/user as mob)
	var/obj/item/weapon/locking_key/inn/INNKEY
	INNKEY = input("Choose a key to take off the holder", "Key taking",null) in KEYS
	if(INNKEY)
		INNKEY.loc = user.loc
		KEYS.Remove(INNKEY)
		update_icon()

/obj/structure/key_holder/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/locking_key/inn))
		var/obj/item/weapon/locking_key/inn/INNKEY = W
		var/count = 0
		for(INNKEY in KEYS)
			count++
		if(count >= 6)
			to_chat(user, "<span class=warning> The [src] is full! </span>")
			return
		KEYS.Add(INNKEY)
		user.drop_item()
		INNKEY.forceMove(src)
		update_icon()
		return

/obj/structure/key_holder/update_icon()
	var/obj/item/weapon/locking_key/inn/INNKEY
	var/count = 0
	for(INNKEY in KEYS)
		count++
	icon_state = "key_holder[count]"


/***
 PREMADE DRINKS

***/

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "Duke Purple Tea"
	desc = "The most expensive of teas, and the most royal at that, and makes you think about stuff you swear you saw somewhere before"
	icon_state = "teacup"
	item_state = "coffee"
	list_reagents = list("tea" = 30)

/obj/item/weapon/reagent_containers/food/drinks/flask
	name = "flask"
	desc = "Ready this up and don't look back"
	icon_state = "flask"
	materials = list(MAT_METAL=250)
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/beer_mug
	name = "super mug"
	desc = "GULPS INCOMING"
	icon_state = "megamug"
	amount_per_transfer_from_this = 25
	volume = 120
	materials = list(MAT_GLASS=550)

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/beer_mug/on_reagent_change()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]1")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 25)
				filling.icon_state = "[icon_state]1"
			if(26 to 79)
				filling.icon_state = "[icon_state]5"
			if(80 to INFINITY)
				filling.icon_state = "[icon_state]12"

		filling.icon += mix_color_from_reagents(reagents.reagent_list)
		overlays += filling
		name = "super mug of " + reagents.get_master_reagent_name() //No matter what, the glass will tell you the reagent's name. Might be too abusable in the future.
	else
		name = "super mug"

/***
MOPS AND CLEANING
***/

/obj/item/weapon/mop/medieval
	desc = "It's time to clean the floor and be a loser... And there's plenty of floors"
	icon = 'icons/obj/medieval/village.dmi'
	name = "mop"
	mopcap = 15
	icon_state = "mop"
	item_state = "mop"	//meh will do for now until TG makes one
	force = 6
	throwforce = 8
	throw_range = 4
	mopspeed = 25

/obj/item/weapon/reagent_containers/glass/bucket/medieval
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	materials = list(MAT_METAL=200)
	w_class = 3
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(5,10,15,20,25,30,50,80,100,120)
	volume = 120
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	//slot_flags = SLOT_HEAD
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/bucket/medieval/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return
	if(!is_open_container())
		return

	for(var/type in can_be_placed_into)
		if(istype(target, type))
			return

	if(ismob(target) && target.reagents && reagents.total_volume)
		to_chat(user, "<span class='notice'>You splash the solution onto [target].</span>")

		var/mob/living/M = target
		var/list/injected = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			injected += R.name
		var/contained = english_list(injected)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [name] by [key_name(user)]. Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to splash [key_name(M)]. Reagents: [contained]</font>")
		if(M.ckey)
			msg_admin_attack("[key_name_admin(user)] splashed [key_name_admin(M)] with [name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)])")
		if(!iscarbon(user))
			M.LAssailant = null
		else
			M.LAssailant = user

		for(var/mob/O in viewers(world.view, user))
			O.show_message(text("<span class='warning'>[] has been splashed with something by []!</span>", target, user), 1)
		reagents.reaction(target, TOUCH)
		spawn(5) reagents.clear_reagents()
		return

	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

		if(!target.reagents.total_volume && target.reagents)
			to_chat(user, "<span class='warning'>[target] is empty.</span>")
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>")

	else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>[src] is empty.</span>")
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, "<span class='warning'>[target] is full.</span>")
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to [target].</span>")

	else if(istype(target, /obj/item/weapon/reagent_containers/glass) && !target.is_open_container())
		to_chat(user, "<span class='warning'>You cannot fill [target] while it is sealed.</span>")
		return

	else if(istype(target, /obj/effect/decal/cleanable)) //stops splashing while scooping up fluids
		return

	else if(istype(target, /obj/structure/heat_controller)) //Allows adding ice to the heat controller - Sansaur
		return

	else if(istype(target, /turf/simulated/floor/beach/water)) //Allows adding ice to the heat controller - Sansaur
		return

	else if(reagents.total_volume)
		to_chat(user, "<span class='notice'>You splash the solution onto [target].</span>")
		reagents.reaction(target, TOUCH)
		spawn(5) reagents.clear_reagents()
		return



/obj/item/weapon/reagent_containers/glass/bucket/medieval/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/mop))
		if(src.reagents.total_volume >= 2)
			src.reagents.trans_to(W, 2)
			to_chat(user, "\blue You wet the mop")
			playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1)
		if(src.reagents.total_volume < 1)
			to_chat(user, "\blue Out of water!")
	return
