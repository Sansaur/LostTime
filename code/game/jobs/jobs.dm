
var/const/ENGSEC			=(1<<0)

var/const/CAPTAIN			=(1<<0)
var/const/HOS				=(1<<1)
var/const/WARDEN			=(1<<2)
var/const/DETECTIVE			=(1<<3)
var/const/OFFICER			=(1<<4)
var/const/CHIEF				=(1<<5)
var/const/ENGINEER			=(1<<6)
var/const/ATMOSTECH			=(1<<7)
var/const/AI				=(1<<8)
var/const/CYBORG			=(1<<9)
var/const/CENTCOM			=(1<<10)

var/const/MEDSCI			=(1<<1)

var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/CMO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/GENETICIST		=(1<<5)
var/const/VIROLOGIST		=(1<<6)
var/const/PSYCHIATRIST		=(1<<7)
var/const/ROBOTICIST		=(1<<8)
var/const/PARAMEDIC			=(1<<9)


var/const/SUPPORT			=(1<<2)

var/const/HOP				=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/CHEF				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/LIBRARIAN			=(1<<5)
var/const/QUARTERMASTER		=(1<<6)
var/const/CARGOTECH			=(1<<7)
var/const/MINER				=(1<<8)
var/const/LAWYER			=(1<<9)
var/const/CHAPLAIN			=(1<<10)
var/const/CLOWN				=(1<<11)
var/const/MIME				=(1<<12)
var/const/CIVILIAN			=(1<<13)


var/const/KARMA				=(1<<3)

var/const/NANO				=(1<<0)
var/const/BLUESHIELD		=(1<<1)
var/const/BARBER			=(1<<3)
var/const/MECHANIC			=(1<<4)
var/const/BRIGDOC			=(1<<5)
var/const/JUDGE				=(1<<6)
var/const/PILOT				=(1<<7)

var/list/assistant_occupations = list(
)

//THIS MUST BE CHANGED IN A LATER TIME - SANSAUR

var/list/omegacorp_positions = list(
	"Operation Leader",
	"Operation Support",
	"Operation Medic",
	"Operation Enforcer"
)
var/list/villagers_positions = list(
	"Mayor",
	"Villager",
	"Blacksmith",
	"Shopkeeper",
	"Mechanic"
)

var/list/guards_positions = list(
	"Captain Guard",
	"Footman",
	"Monster Hunter"
)
var/list/nobility_positions = list(
	"King",
	"Heir",
	"Noble"
)
var/list/religious_positions = list(
	"Bishop",
	"Priest"
)
var/list/wizards_positions = list(
	"Arch Mage",
	"Mage"
)

//THIS MUST BE CHANGED IN A LATER TIME - SANSAUR


//BS12 EDIT
var/list/support_positions = list()
var/list/civilian_positions = list()
var/list/service_positions = support_positions - nobility_positions + list("Head of Personnel")



var/list/nonhuman_positions = list(
	//"AI",
	//"Cyborg",
	//"Drone",
	//"pAI"
)

var/list/whitelisted_positions = list(
	//"Blueshield",
	//"Nanotrasen Representative",
	//"Barber",
	//"Mechanic",
	//"Brig Physician",
	//"Magistrate",
	//"Security Pod Pilot",
)


/proc/guest_jobbans(var/job)
	return (job in whitelisted_positions)

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(!J)	continue
		if(J.title == job)
			titles = J.alt_titles

	return titles

