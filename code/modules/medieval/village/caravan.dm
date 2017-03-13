/**
* The caravan is a simple mob that works this way:
*
* 1- You put some money for it's trip
* 2- The caravan moves towards a random map edge (map_edges.dm), if it reaches said edge, it'll turn around and come back to it's original location
* 3- A list of availible items with random prices linked to them will be shown as availible for purchase, if you give the caravan money during
	a time limit, you'll be able to buy said items.
*/

/mob/living/simple_animal/caravan
	name = "caravan"
	desc = "Now it's time for us to do srs bsns"
	icon = 'icons/obj/medieval/village.dmi'
	health = 250
	maxHealth = 250
	universal_understand = 1
	status_flags = CANPUSH
	icon_state = "caravan_old"
	icon_living = "caravan_old"
	icon_dead = "caravan_old_dead"
	icon_resting = "caravan_old"
	can_rest = 0
	stop_automated_movement = 1 	//Use this to temporarely stop random movement or to if you write special movement code for animals.
	wander = 0 						//Use this to temporarely stop random movement or to if you write special movement code for animals.

	//Interaction
	response_help   = "pokes"
	response_disarm = "shoves"
	response_harm   = "attacks"
	harm_intent_damage = 3

	speed = 5 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster

	deathmessage = "The caravan has been destroyed! Repair it!"
	can_be_pulled = 0 //Can't pull the caravan, because of exploits

	var/turf/simulated/floor/Target = null

	var/money_for_trip = 0						// When the caravan gets sent on a trip, the more money you invest, the more items it'll bring
	var/buying_time_limit = 150					// Time limit to buy the item off.
	var/item_being_sold
	var/item_being_sold_price					// Item being sold, it's a type that gets instantiated on bought
	var/ready_to_sell = 1						// If the caravan is stay put in one place and it's ready to sell

	var/list/items_for_sale = list()			//Items that can be bought from the caravan. MAXIMUM OF 10 ITEMS
	var/list/price_per_item = list()			//Proce of the Items that can be bought from the caravan.
	var/will_go = 1								// If the caravan will start a trip
	var/returning = 0							// If it is returning from the trip
	//The possible items that the merchant can bring
	var/list/possible_items = list(
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita,
			/obj/item/weapon/reagent_containers/food/snacks/margheritaslice,
			/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza
			)

/mob/living/simple_animal/caravan/examine(mob/user)
	var/info = {"Now it's time for us to do srs bsns
			"\the [src] has <b>[items_for_sale.len]</b> items on sale
			"It has <b>[money_for_trip]</b> coins invested on it"}

	to_chat(user, info)

/mob/living/simple_animal/caravan/CtrlClick()
	return 0

	// This doesn't work for our purpose
/mob/living/simple_animal/caravan/handle_automated_movement()
	return 0

/mob/living/simple_animal/caravan/attack_hand(mob/living/carbon/human/M as mob)

	switch(M.a_intent)

		if(I_HELP)
			if(item_being_sold || !ready_to_sell)
				return
			switch(alert("Wantcha want?", "Caravan", "Start trip", "What are you selling?"))
				if("Start trip")
					if(Adjacent(M))
						message_admins("CARAVAN MESSAGE")
						StartTrip()
				else
					if(Adjacent(M))
						SellingList(M)
		if(I_GRAB)
			//Cannot grab a caravan
			return

		if(I_HARM, I_DISARM)
			//M.do_attack_animation(src)
			//visible_message("<span class='danger'>[M] [response_harm] [src]!</span>")
			//playsound(loc, "punch", 25, 1, -1)
			//attack_threshold_check(harm_intent_damage)
			..()

	return

/mob/living/simple_animal/caravan/attackby(var/obj/item/O as obj, var/mob/living/user as mob)
	if(istype(O, /obj/item/weapon/medieval_cash))
		var/obj/item/weapon/medieval_cash/CASH = O
		if(item_being_sold)
			if(CASH.worth > item_being_sold_price)
				CASH.worth -= item_being_sold_price
				visible_message("There you go")
				items_for_sale -= item_being_sold
				price_per_item -= item_being_sold_price
				new item_being_sold (user.loc)
				item_being_sold = null
				item_being_sold_price = null
		else
			var/choice = input("How much are you gonna invest?", "Invest on the caravan", 0) as num
			if(Adjacent(user))
				if(choice > CASH.worth)
					to_chat(user, "<div class=warning> You cannot invest that much money! You only have [CASH.worth] coins </div>")
					return
				else
					to_chat(user, "<div class=warning> Thank you, kind sir~... Now I have [money_for_trip] coins for my trip </div>")
					money_for_trip = choice
					CASH.worth -= choice
					CASH.update_icon()
	else
		..()

