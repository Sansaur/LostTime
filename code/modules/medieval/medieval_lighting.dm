/obj/item/weapon/torch
	name = "torch"
	desc = "Light this on fire and have fun"
	icon = 'icons/obj/items.dmi'
	icon_state = "torch"
	item_state = "torch"
	var/lit = 0

/obj/item/weapon/torch/proc/lit()
	icon_state = "[icon_state]_lit"
	lit = 1
	set_light(5, 1, LIGHT_COLOR_ORANGE)

/obj/item/weapon/torch/hand_candle
	name = "hand candle"
	desc = "You can feel the warmth already"
	icon = 'icons/obj/items.dmi'
	icon_state = "hand_candle"
	item_state = "hand_candle"

/obj/item/weapon/torch/candelabra
	name = "candelabra"
	desc = "You can feel the warmth already"
	icon = 'icons/obj/items.dmi'
	icon_state = "candelabra"
	item_state = "candelabra"

/obj/structure/torch_stick
	name = "torch stick"
	desc = "put torch in stick."
	icon = 'icons/medieval/structures.dmi'
	icon_state = "torch_stick"
	var/lit = 0
	anchored = 0
	density = 0
	opacity = 0


/obj/structure/torch_stick/pre_lit
/obj/structure/torch_stick/pre_lit/New()
	..()
	lit()

/obj/structure/torch_stick/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/torch))
		var/obj/item/weapon/torch/THISTORCH = W
		if(THISTORCH.lit)
			lit()


/obj/structure/torch_stick/proc/lit()
	icon_state = "[icon_state]_lit"
	lit = 1
	set_light(5, 2, LIGHT_COLOR_ORANGE)

/obj/structure/torch_stick/torch_fountain
	name = "torch fountain"
	desc = "put torch in fountain."
	icon = 'icons/medieval/structures.dmi'
	icon_state = "torch_fountain"
	anchored = 1
	density = 1

/obj/structure/torch_stick/torch_fountain/pre_lit
/obj/structure/torch_stick/torch_fountain/pre_lit/New()
	..()
	lit()

/obj/structure/wall_torch
	name = "wall torch"
	desc = "a torch on a wall"
	icon = 'icons/medieval/structures.dmi'
	icon_state = "wall_torch"
	var/lit = 0
	opacity = 0
	anchored = 1
	density = 0
	layer=MOB_LAYER+0.1

/obj/structure/wall_torch/proc/Reorientate(var/mob/living/carbon/human/HUMAN)
	//La idea es hacer que cuando se cree que pase por aqui
	if(HUMAN.dir == 1)
		dir = 2
	else if(HUMAN.dir == 2)
		dir = 1
	else if(HUMAN.dir == 4)
		dir = 8
	else if(HUMAN.dir == 8)
		dir = 4

/obj/structure/wall_torch/proc/lit()
	icon_state = "[icon_state]_lit"
	lit = 1
	set_light(5, 2, LIGHT_COLOR_ORANGE)
	update_icon()

/obj/structure/wall_torch/pre_lit
/obj/structure/wall_torch/pre_lit/New()
	..()
	lit()
