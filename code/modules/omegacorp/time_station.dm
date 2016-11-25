/**
* The Time station can:
* 1) Remove a Turf and change it for grass, it stores that turf as an object in the machine,
	 then it allows for it to be placed down again, changing a different turf. (15 CD)
* 2) Create a forcefield around the cursor's position for up to 10 seconds (30 CD)
* 3) Heal an agent, it heals a small amount of brute and fire damage over time (10 CD)

The Time Station's cursor lasts forever but it's very slow, it can go through walls
**/



/obj/structure/time_station
	name = "Time Station"
	desc = "A non-developed time station made to help agents altering the enviroment or their bodies, it's still in\
			alpha state, be careful while using this contraption. <span class=warning> it's secured so it can only \
			be used in timelines different to the original Omegacorp one.</span>"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "time_station"
	anchored = 1
	density = 1
	opacity = 0
	var/being_used = 0

/obj/structure/time_station/attack_hand(mob/user as mob)
	if(being_used)
		to_chat(user, "The computer is in use at this time or it can't be accessed")
		return 0
	else
		var/obj/structure/timetravel/phonebooth/PHONEBOOTH = locate()
		if(!(PHONEBOOTH.loc.loc.type in medieval_areas))
			to_chat(user, "The computer gives a \"Omega.Timeline.Time.Station.Catcher.OriginalTimelineIndex\" error")
			return
		var/mob/living/time_cursor/neweye = new()
		var/mob/living/carbon/human/humantoreturn = user
		neweye.activate(user.ckey, humantoreturn, src)
		var/obj/structure/heat_controller/HEATCONTROL = locate()
		HEATCONTROL.heat += 25
		src.icon_state = "time_station_inuse"
		update_icon()
		being_used = 1

//Goddamnit, I'm making it living for now, but I don't like it -Sansaur
/mob/living/time_cursor
	name = "operating cursor"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "time_cursor"
	density = 0
	anchored = 1
	status_flags = GODMODE  // You can't damage it.
	mouse_opacity = 0
	see_in_dark = 7
	invisibility = SEE_INVISIBLE_OBSERVER // No one can see us
	alpha = 150
	sight = SEE_SELF
	move_on_shuttle = 0
	var/mob/living/carbon/human/human_to_return
	var/obj/structure/time_station/computer_to_close
	var/tech_speed = 7 //This is to allow improvements later on, the move_delay = the tech_speed
	incorporeal_move = 1
	var/STORED_TURF //Let's change this to types for now, it was Turfs earlier
	var/list/obj/effect/forcefield/FORCEFIELDS = list()
	var/COOLDOWN = 0
	var/SLOWMOVEMENT = 0
	use_me = 0
/mob/living/time_cursor/New()
	..()
	var/obj/structure/timetravel/phonebooth/Phonebooth = locate()
	forceMove(Phonebooth.loc)
	/*
/mob/living/time_cursor/movement_delay()
	var/tally = 0
	tally = tech_speed
	return tally
	*/
/mob/living/time_cursor/forceMove(atom/destination)
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
	return QDEL_HINT_HARDDEL_NOW

/mob/living/time_cursor/Login()
	..()
	update_interface()

/mob/living/time_cursor/verb/Auto_Destruct()
	set name = "Stop scanning"
	set desc = "Use this action to stop scanning the area as the eye"
	set category = "CURSOR"
	Destroy()

/mob/living/time_cursor/verb/Turf_Manipulation()
	set name = "Turf Manipulation"
	set desc = "Terraforming"
	set category = "CURSOR"

	if(COOLDOWN)
		to_chat(src, "The computer is not ready to do that yet")
		return

	if(STORED_TURF)
		var/turf/T = loc
		//T.ChangeTurf(STORED_TURF.type)
		T.ChangeTurf(STORED_TURF)
		STORED_TURF = null
		icon_state = "time_cursor"
		Cooldown(200)
	else
		STORED_TURF = loc.type
		var/turf/T = loc
		T.ChangeTurf(/turf/simulated/floor/grass)
		icon_state = "time_cursor_turf"

/mob/living/time_cursor/verb/Force_Fields()
	set name = "Create Forcefields"
	set desc = "A ring of forcefields"
	set category = "CURSOR"

	if(COOLDOWN)
		to_chat(src, "The computer is not ready to do that yet")
		return
	var/turf/TLOC
	for(var/card in cardinal)
		TLOC = get_step(src, card)
		var/obj/effect/forcefield/FF = new(TLOC)
		FORCEFIELDS.Add(FF)
	Cooldown(50)
	for(var/obj/effect/forcefield/FF in FORCEFIELDS)
		qdel(FF)
	FORCEFIELDS.Cut()
	Cooldown(150)

/mob/living/time_cursor/verb/Heal_Place()
	set name = "Time restoration"
	set desc = "Return your patient's limbs to a better time. Member?"
	set category = "CURSOR"

	if(COOLDOWN)
		to_chat(src, "The computer is not ready to do that yet")
		return
	for(var/mob/living/carbon/human/HUMANS in src.loc)
		var/obj/effect/overlay/healing_overlay/RESCUEOVERLAY
		HUMANS.underlays.Add(RESCUEOVERLAY)
		HUMANS.underlays.Add(/obj/effect/overlay/healing_overlay)

		for(var/i; i<= 10; i++) //Supposedly heals 30 damage
			playsound(HUMANS, 'sound/effects/scifi_pulse.ogg', 60, 1)
			HUMANS.adjustBruteLoss(-3)
			HUMANS.adjustFireLoss(-3)
			Cooldown(10)
			//sleep(10) //Antes era sleep


		Cooldown(10) //Antes era sleep
		HUMANS.underlays.Remove(RESCUEOVERLAY)
		HUMANS.underlays.Remove(/obj/effect/overlay/healing_overlay)
		HUMANS.underlays.Cut()
		Cooldown(10)
	Cooldown(80)


/mob/living/time_cursor/proc/Cooldown(var/amount)
	icon_state = "time_cursor_cooldown"
	COOLDOWN = 1
	sleep(amount)
	COOLDOWN = 0
	icon_state = "time_cursor"
	if(STORED_TURF)
		icon_state = "time_cursor_turf"

/obj/effect/overlay/healing_overlay
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "healing_overlay"

/mob/living/time_cursor/movement_delay()
	return tech_speed
