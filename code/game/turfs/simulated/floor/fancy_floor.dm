/turf/simulated/floor/wood
	icon_state = "wood"
	floor_tile = /obj/item/stack/tile/wood
	broken_states = list("wood-broken", "wood-broken2", "wood-broken3", "wood-broken4", "wood-broken5", "wood-broken6", "wood-broken7")

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/wood_all.ogg'), //@RonaldVanWonderen of Freesound.org
		"xeno"  = list('sound/effects/footstep/wood_all.ogg')  //@RonaldVanWonderen of Freesound.org
	)

/turf/simulated/floor/wood/attackby(obj/item/C, mob/user, params)
	if(..())
		return
	if(istype(C, /obj/item/weapon/screwdriver))
		if(broken || burnt)
			return
		to_chat(user, "<span class='danger'>You unscrew the planks.</span>")
		new floor_tile(src)
		make_plating()
		playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
		return

/turf/simulated/floor/wood/royal_wood // - Sansaur
	icon_state = "wood2"
	floor_tile = /obj/item/stack/tile/wood/royal_wood
	broken_states = list("wood2-broken", "wood2-broken2")

/turf/simulated/floor/wood/worker_wood // - Sansaur
	icon_state = "wood3"
	floor_tile = /obj/item/stack/tile/wood/worker_wood
	broken_states = list("wood3-broken", "wood3-broken2")

/turf/simulated/floor/wood/worker_wood_mini // - Sansaur
	icon_state = "wood4"
	floor_tile = /obj/item/stack/tile/wood/worker_wood_mini
	broken_states = list("wood4-broken", "wood4-broken2")

// STONE FLOORS. - Sansaur

/turf/simulated/floor/stone
	icon_state = "stone"
	floor_tile = /obj/item/stack/tile/stone
	broken_states = list("stone-broken")

/turf/simulated/floor/stone/tiled_multi // - Sansaur
	icon_state = "stone2"
	floor_tile = /obj/item/stack/tile/stone/tiled_multi
	broken_states = list("stone2-broken", "stone2-broken2")

/turf/simulated/floor/stone/tiled // - Sansaur
	icon_state = "stone3"
	floor_tile = /obj/item/stack/tile/stone/tiled
	broken_states = list("stone3-broken", "stone3-broken2")


	// STONE FLOORS.
/turf/simulated/floor/grass
	name = "grass patch"
	icon_state = "grass1"
	floor_tile = /obj/item/stack/tile/grass
	broken_states = list("sand")
	var/excavated = 0
	var/obj/item/BURIED_ITEM

/turf/simulated/floor/grass/New()
	..()
	spawn(1)
		update_icon()

/turf/simulated/floor/grass/update_icon()
	..()
	if(!(icon_state in list("grass1", "grass2", "grass3", "grass4", "sand")))
		icon_state = "grass[pick("1","2","3","4")]"

/turf/simulated/floor/grass/attackby(obj/item/C, mob/user, params)
	if(..())
		return
	if(istype(C, /obj/item/weapon/shovel))
		if(!excavated)

			if(BURIED_ITEM)
				BURIED_ITEM.invisibility = 3
				BURIED_ITEM.loc = src
				BURIED_ITEM = null
			else
				new /obj/item/weapon/ore/glass(src)
			to_chat(user, "<span class='notice'>You shovel the grass.</span>")
			icon_state = "grass_dug"
			excavated = 1
			return
		else
			to_chat(user, "<span class='warning'> You cannot dig here!.</span>")
			return
		//make_plating()

	if(istype(C, /obj/item/weapon/ore/glass))
		if(excavated)
			to_chat(user, "<span class='notice'>You add some sand to the grass.</span>")
			qdel(C)
			icon_state = "grass[pick("1","2","3","4")]"
			excavated = 0
			return

	if(istype(C, /obj/item/stack/tile))
		var/obj/item/stack/tile/TILE = C
		ChangeTurf(TILE.turf_type)
		TILE.use(1)

	if(excavated)
		if(C.w_class <= 2)
			user.drop_item()
			BURIED_ITEM = C
			C.invisibility = 101
			C.loc = src
			icon_state = "grass_buried"
			excavated = 0


/turf/simulated/floor/carpet
	name = "Carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet"
	floor_tile = /obj/item/stack/tile/carpet
	broken_states = list("damaged")
	smooth = SMOOTH_TRUE
	canSmoothWith = null

	footstep_sounds = list(
		"human" = list('sound/effects/footstep/carpet_human.ogg'),
		"xeno"  = list('sound/effects/footstep/carpet_xeno.ogg')
	)


/turf/simulated/floor/carpet/New()
	..()
	if(broken || burnt)
		make_plating()

/turf/simulated/floor/carpet/update_icon()
	if(!..())
		return 0
	if(!broken && !burnt)
		if(smooth)
			smooth_icon(src)
	else
		make_plating()
		if(smooth)
			smooth_icon_neighbors(src)

/turf/simulated/floor/carpet/break_tile()
	broken = 1
	update_icon()

/turf/simulated/floor/carpet/burn_tile()
	burnt = 1
	update_icon()

/turf/simulated/floor/fakespace
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	floor_tile = /obj/item/stack/tile/fakespace
	broken_states = list("damaged")

/turf/simulated/floor/fakespace/New()
	..()
	icon_state = "[rand(0,25)]"


