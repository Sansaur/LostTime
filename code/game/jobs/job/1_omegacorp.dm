
/datum/job/operation_leader
	title = "Operation Leader"
	flag = CENTCOM
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "Omegacorp"
	selection_color = "#E58303"
	idtype = /obj/item/weapon/card/id/omegacorp_leader
	access = list()
	minimal_access = list()

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/clothing/under/omegacorp_leader(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/centcom(H), slot_shoes)
		H.equip_or_collect(new /obj/item/clothing/gloves/color/white(H), slot_gloves)
		H.equip_or_collect(new /obj/item/device/radio/headset(H), slot_l_ear)
		H.equip_or_collect(new /obj/item/clothing/head/beret/centcom/officer(H), slot_head)
		H.equip_or_collect(new /obj/item/device/pda/centcom(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/clothing/glasses/hud/security/sunglasses(H), slot_glasses)
		H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/gun/energy/pulse/pistol(H), slot_in_backpack)

		H.equip_or_collect(new /obj/item/weapon/implanter/dust(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/implanter/death_alarm(H), slot_in_backpack)

		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		H.sec_hud_set_implants()

		if(H.client.prefs.species != "Human")
			omegacorp_checking(H, "Operation Leader")
		H.time_faction = "Omegacorp"
		return 1

	get_access()
		return get_all_accesses()


/datum/job/operation_enforcer
	title = "Operation Enforcer"
	flag = OFFICER
	department_flag = ENGSEC
	total_positions = 2
	spawn_positions = 2
	supervisors = "Omegacorp"
	selection_color = "#FF9100"
	idtype = /obj/item/weapon/card/id/omegacorp_enforcer
	access = list()
	minimal_access = list()

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/clothing/under/omegacorp_enforcer(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/combat(H), slot_shoes)
		H.equip_or_collect(new /obj/item/clothing/gloves/combat(H), slot_gloves)
		H.equip_or_collect(new /obj/item/device/radio/headset(H), slot_l_ear)
		H.equip_or_collect(new /obj/item/clothing/head/beret/centcom/officer/navy(H), slot_head)
		H.equip_or_collect(new /obj/item/device/pda/centcom(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/clothing/glasses/hud/security/sunglasses(H), slot_glasses)
		H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/suit/space/deathsquad/officer(H), slot_wear_suit)
		H.equip_or_collect(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/implanter/dust(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/gun/energy/pulse/pistol/m1911(H), slot_belt)
		H.equip_or_collect(new /obj/item/weapon/implanter/death_alarm(H), slot_in_backpack)
		if(H.client.prefs.species != "Human")
			omegacorp_checking(H, "Operation Enforcer")
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		H.sec_hud_set_implants()
		H.time_faction = "Omegacorp"

	get_access()
		return get_all_accesses()
/datum/job/operation_medic
	title = "Operation Medic"
	flag = ATMOSTECH
	department_flag = ENGSEC
	total_positions = 3
	spawn_positions = 3
	supervisors = "Omegacorp"
	selection_color = "#FF9100"
	idtype = /obj/item/weapon/card/id/omegacorp_medic
	minimal_player_age = 7

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/omegacorp_medic(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_or_collect(new /obj/item/weapon/storage/belt/utility/atmostech/(H), slot_belt)
		H.equip_or_collect(new /obj/item/device/pda/atmos(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/weapon/storage/box/engineer(H), slot_in_backpack)
		if(H.client.prefs.species != "Human")
			omegacorp_checking(H, "Operation Medic")
		H.time_faction = "Omegacorp"
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		H.sec_hud_set_implants()
		return 1
	get_access()
		return get_all_accesses()

/datum/job/operation_support
	title = "Operation Support"
	flag = MECHANIC
	department_flag = KARMA
	total_positions = 3
	spawn_positions = 3
	supervisors = "Omegacorp"
	selection_color = "#FF9100"
	idtype = /obj/item/weapon/card/id/omegacorp_enforcer
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_mechanic, access_external_airlocks, access_mineral_storeroom)
	minimal_access = list(access_maint_tunnels, access_emergency_storage, access_mechanic, access_external_airlocks, access_mineral_storeroom)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/omegacorp_support(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_or_collect(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		H.equip_or_collect(new /obj/item/clothing/head/hardhat(H), slot_head)
		H.equip_or_collect(new /obj/item/device/t_scanner(H), slot_r_store)
		H.equip_or_collect(new /obj/item/device/pda/engineering(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/weapon/storage/box/engineer(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/pod_paint_bucket(H), slot_in_backpack)
		if(H.client.prefs.species != "Human")
			omegacorp_checking(H, "Operation Support")
		H.time_faction = "Omegacorp"
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		H.sec_hud_set_implants()
		return 1

	get_access()
		return get_all_accesses()

/datum/job/proc/omegacorp_checking(var/mob/living/carbon/human/H, var/datum/job/writtenjob)
	var/old_species = H.species
	H.set_species("Human")
	var/response
	var/alertmsg = "You tried to spawn as a [old_species] but it's forbidden for Omegacorp, you've been turned into a human, do you want to return to the lobby or do you stay like this?"
	response = alert(H, alertmsg,"Return to lobby?","Stay","Return")
	if(response == "Stay")
		return	//didn't want to return after-all
	job_master.FreeRole(writtenjob)
	H.resting = 1
	var/mob/dead/observer/ghost = H.ghostize(0)
	log_admin("[key_name(H)] spawned as a species not suitable for Omegacorp and was sent back to the lobby")
	message_admins("[key_name(H)] spawned as a species not suitable for Omegacorp and was sent back to the lobby")
	qdel(H) //LETS SEE IF THIS WORKS
	var/mob/new_player/NP = new()
	non_respawnable_keys -= ghost.ckey
	NP.ckey = ghost.ckey
	qdel(ghost)