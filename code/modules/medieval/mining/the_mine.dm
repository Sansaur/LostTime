/**

STAIRS TO GO INTO AND OUT THE MINE

**/

/obj/effect/step_trigger/teleport_fancy/mine_tp/from_village_to_mine
	invisibility = 101

/obj/effect/step_trigger/teleport_fancy/mine_tp/from_village_to_mine/Trigger(mob/M as mob)

	//MANUAL FOR NOW, IT CAN BE IMPROVED IN THE FUTURE

	var/locx = 104
	var/locy = 105
	var/locz = 5
	var/dest = locate(locx, locy, locz)
	M.loc = dest //Let's test this!!
	return 1


/obj/effect/step_trigger/teleport_fancy/mine_tp/from_mine_to_village
	invisibility = 101

/obj/effect/step_trigger/teleport_fancy/mine_tp/from_mine_to_village/Trigger(mob/M as mob)

	//MANUAL FOR NOW, IT CAN BE IMPROVED IN THE FUTURE

	var/locx = 86
	var/locy = 130
	var/locz = 1
	var/dest = locate(locx, locy, locz)
	M.loc = dest //Let's test this!!
	return 1

/obj/structure/stairs/to_the_mine
	name = "stairs"
	desc = "these ones go towards the mine"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "stairs_down"

/obj/structure/stairs/to_the_mine/Destroy()
	return //Indestructible

/obj/structure/stairs/to_the_mine/New()
	new /obj/effect/step_trigger/teleport_fancy/mine_tp/from_village_to_mine (src.loc)
	..()

/obj/structure/stairs/to_the_village
	name = "stairs"
	desc = "these ones go towards the village"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "stairs_up"

/obj/structure/stairs/to_the_village/Destroy()
	return //Indestructible

/obj/structure/stairs/to_the_village/New()
	new /obj/effect/step_trigger/teleport_fancy/mine_tp/from_mine_to_village (src.loc)
	..()

/**

The code to make both monsters and treasure spawn on the stone mine tiles

**/



/turf/simulated/floor/stone/mine // - Sansaur
	icon_state = "stone_mine"
	floor_tile = null
	var/mob_spawn_list_1 = list("FriendKobold" = 2,"Hivelord" = 2) //Easy Monsters
	var/mob_spawn_list_2 = list("Basilisk" = 4) //Normal Monsters
	var/mob_spawn_list_3 = list("Goliath" = 5) //Fuck-you Monsters
	var/expandChance = 45
	broken_states = list("stone_mine") // NEEDS BROKEN SPRITE - Sansaur

	// THIS SHOULDN'T EXIST.
/turf/simulated/floor/stone/mine/proc/Normalize_Air()
	if(air)
		if(air.oxygen < 19)
			air.oxygen = 19

		if(air.nitrogen < 80)
			air.nitrogen = 80

		if(air.temperature < 19)
			air.temperature = 283 ///??????????? TOTAL TESTING


/turf/simulated/floor/stone/mine/New()
	..()
	Startup()
	Normalize_Air()

/turf/simulated/floor/stone/mine/attackby(obj/item/O, mob/user as mob)
	return

	// THIS IS IMPORTANT TO FIX IN THE FUTURE. - Sansaur
