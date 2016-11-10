/obj/structure/rescuer_computer
	name = "Rescuing Computer"
	desc = "this machine can be used to rescue the omegacorp's operatives at any moment, they will be teleported to the Phonebooth mainframe room \
			to activate the machine you must swipe an ID after a target has been chosen"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "rescuer_computer"
	anchored = 1
	density = 1
	opacity = 0
	var/is_setup = 0
	var/step = 0 //4 steps: 0 = cable, 1 = wirecutters, 2 = screwdriver, 3 = wrench
	var/mob/living/carbon/human/TARGET_HUMAN

/obj/structure/rescuer_computer/attack_hand(mob/user as mob)
	var/list/mob/living/carbon/human/Possible_Targets = list()
	for(var/mob/living/carbon/human/A_HUMAN in world)
		if(A_HUMAN.time_faction == "Omegacorp")
			Possible_Targets.Add(A_HUMAN)

	if(!TARGET_HUMAN)
		var/choice = input(user, "Choose a target to load for a rescue", "RESCUE", null) in Possible_Targets
		if(choice)
			flick("rescuer_computer_loading", src)
			icon_state = "rescuer_computer_ready"
			update_icon()
			TARGET_HUMAN = choice
			var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
			a.autosay("[TARGET_HUMAN] has been chosen for a rescue!", "[src]'s automated message system")
			qdel(a)
	else
		icon_state = "rescuer_computer"
		update_icon()
		TARGET_HUMAN = null

/obj/structure/rescuer_computer/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id))
		Rescue_Target(user)
		return

/obj/structure/rescuer_computer/proc/Rescue_Target(mob/user as mob)
	/*
	* 1) Sends a message through the radio
	* 2) Creates an overlay over the target and plays sounds
	* 3) Delays...
	* 4) Plays an animation on the target's location and the target returns to: 248, 125, 2
	* 5) If there's something dense in his place it is destroyed and the rescued target is gibbed
	* 6) The machine returns to no loaded targets
	*/

	if(!TARGET_HUMAN)
		flick("rescuer_computer_execute_null", src)
		playsound(src, 'sound/machines/metal_lever.ogg', 50,1)
		return 0

	flick("rescuer_computer_execute", src)
	playsound(src, 'sound/machines/metal_lever.ogg', 50,1)
	sleep(20)
	var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset(null)
	a.autosay("[TARGET_HUMAN] is being rescued!", "[src]'s automated message system")
	qdel(a)
	//CUIDADO AQUI
	var/obj/effect/overlay/rescuing_overlay/RESCUEOVERLAY
	//TARGET_HUMAN.overlays.Add(RESCUEOVERLAY)
	TARGET_HUMAN.underlays.Add(RESCUEOVERLAY)
	//TARGET_HUMAN.overlays.Add(/obj/effect/overlay/rescuing_overlay)
	TARGET_HUMAN.underlays.Add(/obj/effect/overlay/rescuing_overlay)
	/*var/image/I = image(RESCUEIMAGE.icon, TARGET_HUMAN, RESCUEIMAGE.icon_state, TARGET_HUMAN.layer+1)
	var/list/viewing = list()
	for(var/mob/M in viewers(TARGET_HUMAN))
		viewing |= M.client
	flick_overlay(I, viewing, 120)*/
	//CUIDADO AQUI
	playsound(src, 'sound/machines/recycler.ogg', 50,1)
	sleep(20)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50,1)
	visible_message("The target will be rescued in 10 seconds")
	sleep(30)
	playsound(TARGET_HUMAN, 'sound/effects/increasing_energy.ogg', 50,1)
	sleep(70)
	playsound(TARGET_HUMAN, 'sound/effects/supermatter.ogg', 50, 1)

	var/turf/dest = locate(248, 125, 2)
	TARGET_HUMAN.forceMove(dest)
	to_chat(TARGET_HUMAN, "<span class=userdanger> THAT WAS TRIPPY!! </span>")
	TARGET_HUMAN.Stun(5)
	TARGET_HUMAN.Weaken(5)
	shake_camera(TARGET_HUMAN, 25, 1)
	var/obj/structure/heat_controller/HEATCONTROL = locate()
	HEATCONTROL.heat += 25
	if(dest.density == 1)
		visible_message("<span class=biggerdanger> WHO PUT THAT THERE??? </span>")
		TARGET_HUMAN.gib()
		qdel(dest)
	for(var/obj/OBJ in dest)
		if(OBJ.density == 1)
			visible_message("<span class=biggerdanger> WHO PUT THAT THERE??? </span>")
			TARGET_HUMAN.gib()
			qdel(OBJ)

	//TARGET_HUMAN.overlays.Remove(RESCUEOVERLAY)
	TARGET_HUMAN.underlays.Remove(RESCUEOVERLAY)
	//TARGET_HUMAN.overlays.Remove(/obj/effect/overlay/rescuing_overlay)
	TARGET_HUMAN.underlays.Remove(/obj/effect/overlay/rescuing_overlay)
	TARGET_HUMAN.underlays.Cut()

	icon_state = "rescuer_computer"
	update_icon()
	TARGET_HUMAN = null

/obj/effect/overlay/rescuing_overlay
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "rescuing_human"

