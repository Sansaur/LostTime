//copy pasta of the space piano, don't hurt me -Sansaur

/obj/item/device/lire
	name = "lire"
	desc = "It's made of royal wood and has bronze strings."
	icon = 'icons/obj/musician.dmi'
	icon_state = "lire"
	item_state = "lire"
	force = 3
	burn_state = FLAMMABLE
	burntime = 20
	actions_types = list(/datum/action/item_action/change_riff)
	w_class = 2
	var/selected_riff
	var/available_riffs = 4
	var/playing

/obj/item/device/lire/New()
	selected_riff = 1

/obj/item/device/lire/Destroy()
	..()

/obj/item/device/lire/attack_hand(mob/user as mob)
	..()
	update_icon()

/obj/item/device/lire/attack_self(mob/user as mob)
	play_riff()

/obj/item/device/lire/proc/play_riff()
	if(playing)
		return

	switch(selected_riff)
		if(1)
			playing = 1
			playsound(src, 'sound/lire/riff1.ogg', 80, 1)
			sleep(40)
			playing = 0
			return
		if(2)
			playing = 1
			playsound(src, 'sound/lire/riff2.ogg', 80, 1)
			sleep(40)
			playing = 0
			return
		if(3)
			playing = 1
			playsound(src, 'sound/lire/riff3.ogg', 80, 1)
			sleep(40)
			playing = 0
			return
		if(4)
			playing = 1
			playsound(src, 'sound/lire/riff4.ogg', 80, 1)
			sleep(40)
			playing = 0
			return

/obj/item/device/lire/verb/change_riff()
	set name = "change riff"
	set category = "Object"
	set src in usr

	selected_riff++
	if(selected_riff > available_riffs)
		selected_riff = 1
	update_icon()

	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/device/lire/update_icon()
	if(isturf(loc))
		icon_state = "lire"
	else
		icon_state = "lire[selected_riff]"

/obj/item/device/lire/dropped()
	icon_state = "lire"
	update_icon()
	..()
