/obj/structure/stairs/ship_hatch
	name = "ship hatch"
	desc = "these ones go towards the mine"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "stairs_down"
	var/target_position = ""
	var/mob/living/ship/MAINSHIP

/obj/structure/stairs/ship_hatch/New()
	..()
	InitializeShip()




/obj/structure/stairs/ship_hatch/Destroy()
	return //Indestructible

/obj/structure/stairs/ship_hatch/proc/InitializeShip()
	sleep(100)
	spawn(100)
	MAINSHIP = locate() in world
	if(!MAINSHIP)
		var/turf/simulated/floor/SHIPWATER = locate(245, 253, 3)
		message_admins("Turf located: [SHIPWATER]")
		MAINSHIP = locate() in SHIPWATER
		message_admins("Ship located: [MAINSHIP]")
	if(!MAINSHIP)
		MAINSHIP = locate(/mob/living/ship) in world

/obj/structure/stairs/ship_hatch/attack_hand(mob/user as mob)
	switch(target_position)
		if("cannon1")
			if(MAINSHIP.AddCannoneer(user, 1))
				return
			else
				to_chat(user, "That position is already taken!")
		if("cannon2")
			if(MAINSHIP.AddCannoneer(user, 2))
				return
			else
				to_chat(user, "That position is already taken!")
		if("cannon3")
			if(MAINSHIP.AddCannoneer(user, 3))
				return
			else
				to_chat(user, "That position is already taken!")
		if("cannon4")
			if(MAINSHIP.AddCannoneer(user, 4))
				return
			else
				to_chat(user, "That position is already taken!")

		if("passenger")
			if(MAINSHIP.AddPassenger(user))
				return
			else
				to_chat(user, "That position is already taken!")
		if("wheel")
			if(MAINSHIP.AddWheel(user))
				return
			else
				to_chat(user, "That position is already taken!")
		else
			to_chat(user, "CONTACT A CODER!!!")

/obj/structure/stairs/ship_hatch/cannon1
	target_position = "cannon1"
/obj/structure/stairs/ship_hatch/cannon2
	target_position = "cannon2"
/obj/structure/stairs/ship_hatch/cannon3
	target_position = "cannon3"
/obj/structure/stairs/ship_hatch/cannon4
	target_position = "cannon4"
/obj/structure/stairs/ship_hatch/passenger
	target_position = "passenger"
/obj/structure/stairs/ship_hatch/wheel
	target_position = "wheel"