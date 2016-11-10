/obj/effect/step_trigger/message
	var/message	//the message to give to the mob
	var/once = 1

/obj/effect/step_trigger/message/Trigger(mob/M as mob)
	if(M.client)
		to_chat(M, "<span class='info'>[message]</span>")
		if(once)
			qdel(src)

/obj/effect/step_trigger/teleport_fancy
	var/locationx
	var/locationy
	var/uses = 1	//0 for infinite uses
	var/entersparks = 0
	var/exitsparks = 0
	var/entersmoke = 0
	var/exitsmoke = 0

/obj/effect/step_trigger/teleport_fancy/Trigger(mob/M as mob)
	var/dest = locate(locationx, locationy, z)
	M.Move(dest)

	if(entersparks)
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(4, 1, src)
		s.start()
	if(exitsparks)
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(4, 1, dest)
		s.start()

	if(entersmoke)
		var/datum/effect/system/harmless_smoke_spread/s = new /datum/effect/system/harmless_smoke_spread
		s.set_up(4, 1, src, 0)
		s.start()
	if(exitsmoke)
		var/datum/effect/system/harmless_smoke_spread/s = new /datum/effect/system/harmless_smoke_spread
		s.set_up(4, 1, dest, 0)
		s.start()

	uses--
	if(uses == 0)
		qdel(src)

/obj/effect/step_trigger/teleport_fancy/tolevels
	icon = 'icons/effects/effects.dmi'
	icon_state = "bhole2"
	var/locationz
	uses = 0	//0 for infinite uses
	invisibility = 0 // This one is visible

/obj/effect/step_trigger/teleport_fancy/tolevels/Trigger(mob/M as mob)
	var/dest = locate(locationx, locationy, locationz)
	M.Move(dest)
	for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in M.contents)
		qdel(MANUAL)

	//for(var/obj/item/clothing/storage/STORAGE in M.contents)
	//	for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in STORAGE.contents)
	//		qdel(MANUAL)

	for(var/obj/item/weapon/storage/B_STORAGE in M.contents)
		for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in B_STORAGE.contents)
			qdel(MANUAL)

/obj/effect/step_trigger/teleport_fancy/tolevels/to_medieval
	locationx = 128
	locationy = 131
	locationz = 1

/obj/effect/step_trigger/teleport_fancy/tolevels/to_medieval/Trigger(mob/living/carbon/human/M as mob)
	if(M.time_faction == "Medieval")
		var/dest = locate(locationx, locationy, locationz)
		M.Move(dest)

		for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in M.contents)
			qdel(MANUAL)

		//for(var/obj/item/clothing/storage/STORAGE in M.contents)
		//	for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in STORAGE.contents)
		//		qdel(MANUAL)

		for(var/obj/item/weapon/storage/B_STORAGE in M.contents)
			for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in B_STORAGE.contents)
				qdel(MANUAL)
	else
		to_chat(M, "This is not the teleporter you are supposed to take")

/obj/effect/step_trigger/teleport_fancy/tolevels/to_omegacorp
	locationx = 201
	locationy = 131
	locationz = 2

/obj/effect/step_trigger/teleport_fancy/tolevels/to_omegacorp/Trigger(mob/living/carbon/human/M as mob)
	if(M.time_faction == "Omegacorp")
		var/dest = locate(locationx, locationy, locationz)
		M.Move(dest)

		for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in M.contents)
			qdel(MANUAL)

		//for(var/obj/item/clothing/storage/STORAGE in M.contents)
		//	for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in STORAGE.contents)
		//		qdel(MANUAL)

		for(var/obj/item/weapon/storage/B_STORAGE in M.contents)
			for(var/obj/item/weapon/book/manual/omegacorp/MANUAL in B_STORAGE.contents)
				qdel(MANUAL)
	else
		to_chat(M, "This is not the teleporter you are supposed to take")