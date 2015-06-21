if fs.exists("/.vlware/init") then
shell.run("/.vlware/init")
else
term.clear()
term.setCursorPos(1,1)
print("Can't find the init file please reinstall VLWARE-OS")'
sleep(3)
term.clear()
term.setCursorPos(1,1)
print"Starting auto recovery!"
print"Terminate to exit"
sleep(5)
shell.run"/.vlware/update"
end