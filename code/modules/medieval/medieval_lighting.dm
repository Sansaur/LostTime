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
/**
** Bonfire
**/
/obj/structure/bonfire
	name = "bonfire"
	desc = "It looks like it'll burn ya"
	icon = 'icons/medieval/structures.dmi'
	icon_state = "bonfire0"
	var/lit = 0
	var/fuel = 0

/obj/structure/bonfire/New()
	layer=2.9 //Replace with Object Layer - 0.1
	fuel += 50
	processing()
	//..()

/obj/structure/bonfire/update_icon()
	icon_state = "bonfire[lit]"
	..()

/obj/structure/bonfire/proc/processing() //COMPROBAR FUNCIONAMIENTO CORRECTO EN EL FUTURO
	if(lit)
		fuel--
		if(fuel < 0)
			new /obj/effect/decal/cleanable/ash (loc)
			qdel(src)
			return 0

		var/turf/simulated/floor/location = locate(x,y,z)
		if(location.wet)
			switch_lit()

	sleep(15)
	processing()

/obj/structure/bonfire/attack_hand(mob/user as mob)
	//switch_lit()

/obj/structure/bonfire/attackby(obj/item/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/log))
		to_chat(user, "<span class=info> You put some wood into the fire </span>")
		fuel += 50
		qdel(W)
	if(istype(W, /obj/item/weapon/wood_plank))
		to_chat(user, "<span class=info> You put some wood into the fire </span>")
		fuel += 25
		qdel(W)
	if(istype(W, /obj/item/weapon/pickaxe) || istype(W, /obj/item/weapon/fire_pick) )
		if(lit)
			to_chat(user, "<span class=warning> You extinguish the fire. </span>")
			switch_lit()
			return

	if(istype(W, /obj/item/weapon/flint))
		if(!lit)
			to_chat(user, "<span class=warning> You start the fire. </span>")
			switch_lit()
			processing()
			return

/obj/structure/bonfire/Crossed(atom/movable/AM as mob|obj)
	spawn( 0 )
		if(istype(AM, /mob/living/carbon/human) && lit)
			var/mob/living/carbon/human/TouchingHuman = AM
			to_chat(TouchingHuman, "<span class=userdanger> OW! The [src] has burned you!</span>")
			TouchingHuman.adjustFireLoss(10)
			if(prob(10))
				spawn(3)
				to_chat(TouchingHuman, "<span class=userdanger> AAARRGH!</span>")
				TouchingHuman.adjust_fire_stacks(4)
				TouchingHuman.IgniteMob()
			return

/obj/structure/bonfire/proc/switch_lit()
	lit = !lit
	if(lit)
		playsound(loc, 'sound/machines/startingfire.ogg', 50, 1)
		set_light(6, 2, LIGHT_COLOR_ORANGE)
	else
		playsound(loc,'sound/machines/extinguishfire.ogg',50,1)
		set_light(0)
	update_icon()
	return lit

// This shit is to put out fires, apparently
/obj/item/weapon/fire_pick
	name = "fire pick"
	desc = "in case you need to put out a bonfire"
	icon = 'icons/obj/items.dmi'
	icon_state = "fire_pick"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 4.0
	throwforce = 4.0
	item_state = "fire_pick"
	w_class = 2
	sharp = 1