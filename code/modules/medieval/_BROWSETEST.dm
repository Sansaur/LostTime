/**
* THIS HAS FUCKING WORKED
* GODDAMNIT WHY ARE POPUPS SO HARD
**/


/obj/item/woodworks/THISISTEST
	icon_state = "2x4"
	name = "TEST"
	desc = "TEST"
	var/PRESSED = 0

/obj/item/woodworks/THISISTEST/attack_self(mob/user as mob)
	var/mob/living/ha = user
	to_chat(ha, "NOW WE'RE EVEN TESTING MORE, THIS HAS BEEN ALTERED IN SUBLIME TEXT")
	var/datum/status_effect/random_slowdown/NewSlodwon = new()
	ha.addStatusEffect(NewSlodwon)

	user.set_machine(src)
	var/dat

	dat += text("This machine only accepts ore. Gibtonite and Slag are not accepted.<br><br>")
	dat += text("Current unclaimed points: asdad <br>")
	dat += text("<A href='?src=[UID()];choice=claim'>Claim points.</A><br>")

	if(PRESSED)
		dat += "PRESS ONE"
	else
		dat += "PRESS NULL"

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
			PRESSED = !PRESSED
	
	updateUsrDialog()
	updateDialog()
	return