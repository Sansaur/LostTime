/obj/item/weapon/mortar
	name = "mortar"
	desc = "Mix, stir, mix, mix, stir, serve, mix, stir, mix, serve, mix, mix, STIR SERVE MIX."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift"
	force = 5
	throwforce = 10
	w_class = 2
	attack_verb = list("attacked", "smashed")
	block_chance = 0
	var/list/obj/item/pigment/pigments_inside = list()
	var/working = 0

/obj/item/weapon/mortar_hand
	name = "mortar hand"
	desc = "Mixit."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"
	force = 5
	throwforce = 8
	w_class = 2
	attack_verb = list("attacked", "smashed")
	block_chance = 0
	var/time_to_mix = 50	//Lower = less time

/obj/item/weapon/mortar/attackby(obj/item/W, mob/user as mob)
	if(W.type in subtypesof(/obj/item/pigment))
		var/obj/item/pigment/pigment_to_add = W
		to_chat(user, "You add [pigment_to_add] to [src]")
		user.drop_item()
		pigments_inside.Add(pigment_to_add)
		pigment_to_add.loc = src
		return

	if(istype(W,/obj/item/weapon/mortar_hand))
		if(working)
			return
		var/obj/item/weapon/mortar_hand/MYMORTAR = W
		to_chat(user, "<div class=notice> You start mixing... </div>")
		working = 1
		if(do_after(user, MYMORTAR.time_to_mix, target = src))
			// First we check the pigments.
			var/red = 0
			var/blue = 0
			var/yellow = 0
			for(var/obj/item/pigment/pigment_inside in pigments_inside)
				if(istype(pigment_inside, /obj/item/pigment/blue))
					blue++
				else if(istype(pigment_inside, /obj/item/pigment/red))
					red++
				else if(istype(pigment_inside, /obj/item/pigment/yellow))
					yellow++
			pigments_inside.Cut()
			CreatePigments(red, blue, yellow, user)
			working = 0

			// Then we check recipes, if there were pigments, the recipes will come out painted as the pigment xD
			// Color to #xxxxxx whatever it is

			return
			
		else
			working = 0
			to_chat(user, "You really should have more patience while mixing")
			return
		
	else
		..()

/obj/item/weapon/mortar/attack_self(mob/user as mob)
	
	

	

/obj/item/weapon/mortar/proc/CreatePigments(var/red, var/blue, var/yellow, mob/user as mob)
	to_chat(user, "You start mixing shiiiiiiit!!!")
	var/black = 0
	var/green = 0
	var/orange = 0
	var/purple = 0

	if(red && blue && yellow)
		red--
		blue--
		yellow--
		black++

	if(red && blue)
		red--
		blue--
		purple++

	if(red && yellow)
		red--
		yellow--
		orange++

	if(blue && yellow)
		blue--
		yellow--
		green++

	for(var/i = 0; i < black; ++i)
		new /obj/item/pigment/black (user.loc)
	for(var/i = 0; i < purple; ++i)
		new /obj/item/pigment/purple (user.loc)
	for(var/i = 0; i < orange; ++i)
		new /obj/item/pigment/orange (user.loc)
	for(var/i = 0; i < green; ++i)
		new /obj/item/pigment/green (user.loc)
	for(var/i = 0; i < red; ++i)
		new /obj/item/pigment/red (user.loc)
	for(var/i = 0; i < blue; ++i)
		new /obj/item/pigment/blue (user.loc)
	for(var/i = 0; i < yellow; ++i)
		new /obj/item/pigment/yellow (user.loc)