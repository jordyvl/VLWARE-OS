local tArgs = {...}
if #tArgs < 1 then
	print("Usage: cd <path>")
	return
end

local dir = tArgs[1]
if dir:sub(1, 1) == "~" then
	dir = "/"..(currentUser == "root" and systemDirs.root or fs.combine(systemDirs.users, currentUser))..dir:sub(2)
end
local newDir = shell.resolve(dir)
if fs.isDir(newDir) then
	shell.setDir(newDir)
else
  	print("Not a directory")
  	return
end