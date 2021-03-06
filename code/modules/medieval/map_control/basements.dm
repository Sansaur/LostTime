/obj/effect/step_trigger/teleport_fancy/medieval_basement
	invisibility = 101
	icon = 'icons/obj/medieval/map_control.dmi'
	icon_state = "bugtesting_landmark"
	var/locx = 104
	var/locy = 105
	var/locz = 5

/obj/effect/step_trigger/teleport_fancy/medieval_basement/Trigger(mob/M as mob)
	sleep(5)
	var/dest = locate(locx, locy, locz)
	M.loc = dest //Let's test this!!
	return 1


/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_king_room
	locx = 3
	locy = 141
	locz = 4

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_king_room
	locx = 107
	locy = 185
	locz = 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_heir_room
	locx = 40
	locy = 138
	locz = 4

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_heir_room
	locx = 151
	locy = 184
	locz = 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_inn_second
	locx = 89
	locy = 117
	locz = 4

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_inn_second
	locx = 96
	locy = 125
	locz = 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_dungeon
	locx = 65
	locy = 148
	locz = 4



	//This is useful for every basement tp
/obj/effect/step_trigger/teleport_fancy/medieval_basement/Trigger(mob/M as mob)
	var/list/mob/atoms_to_move = list()

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/HUMAN = M
		for(var/obj/item/weapon/grab/GRAB in HUMAN.contents)
			atoms_to_move.Add(GRAB.affecting)



	var/dest = locate(locx, locy, locz)
	//var/second_dest = locate(locx+1, locy, locz)
	for(var/mob/atom_to_move in atoms_to_move)
		atom_to_move.loc = dest

	var/mob/living/carbon/human/HUMAN = M
	if(HUMAN.pulling)
		if(istype(HUMAN.pulling, /obj))
			var/obj/TOPULL = HUMAN.pulling
			TOPULL.loc = dest
		if(istype(HUMAN.pulling, /mob))
			var/mob/MOB = HUMAN.pulling
			MOB.loc = dest


	M.loc = dest //Let's test this!!
	return 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_dungeon
	locx = 136
	locy = 126
	locz = 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_bishop
	locx = 109
	locy = 140
	locz = 4

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_bishop
	locx = 86
	locy = 162
	locz = 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_observatory
	locx = 136
	locy = 132
	locz = 4

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_observatory
	locx = 159
	locy = 119
	locz = 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_shop_basement
	locx = 9
	locy = 112
	locz = 4

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_shop_basement
	locx = 84
	locy = 111
	locz = 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_exotic_basement
	locx = 35
	locy = 126
	locz = 4

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_exotic_basement
	locx = 95
	locy = 107
	locz = 1

/obj/effect/step_trigger/teleport_fancy/medieval_basement/to_mayor
	locx = 66
	locy = 119
	locz = 4

/obj/effect/step_trigger/teleport_fancy/medieval_basement/from_mayor
	locx = 109
	locy = 126
	locz = 1



/obj/structure/stairs/basement
	name = "stairs"
	desc = "take them, see where they take you"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "stairs_down"
	var/MYTP

/obj/structure/stairs/basement/down
	icon_state = "stairs_down"

/obj/structure/stairs/basement/up
	icon_state = "stairs_down"

/obj/structure/stairs/basement/Destroy()
	return //Indestructible

/obj/structure/stairs/basement/New()
	if(MYTP)
		new MYTP (src.loc)
	..()

/obj/structure/stairs/basement/down/from_mayor
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_mayor

/obj/structure/stairs/basement/down/to_exotic_basement
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_exotic_basement

/obj/structure/stairs/basement/down/to_shop_basement
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_shop_basement

/obj/structure/stairs/basement/down/from_observatory
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_observatory

/obj/structure/stairs/basement/down/from_bishop
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_bishop

/obj/structure/stairs/basement/down/to_dungeon
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_dungeon

/obj/structure/stairs/basement/down/from_inn_second
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_inn_second

/obj/structure/stairs/basement/down/from_heir_room
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_heir_room

/obj/structure/stairs/basement/down/from_king_room
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_king_room


// up



/obj/structure/stairs/basement/up/to_mayor
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_mayor
/obj/structure/stairs/basement/up/from_exotic_basement
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_exotic_basement
/obj/structure/stairs/basement/up/from_shop_basement
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_shop_basement
/obj/structure/stairs/basement/up/to_observatory
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_observatory
/obj/structure/stairs/basement/up/to_bishop
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_bishop
/obj/structure/stairs/basement/up/from_dungeon
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/from_dungeon
/obj/structure/stairs/basement/up/to_inn_second
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_inn_second
/obj/structure/stairs/basement/up/to_heir_room
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_heir_room
/obj/structure/stairs/basement/up/to_king_room
	MYTP = /obj/effect/step_trigger/teleport_fancy/medieval_basement/to_king_room