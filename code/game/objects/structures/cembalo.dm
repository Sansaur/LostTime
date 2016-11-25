/obj/structure/cembalo
	name = "cembalo"
	desc = "An instrument everyone can play at random and make some soudns, at least to an extent"
	icon = 'icons/obj/musician.dmi'
	icon_state = "cembalo"
	var/list/music = list("intro", "riff1", "riff2", "riff3", "riff4", "riff5","long1", "none")
	var/playing = 0
	density = 1
	anchored = 1
	opacity = 0

/obj/structure/cembalo/attack_hand(mob/user as mob)
	Music_Listing(user)

/obj/structure/cembalo/proc/Music_Listing(mob/user as mob)
	var/choice = input(user, "Choose a riff", "Riff-choosing time", "none") in music
	//We need to check that the user remains near the cembalo before the song begins.
	//We can make it so some white gloves stay on the piano so it's like the gloves are playing (magic stuff)

	switch(choice)
		if("intro")
			if(playing)
				to_chat(user, "A song is already being played, be patient")
				return
			playsound(src, 'sound/cembalo/intro1.ogg', 70, 1)
			playing = 1
			icon_state = "cembalo_playing"
			sleep(170)
			icon_state = "cembalo"
			playing = 0
			return
		if("riff1")
			if(playing)
				to_chat(user, "A song is already being played, be patient")
				return
			playsound(src, 'sound/cembalo/riff1.ogg', 70, 1)
			playing = 1
			icon_state = "cembalo_playing"
			sleep(110)
			icon_state = "cembalo"
			playing = 0
			return
		if("riff2")
			if(playing)
				to_chat(user, "A song is already being played, be patient")
				return
			playsound(src, 'sound/cembalo/riff2.ogg', 70, 1)
			playing = 1
			icon_state = "cembalo_playing"
			sleep(110)
			icon_state = "cembalo"
			playing = 0
			return
		if("riff3")
			if(playing)
				to_chat(user, "A song is already being played, be patient")
				return
			playsound(src, 'sound/cembalo/riff3.ogg', 70, 1)
			playing = 1
			icon_state = "cembalo_playing"
			sleep(180)
			icon_state = "cembalo"
			playing = 0
			return
		if("riff4")
			if(playing)
				to_chat(user, "A song is already being played, be patient")
				return
			playsound(src, 'sound/cembalo/riff4.ogg', 70, 1)
			playing = 1
			icon_state = "cembalo_playing"
			sleep(170)
			icon_state = "cembalo"
			playing = 0
			return
		if("riff5")
			if(playing)
				to_chat(user, "A song is already being played, be patient")
				return
			playsound(src, 'sound/cembalo/riff5.ogg', 70, 1)
			playing = 1
			icon_state = "cembalo_playing"
			sleep(120)
			icon_state = "cembalo"
			playing = 0
			return
		if("long1")
			if(playing)
				to_chat(user, "A song is already being played, be patient")
				return
			playsound(src, 'sound/cembalo/long1.ogg', 70, 1)
			playing = 1
			icon_state = "cembalo_playing"
			sleep(220)
			icon_state = "cembalo"
			playing = 0
			return
		if("none")
			return
