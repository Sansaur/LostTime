/obj/structure/silk_spinner
	name = "\improper silk spinner"
	desc = "because silk needs it's own spinner apparently"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "silk_spinner"
	density = 1
	anchored = 1
	opacity = 0
	var/obj/item/cooked_silk_worm_cocoon/loaded_cocoon
	var/rotations = 0
	var/rotations_needed = 8
	var/working = 0
	var/max_silk_generated = 8
/obj/structure/silk_spinner/attack_hand(mob/user as mob)
	if(working)
		return
	if(loaded_cocoon)
		working = 1
		flick("silk_spinner_spin",src)
		rotations++
		if(rotations >= rotations_needed)
			var/obj/item/stack/sheet/silk/NEWSILK = new /obj/item/stack/sheet/silk (src.loc)
			NEWSILK.amount = rand(3, max_silk_generated)
			loaded_cocoon = null
			rotations = 0
		sleep(20)
		working = 0
	else	
		to_chat(user, "There's nothing to spin")
	
/obj/structure/silk_spinner/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/cooked_silk_worm_cocoon))
		if(loaded_cocoon)
			to_chat(user, "There's already a [loaded_cocoon] inside")
			return 
		var/obj/item/cooked_silk_worm_cocoon/N = W
		loaded_cocoon = N
		qdel(W)
	else
		..()
