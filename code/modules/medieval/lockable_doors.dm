/obj/structure/mineral_door/lockable
	name = "mineral door"
	desc = "this one has a lock in it"
	density = 1
	anchored = 1
	opacity = 1
	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "metal"
	var/ID_TAG
	mineralType = "metal"
	//var/state = 0 //closed, 1 == open
	//var/isSwitchingStates = 0
	//var/hardness = 1
	//var/oreAmount = 7

	var/locked
/obj/structure/mineral_door/lockable/New()
	..()
	update_icon()

/obj/structure/mineral_door/lockable/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/locking_key))
		var/obj/item/weapon/locking_key/KEY = W
		if(ID_TAG == KEY.stored_tag)
			if(state) //If the door is open this does nothing - Sansaur
				return
			else
				locked = !locked
				update_icon()
				return
		else
			to_chat(user, "<span class=info> The [W] doesn't fit into the lock </span>")

/obj/structure/mineral_door/lockable/update_icon()
	..()
	var/obj/effect/overlay/lock/LOCK
	if(locked)
		overlays.Add(LOCK)
		overlays += /obj/effect/overlay/lock
	else
		overlays.Remove(LOCK)
		overlays -= /obj/effect/overlay/lock

/obj/structure/mineral_door/lockable/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(locked)
		to_chat(user, "The door is locked")
		return
	if(ismob(user))
		var/mob/M = user
		if(world.time - user.last_bumped <= 60) return //NOTE do we really need that?
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /obj/mecha))
		SwitchState()

/obj/effect/overlay/lock
	name = "lock"
	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "lock"

/obj/item/weapon/locking_key
	name = "key"
	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "key"
	w_class = 1
	var/stored_tag

/obj/item/weapon/lock //The idea is that a lock is created with the same stored_tag as a key using a mold!
	name = "lock"
	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "lock"
	w_class = 1
	var/stored_tag

/obj/structure/mineral_door/proc/Add_Lock(obj/item/weapon/W as obj, mob/user as mob)
	var/obj/structure/mineral_door/lockable/NEWLOCK = new(src.loc)
	var/obj/item/weapon/lock/LOCK = W
	NEWLOCK.icon_state = src.icon_state
	NEWLOCK.hardness = src.hardness
	NEWLOCK.mineralType = src.mineralType
	NEWLOCK.name = src.name
	NEWLOCK.tag = LOCK.stored_tag
	qdel(W)
	qdel(src)

/****
	PREMADE LOCKED DOORS AND KEYS!!!

****/

/obj/structure/mineral_door/lockable/pre_locked/king_bed
	ID_TAG = "KINGBED"
	locked = 1
	icon_state = "gold"
	mineralType = "gold"

/obj/item/weapon/locking_key/king_bed
	stored_tag = "KINGBED"
	icon_state = "king_key"

/obj/structure/mineral_door/lockable/pre_locked/castle_treasury
	ID_TAG = "CASTLETREASURE"
	locked = 1
	icon_state = "gold"
	mineralType = "gold"

/obj/item/weapon/locking_key/castle_treasury
	stored_tag = "CASTLETREASURE"
	icon_state = "king_key"

/obj/structure/mineral_door/lockable/pre_locked/heir_bed
	ID_TAG = "HEIRBED"
	locked = 1
	icon_state = "gold"
	mineralType = "gold"

/obj/item/weapon/locking_key/heir_bed
	stored_tag = "HEIRBED"
	icon_state = "heir_key"

/obj/structure/mineral_door/lockable/pre_locked/armory //Armory starts closed with the key inside of it and also inside the captain's pocket
	ID_TAG = "ARMORY"
	locked = 1
	icon_state = "metal"
	mineralType = "metal"

/obj/item/weapon/locking_key/armory
	stored_tag = "ARMORY"
	icon_state = "armory_key"

/obj/structure/mineral_door/lockable/pre_locked/general_store
	ID_TAG = "GENERALSTORE"
	locked = 1
	icon_state = "wood"
	mineralType = "wood"

/obj/item/weapon/locking_key/general_store
	name = "General Store Key"
	stored_tag = "GENERALSTORE"
	icon_state = "store_key"

/obj/structure/mineral_door/lockable/pre_locked/farm_house
	ID_TAG = "FARMHOUSE"
	locked = 1
	icon_state = "wood"
	mineralType = "wood"

/obj/item/weapon/locking_key/farm_house
	name = "Farm house Key"
	stored_tag = "FARMHOUSE"
	icon_state = "store_key"


// INN ROOMS!!

/obj/structure/mineral_door/lockable/pre_locked/inn
	ID_TAG = "INN"
	locked = 1
	icon_state = "wood"
	mineralType = "wood"

/obj/item/weapon/locking_key/inn
	name = "Inn key"
	desc = "Don't lose it!"
	stored_tag = "INN"
	icon_state = "store_key"

/obj/structure/mineral_door/lockable/pre_locked/inn/room1
	ID_TAG = "INN1"
	locked = 1
	icon_state = "wood"
	mineralType = "wood"
/obj/item/weapon/locking_key/inn/room1
	name = "First room key"
	stored_tag = "INN1"

/obj/structure/mineral_door/lockable/pre_locked/inn/room2
	ID_TAG = "INN2"
	locked = 1
	icon_state = "wood"
	mineralType = "wood"
/obj/item/weapon/locking_key/inn/room2
	name = "Second room key"
	stored_tag = "INN2"

/obj/structure/mineral_door/lockable/pre_locked/inn/room3
	ID_TAG = "INN3"
	locked = 1
	icon_state = "wood"
	mineralType = "wood"
/obj/item/weapon/locking_key/inn/room3
	name = "Third room key"
	stored_tag = "INN3"

/obj/structure/mineral_door/lockable/pre_locked/inn/room4
	ID_TAG = "INN4"
	locked = 1
	icon_state = "wood"
	mineralType = "wood"
/obj/item/weapon/locking_key/inn/room4
	name = "Fourth room key"
	stored_tag = "INN4"

/obj/structure/mineral_door/lockable/pre_locked/inn/room5
	ID_TAG = "INN5"
	locked = 1
	icon_state = "wood"
	mineralType = "wood"

/obj/item/weapon/locking_key/inn/room5
	name = "Fifth room key"
	stored_tag = "INN5"

// INN ROOMS!!


/**
*
* Lockable cabinets
*
**/

/obj/structure/closet/cabinet/medieval
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon = 'icons/medieval/structures.dmi'
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"
	var/icon_locked = "cabinet_locked"
	var/ID_TAG
	burn_state = FLAMMABLE
	burntime = 20
	locked = 0

/obj/structure/closet/cabinet/medieval/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

	if(locked)
		icon_state = icon_locked

/obj/structure/closet/cabinet/medieval/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/lock))
		var/obj/item/weapon/lock/LOCK = W
		src.ID_TAG = LOCK.stored_tag
		src.locked = 1
		visible_message("[user] locks the [src] with the [LOCK]")
		qdel(LOCK)
		update_icon()
		return

	if(istype(W, /obj/item/weapon/locking_key))
		var/obj/item/weapon/locking_key/KEY = W
		if(locked)
			if(KEY.stored_tag == src.ID_TAG)
				locked = 0
				visible_message("[user] unlocks the [src]")
				update_icon()
				return
		else
			if(KEY.stored_tag == src.ID_TAG)
				locked = 1
				visible_message("[user] locks the [src]")
				update_icon()
				return
		return
	else
		..()