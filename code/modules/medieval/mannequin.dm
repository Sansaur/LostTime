/obj/structure/mannequin
	name = "mannequin"
	desc = "put your clothes on this mannequin and you'll see how it sports them better than you"
	icon = 'icons/medieval/structures.dmi'
	icon_state = "mannequin"
	var/obj/item/clothing/under/UNDER
	var/obj/item/clothing/gloves/GLOVES
	var/obj/item/clothing/suit/SUIT
	var/obj/item/clothing/head/CABEZA
	var/obj/item/clothing/mask/MASK
	var/obj/item/clothing/shoes/SHOES
	opacity = 0
	anchored = 0
	density = 1
/obj/structure/mannequin/attack_hand(mob/user as mob)
	undress_mannequin(user)

/obj/structure/mannequin/attackby(obj/item/clothing/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/clothing/under))
		if(UNDER)
			to_chat(user, "<span class=warning> There's already an item of that type on the mannequin</span>")
			return
		user.visible_message("[user] hangs [W] on \the [src].", "You hang [W] on the \the [src]")
		UNDER = W
		user.drop_item(src)
		UNDER.loc = src
		update_icon()
		return
	if(istype(W, /obj/item/clothing/gloves))
		if(GLOVES)
			to_chat(user, "<span class=warning> There's already an item of that type on the mannequin</span>")
			return
		user.visible_message("[user] hangs [W] on \the [src].", "You hang [W] on the \the [src]")
		GLOVES = W
		user.drop_item(src)
		GLOVES.loc = src
		update_icon()
		return
	if(istype(W, /obj/item/clothing/suit))
		if(SUIT)
			to_chat(user, "<span class=warning> There's already an item of that type on the mannequin</span>")
			return
		user.visible_message("[user] hangs [W] on \the [src].", "You hang [W] on the \the [src]")
		SUIT = W
		user.drop_item(src)
		SUIT.loc = src
		update_icon()
		return
	if(istype(W, /obj/item/clothing/head))
		if(CABEZA)
			to_chat(user, "<span class=warning> There's already an item of that type on the mannequin</span>")
			return
		user.visible_message("[user] hangs [W] on \the [src].", "You hang [W] on the \the [src]")
		CABEZA = W
		user.drop_item(src)
		CABEZA.loc = src
		update_icon()
		return
	if(istype(W, /obj/item/clothing/mask))
		if(MASK)
			to_chat(user, "<span class=warning> There's already an item of that type on the mannequin</span>")
			return
		user.visible_message("[user] hangs [W] on \the [src].", "You hang [W] on the \the [src]")
		MASK = W
		user.drop_item(src)
		MASK.loc = src
		update_icon()
		return
	if(istype(W, /obj/item/clothing/shoes))
		if(SHOES)
			to_chat(user, "<span class=warning> There's already an item of that type on the mannequin</span>")
			return
		user.visible_message("[user] hangs [W] on \the [src].", "You hang [W] on the \the [src]")
		SHOES = W
		user.drop_item(src)
		SHOES.loc = src
		update_icon()
		return

	to_chat(user, "<span class='notice'>You cannot hang [W] on [src]</span>")
	return ..()

/obj/structure/mannequin/update_icon()
	overlays.Cut()
	if(UNDER)
		overlays += image('icons/mob/uniform.dmi', icon_state = UNDER.item_color)
	if(GLOVES)
		overlays += image('icons/mob/hands.dmi', icon_state = GLOVES.item_color)
	if(SUIT)
		overlays += image('icons/mob/suit.dmi', icon_state = SUIT.icon_state)
	if(CABEZA)
		overlays += image('icons/mob/head.dmi', icon_state = CABEZA.icon_state)
	if(MASK)
		overlays += image('icons/mob/mask.dmi', icon_state = MASK.icon_state)
	if(SHOES)
		overlays += image('icons/mob/feet.dmi', icon_state = SHOES.icon_state)

/obj/structure/mannequin/proc/undress_mannequin(mob/user as mob)
	if(UNDER)
		UNDER.loc = user.loc
		UNDER = null
	if(GLOVES)
		GLOVES.loc = user.loc
		GLOVES = null
	if(SUIT)
		SUIT.loc = user.loc
		SUIT = null
	if(CABEZA)
		CABEZA.loc = user.loc
		CABEZA = null
	if(MASK)
		MASK.loc = user.loc
		MASK = null
	if(SHOES)
		SHOES.loc = user.loc
		SHOES = null

	overlays.Cut()