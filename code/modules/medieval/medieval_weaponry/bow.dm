#define XBOW_TENSION_20 "20%"
#define XBOW_TENSION_40 "40%"
#define XBOW_TENSION_60 "60%"
#define XBOW_TENSION_80 "80%"
#define XBOW_TENSION_FULL "100%"

/obj/item/weapon/gun/throw/crossbow/bow
	name = "bow"
	desc = "Now you only need the arrows."
	icon_state = "bow"
	item_state = "crossbow-solid"
	fire_sound_text = "a solid thunk"
	fire_delay = 25

	valid_projectile_type = /obj/item/weapon/arrow
	tension = 0
	drawtension = 50
	maxtension = 5
	speed_multiplier = 5
	range_multiplier = 3

/obj/item/weapon/gun/throw/crossbow/bow/examine(mob/user)
	..()

/obj/item/weapon/gun/throw/crossbow/bow/modify_projectile(obj/item/I, on_chamber = 0)
	return 0 //No supercharging with a regular bow

/obj/item/weapon/gun/throw/crossbow/bow/draw(mob/living/user)
	if(user.incapacitated())
		return
	if(!to_launch)
		to_chat(user, "<span class='warning'>You can't draw [src] without a bolt nocked.</span>")
		return

	user.visible_message("[user] begins to draw back the string of [src].","You begin to draw back the string of [src].")
	if(do_after(user, 10, target = user))
		tension = drawtension
		user.visible_message("[usr] draws back the string of [src]!","[src] clunks as you draw the string to its maximum tension!!")
		update_icon()

/obj/item/weapon/gun/throw/crossbow/bow/attackby(obj/item/W as obj, mob/user as mob, params)
	..()



	//Bows don't change their tension >:C

/obj/item/weapon/gun/throw/crossbow/bow/set_tension()


/obj/item/weapon/gun/throw/crossbow/bow/process_fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, message = 1, params, zone_override)
	..()
	tension = 0
	update_icon()


#undef XBOW_TENSION_20
#undef XBOW_TENSION_40
#undef XBOW_TENSION_60
#undef XBOW_TENSION_80
#undef XBOW_TENSION_FULL
