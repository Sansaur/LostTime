/****
	TABLES
****/

/obj/structure/table/woodentable/royal //No specialties, Just a mapping object.
	name = "royal wood table"
	desc = "Thou will dine in the finest of the woods."
	icon = 'icons/obj/smooth_structures/wood_table_royal.dmi'
	icon_state = "wood_table"
	canSmoothWith = list(/obj/structure/table/woodentable/royal, /obj/structure/table/woodentable)
	canPokerize = 0
	parts = /obj/item/weapon/table_parts/royal

/obj/structure/table/woodentable/ebony //No specialties, Just a mapping object.
	name = "ebony wood table"
	desc = "Thou will dine in the utmost finest of the woods."
	icon = 'icons/obj/smooth_structures/wood_table_ebony.dmi'
	icon_state = "wood_table"
	canSmoothWith = list(/obj/structure/table/woodentable/ebony, /obj/structure/table/woodentable)
	canPokerize = 0
	parts = /obj/item/weapon/table_parts/ebony

/obj/item/weapon/table_parts/royal
	name = "royal table parts"
	desc = "Keep away from fire."
	icon_state = "royal_parts"
	flags = null
	upgradable = 0
	burn_state = FLAMMABLE
	result = /obj/structure/table/woodentable/royal
	parts = list(
		/obj/item/stack/sheet/wood,
		/obj/item/stack/sheet/wood)

/obj/item/weapon/table_parts/ebony
	name = "ebony table parts"
	desc = "Keep away from fire."
	icon_state = "ebony_parts"
	flags = null
	upgradable = 0
	burn_state = FLAMMABLE
	result = /obj/structure/table/woodentable/ebony
	parts = list(
		/obj/item/stack/sheet/wood,
		/obj/item/stack/sheet/wood)

/***
	BEDS
****/

/obj/structure/stool/bed/medieval
	name = "bed"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	icon = 'icons/medieval/structures.dmi'
	icon_state = "medieval_bed"

/obj/structure/stool/bed/hay
	name = "hay bed"
	desc = "Now this is sad.."
	icon = 'icons/medieval/structures.dmi'
	icon_state = "hay_bed"

/obj/structure/stool/bed/royal
	name = "bed"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	icon = 'icons/medieval/structures.dmi'
	icon_state = "royal_bed"