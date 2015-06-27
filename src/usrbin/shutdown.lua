term.clear()
term.setCursorPos(1,1)
if term.isColor() then
term.setTextColor(colours.yellow)
print"Goodbye"
sleep(3)
os.shutdown()
else
print"Goodbye"
sleep(3)
os.shutdown()
end