	// DYE BUCKET


/obj/structure/dye_bucket
	name = "\improper dye bucket"
	desc = "paint it"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "dye_bucket_white"
	density = 1
	anchored = 1
	opacity = 0
	var/list/possible_colors = list("black", "white", "red", "green", "blue", "yellow", "purple", "orange")
	var/current_color = "white"
	var/obj/item/stored_item = null
	var/working = 0

/obj/structure/dye_bucket/attack_hand(mob/user as mob)
	if(working)
		return
	if(stored_item)
		to_chat(user, "You begin painting the [stored_item] [current_color]")
	else 
		to_chat(user, "There's nothing to paint in [src]")
		return
	working = 1
	if(!do_after(user, 35, target = src))
		working = 0
		to_chat(user, "You stop painting")
		return

	if(istype(stored_item, /obj/item/fabric_reel))
		switch(current_color)
			if("white")
				new /obj/item/fabric_reel/white (src.loc)
			if("red")
				new /obj/item/fabric_reel/red (src.loc)
			if("blue")
				new /obj/item/fabric_reel/blue (src.loc)
			if("green")
				new /obj/item/fabric_reel/green (src.loc)
			if("orange")
				new /obj/item/fabric_reel/orange (src.loc)
			if("yellow")
				new /obj/item/fabric_reel/yellow (src.loc)
			if("black")
				new /obj/item/fabric_reel/black (src.loc)
			if("purple")
				new /obj/item/fabric_reel/purple (src.loc)
			else
				message_admins("ERROR IN THE [src]")

		stored_item = null
		playsound(src, 'sound/effects/slosh.ogg', 75, 0)
		qdel(stored_item)
		working = 0


	else
		switch(current_color)
			if("white")
				stored_item.color = COLOR_WHITE
			if("red")
				stored_item.color = COLOR_RED
			if("blue")
				stored_item.color = COLOR_BLUE
			if("green")
				stored_item.color = COLOR_GREEN
			if("orange")
				stored_item.color = COLOR_ORANGE
			if("yellow")
				stored_item.color = COLOR_YELLOW
			if("black")
				stored_item.color = COLOR_GRAY
			if("purple")
				stored_item.color = COLOR_PURPLE
			else
				message_admins("ERROR IN THE [src]")

		playsound(src, 'sound/effects/slosh.ogg', 75, 0)
		stored_item.loc = src.loc
		stored_item = null
		working = 0

/obj/structure/dye_bucket/update_icon()
	icon_state = "dye_bucket_[current_color]"

/obj/structure/dye_bucket/attackby(obj/item/W, mob/user as mob)
	if(W.type in subtypesof(/obj/item/pigment))
		playsound(src, 'sound/effects/slosh.ogg', 75, 0)
		user.drop_item()

		to_chat(user, "<div class=notice> you mix [W] in [src] mix")
		switch(W.type)
			if(/obj/item/pigment/white)
				current_color = "white"
			if(/obj/item/pigment/red)
				current_color = "red"
			if(/obj/item/pigment/blue)
				current_color = "blue"
			if(/obj/item/pigment/green)
				current_color = "green"
			if(/obj/item/pigment/orange)
				current_color = "orange"
			if(/obj/item/pigment/yellow)
				current_color = "yellow"
			if(/obj/item/pigment/black)
				current_color = "black"
			if(/obj/item/pigment/purple)
				current_color = "purple"
			else
				message_admins("ERROR IN THE [src]")

		qdel(W)
		update_icon()
		return
		
	if(stored_item)
		to_chat(user, "There's already something inside")
		return
	else
		playsound(src, 'sound/effects/slosh.ogg', 75, 0)
		user.drop_item()
		stored_item = W
		W.loc = src
		return



		// SILK TERRARIUM AND SILK SPINNER


