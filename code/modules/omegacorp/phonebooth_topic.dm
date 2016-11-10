/obj/structure/timetravel/phonebooth_computer
	name = "Time Travelling Phone Booth Controller"
	desc = "Use this to FLY THROUGH TIME, it's based on a super old computer, so faulty manipulation can lead to BSODs"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "computer"
	density = 1
	opacity = 0
	anchored = 1
	var/obj/structure/timetravel/phonebooth/master_booth
	var/password
	var/selected_location
	var/ID_SCANNED
	var/needs_restart
	var/restart_sound = 'sound/machines/oldcomputer_bootup.ogg'
	var/error_sound = 'sound/machines/oldcomputer_error.ogg'
	var/restarting
	var/secure //Can be emagged? This will make it so entering wrong coordinates fucks the whole thing up
	var/locationX
	var/locationY
	var/ready
	var/operating
	var/icotext

/obj/structure/timetravel/phonebooth_computer/New()
	password = 0
	ID_SCANNED = 0
	restarting = 0
	needs_restart = 0
	secure = 1
	operating = 0
	icotext = "<img class=icon src=\ref[src.icon] ICONSTATE='computer'>: "

/obj/structure/timetravel/phonebooth_computer/Destroy()
	return

/obj/structure/timetravel/phonebooth_computer/attack_hand(mob/user as mob)
	var/obj/structure/pb_mainframe/power_mainframe/PB = locate()
	if(!PB)
		to_chat(user, "A mainframe has not been found!! Contact the company for more details")
		return
	else
		if(!(PB.loc.loc.type == /area/omegacorp/phonebooth))
			to_chat(user, "<span class=warning> Someone built the mainframe out of the phonebooth, you may call them retard</span>")
			return
		if(!PB.is_setup)
			to_chat(user, "Time travelling without the power mainframe ready is almost suicidal!")
			return 0
	if(restarting)
		return 1
	if(needs_restart)
		to_chat(oview(), "[user] pressed the [src] restart button")
		restarting = 1
		playsound(loc, restart_sound, 50, 1)
		sleep(45)
		src.icon_state = "computer"
		src.update_icon()
		src.needs_restart = 0
		restarting = 0
		return 1
	if(!password && !needs_restart && !operating)
		if(ID_SCANNED)
			Operate(user)
			return
		else
			to_chat(user, "[bicon(src)] ERROR, PLEASE SWIPE YOUR ID FIRST.")
			return
	if(password && ID_SCANNED)
		Input_Target_Location(user)
	else
		to_chat(user, "[bicon(src)] ERROR, PLEASE SWIPE YOUR ID FIRST.")
		return
	return 1

/obj/structure/timetravel/phonebooth_computer/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id))
		if(ID_SCANNED)
			if(ready)
				Launch()
				return
			else
				to_chat(user, "[bicon(src)] Securing the [src] with the [W]")
		else
			to_chat(user, "[bicon(src)] The [src] can now be operated")

		ID_SCANNED = !ID_SCANNED

/obj/structure/timetravel/phonebooth_computer/proc/Operate(mob/user as mob)
	operating = 1
	to_chat(user, "[bicon(src)] Receiving timeline mathematics, please wait...")
	sleep(30)
	to_chat(user, "[bicon(src)] Please input the numbers as they are shown.")
	Random_Number(user)
	operating = 0

//Some captchas to go through before the machine actually lets you PLAY THE GAME
/obj/structure/timetravel/phonebooth_computer/proc/Random_Number(mob/user as mob)
	var/random
	var/local_password
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/h_user = user
		if(h_user.time_faction != "Omegacorp") //People who are not from Omegacorp will have a harder time understanding THE MATH
			if(prob(75))	//Let's leave it to chance for now. -Sansaur.
				playsound(loc, error_sound, 50, 1)
				to_chat(user, "You can't understand what this thing wants from you!")
				flick("computer-error", src)
				sleep(20)
				src.icon_state = "computer-restart"
				src.update_icon()
				src.needs_restart = 1
				return

	for(var/i = 0; i < 3; i++)
		random = rand(35, 300)
		local_password = input("Enter the Number [random]", "Enter the Number", 0) as num
		if(local_password == random && Adjacent(user))
			flick("computer-correct", src)
			sleep(20)
			continue
		else
			playsound(loc, error_sound, 50, 1)
			flick("computer-error", src)
			sleep(10)
			src.icon_state = "computer-restart"
			src.update_icon()
			src.needs_restart = 1
			return

	to_chat(user, "[bicon(src)] The Mathematical Lock has been bypassed, welcome.")
	password = 1
