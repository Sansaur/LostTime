/*
Mineral Sheets for the medieval mod
	Contains:
		- Stone
		- Silver
		- Flint (It's not a true mineral)
*/



/*
Flint

You can find this on the ground or while basic mining

uses:

1) Lighting up the bonfire
2) Making shitty spears (NOT YET)

*/

/obj/item/weapon/flint
	name = "flint"
	desc = "sharp"
	icon = 'icons/obj/items.dmi'
	icon_state = "flint"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 2.0
	throwforce = 4.0
	item_state = "flint"
	w_class = 1
	sharp = 1

/*
Stone

You can find this on the ground or while basic mining

uses:

1) Making stone walls and stone floors

*/

/obj/item/stack/sheet/mineral/stone
	name = "stone"
	icon_state = "sheet-stone"
	origin_tech = "materials=4"
	sheettype = "stone"

/obj/item/stack/sheet/mineral/stone/New()
	..()

/obj/item/stack/sheet/mineral/stone/attackby(obj/item/W, mob/user as mob)
	// Crushing stones into dirt with a hammer.
	if(istype(W, /obj/item/weapon/hammer_and_chisel))
		if(isturf(src.loc))
			for(var/obj/structure/table/woodentable/TABLE in src.loc)
				if(TABLE)
					if(src.use(1))
						new /obj/item/weapon/ore/glass (src.loc)
					else
						to_chat(user, "<div class=warning> There's not enough amount of stones to crush </div>")
				else
					to_chat(user, "<div class=warning> You shouldn't be hammering stones there... </div>")
					return
		else
			to_chat(user, "<div class=warning> You shouldn't be hammering stones there... </div>")
			return


/*
Iron

You can find this while basic mining

uses:

1) MANY

*/

/obj/item/weapon/ore/iron
	name = "iron ore"
	icon_state = "Iron ore"
	origin_tech = "materials=1"
	points = 1
	refined_type = /obj/item/stack/sheet/mineral/iron
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/iron
	name = "iron"
	icon_state = "sheet-iron"
	origin_tech = "materials=2"
	sheettype = "iron"

/obj/item/stack/sheet/mineral/iron/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/blacksmith_hammer))
		if(!isturf(loc))
			to_chat(user, "<div class=warning> You cannot shape the [src] here!</div>")
			return

		to_chat(user, "<div class=warning> You shape the [src]!</div>")
		var/obj/item/stack/sheet/metal/METAL = new /obj/item/stack/sheet/metal (loc)
		src.use(1)
		qdel(src)

/obj/item/stack/sheet/mineral/iron/New()
	..()
	//recipes = gold_recipes

/*

Silver

You can find this while advanced mining, from treasure or from some monsters

uses:

1) Making monster-proof weapons

*/

/obj/item/weapon/ore/silver
	name = "silver ore"
	icon_state = "Silver ore"
	origin_tech = "materials=3"
	points = 16
	refined_type = /obj/item/stack/sheet/mineral/silver
	materials = list(MAT_SILVER=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/silver
	name = "silver"
	icon_state = "sheet-silver"
	origin_tech = "materials=3"
	sheettype = "silver"
	materials = list(MAT_SILVER=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/silver/New()
	..()
	//recipes = silver_recipes

/*

Diamond

High level mining

uses:

*/


/obj/item/weapon/ore/diamond
	name = "diamond ore"
	icon_state = "Diamond ore"
	origin_tech = "materials=6"
	points = 50
	refined_type = /obj/item/stack/sheet/mineral/diamond
	materials = list(MAT_DIAMOND=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	origin_tech = "materials=6"
	sheettype = "diamond"
	materials = list(MAT_DIAMOND=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/diamond/New()
	..()
	recipes = diamond_recipes

/*

Gold

High level mining

uses:

*/

/obj/item/weapon/ore/gold
	name = "gold ore"
	icon_state = "Gold ore"
	origin_tech = "materials=4"
	points = 18
	refined_type = /obj/item/stack/sheet/mineral/gold
	materials = list(MAT_GOLD=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/gold
	name = "gold"
	icon_state = "sheet-gold"
	origin_tech = "materials=4"
	sheettype = "gold"
	materials = list(MAT_GOLD=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/gold/New()
	..()
	recipes = gold_recipes

/*

Mythril

High level mining

uses:

*/

/obj/item/weapon/ore/mythril
	name = "Mythril ore"
	icon_state = "Mythril ore"
	origin_tech = "materials=2"
	points = 18
	refined_type = /obj/item/stack/sheet/mineral/mythril
	//materials = list(MAT_GOLD=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/mythril
	name = "mythril"
	icon_state = "sheet-mythril"
	origin_tech = "materials=4"
	sheettype = "mythril"
	//materials = list(MAT_GOLD=MINERAL_MATERIAL_AMOUNT)