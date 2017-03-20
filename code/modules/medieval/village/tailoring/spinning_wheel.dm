/obj/structure/spinning_wheel
	name = "spinning wheel"
	desc = "this is a wheel were you spin fabric"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "spinning_wheel"
	density = 1
	anchored = 1
	opacity = 0
	var/time_to_spin = 15
	var/chance_to_work = 45
	var/loaded_string = 0
	var/string_effectiveness = 4 //How much string is needed to make a fabric_reel
	var/ready_string = 0
	var/working = 0

/obj/structure/spinning_wheel/brokenaf
	time_to_spin = 1
	chance_to_work = 100
	string_effectiveness = 1

/obj/structure/spinning_wheel/examine(mob/user as mob)
	..()
	to_chat(user, "it has [loaded_string] string loaded and ready")

/obj/structure/spinning_wheel/verb/takeString()
	set name = "Pull string"
	set desc = "Take string off the spinning wheel"
	set src in oview(1)
	set category = "Object"

	var/choice = input(usr,"How much string do you want to take? Max [loaded_string]","Spinning wheel",0) as num


	if(choice > 50)
		choice = 50
	if(choice > loaded_string)
		choice = loaded_string

	loaded_string -= choice

	var/obj/item/stack/sheet/string/MY = new /obj/item/stack/sheet/string (src.loc)
	MY.amount = choice


/obj/structure/spinning_wheel/attack_hand(mob/user as mob)
	if(working)
		return
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/MY = user
	if(!MY.buckled)
		to_chat(MY, "<div class=warning> You gotta be sitting before you start spinning string! </div>")
		return
	to_chat(MY, "You start spinning string")
	while(loaded_string && Adjacent(MY) && MY.buckled)
		working = 1
		Spin(user)

	working = 0

/obj/structure/spinning_wheel/attackby(obj/item/W, mob/user as mob)
	if(istype(W,/obj/item/stack/sheet/string))
		var/obj/item/stack/sheet/string/M = W
		to_chat(user, "you load [src] with [M]")
		loaded_string += M.amount
		M.use(M.amount)	//Insert all
		return

/obj/structure/spinning_wheel/proc/Spin(mob/user as mob)

	if(do_after(user, time_to_spin, target = src))
		var/mob/living/carbon/human/MY = user
		if(!MY.buckled)
			return
		if(ready_string > string_effectiveness)
			new /obj/item/fabric_reel (src.loc)
			ready_string = 0
		else
			if(prob(chance_to_work))	//MWAHAHAHAHAAHHAHAHAH - Sansaur
				playsound(src, 'sound/effects/spinning_wheel.ogg', 75, 0)
				ready_string++


		loaded_string--
		return

