/obj/structure/war_table
	name = "war table"
	desc = "Plan your strategy here."
	icon = 'icons/medieval/war_table.dmi'
	density = 1
	opacity = 0
	anchored = 1

/obj/structure/war_table/New()
	..()
/obj/structure/war_table/update_icon()
	..()
/obj/structure/war_table/attackby(obj/item/W as obj, mob/user as mob, params)
	if(!(W.flags & ABSTRACT))
		if(user.drop_item())
			W.Move(loc)
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			W.pixel_x = Clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			W.pixel_y = Clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)

	return

/obj/structure/war_table/center
	icon_state = "center"
/obj/structure/war_table/bottom
	icon_state = "bottom"
/obj/structure/war_table/top
	icon_state = "top"
/obj/structure/war_table/right
	icon_state = "right"
/obj/structure/war_table/left
	icon_state = "left"

/obj/item/weapon/storage/box/medieval/flat_storage/war_table
	name = "figurine box"
	desc = "Contains a lot of figurines for use on the war table."
	icon_state = "medieval_storage_box"

	New()
		..()
		new /obj/item/toy/medieval_figurine/regular(src)
		new /obj/item/toy/medieval_figurine/regular(src)
		new /obj/item/toy/medieval_figurine/regular(src)
		new /obj/item/toy/medieval_figurine/footman(src)
		new /obj/item/toy/medieval_figurine/footman(src)
		new /obj/item/toy/medieval_figurine/footman(src)
		new /obj/item/toy/medieval_figurine/king(src)
		new /obj/item/toy/medieval_figurine/bishop(src)
		new /obj/item/toy/medieval_figurine/captain_guard(src)

/obj/item/toy/medieval_figurine
	name = "A medieval figurine"
	desc = "It's a medieval figurine"
	icon = 'icons/medieval/figurines.dmi'
	icon_state = "nuketoy"
	w_class = 1
/obj/item/toy/medieval_figurine/New()
	..()

/obj/item/toy/medieval_figurine/attack_self(mob/user as mob)
	return

/obj/item/toy/medieval_figurine/regular
	name = "non-descript figurine"
	icon_state = "regular"
/obj/item/toy/medieval_figurine/footman
	name = "footman figurine"
	icon_state = "footman"
/obj/item/toy/medieval_figurine/king
	name = "king figurine"
	icon_state = "king"
/obj/item/toy/medieval_figurine/bishop
	name = "bishop figurine"
	icon_state = "bishop"
/obj/item/toy/medieval_figurine/captain_guard
	name = "captain figurine"
	icon_state = "captain_guard"

