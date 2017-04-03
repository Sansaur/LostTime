
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
	slot_flags = SLOT_HEAD
	flags = OPENCONTAINER

