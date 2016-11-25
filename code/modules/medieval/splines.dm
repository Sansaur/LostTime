/** WOODEN SPLINES **/

/obj/effect/decal/wooden_spline
	icon = 'icons/obj/wooden_splines.dmi'
	layer = 2

/obj/effect/decal/wooden_spline/north
	icon_state = "N"

/obj/effect/decal/wooden_spline/south
	icon_state = "S"

/obj/effect/decal/wooden_spline/east
	icon_state = "E"

/obj/effect/decal/wooden_spline/west
	icon_state = "W"

/obj/effect/decal/wooden_spline/southeast
	icon_state = "NW-in"

/obj/effect/decal/wooden_spline/northwestcorner
	icon_state = "NW-out"

/obj/effect/decal/wooden_spline/southwest
	icon_state = "NE-in"

/obj/effect/decal/wooden_spline/northeastcorner
	icon_state = "NE-out"

/obj/effect/decal/wooden_spline/northeast
	icon_state = "SW-in"

/obj/effect/decal/wooden_spline/southwestcorner
	icon_state = "SW-out"

/obj/effect/decal/wooden_spline/northwest
	icon_state = "SE-in"

/obj/effect/decal/wooden_spline/southeastcorner
	icon_state = "SE-out"

/obj/effect/decal/wooden_spline/eastsouthwest
	icon_state = "U-N"

/obj/effect/decal/wooden_spline/eastnorthwest
	icon_state = "U-S"

/obj/effect/decal/wooden_spline/northeastsouth
	icon_state = "U-W"

/obj/effect/decal/wooden_spline/northwestsouth
	icon_state = "U-E"

/obj/effect/decal/wooden_spline/New()
	. = ..()
	loc.overlays += src
	qdel(src)

/** STONE SPLINES **/

/obj/effect/decal/stone_spline
	icon = 'icons/obj/stone_splines.dmi'
	layer = 2

/obj/effect/decal/stone_spline/north
	icon_state = "N"

/obj/effect/decal/stone_spline/south
	icon_state = "S"

/obj/effect/decal/stone_spline/east
	icon_state = "E"

/obj/effect/decal/stone_spline/west
	icon_state = "W"

/obj/effect/decal/stone_spline/southeast
	icon_state = "NW-in"

/obj/effect/decal/stone_spline/northwestcorner
	icon_state = "NW-out"

/obj/effect/decal/stone_spline/southwest
	icon_state = "NE-in"

/obj/effect/decal/stone_spline/northeastcorner
	icon_state = "NE-out"

/obj/effect/decal/stone_spline/northeast
	icon_state = "SW-in"

/obj/effect/decal/stone_spline/southwestcorner
	icon_state = "SW-out"

/obj/effect/decal/stone_spline/northwest
	icon_state = "SE-in"

/obj/effect/decal/stone_spline/southeastcorner
	icon_state = "SE-out"

/obj/effect/decal/stone_spline/eastsouthwest
	icon_state = "U-N"

/obj/effect/decal/stone_spline/eastnorthwest
	icon_state = "U-S"

/obj/effect/decal/stone_spline/northeastsouth
	icon_state = "U-W"

/obj/effect/decal/stone_spline/northwestsouth
	icon_state = "U-E"

/obj/effect/decal/stone_spline/New()
	. = ..()
	loc.overlays += src
	qdel(src)


/** MARBLE SPLINES **/

/obj/effect/decal/marble_spline
	icon = 'icons/obj/marble_splines.dmi'
	layer = 2

/obj/effect/decal/marble_spline/north
	icon_state = "N"

/obj/effect/decal/marble_spline/south
	icon_state = "S"

/obj/effect/decal/marble_spline/east
	icon_state = "E"

/obj/effect/decal/marble_spline/west
	icon_state = "W"

/obj/effect/decal/marble_spline/southeast
	icon_state = "NW-in"

/obj/effect/decal/marble_spline/northwestcorner
	icon_state = "NW-out"

/obj/effect/decal/marble_spline/southwest
	icon_state = "NE-in"

/obj/effect/decal/marble_spline/northeastcorner
	icon_state = "NE-out"

/obj/effect/decal/marble_spline/northeast
	icon_state = "SW-in"

/obj/effect/decal/marble_spline/southwestcorner
	icon_state = "SW-out"

/obj/effect/decal/marble_spline/northwest
	icon_state = "SE-in"

/obj/effect/decal/marble_spline/southeastcorner
	icon_state = "SE-out"

/obj/effect/decal/marble_spline/eastsouthwest
	icon_state = "U-N"

/obj/effect/decal/marble_spline/eastnorthwest
	icon_state = "U-S"

/obj/effect/decal/marble_spline/northeastsouth
	icon_state = "U-W"

/obj/effect/decal/marble_spline/northwestsouth
	icon_state = "U-E"

/obj/effect/decal/marble_spline/New()
	. = ..()
	loc.overlays += src
	qdel(src)
