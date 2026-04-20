hs.console.clearConsole()

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("ReloadConfiguration", {start = true})

hs.loadSpoon("LocalFocusFollow")
spoon.LocalFocusFollow:start()

hs.loadSpoon("LocalKeyCastr")
spoon.LocalKeyCastr:show()

local hyperMods = {"cmd", "alt", "ctrl", "shift"}

local function hyperDown()
    for _, m in ipairs(hyperMods) do
        hs.eventtap.event.newKeyEvent(m, true):post()
    end
end

local function hyperUp()
    for _, m in ipairs(hyperMods) do
        hs.eventtap.event.newKeyEvent(m, false):post()
    end
end

local lastDown = nil
local lastUp = nil
local hyperStatus = false
local escape = false

keyDownWatcher = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
	local keyCode = event:getKeyCode()

	if keyCode == 0 and hyperStatus == true then
	    hs.execute("/opt/homebrew/bin/alacritty msg create-window", nil)
	    return true
	end
	if keyCode == 53 and escape == false then
		if lastDown ~= nil then
			return true
		end
		
		lastDown = hs.timer.secondsSinceEpoch()
		
		if lastUp ~= nil and lastDown - lastUp < 0.1 then
			lastUp = nil
			lastDown = nil
			hs.hid.capslock.toggle()
			return true
		end

		hs.timer.doAfter(0.2, function() 
			if lastUp ~=nil and lastDown == nil then 
				lastUp = nil
				escape = true
				hs.eventtap.keyStroke({}, "escape")
				return 
			end
			lastUp = nil
			if lastDown ~= nil then
			hyperDown()
			hyperStatus = true
		end
		end)

		return true
	end

	escape = false
	return false
end)
keyDownWatcher:start()

keyUpWatcher = hs.eventtap.new({hs.eventtap.event.types.keyUp}, function(event)
	local keyCode = event:getKeyCode()

	if keyCode == 53 then
		lastDown = nil
		lastUp = hs.timer.secondsSinceEpoch()
		if hyperStatus then
			hyperUp()
			hyperStatus = false
		end
		return true
	end

	return false
end)
keyUpWatcher:start()

