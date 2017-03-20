/obj/structure/silk_worm_terrarium
	name = "\improper silk worm terrarium"
	desc = "look at them grow, so cute!"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "silk_worm_terrarium"
	density = 1
	anchored = 1
	opacity = 0
	var/soil_status = 200
	var/worm_amount = 0
	var/cocoon_amount = 0
	var/leaves = 0
	var/worm_advance = 0

/obj/structure/silk_worm_terrarium/New()
	..()
	processing_objects.Add(src)

/obj/structure/silk_worm_terrarium/process()	//CHECK THIS SHIT IN THE FUTURE
	if(prob(14))
		if(worm_amount)
			if(soil_status < 0)
				worm_amount--

			if(leaves)
				leaves--
				worm_advance += 2

			if(worm_advance > 100 && soil_status > 50)
				worm_advance = 0
				cocoon_amount++

			if(cocoon_amount > 2)
				if(prob(10))
					makeButterfly()

			soil_status--
		else
			if(leaves)
				leaves--
				soil_status += 4

/obj/structure/silk_worm_terrarium/proc/makeButterfly()
	new /mob/living/simple_animal/butterfly (src.loc)
	cocoon_amount--

/obj/structure/silk_worm_terrarium/examine(mob/user as mob)
	if(soil_status > 50)
		to_chat(user, "[bicon(src)] [src]'s soil looks healthy, it has [worm_amount] worms, [leaves] amount of leaves, and [cocoon_amount] cocoons")
		return
	if(soil_status < 50)
		to_chat(user, "[bicon(src)] [src]'s soil <b> doesn't look healthy</b>, it has [worm_amount] worms, [leaves] amount of leaves, and [cocoon_amount] cocoons")
		return
	if(soil_status < 0)
		to_chat(user, "[bicon(src)] [src]'s soil <div class=warning> is completly spoiled </div>, it has [worm_amount] worms, [leaves] amount of leaves, and [cocoon_amount] cocoons")
		return


/obj/structure/silk_worm_terrarium/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/stack/sheet/leaves))
		to_chat(user, "You add all the [W] into [src]")
		var/obj/item/stack/sheet/leaves/LEAVES = W 	//Put all leaves for now
		leaves += LEAVES.amount
		LEAVES.use(LEAVES.amount)
		return
	if(istype(W, /obj/item/silk_worm_dummy))
		to_chat(user, "You add [W] into [src]")
		worm_amount++
		qdel(W)
		for(var/mob/living/simple_animal/silk_worm/S in user.loc)	//HACKY BUT WORKS
			qdel(S)
		return

/obj/structure/silk_worm_terrarium/attack_hand(mob/living/carbon/human/user as mob)
	if(cocoon_amount > 0)
		var/obj/item/silk_worm_cocoon/W = new /obj/item/silk_worm_cocoon (user.loc)	//Put in hands
		to_chat(user, "You take [W] out of [src]")
		user.put_in_hands(W)
		cocoon_amount--
		return

	if(worm_amount > 0)
		var/obj/item/silk_worm_dummy/W = new /obj/item/silk_worm_dummy (user.loc)	//Put in hands
		to_chat(user, "You take [W] out of [src]")
		user.put_in_hands(W)
		worm_amount--
		return
