/*
*	The ship works like this:
*
*	The ship is a mob which will be attacked by other hostile mobs and will be able to be controlled
*

*	1) First we have the way to enter the ship, 4 cannon hatches, 1 passenger hatch and a wheel
*	2) When you enter the ship you get transported to the ship's contents, from there you'll have access to the ship's verbs
*	3) The ship will check if you are a cannoneer a passenger or someone who controls the wheel
*	4) When inside the ship, you won't be able to move, teleport, use spells or items. You'll only be able to access the ship verbs and speech
*	5) Whoever joins in as the wheel gets transported to the ship's contents too, but his mind will be moved to the ship's.
	6) Whoever joined as the wheel won't be able to talk (Because he'll be the ship D:)


	BUGS:

	1- When inside the ship you take oxygen damage
	2- Hatches don't catch the ship at creation
	3- Verbs don't recognize who's wheelguy or who's cannon
*/


//Goddamnit, I'm making it living for now, but I don't like it -Sansaur
/mob/living/ship
	name = "ship"
	icon = 'icons/obj/medieval/ship.dmi'
	icon_state = "ship"
	density = 1
	anchored = 0
	health = 500		//Loads of health for now, but it'd be better to control this another way
	//status_flags = GODMODE  // You can't damage it.
	mouse_opacity = 1
	see_in_dark = 7
	invisibility = 0 // No one can see us
	//alpha = 150
	//sight = SEE_SELF
	move_on_shuttle = 0
	layer = MOB_LAYER+0.3	//Already is

	var/tech_speed = 3
	var/COOLDOWN = 0
	var/SLOWMOVEMENT = 0

	var/right_cannon_ready = 1
	var/left_cannon_ready = 1
	var/reloading_right = 0
	var/reloading_left = 0
	var/mob/living/carbon/human/wheel_guy
	var/mob/living/carbon/human/cannon1	//Left cannon
	var/mob/living/carbon/human/cannon2	//Left cannon
	var/mob/living/carbon/human/cannon3	//Right cannon
	var/mob/living/carbon/human/cannon4	//Right cannon
	var/list/mob/living/carbon/human/passengers = list()
	incorporeal_move = 0
	use_me = 0

/mob/living/ship/New()
	..()

/mob/living/ship/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		return
	else
		..()
		return

/mob/living/ship/proc/AddCannoneer(var/mob/living/carbon/human/ToAdd, var/position)
	switch(position)
		if(1)
			if(cannon1)		//If there already is a cannoneer
				return 0
			else
				cannon1 = ToAdd
				ToAdd.loc = src
				return 1
		if(2)
			if(cannon2)		//If there already is a cannoneer
				return 0
			else
				cannon2 = ToAdd
				ToAdd.loc = src
				return 1
		if(3)
			if(cannon3)		//If there already is a cannoneer
				return 0
			else
				cannon3 = ToAdd
				ToAdd.loc = src
				return 1
		if(4)
			if(cannon4)		//If there already is a cannoneer
				return 0
			else
				cannon4 = ToAdd
				ToAdd.loc = src
				return 1
		else
			return 0

/mob/living/ship/proc/AddWheel(var/mob/living/carbon/human/ToAdd)
	if(wheel_guy)
		return 0
	else
		wheel_guy = ToAdd
		src.ckey = ToAdd.ckey	//This is important to remember to set back
		ToAdd.loc = src
		return 1


/mob/living/ship/proc/AddPassenger(var/mob/living/carbon/human/ToAdd)
	passengers.Add(ToAdd)
	ToAdd.loc = src
	return 1

/mob/living/ship/forceMove(atom/destination)
	if(SLOWMOVEMENT)
		return

	SLOWMOVEMENT = 1
	var/turf/old_loc = loc
	loc = destination

	if(old_loc)
		old_loc.Exited(src, destination)
		for(var/atom/movable/AM in old_loc)
			AM.Uncrossed(src)

	if(destination)
		destination.Entered(src)
		for(var/atom/movable/AM in destination)
			AM.Crossed(src)

		if(isturf(destination) && opacity)
			var/turf/new_loc = destination
			new_loc.reconsider_lights()

	if(isturf(old_loc) && opacity)
		old_loc.reconsider_lights()

	for(var/datum/light_source/L in light_sources)
		L.source_atom.update_light()
	sleep(tech_speed)
	SLOWMOVEMENT = 0
	return 1

/*
/mob/living/time_cursor/proc/activate(var/clave as key, var/mob/living/carbon/human/HUMAN as mob, var/obj/structure/time_station/comp)
	human_to_return = HUMAN
	src.ckey = clave
	computer_to_close = comp
	Login()

/mob/living/time_cursor/Destroy()
	human_to_return.ckey = src.ckey
	computer_to_close.being_used = 0
	computer_to_close.icon_state = "time_station"
	computer_to_close.update_icon()
	to_chat(human_to_return, "<span class=info> The program closes </span>")
	//human_to_return.Login()
	..()
	return QDEL_HINT_HARDDEL_NOW */

/mob/living/ship/Login()
	..()
	update_interface()

