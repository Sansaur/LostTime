/obj/item/wool
	name = "wool"
	desc = "It comes from the mass murdering of sheep hair."
	icon_state = "gauze"

/obj/item/stack/sheet/string
	name = "string"
	desc = "It comes from the mass murdering of wool."
	singular_name = "string piece"
	icon_state = "cuff_white"

/obj/item/stack/sheet/silk
	name = "silk"
	desc = "It comes from the mass murdering of baby worms."
	singular_name = "silk piece"
	icon_state = "silk"

/obj/item/fabric_reel
	name = "white fabric reel"
	desc = "Spinned."
	icon_state = "splint"
/obj/item/fabric_reel/white
/obj/item/fabric_reel/orange
	name = "orange fabric reel"
/obj/item/fabric_reel/blue
	name = "blue fabric reel"
/obj/item/fabric_reel/red
	name = "red fabric reel"
/obj/item/fabric_reel/green
	name = "green fabric reel"
/obj/item/fabric_reel/yellow
	name = "yellow fabric reel"
/obj/item/fabric_reel/black
	name = "black fabric reel"
/obj/item/fabric_reel/purple
	name = "purple fabric reel"


// Only red blue and green, MIX EM AND WHAT DO YOU GET?

/obj/item/pigment
	name = "white pigment"
	desc = "mushy."
	icon_state = "paint_white"
	w_class = 2

/obj/item/pigment/New()
	pixel_x = rand(1,5)
	pixel_y = rand(1,5)

/obj/item/pigment/white

/obj/item/pigment/blue
	name = "blue pigment"
	icon_state = "paint_blue"
/obj/item/pigment/red
	name = "red pigment"
	icon_state = "paint_red"
/obj/item/pigment/yellow
	name = "yellow pigment"
	icon_state = "paint_yellow"


// Only red blue and green, MIX EM AND WHAT DO YOU GET?

/obj/item/pigment/green
	name = "green pigment"
	icon_state = "paint_green"
/obj/item/pigment/orange
	name = "orange pigment"
	icon_state = "paint_orange"
/obj/item/pigment/purple
	name = "purple pigment"
	icon_state = "paint_purple"


/obj/item/pigment/black
	name = "black pigment"
	icon_state = "paint_black"


// LEATHER 

// HIDE TYPES

/obj/item/stack/sheet/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"
	origin_tech = ""

/obj/item/stack/sheet/animalhide/generic
	name = "generic skin"
	desc = "A piece of generic skin."
	singular_name = "generic skin piece"
	icon_state = "sheet-hide"
	origin_tech = null

/obj/item/stack/sheet/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon_state = "sheet-cat"
	origin_tech = ""

/obj/item/stack/sheet/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"
	origin_tech = ""

/obj/item/stack/sheet/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"
	origin_tech = ""

// LEATHER BYPRODUCTS

/obj/item/stack/sheet/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	origin_tech = ""
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying

/obj/item/stack/sheet/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	singular_name = "leather piece"
	icon_state = "sheet-leather"
	origin_tech = "materials=2"


/*
//Step one - dehairing.

/obj/item/stack/sheet/animalhide/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(	istype(W, /obj/item/weapon/kitchen/knife) || \
		istype(W, /obj/item/weapon/twohanded/fireaxe) || \
		istype(W, /obj/item/weapon/hatchet) )

		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		usr.visible_message("\blue \the [usr] starts cutting hair off \the [src]", "\blue You start cutting the hair off \the [src]", "You hear the sound of a knife rubbing against flesh")
		if(do_after(user,50, target = src))
			to_chat(usr, "\blue You cut the hair from this [src.singular_name]")
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/sheet/hairlesshide/HS in usr.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/sheet/hairlesshide/HS = new(usr.loc)
			HS.amount = 1
			src.use(1)
	else
		..()


//Step two - washing..... it's actually in washing machine code.

//Step three - drying
/obj/item/stack/sheet/wetleather/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/sheet/leather/HS in src.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					wetness = initial(wetness)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/sheet/leather/HS = new(src.loc)
			HS.amount = 1
			wetness = initial(wetness)
			src.use(1)

			*/