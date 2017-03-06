

/**
THIS IS FOR THE STONES
Stones are made into cubes and then they are worked and cut
The cubes are fucking gigantic and they must be carried in two hands
**/

var/list/possible_stone_uses = list("stone wall",
									"big brick stone floor",
									"brick stone floor",
									"stone stairs floor",
									"tiled stone floor",
									"multi tiled stone floor"
									)

/obj/item/weapon/twohanded/required/stone_block
	name = "stone block"
	desc = "This thing is heavy, be careful!"
	icon = 'icons/obj/mining.dmi'
	icon_state = "StoneBlock0"
	item_state = "StoneBlock"
	w_class = 4
	throw_range = 1
	anchored = 1 //Forces people to carry it by hand, no pulling!
	var/future_use =  "brick stone floor" //Used by the stone ruler and the masonry gavel, defaults to brick stone floor
	var/work = 0 //Used by the stone ruler and the masonry gavel
	var/operating

/obj/item/weapon/twohanded/required/stone_block/attackby(obj/item/weapon/O, mob/user as mob)
	if(istype(O, /obj/item/weapon/stone_ruler))
		if(!work)
			chooseFutureUse()
		else
			to_chat(user, "<div class=warning> You've already started working on this stone block! </div>")
			return

	if(istype(O, /obj/item/weapon/hammer_and_chisel))
		if(!operating)
			if(locate_easel())
				work++
				operating = 1
				playsound(loc, 'sound/items/gavel.ogg', 50, 1, -1)
				update_icon()
				if(work >= 3)
					playsound(loc, 'sound/effects/break_stone.ogg', 50, 1, -1)
					turnIntoFutureUse()
					qdel(src)
				sleep(15)
				operating = 0
			else
				to_chat(user, "<div class=warning> The stone block must be on an easel if you want to work on it! </div>")

/obj/item/weapon/twohanded/required/stone_block/proc/chooseFutureUse()
	var/choice = input("Choose what you want to do with this block", "Block", "brick stone floor") in possible_stone_uses
	future_use = choice
	return

/obj/item/weapon/twohanded/required/stone_block/proc/turnIntoFutureUse()
	switch(future_use)
		if("stone wall")
			//NOTHING FOR NOW
		if("big brick stone floor")
			new /obj/item/stack/tile/stone/big_brick (loc)
			new /obj/item/stack/tile/stone/big_brick (loc)
			new /obj/item/stack/tile/stone/big_brick (loc)
			new /obj/item/stack/tile/stone/big_brick (loc)

		if("brick stone floor")
			new /obj/item/stack/tile/stone/brick (loc)
			new /obj/item/stack/tile/stone/brick (loc)
			new /obj/item/stack/tile/stone/brick (loc)
			new /obj/item/stack/tile/stone/brick (loc)

		if("stone stairs floor")
			new /obj/item/stack/tile/stone/stairs (loc)
			new /obj/item/stack/tile/stone/stairs (loc)
			new /obj/item/stack/tile/stone/stairs (loc)
			new /obj/item/stack/tile/stone/stairs (loc)

		if("tiled stone floor")
			new /obj/item/stack/tile/stone/tiled (loc)
			new /obj/item/stack/tile/stone/tiled (loc)
			new /obj/item/stack/tile/stone/tiled (loc)
			new /obj/item/stack/tile/stone/tiled (loc)

		if("multi tiled stone floor")
			new /obj/item/stack/tile/stone/tiled_multi (loc)
			new /obj/item/stack/tile/stone/tiled_multi (loc)
			new /obj/item/stack/tile/stone/tiled_multi (loc)
			new /obj/item/stack/tile/stone/tiled_multi (loc)
	return

/obj/item/weapon/twohanded/required/stone_block/proc/locate_easel()
	var/turf/ThisTile = locate(x,y,z)
	var/obj/structure/masonry_easel/B = locate(/obj/structure/masonry_easel) in ThisTile
	if(B)
		return 1
	return 0

/obj/item/weapon/twohanded/required/stone_block/update_icon()
	icon_state = "StoneBlock[work]"
	..()

/obj/item/weapon/twohanded/required/stone_block/attack_hand(mob/user as mob)
	..()

/**
STONE COMPRESSOR
**/

/obj/structure/stone_compressor
	name = "stone compressor"
	desc = "You put the stones in and you get the blocks out"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "stone_compressor"
	anchored = 1
	density = 1
	var/stone_needed = 15 //How much stone is needed for a block
	var/stone_in = 0 //How much stone is inside the compressor

/obj/structure/stone_compressor/attack_hand(mob/user as mob)
	if(stone_in == stone_needed)
		smeltIntoBlock()
	else
		to_chat(user, "<div class=warning> There's not enough stone inside the compressor to make it into a block </div>")

/obj/structure/stone_compressor/update_icon()
	if(stone_in == stone_needed)
		icon_state = "stone_compressor_full"
	else
		icon_state = "stone_compressor"

/obj/structure/stone_compressor/proc/smeltIntoBlock()
	stone_in = 0
	playsound(loc,'sound/effects/shovel_dig.ogg',100,1)
	flick("stone_compressor_working", src)
	sleep(8)
	playsound(loc,'sound/effects/shovel_dig.ogg',100,1)
	sleep(8)
	playsound(loc,'sound/effects/woodhit.ogg',100,1)
	update_icon()
	new /obj/item/weapon/twohanded/required/stone_block (loc)

/obj/structure/stone_compressor/attackby(obj/item/O, mob/user as mob)
	if(istype(O, /obj/item/stack/sheet/mineral/stone))
		var/obj/item/stack/sheet/mineral/stone/THISSTACK = O
		var/to_add = input("How much stone will you add? ([THISSTACK.amount] availible)", "Stone", 0) as num
		if(to_add > THISSTACK.amount)
			to_add = THISSTACK.amount
		if((to_add+stone_in) > stone_needed)
			to_add = stone_needed - stone_in
		stone_in += to_add
		THISSTACK.use(to_add)

		update_icon()

/**
MASONRY EASEL
**/

/obj/structure/masonry_easel
	name = "masonry easel"
	desc = "You need to put that stone somewhere."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "masonry_easel"
	anchored = 1
	density = 0
	layer = OBJ_LAYER +0.1

/obj/item/weapon/stone_ruler
	name = "masonry ruler"
	desc = "Let's make those stones useful."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "stone_ruler"
	force = 4

/obj/item/weapon/hammer_and_chisel
	name = "hammer and chisel"
	desc = "Ay ho!."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "hammer_and_chisel"
	force = 8