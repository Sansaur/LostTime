/* Different misc types of tiles
 * Contains:
 *		Grass
 *		Wood
 *		Carpet
 *		Plasteel
 *		Light
 *		Fakespace
 *		High-traction
 \\ If you don't update the contains list, I'm going to shank you
 */
/obj/item/stack/tile
	name = "broken tile"
	singular_name = "broken tile"
	desc = "A broken tile. This should not exist."
	icon = 'icons/obj/items.dmi'
	icon_state = "tile"
	item_state = "tile"
	w_class = 3
	force = 1
	throwforce = 1
	throw_speed = 5
	throw_range = 20
	max_amount = 60
	flags = CONDUCT
	var/turf_type = null
	var/mineralType = null

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tiles"
	gender = PLURAL
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses"
	icon_state = "tile_grass"
	origin_tech = "biotech=1"
	turf_type = /turf/simulated/floor/grass
	burn_state = FLAMMABLE

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tiles"
	gender = PLURAL
	singular_name = "wood floor tile"
	desc = "an easy to fit wood floor tile"
	icon_state = "tile-wood"
	turf_type = /turf/simulated/floor/wood
	burn_state = FLAMMABLE

/obj/item/stack/tile/wood/royal_wood // - Sansaur
	name = "artesanal wood floor tiles"
	gender = PLURAL
	singular_name = "artesanal wood floor tile"
	desc = "an easy to fit wood floor tile, this one looks royal-ish"
	icon_state = "tile-wood2"
	turf_type = /turf/simulated/floor/wood/royal_wood
	burn_state = FLAMMABLE

/obj/item/stack/tile/wood/worker_wood // - Sansaur
	name = "fixed wood floor tiles"
	gender = PLURAL
	singular_name = "fixed wood floor tile"
	desc = "an easy to fit wood floor tile, this one looks strong"
	icon_state = "tile-wood3"
	turf_type = /turf/simulated/floor/wood/worker_wood
	burn_state = FLAMMABLE

/obj/item/stack/tile/wood/worker_wood_mini // - Sansaur
	name = "fixed wood floor tiles"
	gender = PLURAL
	singular_name = "fixed wood floor tile"
	desc = "an easy to fit wood floor tile, this one looks average"
	icon_state = "tile-wood4"
	turf_type = /turf/simulated/floor/wood/worker_wood_mini
	burn_state = FLAMMABLE

/obj/item/stack/tile/wood/plain_wood_tile // - Sansaur
	name = "plain floor tiles"
	gender = PLURAL
	singular_name = "plain floor tile"
	desc = "an easy to fit wood floor tile, this one is plain, without decorations"
	icon_state = "tile-wood5"
	turf_type = /turf/simulated/floor/wood/plain_wood_tile
	burn_state = FLAMMABLE

/obj/item/stack/tile/wood/stairs // - Sansaur
	name = "plain stairs tiles"
	gender = PLURAL
	singular_name = "plain stairs tile"
	desc = "an easy to fit mini wooden stairs"
	icon_state = "tile-wood6"
	turf_type = /turf/simulated/floor/wood/stairs
	burn_state = FLAMMABLE

/obj/item/stack/tile/wood/smooth_tile // - Sansaur
	name = "smooth wood"
	gender = PLURAL
	singular_name = "smooth wood tile"
	desc = "an easy to fit smooth wooden floor"
	icon_state = "tile-wood7"
	turf_type = /turf/simulated/floor/wood/smooth_tile
	burn_state = FLAMMABLE
/*
 * Stones
 */
/obj/item/stack/tile/stone
	name = "wood floor tiles"
	gender = PLURAL
	singular_name = "wood floor tile"
	desc = "a plain stone tile"
	icon_state = "tile-stone"
	turf_type = /turf/simulated/floor/stone

/obj/item/stack/tile/stone/tiled_multi // - Sansaur
	name = "artesanal wood floor tiles"
	gender = PLURAL
	singular_name = "artesanal wood floor tile"
	desc = "an easy to fit multi-tiled stone plaque"
	icon_state = "tile-stone2"
	turf_type = /turf/simulated/floor/stone/tiled_multi

/obj/item/stack/tile/stone/tiled // - Sansaur
	name = "tiled wood floor tiles"
	gender = PLURAL
	singular_name = "fixed wood floor tile"
	desc = "an easy to fit stone floor tile"
	icon_state = "tile-stone3"
	turf_type = /turf/simulated/floor/stone/brick

