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

/obj/structure/pb_mainframe/power_mainframe/proc/Explosion()
	new /obj/item/mainframe_building/circuit(src.loc)
	new /obj/item/mainframe_building/assembly(src.loc)
	new /obj/item/mainframe_building/engine(src.loc)
	visible_message("The [src] goes boom!")
	explosion(src, -1, -1, 3, 3)
	qdel(src)

/obj/structure/pb_mainframe/power_mainframe/New()
	..()
	var/obj/structure/power_mainframe_repair/MAINREPAIR = locate()
	qdel(MAINREPAIR)
	//Esto no lo coge porque el heatcontrol se crea despues, hacemos un metodo y que se llame desde el propio heatcontrol


/obj/structure/pb_mainframe/stabilization_mainframe
	name = "Stabilization mainframe"
	desc = "Don't want to fall flat on your ass? Set this up! looks like it's missing some cables"
	ori_desc = "Don't want to fall flat on your ass? Set this up!"
	icon_state = "stabilization_mainframe0"
	ori_icon = "stabilization_mainframe"

/obj/structure/pb_mainframe/scanner_resource_mainframe
	name = "Scanner console resource optimizer"
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
	var/obj/structure/heat_controller/HEATCONTROL = locate()
	HEATCONTROL.heat += 5

/obj/structure/pb_mainframe/forcefield_mainframe/proc/delete_forcefield()
	var/obj/structure/timetravel/phonebooth/PB = locate()
	PB.LOCKED = 0
	PB.overlays -= /obj/effect/overlay/phonebooth_lock
	var/obj/structure/heat_controller/HEATCONTROL = locate()
	HEATCONTROL.heat += 5

/********
HERE GO THE PARTS TO BUILD THE MAINFRAME ONCE AGAIN
**********/

/obj/item/mainframe_building/Destroy()
	return

/obj/item/mainframe_building/assembly
	name = "Power mainframe assembly"
	desc = "Whoops"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "assembly_broken"
	var/repaired = 0

/obj/item/mainframe_building/assembly/attack_self(mob/user as mob)
	if(repaired)
		visible_message("[user] deploys the [src] to prepare a new assembly")
		new /obj/structure/power_mainframe_repair(user.loc)
		del src
	else
		to_chat(user, "This assembly is still broken, you must weld it back to stability")

/obj/item/mainframe_building/assembly/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			visible_message("[user] starts repairing the [src] and he shapes it back")
			if(do_after(user, 80, target = src))
				playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
				icon_state = "assembly_ready"
				update_icon()
				repaired = 1

/obj/structure/power_mainframe_repair
	name = "Power mainframe assembly"
	desc = "A mainframe"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "power_mainframe_repair"
	anchored = 1
	density = 1
	opacity = 0
	var/step = 0 // 0 = Needs Engine | 1 = Needs Circuit | 2 = Needs Screwdriver

/obj/structure/power_mainframe_repair/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/mainframe_building/engine))
		if(step == 0)
			visible_message("<span class=notice>[user] starts adding the [W] to the [src]</span>")
			if(do_after(user, 50, target = src))
				playsound(src.loc, 'sound/machines/metal_lever.ogg', 60, 1)
				icon_state = "power_mainframe_repair_engine"
				update_icon()
				del W
				step = 1
				return
		else
			to_chat(user, "<span class=warning>[W] is not the item it needs</span>")

	if(istype(W, /obj/item/mainframe_building/circuit))
		if(step == 1)
			visible_message("<span class=notice>[user] starts adding the [W] to the [src]</span>")
			if(do_after(user, 10, target = src))
				playsound(src.loc, 'sound/machines/click.ogg', 100, 1)
				icon_state = "power_mainframe0"
				update_icon()
				del W
				step = 2
				return
		else
			to_chat(user, "<span class=warning>[W] is not the item it needs</span>")

	if(istype(W, /obj/item/weapon/screwdriver))
		if(step == 2)
			visible_message("<span class=notice>[user] secures the bolts of the machine</span>")
			if(do_after(user, 50, target = src))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				new /obj/structure/pb_mainframe/power_mainframe (src.loc)
				qdel(src)
		else
			to_chat(user, "<span class=warning>[W] is not the item it needs</span>")

	if(step == 2)
		qdel(src)
		return

/obj/item/mainframe_building/circuit
	name = "Power mainframe circuit"
	desc = "This circuit has always looked pretty clumsy to use."
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "circuit"


/obj/item/mainframe_building/engine
	name = "Power mainframe engine"
	desc = "So it was the bottom part!"
	w_class = 5
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "engine"

