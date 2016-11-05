/*

* A computer which allows the user to control a mind like the AI eye or the Blob

*/


/obj/structure/seeking_comp
	name = "area scanner computer"
	desc = "Use this advanced piece of machinery to get a view of the terrain surrounding the phonebooth"
	anchored = 1
	density = 1
	opacity = 0
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "seeking_comp"
	var/being_used

/obj/structure/seeking_comp/attack_hand(mob/user as mob)
	if(being_used)
		to_chat(user, "The computer is in use at this time or it can't be accessed")
		return 0
	else
		var/mob/camera/seeking_eye/neweye = new()
		var/mob/living/carbon/human/humantoreturn = user
		neweye.activate(user.ckey, humantoreturn, src)
		src.icon_state = "seeking_comp-inuse"
		update_icon()
		being_used = 1

//The Camera Mob
/mob/camera/seeking_eye
	name = "seeking eye"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "seeking_eye"
	density = 0
	anchored = 1
	status_flags = GODMODE  // You can't damage it.
	mouse_opacity = 0
	see_in_dark = 7
	invisibility = 101 // No one can see us
	sight = SEE_SELF
	move_on_shuttle = 0
	var/mob/living/carbon/human/human_to_return
	var/max_steps
	var/obj/structure/seeking_comp/computer_to_close

/mob/camera/seeking_eye/New()
	..()
	max_steps = 55 //55 max steps for now.
	var/obj/structure/pb_mainframe/scanner_resource_mainframe/SRM = locate()
	if(SRM.is_setup)
		max_steps += 35 //Up to 90 steps with the SRM installed and ready

	var/obj/structure/timetravel/phonebooth/Phonebooth = locate()
	forceMove(Phonebooth.loc)

/mob/camera/seeking_eye/Move()
	..()
	max_steps -= 1
	if(max_steps <= 0)
		Destroy()

/mob/camera/seeking_eye/proc/activate(var/clave as key, var/mob/living/carbon/human/HUMAN as mob, var/obj/structure/seeking_comp/comp)
	human_to_return = HUMAN
	src.ckey = clave
	computer_to_close = comp
	Login()

/mob/camera/seeking_eye/Destroy()
	human_to_return.ckey = src.ckey
	computer_to_close.being_used = 0
	computer_to_close.icon_state = "seeking_comp"
	computer_to_close.update_icon()
	to_chat(human_to_return, "The scanning eye has ran out of energy")
	//human_to_return.Login()
	..()
	return QDEL_HINT_HARDDEL_NOW

/mob/camera/seeking_eye/Login()
	..()
	update_interface()

/mob/camera/seeking_eye/verb/Auto_Destruct()
	set name = "Stop scanning"
	set desc = "Use this action to stop scanning the area as the eye"
	set category = "IC"
	Destroy()