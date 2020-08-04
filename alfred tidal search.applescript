-- title: Alfred TIDAL Search Workflow
-- description: Enables TIDAL app search for Alfred
-- author: Gregory D. Hardy

set searchTerm to (system attribute "searchTerm") -- search term provided to workflow by user
set dt to (system attribute "dt") -- specifies how long to wait for Tidal app to open

set delayTime to 0
set originalClip to the clipboard -- store clipboard content
set the clipboard to searchTerm
set cycles to 0


tell application "System Events"
	
	if name of processes contains "TIDAL" then -- check if Tidal is open
		tell application "TIDAL" to activate -- switch to application
	else
		tell application "TIDAL" to activate -- open app
		set delayTime to dt 
	end if
	
	delay delayTime -- wait for app to open before performing search
	
	tell process "TIDAL"
		repeat while cycles <=10
			try
                tell application "TIDAL" to activate
				if enabled of menu item "Select All" of menu "Edit" of menu bar 1 and enabled of menu item "Search" of menu "Navigation" of menu bar 1 and enabled of menu item "Copy" of menu "Edit" of menu bar 1 and enabled of menu item "Paste" of menu "Edit" of menu bar 1 then
                    
					tell application "TIDAL" to activate -- force focus on TIDAL app to ensure actions don't fail or affect other apps if user clicks away before script finishes
                    click (menu item "Search" of menu "Navigation" of menu bar 1)
					tell application "TIDAL" to activate
                    click (menu item "Select All" of menu "Edit" of menu bar 1)
					tell application "TIDAL" to activate
                    click (menu item "Paste" of menu "Edit" of menu bar 1)
					
					-- copy search field content       
					tell application "TIDAL" to activate
                    click (menu item "Select All" of menu "Edit" of menu bar 1)
					tell application "TIDAL" to activate
                    click (menu item "Copy" of menu "Edit" of menu bar 1)
					
					if searchTerm is equal to (the clipboard) then -- check copied content to verify it matches the search query
						tell application "TIDAL" to activate
						key code 36 -- (enter key) execute the search
						exit repeat
						
					end if
				end if
			on error
				-- do nothing
			end try
			
			-- protect against infinite loop
			set cycles to cycles + 1			
		end repeat
	end tell
	
	delay 0.1 -- delay to make sure clipboard content has time to restore
	set the clipboard to originalClip -- restore original clipboard content
end tell