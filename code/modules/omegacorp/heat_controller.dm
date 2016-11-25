/obj/structure/heat_controller
	name = "Heat Controller"
	desc = "The thing you will hate the most!"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "heat_controller_0"
	anchored = 1
	density = 1
	opacity = 0
	var/ice = 0
	var/heat = 0 //Max is 125 now
	var/obj/structure/pb_mainframe/power_mainframe/MAINFRAME

/obj/structure/heat_controller/New()
	..()
	MAINFRAME = locate()
	processing()

/obj/structure/heat_controller/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers))
		var/icing = "ice"
		var/obj/item/weapon/reagent_containers/REAGENTCONT = W
		if(icing in REAGENTCONT.list_reagents)
			if(REAGENTCONT.list_reagents[icing] > REAGENTCONT.amount_per_transfer_from_this)
				REAGENTCONT.list_reagents[icing] -= REAGENTCONT.amount_per_transfer_from_this
				ice = REAGENTCONT.amount_per_transfer_from_this

/obj/structure/heat_controller/proc/processing()
	if(ice)
		ice--
		if(heat > 0)
			heat--
	if(prob(10))
		if(heat > 0)
			heat--
	if(heat > 50)
		if(prob(50))
			heat++
		if(prob(10))
			visible_message("<span class=warning>The [src] hums omniously</span>")
	if(heat > 100)
		heat++
		if(prob(30))
			visible_message("<span class=danger>The [src] is overheating!!</span>")

	if(heat > 125)

		if(MAINFRAME)
			MAINFRAME.Explosion()
			heat = 0
			update_icon()
			processing() //AFTER ENTERING HERE IT STOPS PROCESSING CORRECTLY

	update_icon()
	sleep(30)
	processing()
	return

/obj/structure/heat_controller/update_icon()
	if(heat == 0)
		icon_state = "heat_controller_0"
	if(heat > 0 && heat <= 25)
		icon_state = "heat_controller_1"
	if(heat > 25 && heat <= 50)
		icon_state = "heat_controller_2"
	if(heat > 50 && heat <= 100)
		icon_state = "heat_controller_3"
	if(heat > 100)
		icon_state = "heat_controller_4"

	//desc = "The thing you will hate the most! It reads it has a [heat]% amount of temperature instability"