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
	refined_type = /obj/item/stack/sheet/metal
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)

/*

Silver

You can find this while advanced mining, from treasure or from some monsters

uses:

1) Making monster-proof weapons

*/

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

/obj/item/stack/sheet/mineral/mythril
	name = "mythril"
	icon_state = "sheet-mythril"
	origin_tech = "materials=4"
	sheettype = "mythril"
	//materials = list(MAT_GOLD=MINERAL_MATERIAL_AMOUNT)