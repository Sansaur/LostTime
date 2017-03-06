/**
* THIS HAS FUCKING WORKED
* GODDAMNIT WHY ARE POPUPS SO HARD
**/


/obj/item/woodworks/THISISTEST
	icon_state = "2x4"
	name = "TEST"
	desc = "TEST"

/obj/item/woodworks/THISISTEST/attack_self(mob/user as mob)
	user.set_machine(src)
	var/dat

	dat += text("This machine only accepts ore. Gibtonite and Slag are not accepted.<br><br>")
	dat += text("Current unclaimed points: asdad <br>")
	dat += text("<A href='?src=[UID()];choice=claim'>Claim points.</A><br>")

	var/datum/browser/popup = new(user, "console_stacking_machine", "Ore Redemption Machine", 400, 500)
	popup.set_content(dat)
	popup.open()
	return

/obj/item/woodworks/THISISTEST/Topic(href, href_list)
	if(..())
		return
	if(href_list["choice"])
		if(href_list["choice"] == "claim")
			visible_message("ASDADASDASDASSS")

	updateUsrDialog()
	return