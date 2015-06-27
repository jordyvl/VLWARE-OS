term.clear()
term.setCursorPos(1,1)
if term.isColor() then
term.setTextColor(colours.yellow)
print"See you soon!"
sleep(3)
os.reboot()
else
print"See you soon!"
sleep(3)
os.reboot()
end