/turf/simulated/floor/stone/mine/Assimilate_Air()
	//We are doing this because our mine ACTUALLY HAS AIR
	if(air)
		var/aoxy = 0//Holders to assimilate air from nearby turfs
		var/anitro = 0
		var/aco = 0
		var/atox = 0
		var/atemp = 0
		var/turf_count = 0

		for(var/direction in cardinal)//Only use cardinals to cut down on lag
			var/turf/T = get_step(src,direction)
			if(istype(T,/turf/space))//Counted as no air
				turf_count++//Considered a valid turf for air calcs
				continue
			else if(istype(T,/turf/simulated/floor))
				var/turf/simulated/S = T
				if(S.air)//Add the air's contents to the holders
					aoxy += S.air.oxygen
					anitro += S.air.nitrogen
					aco += S.air.carbon_dioxide
					atox += S.air.toxins
					atemp += S.air.temperature
				turf_count++
		air.oxygen = (aoxy/max(turf_count,1))//Averages contents of the turfs, ignoring walls and the like //Will this do it?? Sansaur
		//Will this do it?? Sansaur, this is so fucking hacky...
		// Change this for the acceptable values
		air.nitrogen = (anitro/max(turf_count,1))
		air.carbon_dioxide = (aco/max(turf_count,1))
		air.toxins = (atox/max(turf_count,1))
		air.temperature = (atemp/max(turf_count,1))//Trace gases can get bant
		Normalize_Air()
		if(air_master)
			air_master.add_to_active(src)



/turf/simulated/floor/stone/mine/proc/Startup()
	//WE MIGHT HAVE TO REMOVE THIS "SLEEP" HERE -Sansaur
	//sleep(10)
	if(prob(expandChance))
		Expand()
	SpawnMonster()

	fullUpdateMineralOverlays()

/turf/simulated/floor/stone/mine/proc/Expand()
	if(!loc) return 0
	// If there's a human close it won't expand
	for(var/mob/living/carbon/human/NearHuman in loc.contents)
		if(get_dist(src, NearHuman.loc) <= 5)
			return 0


	update_icon()
	for(var/direction in cardinal)
		if(prob(expandChance / 2))
			return
		var/turf/edge = get_step(src,direction)
		if(edge && istype(edge, /turf/simulated/mineral))
			edge.ChangeTurf(/turf/simulated/floor/stone/mine)
			//new /turf/simulated/floor/stone/mine (edge.loc)
			//qdel(edge)


/turf/simulated/floor/stone/mine/proc/SpawnMonster()
	if(prob(30))
		if(istype(loc, /area/medieval/underground/mine_generic))
			return
		if(istype(loc, /area/medieval/underground/mine_start))
			return
		if(istype(loc, /area/medieval/underground/mine_level_1))
			for(var/atom/A in range(15,src))//Lowers chance of mob clumps
				if(istype(A, /mob/living/simple_animal/hostile/asteroid)) //Remember to change the type of this monster in the future
					return
			var/randumb = pickweight(mob_spawn_list_1)
			switch(randumb)
				if("FriendKobold")
					new /mob/living/simple_animal/friendly_kobold(src)
				if("Hivelord")
					new /mob/living/simple_animal/hostile/asteroid/hivelord(src)

		if(istype(loc, /area/medieval/underground/mine_level_2))
			for(var/atom/A in range(15,src))//Lowers chance of mob clumps
				if(istype(A, /mob/living/simple_animal/hostile/asteroid))
					return
			var/randumb = pickweight(mob_spawn_list_2)
			switch(randumb)
				if("Goliath")
					new /mob/living/simple_animal/hostile/asteroid/goliath(src)
				if("Goldgrub")
					new /mob/living/simple_animal/hostile/asteroid/goldgrub(src)
				if("Basilisk")
					new /mob/living/simple_animal/hostile/asteroid/basilisk(src)
				if("Hivelord")
					new /mob/living/simple_animal/hostile/asteroid/hivelord(src)

		if(istype(loc, /area/medieval/underground/mine_level_3))
			for(var/atom/A in range(15,src))//Lowers chance of mob clumps
				if(istype(A, /mob/living/simple_animal/hostile/asteroid))
					return
			var/randumb = pickweight(mob_spawn_list_3)
			switch(randumb)
				if("Goliath")
					new /mob/living/simple_animal/hostile/asteroid/goliath(src)
				if("Goldgrub")
					new /mob/living/simple_animal/hostile/asteroid/goldgrub(src)
				if("Basilisk")
					new /mob/living/simple_animal/hostile/asteroid/basilisk(src)
				if("Hivelord")
					new /mob/living/simple_animal/hostile/asteroid/hivelord(src)

	return