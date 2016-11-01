/datum/job/archmage
	title = "Arch Mage"
	flag = CHIEF
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "Your majesty"
	selection_color = "#C618BA"
	//idtype = /obj/item/weapon/card/id/ce
	req_admin_notify = 1
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_minisat, access_mechanic, access_mineral_storeroom)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_minisat, access_mechanic, access_mineral_storeroom)
	minimal_player_age = 34


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset/heads/ce(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/rank/chief_engineer(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/device/pda/heads/ce(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_or_collect(new /obj/item/clothing/head/hardhat/white(H), slot_head)
		H.equip_or_collect(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		H.equip_or_collect(new /obj/item/clothing/gloves/color/black/ce(H), slot_gloves)
		H.equip_or_collect(new /obj/item/weapon/storage/box/engineer(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/melee/classic_baton/telescopic(H), slot_in_backpack)
		H.underwear = "Nude"
		H.undershirt = "Nude"
		H.socks = "Nude"
		return 1



/datum/job/mage
	title = "Mage"
	flag = ENGINEER
	department_flag = ENGSEC
	total_positions = 4
	spawn_positions = 4
	supervisors = "The archmage and Your Majesty"
	selection_color = "#E61FD9"
	idtype = /obj/item/weapon/card/id/engineering
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_mineral_storeroom)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_mineral_storeroom)
	alt_titles = list("Elementalist","Wizard","Witch", "Spellweaver", "Wizard apprentice")
	minimal_player_age = 7

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/rank/engineer(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
		H.equip_or_collect(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		H.equip_or_collect(new /obj/item/clothing/head/hardhat(H), slot_head)
		H.equip_or_collect(new /obj/item/device/t_scanner(H), slot_r_store)
		H.equip_or_collect(new /obj/item/device/pda/engineering(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/weapon/storage/box/engineer(H), slot_in_backpack)
		H.underwear = "Nude"
		H.undershirt = "Nude"
		H.socks = "Nude"
		return 1