//Inputting the target location after bypassing the captchas
/obj/structure/timetravel/phonebooth_computer/proc/Input_Target_Location(mob/user as mob)

	to_chat(user, "[bicon(src)]  You will now input the coordinates of the destination.")
	sleep(10)
	to_chat(user, "[bicon(src)] Remember to only input coordinates between 0 and 255 or you'll make a great mistake.")
	sleep(10)

	locationX = input("Input a coordinate X", "Input a coordinate", 0) as num
	sleep(10)
	locationY = input("Input a coordinate Y", "Input a coordinate", 0) as num
	if(Adjacent(user))
		if(locationX <= 0 || locationX >= 255 || locationY <= 0 || locationY >= 255)
			if(secure)
				to_chat(user, "[bicon(src)],  a mistake has been made in the coordinates input, please try again")
			else
				visible_message("[bicon(src)], <span class=danger>S9X0ZC8Z9C 8039@@#308Q#{]€}€+`WU9EJDS'EW</span>")
				sleep(8)
				Auto_Destruct()
		else
			to_chat(user, "[bicon(src)], time machine is locked in, please swipe your ID again to confirm launch sequence")
			src.icon_state = "computer-ready"
			src.update_icon()
			src.ready = 1

//Shit! Someone emagged the machine!
/obj/structure/timetravel/phonebooth_computer/proc/Auto_Destruct()
	var/turf/T = get_turf(src.loc)
	explosion(T, -1, -1, 2, 3)
	qdel(src)

//Launching the Master Phonebooth to the coordinates
/obj/structure/timetravel/phonebooth_computer/proc/Launch()
	visible_message("[bicon(src)]  <B>the computer</B> beeps, Commencing launch calculations")
	sleep(50)
	var/area/omegacorp/phonebooth/PHONE_AREA = locate()
	var/turf/dest = locate(locationX,locationY,1)
	if(!Dest_IsSafe(dest))
		visible_message("[bicon(src)]  <B>the computer</B> beeps, Launch Sequence canceled, the chosen location is unsafe")
		return
	visible_message("[bicon(src)]  <B>the computer</B> beeps, LAUNCH SEQUENCE INITIATED")
	sleep(10)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, 4")
	sleep(10)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, 3")
	sleep(10)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, 2")
	sleep(10)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, 1")
	sleep(10)
	master_booth.forceMove(dest)
	var/obj/effect/overlay/trippyfloor/TRIPPZ
	for(var/turf/T in src.loc.loc)
		T.overlays.Add(TRIPPZ)
	playsound(loc, 'sound/effects/phasein.ogg', 70, 1)
	var/obj/structure/heat_controller/HEATCONTROL = locate()
	HEATCONTROL.heat += 15
	var/obj/structure/pb_mainframe/stabilization_mainframe/SB = locate()
	if(SB)
		if(SB.is_setup)
			return 1

	for(var/mob/living/carbon/human/HUMAN in PHONE_AREA)
		if(!HUMAN.buckled)
			to_chat(HUMAN, "TIME TRAVELLING TURBULENCE!")
			HUMAN.Stun(5)
			HUMAN.Weaken(5)
			shake_camera(HUMAN, 15, 1)
	sleep(8)
	for(var/turf/T in src.loc.loc)
		T.overlays.Remove(TRIPPZ)
/obj/structure/timetravel/phonebooth_computer/proc/Dest_IsSafe(turf/dest as turf)
	if(dest.density)
		return 0
	for(var/card in cardinal)
		var/turf/T
		T = get_step(dest, card)
		if(istype(T) && !T.density)
			continue
		else
			return 0
	return 1
/*


* TO RETURN TO BASE WE USE A DIFFERENT COMPUTER BECAUSE I'M A CRAZY MAAAAN. - Sansaur

*/

/obj/structure/timetravel/phonebooth_saver
	name = "TTPB Secondary Controller"
	desc = "This computer allows for more interactivity with the TTPB system. It's based on a super old computer, so faulty manipulation can lead to BSODs"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "secondarycomp"
	density = 1
	opacity = 0
	anchored = 1
	var/obj/structure/timetravel/phonebooth/master_booth
	var/password
	var/savedX
	var/savedY
	var/savedZ
/obj/structure/timetravel/phonebooth_saver/New()

/obj/structure/timetravel/phonebooth_saver/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id/omegacorp_leader))
		if(!password)
			to_chat(user, "Please set a new password for the computer")
			var/texti = input(user, "Please introduce the password", "Introduce password", 0) as text
			password = texti
			to_chat(user, "Password entered correctly")
			return 1
		else
			to_chat(user, "Printing the password, please wait...")
			sleep(50)
			var/obj/item/weapon/paper/ThisPaper
			ThisPaper = new (src)
			ThisPaper.info = "Username: OMG_Corp@hnetmail.un \n Password: [password]"

