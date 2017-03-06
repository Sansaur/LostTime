
/**
	STRUCTURES TO TREAT LOGS AND PLANKS

	THIS HAS TO BE UPDATED WITH EACH NEW WOOD

	I'M GOING TO MOVE THIS TO THE START OF THE FILE
**/

/obj/structure/sawmill
	name = "sawmill"
	desc = "A tool used to turn logs into planks after a noisy ruckus."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "sawmill"
	anchored = 1
	density = 1

/obj/structure/sawmill/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/log))
		playsound(loc, 'sound/effects/sawingmill.ogg', 90, 1)
		flick("sawmill-cut",src)
		for(var/i=0, i<3, i++)
			new /obj/item/weapon/wood_plank(src.loc)
		qdel(O)


//Wood Workbench
// The workbench recipes should ONLY include tools / items
// We'll use a part-by-part system to make furniture
// And we'll use a saw and bow to make those parts

/obj/structure/wood_workbench
	name = "woodsman workbench"
	desc = "It's time to get crafty."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "workbench"
	anchored = 1
	density = 1
	var/obj/structure/wood_storage/ThisStorage //A storage unit that will get set when needed, it has to be adjacent to the source
	var/list/workbech_recipes = list(
                      "wooden table parts (1 wood)"
                      )

/obj/structure/wood_workbench/attack_hand(mob/user as mob)
	var/choice = input("Select what you want to build","Recipe",0) in workbech_recipes
	switch(choice)
		if("wooden table parts (1 wood)")
			if(setStorage())
				if(ThisStorage.regular_wood >= 1)
					ThisStorage.regular_wood -= 1
					new /obj/item/weapon/table_parts/wood(src.loc)
					nullStorage()
				else
					to_chat(user, "The [ThisStorage] doesn't have enough wood")

		if("baker's peel (1 wood)")
			if(setStorage())
				if(ThisStorage.regular_wood >= 1)
					ThisStorage.regular_wood -= 1
					new /obj/item/weapon/kitchen/peel(src.loc)
					nullStorage()
				else
					to_chat(user, "The [ThisStorage] doesn't have enough wood")

		else
			return

/obj/structure/wood_workbench/proc/setStorage()
	for(var/direction in cardinal)
		for(var/obj/structure/wood_storage/W in get_step(src,direction))
			ThisStorage = W
			return 1

	return 0

/obj/structure/wood_workbench/proc/nullStorage()
	ThisStorage = null

/obj/structure/wood_storage
	name = "workbench storage"
	desc = "It's time to store the things to get crafty."
	icon = 'icons/obj/medieval/village.dmi'
	icon_state = "wood_storage"
	anchored = 1
	density = 1
	var/max_storage = 10
	var/regular_wood = 0 //This will need loads of updating, basically, anything this thing is going to use needs to be added

/obj/structure/wood_storage/verb/TakeWood()
	set name = "Interact with storage"
	set desc = "remove items from the workbench storage"
	set category = "Object"
	set src in oview(1)
	takeWood(usr)

/obj/structure/wood_storage/proc/takeWood(mob/user as mob)
	//THIS NEEDS UPDATING TOO
	var/choice = input("Select which item you want to remove","Item storage",0) in list("Regular wood")
	switch(choice)
		if("Regular wood")
			var/number_to_take = input("How many will you remove? ([regular_wood] units in storage)","Item storage",0) as num
			if(number_to_take > regular_wood)
				number_to_take = regular_wood
			for(var/i=0;i<number_to_take;i++)
				regular_wood--
				new /obj/item/weapon/wood_plank (loc)
		else
			return

/obj/structure/wood_storage/attackby(obj/item/O, mob/user, params)
	//REMEMBER TO UPDATE THIS TOO
	if(isFull())
		to_chat(user, "<div span=warning> The workbench's storage is full </div>")
		return 0

	if(istype(O, /obj/item/weapon/wood_plank))
		to_chat(user, "<div span=info> You add some <b> common wood </b> to the workbench's storage </div>")
		regular_wood++
		qdel(O)

/obj/structure/wood_storage/proc/isFull()
	//REMEMBER TO UPDATE THIS
	var/sum = regular_wood //Add new woods and materials as they come along
	if(sum >= max_storage)
		return 1
	else
		return 0

/****

PART BY PARY SYSTEM

- TOOLS:

	- Saw
	- Polisher


- MATERIALS:

	- Double Planks (Use Saw on Planks)
	- Notched plank (Use Polisher on Planks)
	- Spindle (Use Polisher on Double Planks)
	- 2x4 (Use Saw on Double Planks)
	- Royal wood cover (Use Saw on Royal Wood Planks)
	- Ebony wood cover (Use Saw on Ebony Wood Planks)

- RECIPES

	- Regular wood table parts = 1xDouble Planks | 4xNotched Planks
	- Royal wood table parts = use cover on regular table
	- Ebony wood table parts = use cover on regular table

*****/

/obj/item/weapon/wood_saw
	icon_state = "wood_saw"
	name = "saw"
	desc = "Just in case the sawmill isn't precise enough"
	force = 10
	throwforce = 5
	sharp = 1
	edge = 1
	w_class = 2
	slot_flags = SLOT_BELT

/obj/item/weapon/wood_polisher
	icon_state = "wood_polisher"
	name = "polisher"
	desc = "Patience is a virtue, they say..."
	force = 10
	throwforce = 5
	sharp = 1
	edge = 1
	w_class = 2
	slot_flags = SLOT_BELT

/obj/item/woodworks
	desc = "IF YOU SEE THIS CONTACT A CODER!!"
	icon = 'icons/obj/medieval/woodworks.dmi'
	var/saw_result
	var/polisher_result

