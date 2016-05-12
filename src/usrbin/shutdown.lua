term.clear()
term.setCursorPos(1,1)
if term.isColor() then
term.setTextColor(colours.yellow)
print"See you next time!"
sleep(3)
os.shutdown()
else
print"See you next time!"
sleep(3)
os.shutdown()
end