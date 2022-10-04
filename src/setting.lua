--[[Hotkey Setting]]
function AccessSetting(Key)
    return textToShortCut(Key)
end

function ViewSetting(Key)
    return shortCutToText(Key)
end

function CreateSettingTab()
    f = createForm()
    f.FormStyle = 'fsSystemStayOnTop'
    f.caption = 'Setting'

    lb1 = createLabel(f)
    lb1.left = 10
    lb1.top = 10
    lb1.Caption = 'Teleport Object'

    lb2 = createLabel(f)
    lb2.left = 10
    lb2.top = 30
    lb2.Caption = 'Teleport Waypoint'

    lb3 = createLabel(f)
    lb3.left = 10
    lb3.top = 50
    lb3.Caption = 'Player Wanted Level 0'

    lb4 = createLabel(f)
    lb4.left = 10
    lb4.top = 70
    lb4.Caption = 'Set Heist Cut 85%'

    e1 = createEdit(f)
    e1.left = 120
    e1.top = 10
    e1.width = 60
    e1.Text = 'Del'

    e2 = createEdit(f)
    e2.left = 120
    e2.top = 30
    e2.width = 60
    e2.Text = 'End'

    e3 = createEdit(f)
    e3.left = 120
    e3.top = 50
    e3.width = 60
    e3.Text = 'PgDn'

    e4 = createEdit(f)
    e4.left = 120
    e4.top = 70
    e4.width = 60
    e4.Text = 'NumMul'

    b1 = createButton(f)
    b1.left = 10
    b1.height = 30
    b1.top = 170
    b1.width = 60
    b1.Caption = 'Save'

    b2 = createButton(f)
    b2.left = b1.left + b1.width + 10
    b2.height = 30
    b2.top = 170
    b2.width = 60
    b2.Caption = 'Load'

    b3 = createButton(f)
    b3.left = b2.left + b2.width + 10
    b3.height = 30
    b3.top = 170
    b3.width = 60
    b3.Caption = 'Close'

    b1.onClick = SaveVars
    b2.onClick = LoadVars
    b3.onClick = exitTrainer
    f.hide()
end
CreateSettingTab()


hotkey3=createHotkey(function() set.global(int,2409291+8,1) end, VK_LCONTROL,VK_F)
hotkey4=createHotkey(function() 
    set.int(CASINO_CUT_1,85) 
    set.int(CASINO_CUT_2,85) 
    set.int(CASINO_CUT_3,85) 
    set.int(CASINO_CUT_4,85)
    set.int(CPERICO_1,85) 
    set.int(CPERICO_2,85) 
    set.int(CPERICO_3,85) 
    set.int(CPERICO_4,85)
end, AccessSetting(e4.Text))

hotkey5 = createHotkey(function() PLAYER.SET_PLAYER_WANTED_LEVEL(0) end, AccessSetting(e3.Text))
hotkey6 = createHotkey(function() Player.AutoClick.Checked = false AutoMouseHold(false) end, VK_LCONTROL,VK_TAB)
hotkey7 = createHotkey(function() Player.AutoClick.Checked = true end, VK_LCONTROL,VK_1)
hotkey8 = createHotkey(function() THREAD.NATIVE_LOOP(CPHAutoLootMain,TRUE,1000) end, VK_LCONTROL,VK_2)
hotkey9 = createHotkey(function() THREAD.NATIVE_LOOP(CPHAutoLootMain,FALSE,1000) end, VK_LCONTROL,VK_3)
hotkey10 = createHotkey(function() AutoMouseHold(true) end, VK_NUMPAD1 ,VK_NUMPAD2)
hotkey11 = createHotkey(function() AutoMouseHold(false) end, VK_NUMPAD1,VK_NUMPAD3)

function SaveVars()
    hotkey1 = createHotkey(function()
        teleport_to_objective()
    end, AccessSetting(e1.Text))
    hotkey2 = createHotkey(function()
        teleport_to_waypoint()
    end, AccessSetting(e2.Text))
    hotkey4 = createHotkey(function()
        set.int(CASINO_CUT_1, 85)
        set.int(CASINO_CUT_2, 85)
        set.int(CASINO_CUT_3, 85)
        set.int(CASINO_CUT_4, 85)
        set.int(CPERICO_1, 85)
        set.int(CPERICO_2, 85)
        set.int(CPERICO_3, 85)
        set.int(CPERICO_4, 85)
    end, AccessSetting(e4.Text))
    hotkey5 = createHotkey(function()
        PLAYER.SET_PLAYER_WANTED_LEVEL(0)
    end, AccessSetting(e3.Text))
end

SaveVars()


function SettingTab()
    f.show()
end

-- function SaveVars()
--     get_Top1 = tonumber(e1.text)
--     get_Texture1 = tonumber(e2.text)
--     local f = assert(io.open(string.format('%s/%s', _MyFilePath, "Setting.ini"), "w"))
--     f:write(get_Top1, "\n")
--     f:write(get_Texture1, "\n")
--     f:close()
--     showMessage("Done... Data Saved")
--     return
-- end

-- function LoadVars()
--     local f = assert(io.open(string.format('%s/%s', _MyFilePath, "Setting.ini"), "r"))
--     set_Top1 = f:read("*line")
--     set_Texture1 = f:read("*line")
--     f:close()
--     e1.Text = tostring(set_Top1)
--     e2.Text = tostring(set_Texture1)
-- end

function exitTrainer()
    -- form_hide(f)
    f.hide()
    --return caFree
end