/obj/item/woodworks/attackby(obj/item/weapon/O, mob/user, params)
	if(istype(O, /obj/item/weapon/wood_saw))
		if(istype(src.loc, /turf/simulated)) //Needs to be cut on the floor
			if(saw_result)
				playsound(loc,'sound/effects/choppingtree.ogg',90,1) //Change sound in the future -Sansaur
				new saw_result (loc)
				qdel(src)

	if(istype(O, /obj/item/weapon/wood_polisher))
		if(istype(src.loc, /turf/simulated)) //Needs to be cut on the floor
			if(polisher_result)
				playsound(loc,'sound/effects/choppingtree.ogg',90,1) //Change sound in the future -Sansaur
				new polisher_result (loc)
				qdel(src)

// THE WOODWORKS OBJECTS

/obj/item/woodworks/double_planks
	icon_state = "double_planks"
	name = "double planks"
	desc = "They'd be better than regular planks if they weren't half their size"
	saw_result = /obj/item/woodworks/spindle
	polisher_result = /obj/item/woodworks/two_by_four

/obj/item/woodworks/notched_plank
	icon_state = "notched_plank"
	name = "notched plank"
	desc = "Dumb people would say \"It has a hole in it \" "

/obj/item/woodworks/spindle
	icon_state = "spindle"
	name = "spindle"
	desc = "It doesn't spin"

/obj/item/woodworks/two_by_four
	icon_state = "2x4"
	name = "2x4"
	desc = "It's not actually the same as a 4x2"

/obj/item/woodworks/royal_wood_cover
	icon_state = "royal_wood_cover"
	name = "royal wood cover"
	desc = "Make things more royal"

/obj/item/woodworks/ebony_wood_cover
	icon_state = "ebony_wood_cover"
	name = "ebony wood cover"
	desc = "Make things more ebony"



// THE WOODWORKS STATION

/obj/structure/woodworks_station
	name = "woodworks station"
	desc = "Time to get craftier"
	icon = 'icons/obj/medieval/woodworks.dmi'
	icon_state = "woodworks_station"
	density = 1
	anchored = 1
	var/recipe_type = /datum/recipe/woodworks

/obj/structure/woodworks_station/New()
	if(dir == SOUTH)
		var/dest = locate(x+1,y,z)
		var/obj/structure/woodworks_station_decoration/NEWDECOR = new /obj/structure/woodworks_station_decoration (dest)
		NEWDECOR.dir = dir
	if(dir == NORTH)
		var/dest = locate(x-1,y,z)
		var/obj/structure/woodworks_station_decoration/NEWDECOR = new /obj/structure/woodworks_station_decoration (dest)
		NEWDECOR.dir = dir
	if(dir == EAST)
		var/dest = locate(x,y+1,z)
		var/obj/structure/woodworks_station_decoration/NEWDECOR = new /obj/structure/woodworks_station_decoration (dest)
		NEWDECOR.dir = dir
	if(dir == WEST)
		var/dest = locate(x,y-1,z)
		var/obj/structure/woodworks_station_decoration/NEWDECOR = new /obj/structure/woodworks_station_decoration (dest)
		NEWDECOR.dir = dir

/obj/structure/woodworks_station/attack_hand(mob/user as mob)
	if(tryRecipes())
		to_chat(user, "You've crafted something!")
		return
	else
		to_chat(user, "<div class=warning> You don't know what you can do with these! </div>")
		return

/obj/structure/woodworks_station/attackby(obj/item/W, mob/user as mob)
	if(!user.drop_item())
		to_chat(user, "<span class='notice'>\The [W] is stuck to your hand, you cannot put it in \the [src]</span>")
		return 0
	W.forceMove(src.loc)
	W.layer = src.layer +0.1

/obj/structure/woodworks_station/proc/tryRecipes()
	//If recipe works return 1
	var/list/datum/recipe/POSSIBLE_RECIPES = list() //We store all the possible recipes in a list and we send it to another method
	for(var/type in subtypesof(recipe_type))
		var/datum/recipe/MYRECIPE = new type
		if(MYRECIPE.result) // Ignore recipe subtypes that lack a result
			if(!MYRECIPE.check_items_floor(src.loc)) //THIS ALWAYS RETURNS TREU
				POSSIBLE_RECIPES.Add(MYRECIPE)
				//var/obj/item/RESULTADO = new MYRECIPE.result (loc)
				//for(var/I in (loc.contents-src-RESULTADO))
				//	qdel(I)
				//return 1
	var/datum/recipe/ChosenRecipe = ChooseRecipe(POSSIBLE_RECIPES)
	if(ChosenRecipe)
		new ChosenRecipe.result (loc)
		for(var/I in ChosenRecipe.items)
			var/obj/item/ERASE = locate(I) in loc
			qdel(ERASE)
		return 1
	else
		return 0

/obj/structure/woodworks_station/proc/ChooseRecipe(var/list/datum/recipe/POSSIBLE_RECIPES)
	var/list/ReplaceNames = list()
	for(var/datum/recipe/R in POSSIBLE_RECIPES)
		ReplaceNames.Add(R.name_replace)

	var/ChosenName = input("Choose the recipe you want to make", "Recipe", null) in ReplaceNames
	if(ChosenName)
		for(var/datum/recipe/R in POSSIBLE_RECIPES)
			if(cmptext(ChosenName,R.name_replace))
				return R

	return 0

/obj/structure/woodworks_station_decoration
	name = "woodworks toolkit"
	desc = "You'll have all what you need at the reach of your hands"
	icon = 'icons/obj/medieval/woodworks.dmi'
	icon_state = "woodworks_station_decoration"
	density = 1
	anchored = 1