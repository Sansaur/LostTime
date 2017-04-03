/obj/structure/rack/wooden_shelves
	name = "wooden shelves"
	desc = "woody."
	icon = 'icons/obj/objects.dmi'
	icon_state = "wooden_shelves"
	density = 1
	anchored = 1.0
	throwpass = 1	//You can throw objects over this, despite it's density.
	parts = /obj/item/weapon/wooden_shelf_parts
	health = 5

/obj/item/weapon/wooden_shelf_parts
	name = "wooden shelf parts"
	desc = "Parts of a shelf."
	icon = 'icons/obj/items.dmi'
	icon_state = "wooden_shelf_parts"
	flags = CONDUCT
	materials = list(MAT_METAL=2000)

/obj/item/weapon/wooden_shelf_parts/attack_self(mob/user as mob)
	var/obj/structure/rack/wooden_shelves/R = new /obj/structure/rack/wooden_shelves(user.loc)
	R.add_fingerprint(user)
	user.drop_item()
	qdel(src)