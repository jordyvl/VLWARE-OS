if fs.exists("/.vlware/init") then
shell.run("/.vlware/init")
else
print("Can't find the init file please reinstall VLWARE-OS")
end