/obj/item/stack/sheet/animalhide/human
	name = "human skin"
	desc = "The by-product of human farming."
	singular_name = "human skin piece"
	icon_state = "sheet-hide"
	origin_tech = ""

var/global/list/datum/stack_recipe/human_recipes = list( \
	new/datum/stack_recipe("bloated human costume", /obj/item/clothing/suit/bloated_human, 5, on_floor = 1), \
	new/datum/stack_recipe("bloated human costume head", /obj/item/clothing/head/human_head, 5, on_floor = 1), \
	)

/obj/item/stack/sheet/animalhide/human/New(var/loc, var/amount=null)
	recipes = human_recipes
	return ..()



/obj/item/stack/sheet/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon_state = "sheet-xeno"
	origin_tech = ""

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/sheet/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien hide piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	origin_tech = ""

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"
	origin_tech = ""

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"
	origin_tech = ""

/obj/item/stack/sheet/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"
	origin_tech = ""

