/turf/simulated/floor/vault
	icon = 'icons/turf/floors.dmi'
	icon_state = "rockvault"
	smooth = SMOOTH_FALSE

/turf/simulated/floor/vault/New(location, vtype)
	..()
	icon_state = "[vtype]vault"

/turf/simulated/wall/vault
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"
	smooth = SMOOTH_FALSE

/turf/simulated/wall/vault/New(location, vtype)
	..()
	icon_state = "[vtype]vault"

/turf/simulated/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/simulated/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"

/turf/simulated/floor/greengrid/airless
	icon_state = "gcircuit"
	name = "airless floor"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

/turf/simulated/floor/greengrid/airless/New()
	..()
	name = "floor"

/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"
	slowdown = 4
	footstep_sounds = list(
		"human" = list('sound/effects/footstep/swimming.ogg'), //@RonaldVanWonderen of Freesound.org
		"xeno"  = list('sound/effects/footstep/swimming.ogg')  //@RonaldVanWonderen of Freesound.org
	)
/turf/simulated/floor/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)

/turf/simulated/floor/beach/water/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers/glass/bucket))
		var/obj/item/weapon/reagent_containers/glass/bucket/BUCKET = W
		BUCKET.reagents.add_reagent("water",120)
		to_chat(user, "<span class=info> You fill the bucket to the brim with water </span>")
		return

	if(istype(W, /obj/item/weapon/fishing_rod))
		var/area/medieval/castle/CASTLEAREA
		if(loc == CASTLEAREA)
			to_chat(user, "There are no fish around here...")
			return
		else
			var/obj/item/weapon/fishing_rod/ROD = W
			ROD.attempt_fish(user, src)
			return

/turf/simulated/floor/noslip
	name = "high-traction floor"
	icon_state = "noslip"
	floor_tile = /obj/item/stack/tile/noslip
	broken_states = list("noslip-damaged1","noslip-damaged2","noslip-damaged3")
	burnt_states = list("noslip-scorched1","noslip-scorched2")
	slowdown = -0.3

/turf/simulated/floor/noslip/MakeSlippery()
	return

/turf/simulated/floor/silent
	name = "silent floor"
	icon_state = "silent"
	floor_tile = /obj/item/stack/tile/silent
	shoe_running_volume = 0
	shoe_walking_volume = 0