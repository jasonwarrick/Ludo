extends Node

#Saving and loading code taken from youtube.com/watch?v=9nT_EiDXjJY&t=600s

var coins: int = 0
var g1: int = 0
var g1C: int = 0
var g2: int = 0
var g2C: int = 0
var g3: int = 0
var g3C: int = 0

#Dictionary
var saveData = {
	"coinCount" : 0 ,
	"g1HighScore" : 0,
	"g1ChallengeHighScore" : 0,
	"g2HighScore" : 0,
	"g2ChallengeHighScore" : 0,
	"g3HighScore" : 0,
	"g3ChallengeHighScore" : 0
}

#Path string
var saveGameFileName: String = "user://playerData.txt"

func _ready() -> void:
	print("Original Data: ", saveData)
	self.loadData()
	print("Altered Data: ", saveData)

func editData() -> void:
	saveData.coinCount += coins
	coins = 0
	saveData.g1HighScore = g1
	saveData.g1ChallengeHighScore = g1C
	saveData.g2HighScore = g2
	saveData.g2ChallengeHighScore = g2C
	saveData.g3HighScore = g3
	saveData.g3ChallengeHighScore = g3C

func saveData() -> void:
	self.editData()
	
	var saveFile = File.new()
	saveFile.open(saveGameFileName, File.WRITE)
	
	saveFile.store_line(to_json(saveData))
	saveFile.close()

func loadData() -> void:
	var dataFile: File = File.new()
	
	#make sure our file exists on users system
	if not dataFile.file_exists(saveGameFileName):
		return
	
	#allow reading only for file
	dataFile.open(saveGameFileName, File.READ)
	
	while dataFile.get_position() < dataFile.get_len():
		var nodeData = parse_json(dataFile.get_line())
		
		#grab save data
		saveData.coinCount = nodeData["coinCount"]
		saveData.g1HighScore = nodeData["g1HighScore"]
		saveData.g1ChallengeHighScore = nodeData["g1ChallengeHighScore"]
		saveData.g2HighScore = nodeData["g2HighScore"]
		saveData.g2ChallengeHighScore = nodeData["g2ChallengeHighScore"]
		saveData.g3HighScore = nodeData["g3HighScore"]
		saveData.g3ChallengeHighScore = nodeData["g3ChallengeHighScore"]
	
	dataFile.close()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		self.saveData()
		get_tree().quit()
	
