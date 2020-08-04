extends Reference
class_name DialogueLine

var character:String
var content:String
var commands:Array

func _init(line:String):
	var colonPos = line.find(":")
	if(colonPos >= 0):
		character = line.substr(0, colonPos)
	else:
		character = ""
	content = line.substr(colonPos+1)
	
	var commandStart = content.find("<<")
	while commandStart >= 0:
		var commandEnd = content.find(">>", commandStart)
		if(commandEnd < 0):
			break
		var commandCore = content.substr(commandStart+2, commandEnd-commandStart-2).strip_edges().split(" ", false) #array mit command and argument
		if (commandCore.size() == 0):
			commandStart = content.find("<<", commandStart+2)
			continue
		#above just checkin if real command
		var command = DialogueCommand.new()
		command.type = commandCore[0]
		command.arguments = Array(commandCore).slice(1, commandCore.size())
		commands.push_front(command) 
		content = content.substr(0, commandStart)+content.substr(commandEnd+2)
		commandStart = content.find("<<", commandStart)
		
	content = content.strip_edges()
	