/obj/structure/timetravel/phonebooth_saver/attack_hand(mob/user as mob)
	var/obj/structure/pb_mainframe/power_mainframe/PB = locate()
	if(!PB)
		to_chat(user, "A mainframe has not been found!! Contact the company for more details")
		return
	else
		if(!(PB.loc.loc.type == /area/omegacorp/phonebooth))
			to_chat(user, "<span class=warning> Someone built the mainframe out of the phonebooth, you may call them retard</span>")
			return 0

		if(!PB.is_setup)
			to_chat(user, "Time travelling without the power mainframe ready is almost suicidal!")
			return 0

	if(password)
		var/texti = input(user, "Please introduce the password", "Introduce password", 0) as text
		if(texti != password)
			visible_message("<span class=warning> Incorrect password entered </span>")
			return 0


	add_fingerprint(usr)
	if(prob(30))
		to_chat(user, "L O A D I N G . . .")
		sleep(30)
	to_chat(user, "Welcome to Omegacorp.hnet")
	sleep(10)
	to_chat(user, "Please make your selection")
	var/choice
	choice = input("Input a command (HELP if you don't know them)", "Input a command", 0) as text
	playsound(loc, 'sound/machines/oldcomputer_typing.ogg', 70, 1)
	if(choice == "HELP" && Adjacent(user))
		var/dat = "<html><body>"
		dat += "<h4>Help with the commands</h4>"
		dat += "<p>HELP = Shows help </p>"
		dat += "<p>SAVE = Saves current phonebooth location </p>"
		dat += "<p>RETURN = Returns the phonebooth to the base </p>"
		dat += "<p>SCAN = Shows a possible coordinate to move the phonebooth to </p>"
		dat += "<p>RETURNPREV = Returns the phonebooth to the saved location</p>"
		dat += "</body></html>"
		user << browse(dat, "window=clipboard") //, "window=command_help;size=370x420;can_close=1" | user << browse(dat, "window=clipboard")
		onclose(user, "clipboard")
		return 1

	if(choice == "SAVE" && Adjacent(user))
		to_chat(user, "The phonebooth's current location has been saved")
		savedX = master_booth.x
		savedY = master_booth.y
		savedZ = master_booth.z
		return 1

	if(choice == "RETURN" && Adjacent(user))
		var/dest = locate(220, 135, 2)
		Launch(dest)
		return 1

	if(choice == "SCAN" && Adjacent(user))
		var/coord_max = 0
		to_chat(user, "Checking a possible coordinate to jump to...")
		var/area/medieval/MAREA = locate()
		for(var/turf/T in MAREA)
			if(T.x >= 35 && T.y >= 35)
				if(Dest_IsSafe_Advanced(T))
					if(prob(2))
						to_chat(user, "We can jump to [T.x],[T.y].")
						coord_max++
						if(coord_max == 6)
							return 1
		return 1

	if(choice == "RETURNPREV" && Adjacent(user))
		var/dest = locate(savedX, savedY, savedZ)
		Launch(dest)
		return 1

/obj/structure/timetravel/phonebooth_saver/proc/Launch(var/turf/dest)

	//	RETURNING TO BASE OR SAVED POS DOESN'T CAUSE THE PEOPLE TO FALL.
	visible_message("[bicon(src)]  <B>the computer</B> beeps, Commencing launch calculations")
	sleep(20)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, This is a safe travel, there will be no time-turbulences")
	sleep(30)
	if(!Dest_IsSafe(dest))
		visible_message("[bicon(src)]  <B>the computer</B> beeps, Launch Sequence canceled, the chosen location is unsafe")
		return
	visible_message("[bicon(src)]  <B>the computer</B> beeps, LAUNCH SEQUENCE INITIATED")
	sleep(10)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, 4")
	sleep(10)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, 3")
	sleep(10)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, 2")
	sleep(10)
	visible_message("[bicon(src)]  <B>the computer</B> beeps, 1")
	sleep(10)
	master_booth.forceMove(dest)
	var/obj/structure/heat_controller/HEATCONTROL = locate()
	HEATCONTROL.heat += 15
	playsound(loc, 'sound/effects/phasein.ogg', 70, 1)

/obj/structure/timetravel/phonebooth_saver/proc/Dest_IsSafe(turf/dest as turf)
	if(dest.density)
		return 0
	for(var/card in cardinal)
		var/turf/T
		T = get_step(dest, card)
		if(istype(T) && !T.density)
			continue
		else
			return 0
	return 1

/obj/structure/timetravel/phonebooth_saver/proc/Dest_IsSafe_Advanced(turf/dest as turf)
	if(dest.density)
		return 0
	var/list/returned_objects = view(src)
	var/mob/living/carbon/human/HUMAN

	if(HUMAN in returned_objects)
		return 0

	for(var/card in cardinal)
		var/turf/T
		T = get_step(dest, card)
		if(istype(T) && !T.density)
			continue
		else
			return 0
	return 1

/obj/effect/overlay/trippyfloor
	icon = 'icons/turf/floors.dmi'
	icon_state = "trippyfloor"