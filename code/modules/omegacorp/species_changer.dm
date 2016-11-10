/obj/structure/species_changer
	name = "quick species alterer"
	desc = "This machine allows the user to transform into the species inserted in a data disk."
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "species_changer_platform"
	anchored = 1
	density = 0
	opacity = 0
	var/obj/structure/species_server/my_server

/obj/structure/species_changer/New()
	..()
	detect_server()

/obj/structure/species_changer/attack_hand(mob/user as mob)
	visible_message("[user] presses the [src]'s server detection button")
	detect_server()
	..()
/obj/structure/species_changer/verb/activate_change()
	set name = "Activate Species Change"
	set desc = "Activate the species change!"
	set category = "Object"
	set src in oview(1)

	if(my_server)
		change_species()
	else
		visible_message("<span class=warning> The [src] has not located the servers, please press the button on the platform to locate the nearest server")
		playsound(loc, 'sound/machines/synth_no.ogg', 70, 1)

/obj/structure/species_changer/proc/change_species()
	playsound(loc, 'sound/goonstation/machines/printer_thermal.ogg', 70, 1)
	layer = 11
	flick("species_changer_platform_ENGAGED", src)
	var/mob/living/carbon/human/HUMAN
	for(HUMAN in src.loc)
		var/species = my_server.disk.stored_species
		HUMAN.change_species(my_server.disk.stored_species)//LET'S KEEP DEBUGGING THIS
		HUMAN.change_species(species)//LET'S KEEP DEBUGGING THIS
		visible_message("<span class=warning>[HUMAN] has been turned into a [my_server.disk.stored_species]!!</span>")
	layer = 3

/obj/structure/species_changer/proc/detect_server()
	for(var/card in cardinal)
		var/turf/T
		T = get_step(src, card)
		if(!my_server)
			for(var/obj/structure/W in T)
				if(istype(W, /obj/structure/species_server))
					my_server = W

/obj/structure/species_server
	name = "quick species alterer server"
	desc = "This machine stores the information of the datadisks and prepares it to be sent to the transformation platform"
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "species_server"
	anchored = 1
	density = 1
	opacity = 0
	var/obj/item/weapon/species_datadisk/disk


/obj/structure/species_server/attack_hand(mob/user as mob)
	if(!disk)
		visible_message("There's no disk on the [src]")
		return
	else
		visible_message("[user] took the [disk] out")
		disk.loc = src.loc
		user.put_in_hands(disk)
		disk = null
		return

/obj/structure/species_server/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/species_datadisk))
		if(!disk)
			visible_message("[user] introduced the [W] into the [src]")
			user.drop_item()
			W.loc = src
			disk = W
			return
		else
			to_chat(user, "There's already a disk in the server")
			return

/obj/structure/species_server_computer
	name = "quick species alterer computer"
	desc = "Do you want to know what's inside a datadisk? You'll have to USE THIS."
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "species_server_comp"
	anchored = 1
	density = 1
	opacity = 0
	var/obj/item/weapon/species_datadisk/disk

/obj/structure/species_server_computer/attack_hand(mob/user as mob)
	if(!disk)
		visible_message("There's no disk on the [src]")
		return
	else
		var/response
		var/alertmsg = "What do you want to do with the computer?"
		response = input(alertmsg,"Operating", "Exit") in list("Exit", "Eject Disk", "Change Disk Species", "Show Disk Data")
		if(response == "Eject Disk")
			visible_message("[user] took the [disk] out")
			disk.loc = src.loc
			user.put_in_hands(disk)
			disk = null
			return

		if(response == "Change Disk Species")
			var/altering
			var/list/availible_species = list("Human")
			var/obj/structure/human_imprinter_comp/database
			for(database in world)
				if(database.scanned_humans)
					for(var/mob/living/carbon/human/HUMANOID in database.scanned_humans)
						if(HUMANOID.species.name in availible_species)
							continue
						else
							availible_species.Add(HUMANOID.species.name)


			if(availible_species.len == 1)
				to_chat(user, "There's only humans in the availible species database, do you want to change the disk's data to the Human species?")
				var/choice = input(user, "Decide time!", "Operating", "No") in list("Yes", "No")
				if(choice == "No")
					return 0

			altering = input(user, "Choose a new species to change the disk contents to", "Operating", null) in availible_species
			disk.stored_species = altering
			return 1
		if(response == "Show Disk Data")
			to_chat(user, "The disk contains the information of a [disk.stored_species]")
			return
		if(response == "Exit")
			return
		return

/obj/structure/species_server_computer/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/species_datadisk))
		if(!disk)
			visible_message("[user] introduced the [W] into the [src]")
			user.drop_item()
			W.loc = src
			disk = W
			return
		else
			to_chat(user, "There's already a disk in the [src]")
			return

/obj/item/weapon/species_datadisk
	name = "species datadisk"
	desc = "contains random data of the specified species, be careful when using this and remember to scan yourself beforehand"
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "species_datadisk"
	var/datum/species/stored_species
	//These I will do tomorrow, I hope
	var/random_skin_r
	var/random_skin_g
	var/random_skin_b
	var/random_hair
	var/random_facial

/obj/item/weapon/species_datadisk/New()
	//if(stored_species)
	//	desc += "\n this disk contains the data of a [stored_species]"

/obj/item/weapon/species_datadisk/random

/obj/item/weapon/species_datadisk/random/New()
	stored_species = pick("Human", "Unathi", "Tajaran", "Vulpkanin", "Kobold", "Dwarf")
	..()