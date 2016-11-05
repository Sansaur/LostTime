/obj/structure/artifact_holder
	name = "Artifact holder"
	desc = "This piece of machinery mantains ancient and dangerous artifacts contained"
	icon = 'icons/obj/omegacorp_objs.dmi'
	icon_state = "artifact_h"
	anchored = 1
	density = 1
	opacity = 0
	var/obj/item/holding_item
	var/password
	var/lockdown

/obj/structure/artifact_holder/attack_hand(mob/user as mob)
	if(lockdown)
		return
	if(holding_item)
		if(password)
			if(!Enter_Password(user))
				to_chat(user, "The password was incorrect, sending the holder into lockdown, swipe an ID to unlock it.")
				Lock_This()
				return
			else
				Give_Artifact(user)
				return
		else
			Give_Artifact(user)
			return

/obj/structure/artifact_holder/attackby(obj/item/W, mob/user as mob)
	if(lockdown)
		if(istype(W, /obj/item/weapon/card/id))
			visible_message("[user] unlocked the [src] using the [W]")
			Unlock_This()
			return
	if(!password)
		if(istype(W, /obj/item/weapon/card/id))
			Set_Password(user)
			return
	else
		if(istype(W, /obj/item/weapon/card/id))
			to_chat(user, "The password for this machine is: <B>[password]</B>")
			return

	if(holding_item)
		to_chat(user, "The [src] already has an item inside of it!")
	else
		Insert_Artifact(W, user)

/obj/structure/artifact_holder/proc/Enter_Password(mob/user as mob)
	var/entered_password
	entered_password = input(user, "Enter the password for this [src]", "Password Screen", 0) as num
	if(password == entered_password)
		return 1
	else
		return 0
/obj/structure/artifact_holder/proc/Set_Password(mob/user as mob)
	var/entered_password
	entered_password = input(user, "Enter new password for this machine", "Password Screen", 0) as num
	password = entered_password

obj/structure/artifact_holder/proc/Give_Artifact(mob/user as mob)
	holding_item.loc = user.loc
	user.put_in_hands(holding_item)
	holding_item = null
	icon_state = "artifact_h"
	update_icon()

obj/structure/artifact_holder/proc/Insert_Artifact(obj/item/W, mob/user as mob)

	user.drop_item()
	W.loc = src
	holding_item = W
	icon_state = "artifact_h-holding"
	update_icon()

obj/structure/artifact_holder/proc/Lock_This()
	lockdown = 1
	flick("artifact_h-locking",src)
	sleep(4)
	icon_state = "artifact_h-lockdown"
	update_icon()

obj/structure/artifact_holder/proc/Unlock_This()
	lockdown = 0
	flick("artifact_h-opening",src)
	sleep(4)
	if(holding_item)
		icon_state = "artifact_h-holding"
	else
		icon_state = "artifact_h"
	update_icon()

/obj/structure/artifact_holder/random_item
	//This artifact holder begins the round with a random item inside of it
	var/list/possible_items = list(/obj/item/weapon/cane)

/obj/structure/artifact_holder/random_item/New()
	password = rand(999,9999)
	var/New_Item = pick(possible_items)
	New_Item = new New_Item(src) //Si no funciona, poner "src.loc" aqui.
	holding_item = New_Item
	icon_state = "artifact_h-holding"

	//ESTO NO FUCNIONA ARREGLAR.