/mob/living/simple_animal/caravan/proc/SellingList(var/mob/living/carbon/human/user as mob)
	// We make a loop to iterate over the list of items, it gives an ID number to them, on the topic, it searchs for said item and instantiates that list entry
	user.set_machine(src)
	var/dat


	dat += text("Welcome, stranger.<br>")
	dat += text("Right now I have: [money_for_trip] coins invested. <br><br>")
	dat += text("What are you buying? <br>")
	for(var/i=1;i<items_for_sale.len+1;i++)
		message_admins("LIST LENGTH: [items_for_sale.len]")
		message_admins("Number: [i]")
		message_admins("OUR ITEM: [items_for_sale[i]]")
		var/TYPE = items_for_sale[i]
		var/obj/item/ITEMTOLIST = new TYPE (src)
		dat += text("<A href='?src=[UID()];choice=[i]'>[ITEMTOLIST.name].</A> Price: [price_per_item[i]]<br>")
		qdel(ITEMTOLIST)

	var/datum/browser/popup = new(user, "caravan_window", "Caravan", 400, 500)
	popup.set_content(dat)
	popup.open()
	return

/mob/living/simple_animal/caravan/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		switch(href_list["choice"])
			if("0")
				PrepareItem(0)
			if("1")
				PrepareItem(1)
			if("2")
				PrepareItem(2)
			if("3")
				PrepareItem(3)
			if("4")
				PrepareItem(4)
			if("5")
				PrepareItem(5)
			if("6")
				PrepareItem(6)
			if("7")
				PrepareItem(7)
			if("8")
				PrepareItem(8)
			if("9")
				PrepareItem(9)
			else
				message_admins("ERROR ON THE CARAVAAAAAAN!!")

	//usr << browse(null, "window=caravan_window") //This is hacky as fuck, improve in the future. - Sansaur
	//updateUsrDialog() <- This would be the better way, but it only works with objects
	return

/mob/living/simple_animal/caravan/proc/PrepareItem(var/itemID)
	item_being_sold = items_for_sale[itemID]
	item_being_sold_price = price_per_item[itemID]
	visible_message("the <b> [src]</b> says, \" Alright! It'll cost ya [item_being_sold_price] coins \" ")
	sleep(buying_time_limit)
	if(item_being_sold)
		visible_message("<span class='danger'>\The <b>[src]</b> yells, \"I don't have all day!\"</span>")
		item_being_sold = null
		item_being_sold_price = null

/mob/living/simple_animal/caravan/proc/RandomizeItems()
	if(returning)
		return
	items_for_sale.Cut()
	price_per_item.Cut()

	var/item_number = round(money_for_trip / 100) + 3 // +3 'cause it's pretty shitty to send caravans and don't get nothing
	if(item_number > 10)
		item_number = 10
	if(item_number < 0)
		item_number = 0

	for(var/i=0;i<item_number;i++)
		var/random_number = rand(1, possible_items.len)
		items_for_sale.Add( possible_items[random_number] )
		var/random_price = rand(20,200)
		price_per_item.Add( random_price )

	money_for_trip = 0 // At the end of the trip, the money returns to 0, this is commented while debugging

/mob/living/simple_animal/caravan/proc/adjustMoney(var/amount)
	money_for_trip += amount
	return

	/*
	*
	* CARAVAN TRIP
	*
	*/

/mob/living/simple_animal/caravan/proc/StartTrip()
	spawn(3)
	if(!will_go)
		return
	message_admins("Starting trip")
	ready_to_sell=0
	var/obj/effect/step_trigger/teleport_fancy/medieval_map_edge/EDGE = locate()
	if(EDGE)
		Target = EDGE.loc
		//while src.loc != Target??
		///walk_to(src,Target,0,speed)//This should locate a random place instead. Walk to doesnt work, that's final
		while(Target)
			step_towards(src, Target)
			sleep(10)

	else
		return
	//walk_to(src,Target,0,1)

/mob/living/simple_animal/caravan/proc/finishTrip()
	Target = null
	if(returning)
		return

	spawn(3)
	returning = 1
	message_admins("Finish trip")
	var/area/medieval/village/center/TownCenter = locate()
	var/list/turf/simulated/floor/TurfList = list()

	for(var/turf/simulated/floor/T in TownCenter)
		if(T.density == 1)
			continue

		var/blocked = 0
		for(var/obj/anything in T)
			if(anything.density == 1)
				blocked = 1
				break
			else
				continue
		if(blocked)
			continue

		if(prob(50)) //This is dangerous, but it's so it doesn't spawn always in the same place
			continue

		TurfList.Add(T)

	var/turf/Final = pick_n_take(TurfList)
	returning = 0
	sleep(1)
	Move(Final)
	sleep(5)
	returning = 0
	ready_to_sell = 1
	return