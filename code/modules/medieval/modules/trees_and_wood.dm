/*


* TREES MOTHERFUCKER


*/
/obj/structure/flora/tree
	name = "tree"
	desc = "It's a tree"
	anchored = 1
	density = 1
	pixel_x = -16
	layer = 9
	var/log_number = 2
	var/tree_life = 300
	var/gettingCut = 0
	var/log_type = /obj/item/weapon/log

/obj/structure/flora/tree/New()
	log_number = pick(1,2,3,4)
	desc = "It's a tree, this tree yields <b>[log_type]</b> wood"
	..()

/obj/structure/flora/tree/attackby(obj/item/weapon/O, mob/living/user, params)
	//This should accept both hatchets and combat axes
	if(istype(O, /obj/item/weapon/hatchet) ||istype(O, /obj/item/weapon/twohanded/fireaxe/medieval_combat_axe) || istype(O, /obj/item/weapon/medieval/axe))
		user.do_attack_animation(src)
		playsound(loc,'sound/effects/choppingtree.ogg',90,1)
		damageTree(O.force)

/obj/structure/flora/tree/proc/damageTree(var/damage)
	tree_life -= damage
	if(tree_life <= 0)
		if(!gettingCut)
			getCut()

/obj/structure/flora/tree/proc/getCut()
	gettingCut = 1
	for(var/i=0, i<log_number, i++)
		new log_type(src.loc)
	playsound(loc,'sound/effects/treefall.ogg',90,1)
	animate_spin(src,"L",45,-1)
	sleep(15)
	qdel(src)


/** LOGS AND PLANKS AND BIRCH **/

/obj/item/weapon/log
	name = "wood log"
	desc = "It's a log."
	icon = 'icons/obj/items.dmi'
	icon_state = "woodlog"
	origin_tech = "biotech=2"
	w_class = 4
	burn_state = FLAMMABLE
	var/cutting = 0
	var/plank_type = /obj/item/weapon/wood_plank
/obj/item/weapon/log/attackby(obj/item/weapon/O, mob/user, params)
	//This should accept both hatchets and combat axes
	if((istype(O, /obj/item/weapon/hatchet) || istype(O, /obj/item/weapon/twohanded/fireaxe/medieval_combat_axe) || istype(O, /obj/item/weapon/medieval/axe)) && istype(src.loc, /turf/simulated)) //Needs to be on the ground
		if(cutting)
			return
		cutting = 1
		if(do_after(user, 18, target=src))
			playsound(loc,'sound/effects/choppingtree.ogg',90,1)
			if(do_after(user, 18, target=src))
				playsound(loc,'sound/effects/choppingtree.ogg',90,1)
				if(do_after(user, 18, target=src))
					playsound(loc,'sound/effects/choppingtree.ogg',90,1)
					if(do_after(user, 18, target=src))
						playsound(loc,'sound/effects/choppingtree.ogg',90,1)
						makePlanks()
				else
					to_chat(user, "<div class=warning> You fail to cut the log into planks! </div>")
					qdel(src)
			else
				to_chat(user, "<div class=warning> You fail to cut the log into planks! </div>")
				qdel(src)
		else
			to_chat(user, "<div class=warning> You fail to cut the log into planks! </div>")
			qdel(src)

/obj/item/weapon/log/proc/makePlanks()
	//This is just a debug proc for now
	var/num = rand(1,4)
	for(var/i=0, i<num, i++)
		new plank_type (src.loc)
	qdel(src)

/obj/item/weapon/wood_plank
	name = "wooden plank"
	desc = "One can only guess that this is a bunch of wood."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-wood"
	origin_tech = "materials=1;biotech=1"
	w_class = 2
	burn_state = FLAMMABLE
	var/saw_result = /obj/item/woodworks/double_planks
	var/polisher_result = /obj/item/woodworks/notched_plank

/obj/item/weapon/wood_plank/attackby(obj/item/weapon/O, mob/user, params)
	//This should accept both hatchets and combat axes
	if(istype(O, /obj/item/weapon/hatchet) || istype(O, /obj/item/weapon/twohanded/fireaxe/medieval_combat_axe) || istype(O, /obj/item/weapon/medieval/axe))
		if(istype(src.loc, /turf/simulated)) //Needs to be cut on the floor
			playsound(loc,'sound/effects/choppingtree.ogg',90,1)
			new /obj/item/stack/sheet/kindling (loc)
			new /obj/item/stack/sheet/kindling (loc)
			qdel(src)

	if(istype(O, /obj/item/weapon/wood_saw))
		if(istype(src.loc, /turf/simulated)) //Needs to be cut on the floor
			playsound(loc,'sound/effects/choppingtree.ogg',90,1) //Change sound in the future -Sansaur
			new saw_result (loc)
			qdel(src)

	if(istype(O, /obj/item/weapon/wood_polisher))
		if(istype(src.loc, /turf/simulated)) //Needs to be cut on the floor
			playsound(loc,'sound/effects/choppingtree.ogg',90,1) //Change sound in the future -Sansaur
			new polisher_result (loc)
			qdel(src)

/obj/item/stack/sheet/kindling
	name = "kindling"
	desc = "Some kindling, looks flammable"
	icon = 'icons/obj/items.dmi'
	icon_state = "birch"
	w_class = 2
	burn_state = FLAMMABLE
	max_amount = 20

/obj/item/stack/sheet/kindling/attack_self(mob/user as mob)
	if(src.amount >= 10)
		use(10)
		new /obj/structure/bonfire (loc.loc)
	else
		to_chat(user, "<div class=warning> There's not enough kindling to make a bonfire! </div>")
