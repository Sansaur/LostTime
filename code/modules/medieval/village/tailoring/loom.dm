/obj/structure/loom
	name = "loom"
	desc = "Murdering sheep hair for this, savage"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "loom"
	density = 1
	anchored = 1
	opacity = 0
	var/time_to_finish = 50
	var/obj/item/wool/loaded_wool
	var/string_yield_min = 3
	var/string_yield_max = 7
	var/working = 0

/obj/structure/loom/update_icon()
	if(loaded_wool)
		icon_state="loom_loaded"
	else
		icon_state="loom"

/obj/structure/loom/attack_hand(mob/user as mob)
	if(working)
		return
	comb_wool(0, user)
	return

/obj/structure/loom/attackby(obj/item/W, mob/user as mob)
	if(working)
		return

	if(istype(W,/obj/item/wool))
		playsound(src, 'sound/effects/zipper.ogg', 75, 0)
		var/obj/item/wool/mywool = W
		user.drop_item()
		loaded_wool = mywool
		mywool.loc = src
		update_icon()
		return

	if(istype(W,/obj/item/weapon/comb))
		comb_wool(1, user)
		return

/obj/structure/loom/proc/comb_wool(var/using_comb, mob/user as mob)
	var/time = time_to_finish
	if(working)
		return
	if(using_comb)
		time = time / 2
	if(!loaded_wool)
		to_chat(user, "Nope, no wool loaded")
		return


	user.visible_message("[user] is combing the wool into string.", "you start combing the wool into string")
	update_icon()
	working = 1

	if(do_after(user, time, target = src))
		user.visible_message("[user] has combed the wool.", "you combed the wool")
		loaded_wool = null
		contents.Cut()
		var/obj/item/stack/sheet/string/N = new /obj/item/stack/sheet/string (src.loc)
		N.amount = rand(string_yield_min, string_yield_max)
		update_icon()
		working = 0
		return
	else
		working = 0
		return
