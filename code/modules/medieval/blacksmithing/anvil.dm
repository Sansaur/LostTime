/obj/structure/anvil
	name = "anvil"
	desc = "A fucking ANVIL"
	icon = 'icons/obj/blacksmithing.dmi'
	icon_state = "anvil"
	opacity = 0
	anchored = 1
	density = 1
	layer = 3

/obj/structure/anvil/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/pincers))
		var/obj/item/weapon/pincers/MYPINCERS = W
		if(MYPINCERS.HELDPART)
			to_chat(user, "<div class=info> You put [MYPINCERS.HELDPART] on top of the [src] </div>")
			MYPINCERS.HELDPART.loc = src.loc
			MYPINCERS.HELDPART = null
			return

		else
			to_chat(user, "<div class=warning> There's nothing held by the [MYPINCERS] </div>")
			return
	else
		if(user.drop_item())
			W.loc = src.loc
			return