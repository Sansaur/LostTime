/datum/job/captain_guard
	title = "Captain Guard"
	flag = HOS
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "Your majesty"
	selection_color = "#ffdddd"
	//idtype = /obj/item/weapon/card/id/hos
	req_admin_notify = 1
	access = list(access_security, access_sec_doors, access_brig, access_armory, access_court,
			            access_forensics_lockers, access_pilot, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_weapons)
	minimal_access = list(access_eva, access_security, access_sec_doors, access_brig, access_armory, access_court,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_pilot, access_weapons)
	minimal_player_age = 24

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/device/radio/headset/heads/hos/alt(H), slot_l_ear)
		H.equip_or_collect(new /obj/item/clothing/under/rank/head_of_security(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_or_collect(new /obj/item/clothing/suit/armor/hos(H), slot_wear_suit)
		H.equip_or_collect(new /obj/item/device/pda/heads/hos(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/clothing/gloves/color/black/hos(H), slot_gloves)
		H.equip_or_collect(new /obj/item/clothing/head/HoS(H), slot_head)
		H.equip_or_collect(new /obj/item/clothing/glasses/hud/security/sunglasses(H), slot_glasses)
		H.equip_or_collect(new /obj/item/weapon/gun/energy/gun(H), slot_s_store)
		H.equip_or_collect(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/restraints/handcuffs(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/melee/classic_baton/telescopic(H), slot_in_backpack)
		H.underwear = "Nude"
		H.undershirt = "Nude"
		H.socks = "Nude"
		H.time_faction = "Medieval"
		return 1



/datum/job/footman
	title = "Footman"
	flag = WARDEN
	department_flag = ENGSEC
	total_positions = 5
	spawn_positions = 5
	supervisors = "Your majesty and the Captian Guard"
	selection_color = "#ffeeee"
	//idtype = /obj/item/weapon/card/id/security
	access = list(access_security, access_sec_doors, access_brig, access_armory, access_court, access_maint_tunnels, access_morgue, access_weapons)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_armory, access_court, access_maint_tunnels, access_weapons)
	minimal_player_age = 21

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset/headset_sec/alt(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/rank/warden(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_or_collect(new /obj/item/clothing/suit/armor/vest/warden(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/warden(H), slot_head)
		H.equip_or_collect(new /obj/item/device/pda/warden(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/clothing/gloves/color/black(H), slot_gloves)
		H.equip_or_collect(new /obj/item/clothing/glasses/hud/security/sunglasses(H), slot_glasses)
//		H.equip_or_collect(new /obj/item/clothing/mask/gas(H), slot_wear_mask) //Grab one from the armory you donk
		H.equip_or_collect(new /obj/item/device/flash(H), slot_l_store)
		H.equip_or_collect(new /obj/item/weapon/gun/energy/gun/advtaser(H), slot_s_store)
		H.equip_or_collect(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/restraints/handcuffs(H), slot_in_backpack)
		H.underwear = "Nude"
		H.undershirt = "Nude"
		H.socks = "Nude"
		H.time_faction = "Medieval"
		return 1



/datum/job/monster_hunter
	title = "Monster Hunter"
	flag = DETECTIVE
	department_flag = ENGSEC
	total_positions = 2
	spawn_positions = 2
	supervisors = "Your majesty and the Captian Guard"
	selection_color = "#ffeeee"
	//idtype = /obj/item/weapon/card/id/security
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court, access_weapons)
	minimal_access = list(access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court, access_weapons)
	minimal_player_age = 14
	alt_titles = list("Witch Hunter")
	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_or_collect(new /obj/item/device/radio/headset/headset_sec/alt(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_or_collect(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_or_collect(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_or_collect(new /obj/item/clothing/under/det(H), slot_w_uniform)
		H.equip_or_collect(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_or_collect(new /obj/item/device/pda/detective(H), slot_wear_pda)
		H.equip_or_collect(new /obj/item/toy/crayon/white(H), slot_l_store)
/*		var/obj/item/clothing/mask/cigarette/CIG = new /obj/item/clothing/mask/cigarette(H)
		CIG.light("")
		H.equip_or_collect(CIG, slot_wear_mask)	*/
		H.equip_or_collect(new /obj/item/clothing/glasses/sunglasses/noir(H),slot_glasses)
		H.equip_or_collect(new /obj/item/clothing/gloves/color/black(H), slot_gloves)
		if(H.mind.role_alt_title && H.mind.role_alt_title == "Forensic Technician")
			H.equip_or_collect(new /obj/item/clothing/suit/storage/det_suit/forensics/blue(H), slot_wear_suit)
		else
			H.equip_or_collect(new /obj/item/clothing/suit/storage/det_suit(H), slot_wear_suit)
			H.equip_or_collect(new /obj/item/clothing/head/det_hat(H), slot_head)
		H.equip_or_collect(new /obj/item/weapon/lighter/zippo(H), slot_l_store)
		H.equip_or_collect(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/storage/box/evidence(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/device/detective_scanner(H), slot_in_backpack)
		H.equip_or_collect(new /obj/item/weapon/melee/classic_baton/telescopic(H), slot_in_backpack)
		H.underwear = "Nude"
		H.undershirt = "Nude"
		H.socks = "Nude"
		H.time_faction = "Medieval"
		return 1