/mob/living/ship/verb/Anchor()
	//This is used to both unload everyone in a harbour or to find treasure
	set name = "Drop anchor"
	set desc = "AHOY."
	set category = "SHIP"
	set src = view(0)	//HARDCORE TESTING!!!! -SANSAUR

	if(!wheel_guy)	//If there's noone at the wheel, anyone can drop the anchor
		visible_message("DROPPING THE ANCHOR!")
		var/turf/LANDMARKWATER = locate(x,y,z)
		var/obj/effect/landmark/ship/LANDMARK = locate() in LANDMARKWATER

		if(istype(LANDMARK, /obj/effect/landmark/ship/harbour))
			UnloadEveryoneAtPort()

			return

	if(usr == src)
		visible_message("DROPPING THE ANCHOR!")
		var/turf/LANDMARKWATER = locate(x,y,z)
		var/obj/effect/landmark/ship/LANDMARK = locate() in LANDMARKWATER

		if(istype(LANDMARK, /obj/effect/landmark/ship/harbour))
			UnloadEveryoneAtPort()

		else
			return 0
	else
		to_chat(usr, "You're not the wheel guy!")
		return 0

/mob/living/ship/verb/ShootCannon()
	set name = "Shoot cannon"
	set desc = "bang"
	set category = "SHIP"
	set src = view(0)	//TESTING FOR NOW!!!! -SANSAUR

	if(usr == cannon1 || usr == cannon2)
		ShootLeftCannon()
		return 1
	if(usr == cannon3 || usr == cannon4)
		ShootRightCannon()
		return 1
	else
		to_chat(usr, "You're not a cannoneer!")
		return 0

/mob/living/ship/verb/ReloadCannon()
	set name = "Reload cannon"
	set desc = "reaload!"
	set category = "SHIP"
	set src = view(0)	//TESTING FOR NOW!!!! -SANSAUR


	if(usr == cannon1 || usr == cannon2)
		if(reloading_left)
			return 0
		ReloadLeftCannon()
		return 1
	if(usr == cannon3 || usr == cannon4)
		if(reloading_right)
			return 0
		ReloadRightCannon()
		return 1
	else
		to_chat(usr, "You're not a cannoneer!")
		return 0



/mob/living/ship/proc/ShootLeftCannon()
	if(left_cannon_ready)
		playsound(loc, 'sound/weapons/cannonshot.ogg', 100,0)
		new /obj/effect/cannonball (loc, dir = 8)
		left_cannon_ready = 0
		return
	else
		return

/mob/living/ship/proc/ShootRightCannon()
	if(right_cannon_ready)
		playsound(loc, 'sound/weapons/cannonshot.ogg', 100,0)
		new /obj/effect/cannonball (loc, dir = 4)
		right_cannon_ready = 0
		return
	else
		return




/mob/living/ship/proc/ReloadLeftCannon()
	if(left_cannon_ready)
		return
	reloading_left = 1
	sleep(20)
	left_cannon_ready = 1
	reloading_left = 0
	playsound(loc, 'sound/effects/shipbell.ogg', 100,0)
	return

/mob/living/ship/proc/ReloadRightCannon()
	if(right_cannon_ready)
		return
	reloading_right = 1
	sleep(20)
	reloading_right = 0
	right_cannon_ready = 1
	playsound(loc, 'sound/effects/shipbell.ogg', 100,0)
	return

/mob/living/ship/proc/UnloadEveryoneAtPort()
	var/area/medieval/village/center/TESTINGAREA = locate()
	for(var/mob/living/carbon/human in contents)
		for(var/turf/simulated/floor/F in TESTINGAREA)
			if(prob(1))
				human.Move(F)
				break
			else
				continue

	if(wheel_guy)
		wheel_guy.ckey = src.ckey
	wheel_guy = null
	cannon1 = null	//Left cannon
	cannon2 = null	//Left cannon
	cannon3 = null	//Right cannon
	cannon4 = null	//Right cannon
	passengers.Cut()

/obj/effect/cannonball
	name = "cannonball"
	desc = "WOOOO."
	icon = 'icons/obj/medieval/ship.dmi'
	icon_state = "cannonball"
	anchored = 0
	density = 1
	var/movement_range = 10
	var/energy = 10

/obj/effect/cannonball/New(loc, dir = 2)		//Remember, when creating cannonballs they need dir too
	src.loc = loc
	src.dir = dir

	if(movement_range > 20)
		movement_range = 20
	spawn(0)
		move(1)
	return

/obj/effect/cannonball/Bump(atom/A)
	if(A)
		if(ismob(A))
			if(istype(A, /mob/living))
				var/mob/living/Target = A
				Target.adjustBruteLoss(energy)
				playsound(loc, 'sound/effects/meteorimpact.ogg', 100,0)

/obj/effect/cannonball/Bumped(atom/A)
	if(ismob(A))
		Bump(A)
	return

/obj/effect/cannonball/proc/move(var/lag)
	if(!step(src,dir))
		src.loc = get_step(src,dir)
	movement_range--
	if(movement_range <= 0)
		qdel(src)
	else
		sleep(lag)
		move(lag)

/mob/living/ship/movement_delay()
	return tech_speed
