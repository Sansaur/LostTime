
/datum/job/operation_leader
	title = "Operation Leader"
	flag = CENTCOM
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "Omegacorp"
	selection_color = "#E58303"
	//idtype = /obj/item/weapon/card/id/centcom
	access = list()
	minimal_access = list()

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/clothing/under/rank/centcom/officer(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/centcom(H), slot_shoes)
		H.equip_or_collect(new /obj/item/clothing/gloves/color/white(H), slot_gloves)
		H.equip_or_collect(new /obj/item/device/radio/headset/centcom(H), slot_l_ear)
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
		return 1


/datum/job/operation_enforcer
	title = "Operation Enforcer"
	flag = VIROLOGIST
	department_flag = ENGSEC
	total_positions = 2
	spawn_positions = 2
	supervisors = "Omegacorp"
	selection_color = "#FF9100"
	//idtype = /obj/item/weapon/card/id/centcom
	access = list()
	minimal_access = list()

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/clothing/under/syndicate/combat(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/combat(H), slot_shoes)
		H.equip_or_collect(new /obj/item/clothing/gloves/combat(H), slot_gloves)
		H.equip_or_collect(new /obj/item/device/radio/headset/centcom(H), slot_l_ear)
		H.equip_or_collect(new /obj/item/clothing/head/beret/centcom/officer/navy(H), slot_head)
		H.equip_or_collect(new /obj/item/device/pda/centcom(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/clothing/glasses/hud/security/sunglasses(H), slot_glasses)
		H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/suit/space/deathsquad/officer(H), slot_wear_suit)
		H.equip_or_collect(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/implanter/dust(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/gun/energy/pulse/pistol/m1911(H), slot_belt)
		H.equip_or_collect(new /obj/item/weapon/implanter/death_alarm(H), slot_in_backpack)


/datum/job/operation_medic
	title = "Operation Medic"
	flag = ATMOSTECH
	department_flag = ENGSEC
	total_positions = 3
	spawn_positions = 3
	supervisors = "Omegacorp"
	selection_color = "#FF9100"
	//idtype = /obj/item/weapon/card/id/engineering
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_mineral_storeroom)
	minimal_access = list(access_eva, access_atmospherics, access_maint_tunnels, access_external_airlocks, access_emergency_storage, access_construction, access_mineral_storeroom)
	minimal_player_age = 7

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/rank/atmospheric_technician(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_or_collect(new /obj/item/weapon/storage/belt/utility/atmostech/(H), slot_belt)
		H.equip_or_collect(new /obj/item/device/pda/atmos(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/weapon/storage/box/engineer(H), slot_in_backpack)
		return 1

/datum/job/operation_support
	title = "Operation Support"
	flag = MECHANIC
	department_flag = KARMA
	total_positions = 3
	spawn_positions = 3
	supervisors = "Omegacorp"
	selection_color = "#FF9100"
	//idtype = /obj/item/weapon/card/id/engineering
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_mechanic, access_external_airlocks, access_mineral_storeroom)
	minimal_access = list(access_maint_tunnels, access_emergency_storage, access_mechanic, access_external_airlocks, access_mineral_storeroom)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/rank/mechanic(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_or_collect(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		H.equip_or_collect(new /obj/item/clothing/head/hardhat(H), slot_head)
		H.equip_or_collect(new /obj/item/device/t_scanner(H), slot_r_store)
		H.equip_or_collect(new /obj/item/device/pda/engineering(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/weapon/storage/box/engineer(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/pod_paint_bucket(H), slot_in_backpack)
		return 1