/obj/item/stack/tile/stone/brick // - Sansaur
	name = "bricked floor tiles"
	gender = PLURAL
	singular_name = "bricked floor tile"
	desc = "an easy to fit stone floor tile"
	icon_state = "tile-stone4"
	turf_type = /turf/simulated/floor/stone/brick

/obj/item/stack/tile/stone/big_brick // - Sansaur
	name = "big bricked floor tiles"
	gender = PLURAL
	singular_name = "big bricked floor tile"
	desc = "an easy to fit stone floor tile"
	icon_state = "tile-stone5"
	turf_type = /turf/simulated/floor/stone/big_brick

/obj/item/stack/tile/stone/stairs // - Sansaur
	name = "stairs floor tiles"
	gender = PLURAL
	singular_name = "stairs floor tiles"
	desc = "an easy to fit stone floor tile"
	icon_state = "tile-stone6"
	turf_type = /turf/simulated/floor/stone/stairs

/**
	Marble
**/

/obj/item/stack/tile/marble // - Sansaur
	name = "marble tiles"
	gender = PLURAL
	singular_name = "marble tile"
	desc = "an easy to fit marble floor tile"
	icon_state = "tile-marble"
	turf_type = /turf/simulated/floor/marble

/obj/item/stack/tile/marble/yellow // - Sansaur
	name = "marble tiles"
	gender = PLURAL
	singular_name = "marble tile"
	desc = "an easy to fit marble floor tile"
	icon_state = "tile-marble2"
	turf_type = /turf/simulated/floor/marble/yellow

/obj/item/stack/tile/marble/plain // - Sansaur
	name = "marble tiles"
	gender = PLURAL
	singular_name = "marble tile"
	desc = "an easy to fit marble floor tile"
	icon_state = "tile-marble3"
	turf_type = /turf/simulated/floor/marble/plain

/obj/item/stack/tile/marble/stairs // - Sansaur
	name = "marble stairs"
	gender = PLURAL
	singular_name = "marble stairs"
	desc = "an easy to fit marble stairs tile"
	icon_state = "tile-marble4"
	turf_type = /turf/simulated/floor/marble/stairs
/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a floor tile"
	icon_state = "tile-carpet"
	turf_type = /turf/simulated/floor/carpet
	burn_state = FLAMMABLE

/*
 * Plasteel
 */
/obj/item/stack/tile/plasteel
	name = "floor tiles"
	gender = PLURAL
	singular_name = "floor tile"
	desc = "Those could work as a pretty decent throwing weapon."
	icon_state = "tile"
	force = 6
	materials = list(MAT_METAL=500)
	throwforce = 10
	throw_speed = 3
	throw_range = 7
	flags = CONDUCT
	turf_type = /turf/simulated/floor/plasteel
	mineralType = "metal"

/*
 * Light
 */
/obj/item/stack/tile/light
	name = "light tiles"
	gender = PLURAL
	singular_name = "light floor tile"
	desc = "A floor tile, made out off glass. Use a multitool on it to change its color."
	icon_state = "tile_light blue"
	force = 3
	throwforce = 5
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	turf_type = /turf/simulated/floor/light

/*
 * Fakespace
 */
/obj/item/stack/tile/fakespace
	name = "astral carpet"
	singular_name = "astral carpet"
	desc = "A piece of carpet with a convincing star pattern."
	icon_state = "tile_space"
	turf_type = /turf/simulated/floor/fakespace
	burn_state = FLAMMABLE

/obj/item/stack/tile/fakespace/loaded
	amount = 30

//High-traction
/obj/item/stack/tile/noslip
	name = "high-traction floor tile"
	singular_name = "high-traction floor tile"
	desc = "A high-traction floor tile. It feels rubbery in your hand."
	icon_state = "tile_noslip"
	turf_type = /turf/simulated/floor/noslip
	origin_tech = "materials=3"

/obj/item/stack/tile/noslip/loaded
	amount = 20

/obj/item/stack/tile/silent
	name = "silent tile"
	singular_name = "silent floor tile"
	desc = "A tile made out of tranquillite, SHHHHHHHHH!"
	icon_state = "tile-silent"
	origin_tech = "materials=1"
	turf_type = /turf/simulated/floor/silent
	mineralType = "tranquillite"
	materials = list(MAT_TRANQUILLITE=500)

//Pod floor
/obj/item/stack/tile/pod
	name = "pod floor tile"
	singular_name = "pod floor tile"
	desc = "A grooved floor tile."
	icon_state = "tile_pod"
	turf_type = /turf/simulated/floor/pod