//THERE MUST ONLY BE ONE PHONEBOOTH IN THE WORLD AT A GIVEN TIME.

/obj/structure/timetravel/phonebooth
	name = "Time Travelling Phone Booth"
	desc = "A restored version of a device capable of performing time travel discovered by a now ancient doctor, nobody knows what happened to him"
	icon = 'icons/obj/phonebooth.dmi'
	icon_state = "phonebooth"
	density = 1
	opacity = 0
	anchored = 1
	var/LOCKED = 0 //This is used with one of the mainframes
	var/obj/effect/step_trigger/teleport_fancy/phonebooth/Door_To_Outside
	var/obj/item/weapon/phonebooth_remote/Master_Remote
	var/obj/item/weapon/pinpointer/phonebooth/Pinpointer_ToAdd
	var/list/obj/item/weapon/pinpointer/phonebooth/Pinpointer_List = list()
	var/obj/structure/timetravel/phonebooth_computer/Computer
	var/obj/structure/timetravel/phonebooth_saver/SecondaryComp
	//La idea es hacer que el teletransportador sea parte del phonebooth

/obj/structure/timetravel/phonebooth/Destroy() //CAN'T DESTROY THISSSSS
	return
/obj/structure/timetravel/phonebooth/New() //Creates a Step Trigger in a specific tile
	..()

	/*
	Esto puede ser mejorado usando un locate() in world para la creación de los otros objetos
	*/
	var/locationx = 248
	var/locationy = 119
	var/locationz = 2
	var/dest = locate(locationx, locationy, locationz)
	Door_To_Outside = new(dest)
	Door_To_Outside.master_booth = src

	locationx = 246
	locationy = 129
	dest = locate(locationx, locationy, locationz)
	Master_Remote = new(dest)
	Master_Remote.master_booth = src

	locationx = 248
	locationy = 129
	dest = locate(locationx, locationy, locationz)
	Computer = new(dest)
	Computer.master_booth = src

	locationx = 249
	locationy = 129
	dest = locate(locationx, locationy, locationz)
	SecondaryComp = new(dest)
	SecondaryComp.master_booth = src

	locationx = 245
	locationy = 129
	dest = locate(locationx, locationy, locationz)
	for(var/i = 0; i < 7; i++)
		Pinpointer_ToAdd = new(dest)
		Pinpointer_ToAdd.master_booth = src
		Pinpointer_ToAdd.pixel_x = i
		Pinpointer_ToAdd.pixel_y = i
		Pinpointer_ToAdd.target = src
		Pinpointer_List.Add(Pinpointer_ToAdd)
	return

/obj/structure/timetravel/phonebooth/attack_hand(mob/user as mob)
	if(LOCKED)
		return 0
	//THERE MUST BE A CHECKER TO AVOID ANIMALS AND MONSTERS FROM USING THE PHONEBOOTH
	var/locationx = 248
	var/locationy = 121
	var/locationz = 2
	var/dest = locate(locationx, locationy, locationz)
	user.Move(dest)

/obj/effect/step_trigger/teleport_fancy/phonebooth
	var/locationz
	invisibility = 101
	var/obj/structure/timetravel/phonebooth/master_booth

/obj/effect/step_trigger/teleport_fancy/phonebooth/New()

/obj/effect/step_trigger/teleport_fancy/phonebooth/Trigger(mob/M as mob)
	var/locx = master_booth.x
	var/locy = master_booth.y - 1
	var/locz = master_booth.z
	var/dest = locate(locx, locy, locz)
	M.Move(dest)
	return 1


/obj/item/weapon/phonebooth_remote //Very important item, there's only one of these too
	name = "Phonebooth controller"
	icon = 'icons/obj/timetravel.dmi'
	icon_state = "controller"
	w_class = 2
	var/obj/structure/timetravel/phonebooth/master_booth

/obj/item/weapon/phonebooth_remote/attack_self()
	var/list/possible_sprites = list("Default", "Tree", "Bush", "Flower", "Rock")
	var/selection
	selection = input("Select the disguise for the phonebooth","Default is the Phonebooth sprite itself",selection) in possible_sprites
	ChangePhoneBoothSprite(selection)

/obj/item/weapon/phonebooth_remote/proc/ChangePhoneBoothSprite(var/selection)
	if(selection == "Default")
		master_booth.icon = 'icons/obj/phonebooth.dmi'
		master_booth.icon_state = "phonebooth"
		master_booth.name = "Time Travelling Phone Booth"
		master_booth.desc = "A restored version of a device capable of performing time travel discovered by a now ancient doctor, nobody knows what happened to him"
		master_booth.update_icon()
	else if(selection == "Tree")
		master_booth.name = "pine tree"
		master_booth.desc = "It's a pine tree"
		master_booth.icon = 'icons/obj/flora/pinetrees.dmi'
		master_booth.icon_state = "pine_1"
		master_booth.update_icon()
	else if(selection == "Flower")
		master_booth.icon = 'icons/obj/flora/ausflora.dmi'
		master_booth.icon_state = "brflowers_3"
		master_booth.name = "some flowers"
		master_booth.desc = "Smells like silicon"
		master_booth.update_icon()
	else if(selection == "Rock")
		master_booth.icon = 'icons/obj/flora/rocks.dmi'
		master_booth.icon_state = "rock1"
		master_booth.name = "rocks"
		master_booth.desc = "some rocks"
		master_booth.update_icon()
	else if(selection == "Bush")
		master_booth.icon = 'icons/obj/flora/ausflora.dmi'
		master_booth.icon_state = "genericbush_2"
		master_booth.name = "bush"
		master_booth.desc = "Smells like silicon"
		master_booth.update_icon()
	else
		master_booth.icon = 'icons/obj/phonebooth.dmi'
		master_booth.icon_state = "phonebooth"
		master_booth.name = "Time Travelling Phone Booth"
		master_booth.desc = "A restored version of a device capable of performing time travel discovered by a now ancient doctor, nobody knows what happened to him"
		master_booth.update_icon()

	return 1
/obj/item/weapon/pinpointer/phonebooth //We keep the "the_disk" variable the same way so we don't need to change code
	name = "pinpointer"
	icon = 'icons/obj/device.dmi'
	icon_state = "pinoff"
	flags = CONDUCT
	slot_flags = SLOT_PDA | SLOT_BELT
	w_class = 2
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	materials = list(MAT_METAL=500)
	var/obj/structure/timetravel/phonebooth/master_booth = null
	var/turf/location = null
	var/obj/target = null

/obj/item/weapon/pinpointer/phonebooth/New() //We keep the "the_disk" variable the same way so we don't need to change code
	..()
	target = master_booth

/obj/item/weapon/pinpointer/phonebooth/attack_self()
	if(!active)
		active = 1
		point_at(target)
		to_chat(usr, "<span class='notice'>You activate the pinpointer.</span>")
	else
		active = 0
		icon_state = "pinoff"
		to_chat(usr, "<span class='notice'>You deactivate the pinpointer.</span>")

/obj/item/weapon/pinpointer/phonebooth/workdisk()
	return

/obj/effect/overlay/phonebooth_lock
	icon = 'icons/obj/phonebooth.dmi'
	icon_state = "phonebooth_overlay_locked"

