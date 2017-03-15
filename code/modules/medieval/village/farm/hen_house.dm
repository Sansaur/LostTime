/*

*	 HEN HOUSE

*/

/obj/structure/hen_house
	name = "\improper hen house"
	desc = "Once this is full of hens it WILL get noisy."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "hen_house"
	density = 1
	opacity = 0
	anchored = 1
	var/list/mob/living/simple_animal/chicken/chickenList = list()
	var/eggs = 0
	var/maximum_capacity = 5
	var/allow_breeding = 1
	var/allow_hatching = 1
	var/food_inside = 0
	var/list/allowed_food = list(
		"wheat"
	)
/obj/structure/hen_house/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		ChickenList(user)
		return

/obj/structure/hen_house/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/MyGrab = W
		var/mob/comparison = MyGrab.affecting
		if(istype(comparison, /mob/living/simple_animal/chicken))
			var/mob/living/simple_animal/chicken/MyChicken = comparison
			if(chickenList.len > maximum_capacity)
				to_chat(user, "<div class=warning> The [src] is full of chickens </div>")
				return
			else
				user.drop_item()
				MyChicken.loc = src
				chickenList.Add(MyChicken)

	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/MYSNACK = W
		var/datum/reagents/this_reagents = MYSNACK.reagents
		if(this_reagents && MYSNACK.seed.kitchen_tag in allowed_food)
			to_chat(user, "<div class=notice> you grind and mix [MYSNACK] into a mix for [src] food pile </div>")
			for(var/datum/reagent/REAGENT in this_reagents.reagent_list)
				food_inside += REAGENT.volume

			qdel(MYSNACK)
		else
			to_chat(user, "<div class=warning> [MYSNACK] is not suitable food for [src]</div>")
			return
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/egg))
		to_chat(user, "<div class=notice> you store the egg in [src] </div>")
		eggs++
		user.drop_item()
		qdel(W)


/obj/structure/hen_house/proc/ChickenList(mob/user as mob)
	user.set_machine(src)
	var/dat

	dat += text(" Hen house <br>")
	for(var/i=1;i<chickenList.len+1;i++)
		var/mob/living/simple_animal/chicken/Chicken = chickenList[i]
		dat += text("<A href='?src=[UID()];choice=[i]'>[Chicken.name].</A><br>")

	dat += text("<A href='?src=[UID()];choice=11'>Eggs: [eggs].</A><br>")
	dat += text("There's a total of <b>[food_inside]</b> units of food mix inside the hen house<br>")
	if(allow_breeding)
		dat += text("Are the chickens allowed to breed? <A href='?src=[UID()];choice=breeding'> Yes.</A><br>")
	else
		dat += text("Are the chickens allowed to breed? <A href='?src=[UID()];choice=breeding'>No.</A><br>")

	if(allow_hatching)
		dat += text("Are the eggs allowed to hatch? <A href='?src=[UID()];choice=hatching'>Yes.</A><br>")
	else
		dat += text("Are the eggs allowed to hatch? <A href='?src=[UID()];choice=hatching'>No.</A><br>")

	var/datum/browser/popup = new(user, "caravan_window", "Caravan", 400, 500)
	popup.set_content(dat)
	popup.open()
	return


/obj/structure/hen_house/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		switch(href_list["choice"])
			if("0")
				ReleaseChicken(0)
			if("1")
				ReleaseChicken(1)
			if("2")
				ReleaseChicken(2)
			if("3")
				ReleaseChicken(3)
			if("4")
				ReleaseChicken(4)
			if("5")
				ReleaseChicken(5)
			if("6")
				ReleaseChicken(6)
			if("7")
				ReleaseChicken(7)
			if("8")
				ReleaseChicken(8)
			if("9")
				ReleaseChicken(9)
			if("11")
				ReleaseEgg()
			if("breeding")
				allow_breeding = !allow_breeding
			if("hatching")
				allow_hatching = !allow_hatching
			else
				message_admins("ERROR ON THE HEN HOUSE!!")
	return

/obj/structure/hen_house/proc/ReleaseChicken(var/ID)
	var/mob/living/simple_animal/chicken/Chicken = chickenList[ID]
	Chicken.loc = src.loc
	chickenList.Remove(Chicken)
	return

/obj/structure/hen_house/proc/ReleaseEgg()
	if(eggs > 0)
		var/obj/item/weapon/reagent_containers/food/snacks/egg/eggy = new (src)
		eggy.loc = src.loc
		eggs--
		return
	else
		return

/obj/structure/hen_house/proc/HatchEgg()
	if(eggs > 0)
		if(chickenList.len > maximum_capacity)
			return
		if(chickenList.len <= 0)	//There must be at least a chicken or even a cock giving warmth
			return
		if(prob(50))
			var/mob/living/simple_animal/chicken/NEW = new (src)
			chickenList.Add(NEW)
		else
			var/mob/living/simple_animal/chicken/cock/NEW = new (src)
			chickenList.Add(NEW)
		eggs--
		return
	else
		return