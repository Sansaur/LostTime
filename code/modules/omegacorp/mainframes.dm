/**
*
* 4 Mainframes

	It must be setup if it's not setup...
* - 1) Power Mainframe =  the main and secondary TTPB computers cannot be used
* - 2) Stabilization Mainframe = if this is setup, timetravelling doesnt cause people to fall
* - 3) Scanner Resource Optimizer = if this is setup, all area scanners get additional steps to their scans
* - 4) Phonebooth forcefield generator = if this is setup, it can be connected to create a forcefield around the PB

**/

/obj/structure/pb_mainframe
	name = "Phonebooth mainframe"
	desc = "A mainframe"
	var/ori_desc = "This is imperative for you to setup, it's what allows the phonebooth to work!"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "power_mainframe0"
	var/ori_icon = "power_mainframe"
	anchored = 1
	density = 1
	opacity = 0
	var/is_setup = 0
	var/step = 0 //4 steps: 0 = cable, 1 = wirecutters, 2 = screwdriver, 3 = wrench

/obj/structure/pb_mainframe/attackby(obj/item/W, mob/user as mob)
	if(!is_setup)
		if(step == 0)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/thiscable = W
				if(thiscable.amount >= 10)
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, "You connect the cables in the machine")
					src.desc = ori_desc + " Looks like you need to secure the cables with wirecutters"
					thiscable.amount -= 10
					if(thiscable.amount <= 0)
						qdel(thiscable)
					step++
					icon_state = ori_icon+"[step]"
					update_icon()
				else
					to_chat(user, "You don't have enough cable!")
				return
			else
				to_chat(user, "This is not right...")
		if(step == 1)
			if(istype(W, /obj/item/weapon/wirecutters))
				playsound(src, 'sound/items/Wirecutter.ogg', 50, 1)
				to_chat(user, "You secure the cables in the machine")
				src.desc = ori_desc + " Looks like you need to screw some bolts in"
				step++
				icon_state = ori_icon+"[step]"
				update_icon()
				return
			else
				to_chat(user, "This is not right...")
		if(step == 2)
			if(istype(W, /obj/item/weapon/screwdriver))
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "You secure the bolts of the machine")
				src.desc = ori_desc + " Looks like you need to close the panel and wrench it down"
				step++
				//icon_state = ori_icon+"[step]"
				update_icon()
				return
			else
				to_chat(user, "This is not right...")
		if(step == 3)
			if(istype(W, /obj/item/weapon/wrench))
				playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
				to_chat(user, "You close the mainframe's panel and it turns on!")
				Complete()
				return
			else
				to_chat(user, "This is not right...")
	else
		to_chat(user, "The machine is ready!")

/obj/structure/pb_mainframe/proc/Complete()
	playsound(src, 'sound/machines/ping.ogg', 50, 1)
	icon_state = ori_icon+"3"
	update_icon()
	is_setup = 1

/obj/structure/pb_mainframe/power_mainframe
	name = "Power mainframe"
	desc = "This is imperative for you to setup, it's what allows the phonebooth to work!, looks like it's missing some cable"
	ori_desc = "This is imperative for you to setup, it's what allows the phonebooth to work!"
	icon_state = "power_mainframe0"
	ori_icon = "power_mainframe"

/obj/structure/pb_mainframe/stabilization_mainframe
	name = "Stabilization mainframe"
	desc = "Don't want to fall flat on your ass? Set this up! looks like it's missing some cables"
	ori_desc = "Don't want to fall flat on your ass? Set this up!"
	icon_state = "stabilization_mainframe0"
	ori_icon = "stabilization_mainframe"

/obj/structure/pb_mainframe/scanner_resource_mainframe
	name = "Stabilization mainframe"
	desc = "A better eye is about to explore this world! looks like it's missing some cables"
	ori_desc = "A better eye is about to explore this world!"
	icon_state = "scanner_resource_mainframe0"
	ori_icon = "scanner_resource_mainframe"

/obj/structure/pb_mainframe/forcefield_mainframe
	name = "Phonebooth forcefield mainframe"
	desc = "Use this machine to lock the phonebooth with an invisible forcefield! looks like it's missing some cables"
	ori_desc = "Use this machine to create a forcefield around the phonebooth!"
	icon_state = "forcefield_mainframe0"
	ori_icon = "forcefield_mainframe"
	var/active = 0
	var/list/obj/effect/forcefield/created_fields

/obj/structure/pb_mainframe/forcefield_mainframe/attack_hand(mob/user as mob)
	if(is_setup)
		active = !active
		if(active)
			icon_state = "forcefield_mainframe-active"
			update_icon()
			create_forcefield()
			return
		else
			icon_state = "forcefield_mainframe3"
			update_icon()
			delete_forcefield()
			return

/obj/structure/pb_mainframe/forcefield_mainframe/proc/create_forcefield()
	var/obj/structure/timetravel/phonebooth/PB = locate()
	PB.LOCKED = 1
	PB.overlays += /obj/effect/overlay/phonebooth_lock

/obj/structure/pb_mainframe/forcefield_mainframe/proc/delete_forcefield()
	var/obj/structure/timetravel/phonebooth/PB = locate()
	PB.LOCKED = 0
	PB.overlays -= /obj/effect/overlay/phonebooth_lock