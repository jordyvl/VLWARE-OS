term.clear()
term.setCursorPos(1,1)
if not fs.exists(".vlware/apis/ui") then
	if not fs.exists(".vlware/apis") then
		if not fs.exists(".vlware") then
			fs.makeDir(".vlware")
		end
		fs.makeDir(".vlware/apis")
	end
	if not http then
		printError("HTTP not enabled.")
		return
	end
	local remote = http.get("https://raw.github.com/jordyvl/VLWARE-OS/master/src/apis/ui.lua")
	if not remote then
		printError("Error getting required API. Please try again later.")
		return
	end
	local file = fs.open(".vlware/apis/ui", "w")
	file.write(remote.readAll())
	file.close()
	remote.close()
end
print"Connected Printers:"
for _, v in pairs(peripheral.getNames()) do
  if peripheral.getType(v) == "printer" then
    print(v)
  end
end
local tArgs = {...}
if #tArgs < 1 or (tArgs[1] == "-1" and #tArgs < 2) then
	print("Usage: "..shell.getRunningProgram().." [-1] <file> [file ...]")
	print("Use -1 to print all files on 1 printer.")
	return
end
local onePrinter = false
if tArgs[1] == "-1" then
	table.remove(tArgs, 1)
	onePrinter = true
end
if not ui then
	os.loadAPI(".vlware/apis/ui")
end
local printers = {}
for _, v in pairs(peripheral.getNames()) do
	if peripheral.getType(v) == "printer" then
		table.insert(printers, v)
	end
end
table.sort(printers)
local printedFiles = 0
local printed = {}
local selectedPrinter
if onePrinter then
	selectedPrinter = ui.menu(printers, "Select Printer")
	if not selectedPrinter then
		print("Aborting.")
		return
	end
	print("Printer: "..selectedPrinter)
end
for i = 1, #tArgs do
	if not onePrinter then
		selectedPrinter = ui.menu(printers, "Select Printer")
	end
	if not selectedPrinter then
		print("Aborting.")
	else
		if not onePrinter then
			print("Printer: "..selectedPrinter)
		end
		print(" >> "..tArgs[i])
		if not fs.exists(tArgs[i]) then
			printError(tArgs[i]..": file not found")
			sleep(1.5)
		else
			local printer = peripheral.wrap(selectedPrinter)
			local nPage = 0
			if printer.getInkLevel() < 1 then
				printError(selectedPrinter.."Printer out of ink")
				sleep(2)
			elseif printer.getPaperLevel() < 1 then
				printError(selectedPrinter..": out of paper")
				sleep(2)
			end
			local screenTerminal = term.current()
			local printerTerminal = {
				getCursorPos = printer.getCursorPos,
				setCursorPos = printer.setCursorPos,
				getSize = printer.getPageSize,
				write = printer.write,
			}
			printerTerminal.scroll = function()
				if nPage == 1 then
					printer.setPageTitle( sName.." (page "..nPage..")" )			
				end
				
				while not printer.newPage()	do
					term.redirect( screenTerminal )
					if printer.getInkLevel() < 1 then
						printError(selectedPrinter..": out of ink, please refill")
					elseif printer.getPaperLevel() < 1 then
						printError(selectedPrinter..": out of paper, please refill")
					else
						printError(selectedPrinter..": output tray full, please empty")
					end
					term.redirect( printerTerminal )
					local timer = os.startTimer(0.5)
					sleep(0.5)
				end
				nPage = nPage + 1
				if nPage == 1 then
					printer.setPageTitle( tArgs[i] )
				else
					printer.setPageTitle( tArgs[i].." (page "..nPage..")" )
				end
			end
			term.redirect( printerTerminal )
			local ok, error = pcall( function()
				term.scroll()
				local file = fs.open(tArgs[i], "r")
				print(file.readAll())
				file.close()
			end )
        	term.redirect( screenTerminal )
			if not ok then
				printError( error )
			end
			while not printer.endPage() do
				printError(selectedPrinter..": output tray full, please empty")
				sleep( 0.5 )
			end
		end
	end
end
