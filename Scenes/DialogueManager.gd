extends Node

export(String, DIR) var dialogueFolder

signal line_change

var directory = Directory.new()
var data:Array
var activeNode
var activeNodeLines:Array #all lines
var activeLineIndex = 0
var activeLine:DialogueLine

func _ready():
	directory.open(dialogueFolder)
	loadDialogue("prologue")
	setActiveNode("FabiStart")
	nextLine()

func loadDialogue(fileName: String):
	fileName+=".json"
	if(!directory.file_exists(fileName)):
		print('file nonexistent')
		return
		
	var file = File.new()
	file.open(dialogueFolder+"/"+fileName, File.READ)
	var text = file.get_as_text()
	file.close()
	var dialogueFile = JSON.parse(text)
	data = dialogueFile.result
	
func start(nodeName):
	pass
	

func setActiveNode(nodeName):
	activeNode = getNode(nodeName)
	activeNodeLines = activeNode["body"].split("\n")
	activeLineIndex = -1

func nextLine():
	activeLineIndex+=1
	var lineString = activeNodeLines[activeLineIndex]
	activeLine = DialogueLine.new(lineString)
	while(activeLine.content == ""):
		var previousLine = activeLine
		activeLineIndex+=1
		lineString = activeNodeLines[activeLineIndex]
		activeLine = DialogueLine.new(lineString)
		activeLine.commands+=previousLine.commands
	emit_signal("line_change")
	return activeLine


func getNode(nodeName):
	for node in data:
		if (node["title"] == nodeName):
			return node
	return null








