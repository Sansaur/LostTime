/obj/structure/separating_table
	name = "\improper Separating table"
	desc = "A table used to separate diverse reagents and liquids from each other"
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "separating_table"
	density = 1
	anchored = 1
	var/has_pill_bottle = 0
	var/obj/item/weapon/reagent_containers/beaker = null
	var/obj/item/weapon/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/condi = 1
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/patchamount = 10
	var/bottlesprite = "bottle"
	var/pillsprite = "1"
	var/client/has_sprites = list()
	var/printing = null
	var/medieval = 1

/obj/structure/separating_table/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src
	overlays += "waitlight"

/obj/structure/separating_table/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return

/obj/structure/separating_table/blob_act()
	if(prob(50))
		qdel(src)

/obj/structure/separating_table/attackby(obj/item/weapon/B, mob/user, params)

	if(istype(B, /obj/item/weapon/reagent_containers/glass) || istype(B, /obj/item/weapon/reagent_containers/food/drinks/drinkingglass))

		if(beaker)
			to_chat(user, "<span class='warning'>[beaker] is already loaded into the machine.</span>")
			return
		if(!user.drop_item())
			to_chat(user, "<span class='warning'>[B] is stuck to you!</span>")
			return
		beaker = B
		B.forceMove(src)
		to_chat(user, "<span class='notice'>You add the [B] to the machine!</span>")
		nanomanager.update_uis(src)
		icon_state = "separating_table1"
	return

