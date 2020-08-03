-- title: Alfred TIDAL Search Workflow
-- description: Enables TIDAL app search for Alfred
-- author: Gregory D. Hardy

set searchTerm to (system attribute "searchTerm")
set dt to (system attribute "dt")

set delayTime to 0 
set originalClip to the clipboard -- store clipboard content
set cycles to 0 


tell application "System Events"
    
    if name of processes contains "TIDAL" -- check if Tidal is open
        
        tell application "TIDAL" to activate -- switch to application
    else
        
        tell application "TIDAL" to activate -- open app
        
        set delayTime to dt -- specify how long to wait for Tidal app to open
    end if

    tell process "TIDAL"
        delay delayTime -- wait for app to open before performing search
        set delayTime to 0

        repeat
            -- enter search text in search field
            click (menu item "Search" of menu "Navigation" of menu bar 1)
            click (menu item "Select All" of menu "Edit" of menu bar 1)                     
            keystroke searchTerm

            -- copy search field content       
            click (menu item "Select All" of menu "Edit" of menu bar 1) 
            click (menu item "Copy" of menu "Edit" of menu bar 1)
            
            if searchTerm equals the clipboard then -- check copied content to verify it matches the search query
                
                key code 36 -- (enter key) execute the search
                exit repeat

            -- protect against infinite loop
            else if cycles equal 25 then 
                exit repeat
            else
                set cycles to cycles + 1
            end if
        end repeat
    end tell

    delay 0.1 -- delay to make sure clipboard content has time to restore
    set the clipboard to originalClip -- restore original clipboard content
end tell