/obj/structure/separating_table/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)
	usr.set_machine(src)


	if(href_list["ejectp"])
		if(loaded_pill_bottle)
			loaded_pill_bottle.forceMove(loc)
			loaded_pill_bottle = null

	else if(href_list["close"])
		usr << browse(null, "window=chem_master")
		onclose(usr, "chem_master")
		usr.unset_machine()
		return

	if(href_list["print_p"])
		if(medieval)
			return
		if(!(printing))
			printing = 1
			visible_message("<span class='notice'>[src] rattles and prints out a sheet of paper.</span>")
			playsound(loc, "sound/goonstation/machines/printer_dotmatrix.ogg", 50, 1)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(loc)
			P.info = "<CENTER><B>Chemical Analysis</B></CENTER><BR>"
			P.info += "<b>Time of analysis:</b> [worldtime2text(world.time)]<br><br>"
			P.info += "<b>Chemical name:</b> [href_list["name"]]<br>"
			if(href_list["name"] == "Blood")
				var/datum/reagents/R = beaker.reagents
				var/datum/reagent/blood/G
				for(var/datum/reagent/F in R.reagent_list)
					if(F.name == href_list["name"])
						G = F
						break
				var/B = G.data["blood_type"]
				var/C = G.data["blood_DNA"]
				P.info += "<b>Description:</b><br>Blood Type: [B]<br>DNA: [C]"
			else
				P.info += "<b>Description:</b> [href_list["desc"]]"
			P.info += "<br><br><b>Notes:</b><br>"
			P.name = "Chemical Analysis - [href_list["name"]]"
			printing = null

	if(beaker)
		var/datum/reagents/R = beaker.reagents
		if(href_list["analyze"])
			var/dat = ""
			if(!condi)
				if(href_list["name"] == "Blood")
					var/datum/reagent/blood/G
					for(var/datum/reagent/F in R.reagent_list)
						if(F.name == href_list["name"])
							G = F
							break
					var/A = G.name
					var/B = G.data["blood_type"]
					var/C = G.data["blood_DNA"]
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[A]<BR><BR>Description:<BR>Blood Type: [B]<br>DNA: [C]"
				else
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]"
				dat += "<BR><BR><A href='?src=[UID()];print_p=1;desc=[href_list["desc"]];name=[href_list["name"]]'>(Print Analysis)</A><BR>"
				dat += "<A href='?src=[UID()];main=1'>(Back)</A>"
			else
				if(!medieval)
					dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=[UID()];main=1'>(Back)</A>"
				else
					dat += "<TITLE> Reagent separator: </TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=[UID()];main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return

		else if(href_list["add"])

			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = text2num(href_list["amount"])
				R.trans_id_to(src, id, amount)

		else if(href_list["addcustom"])

			var/id = href_list["addcustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = isgoodnumber(useramount)
			Topic(null, list("amount" = "[useramount]", "add" = "[id]"))

		else if(href_list["remove"])

			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = text2num(href_list["amount"])
				if(mode)
					reagents.trans_id_to(beaker, id, amount)
				else
					reagents.remove_reagent(id, amount)


		else if(href_list["removecustom"])

			var/id = href_list["removecustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = isgoodnumber(useramount)
			Topic(null, list("amount" = "[useramount]", "remove" = "[id]"))

		else if(href_list["toggle"])
			mode = !mode

		else if(href_list["main"])
			attack_hand(usr)
			return
		else if(href_list["eject"])
			if(beaker)
				beaker.forceMove(get_turf(src))
				beaker = null
				reagents.clear_reagents()
				icon_state = "separating_table0"
		else if(href_list["createpill"] || href_list["createpill_multiple"])
			if(!condi || !medieval)
				var/count = 1
				if(href_list["createpill_multiple"])
					count = input("Select the number of pills to make.", 10, pillamount) as num|null
					if(count == null)
						return
					count = isgoodnumber(count)
				if(count > 20) count = 20	//Pevent people from creating huge stacks of pills easily. Maybe move the number to defines?
				if(count <= 0) return
				var/amount_per_pill = reagents.total_volume/count
				if(amount_per_pill > 50) amount_per_pill = 50
				var/name = input(usr,"Name:","Name your pill!","[reagents.get_master_reagent_name()] ([amount_per_pill]u)") as text|null
				if(!name)
					return
				name = reject_bad_text(name)
				while(count--)
					var/obj/item/weapon/reagent_containers/food/pill/P = new/obj/item/weapon/reagent_containers/food/pill(loc)
					if(!name) name = reagents.get_master_reagent_name()
					P.name = "[name] pill"
					P.pixel_x = rand(-7, 7) //random position
					P.pixel_y = rand(-7, 7)
					P.icon_state = "pill"+pillsprite
					reagents.trans_to(P,amount_per_pill)
					if(loaded_pill_bottle)
						if(loaded_pill_bottle.contents.len < loaded_pill_bottle.storage_slots)
							P.forceMove(loaded_pill_bottle)
							updateUsrDialog()
			else
				var/name = input(usr,"Name:","Name your bag!",reagents.get_master_reagent_name()) as text|null
				if(!name || !medieval)
					return
				name = reject_bad_text(name)
				var/obj/item/weapon/reagent_containers/food/condiment/pack/medieval/P = new/obj/item/weapon/reagent_containers/food/condiment/pack/medieval(loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.originalname = name
				P.name = "[name] pack"
				P.desc = "A small condiment pack. The label says it contains [name]."
				reagents.trans_to(P,10)

		else if(href_list["createpatch"] || href_list["createpatch_multiple"])
			if(!condi || !medieval)
				var/count = 1
				if(href_list["createpatch_multiple"])
					count = input("Select the number of patches to make.", 10, patchamount) as num|null
					if(count == null)
						return
					count = isgoodnumber(count)
				if(!count || count <= 0)
					return
				if(count > 20) count = 20	//Pevent people from creating huge stacks of patches easily. Maybe move the number to defines?
				var/amount_per_patch = reagents.total_volume/count
				if(amount_per_patch > 40) amount_per_patch = 40
				var/name = input(usr,"Name:","Name your patch!","[reagents.get_master_reagent_name()] ([amount_per_patch]u)") as text|null
				if(!name)
					return
				name = reject_bad_text(name)
				var/is_medical_patch = chemical_safety_check(reagents)
				while(count--)
					var/obj/item/weapon/reagent_containers/food/pill/patch/P = new/obj/item/weapon/reagent_containers/food/pill/patch(loc)
					if(!name) name = reagents.get_master_reagent_name()
					P.name = "[name] patch"
					P.pixel_x = rand(-7, 7) //random position
					P.pixel_y = rand(-7, 7)
					reagents.trans_to(P,amount_per_patch)
					if(is_medical_patch)
						P.instant_application = 1
						P.icon_state = "bandaid_med"

		else if(href_list["createbottle"])
			if(!condi)
				var/name = input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()) as text|null
				if(!name)
					return
				name = reject_bad_text(name)
				var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = bottlesprite
				reagents.trans_to(P,30)
			else
				var/obj/item/weapon/reagent_containers/food/condiment/medieval/P = new/obj/item/weapon/reagent_containers/food/condiment/medieval(loc)
				reagents.trans_to(P,50)


		else if(href_list["change_pill"])
			#define MAX_PILL_SPRITE 20 //max icon state of the pill sprites
			var/dat = "<table>"
			var/j = 0
			for(var/i = 1 to MAX_PILL_SPRITE)
				j++
				if(j == 1)
					dat += "<tr>"
				dat += "<td><a href=\"?src=[UID()]&pill_sprite=[i]\"><img src=\"pill[i].png\" /></a></td>"
				if(j == 5)
					dat += "</tr>"
					j = 0
			dat += "</table>"
			usr << browse(dat, "window=chem_master_iconsel;size=225x193")
			return
		else if(href_list["change_bottle"])
			var/dat = "<table>"
			var/j = 0
			for(var/i in list("bottle", "small_bottle", "wide_bottle", "round_bottle"))
				j++
				if(j == 1)
					dat += "<tr>"
				dat += "<td><a href=\"?src=[UID()]&bottle_sprite=[i]\"><img src=\"[i].png\" /></a></td>"
				if(j == 5)
					dat += "</tr>"
					j = 0
			dat += "</table>"
			usr << browse(dat, "window=chem_master_iconsel;size=225x193")
			return
		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
			usr << browse(null, "window=chem_master_iconsel")
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]
			usr << browse(null, "window=chem_master_iconsel")

	nanomanager.update_uis(src)
	return

/obj/structure/separating_table/attack_ai(mob/user)
	return attack_hand(user)

/obj/structure/separating_table/attack_ghost(mob/user)
	return attack_hand(user)

/obj/structure/separating_table/attack_hand(mob/user)
	if(..())
		return 1
	ui_interact(user)
	return

/obj/structure/separating_table/ui_interact(mob/user, ui_key="main", datum/nanoui/ui = null, force_open = 1)

	var/datum/asset/chem_master/assets = get_asset_datum(/datum/asset/chem_master)
	assets.send(user)

	var/data = list()

	data["condi"] = condi
	data["loaded_pill_bottle"] = (loaded_pill_bottle ? 1 : 0)
	if(loaded_pill_bottle)
		data["loaded_pill_bottle_contents_len"] = loaded_pill_bottle.contents.len
		data["loaded_pill_bottle_storage_slots"] = loaded_pill_bottle.storage_slots

	data["beaker"] = (beaker ? 1 : 0)
	if(beaker)
		var/list/beaker_reagents_list = list()
		data["beaker_reagents"] = beaker_reagents_list
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beaker_reagents_list[++beaker_reagents_list.len] = list("name" = R.name, "volume" = R.volume, "id" = R.id, "description" = R.description)
		var/list/buffer_reagents_list = list()
		data["buffer_reagents"] = buffer_reagents_list
		for(var/datum/reagent/R in reagents.reagent_list)
			buffer_reagents_list[++buffer_reagents_list.len] = list("name" = R.name, "volume" = R.volume, "id" = R.id, "description" = R.description)

	data["pillsprite"] = pillsprite
	data["bottlesprite"] = bottlesprite
	data["mode"] = mode

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "chem_master.tmpl", name, 575, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/separating_table/proc/isgoodnumber(num)
	if(isnum(num))
		if(num > 200)
			num = 200
		else if(num < 0)
			num = 1
		else
			num = round(num)
		return num
	else
		return 0

/obj/structure/separating_table/proc/chemical_safety_check(datum/reagents/R)
	var/all_safe = 1
	for(var/datum/reagent/A in R.reagent_list)
		if(!safe_chem_list.Find(A.id))
			all_safe = 0
	return all_safe