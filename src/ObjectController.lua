StatTab = Protection
MainTab = Player
VehicleTab = VehOp
PlaylistTab = VSpawn
ManualTab = PlayerData
MiscTab = Struct
------------------------------------------HEIST OPTION----------------------------------------------------------

----------------------------------------------HEIST OPTION END--------------------------------------------------
-- MainSliderInput = CEEdit2
-- ListSlider = CEListBox1
-- InputLevel = CEEdit3
-- RIDSpooferInput = CEEdit4
-- RIDSpooferSet = CEEdit8
-- ScriptEventData = CheckListBox1

function ShowNotification(Information, time)
    local function DragNotification(sender, button, x, y)
        Notification.DragNow()
    end

    local function DragNotification(sender, button, x, y)
        Notification.DragNow()
    end

    --
    ----
    ---- FORM: Notification
    ------------------------------
    Notification = createForm()
    Notification.Tag = 0
    Notification.Left = 3
    Notification.Height = 240
    Notification.Hint = ''
    Notification.Top = 5
    Notification.Width = 320
    Notification.HelpType = htContext
    Notification.HelpKeyword = ''
    Notification.HelpContext = 0
    Notification.Align = alNone
    Notification.AllowDropFiles = false
    Notification.AlphaBlend = true
    Notification.AlphaBlendValue = 200
    Notification.Anchors = '[akTop,akLeft]'
    Notification.AutoScroll = false
    Notification.AutoSize = false
    Notification.BiDiMode = bdLeftToRight
    Notification.BorderIcons = '[]'
    Notification.BorderStyle = bsNone
    Notification.BorderWidth = 0
    Notification.Caption = 'Notification'
    Notification.ClientHeight = 240
    Notification.ClientWidth = 320
    Notification.Color = -2147483641
    Notification.Constraints.MaxWidth = 0
    Notification.Constraints.MinHeight = 0
    Notification.Constraints.MinWidth = 0
    Notification.DefaultMonitor = dmActiveForm
    Notification.DockSite = false
    Notification.DragKind = dkDrag
    Notification.DragMode = dmManual
    Notification.Font.Color = 536870912
    Notification.Font.Height = 0
    Notification.Font.Name = 'default'
    Notification.Font.Orientation = 0
    Notification.Font.Pitch = fpDefault
    Notification.Font.Quality = fqDefault
    Notification.Font.Size = 0
    Notification.Font.Style = '[]'
    Notification.FormStyle = 'fsSystemStayOnTop'
    Notification.KeyPreview = false
    Notification.ParentBiDiMode = true
    Notification.ParentFont = false
    Notification.PixelsPerInch = 96
    Notification.Position = poDesigned
    Notification.ShowInTaskBar = 'stAlways'
    Notification.Visible = true
    Notification.WindowState = wsNormal
    Notification.DoNotSaveInTable = false
    ------------------------------
    ---- Notification : Components
    ------------------------------
    --
    ---- Info
    --------------------
    Info = createMemo(Notification)
    Info.Tag = 0
    Info.Left = -1
    Info.Height = 238
    Info.Hint = ''
    Info.Top = 0
    Info.Width = 318
    Info.HelpType = 'htContext'
    Info.HelpKeyword = ''
    Info.HelpContext = 0
    Info.Align = 'alNone'
    Info.Alignment = 'taLeftJustify'
    Info.Anchors = '[akTop,akLeft]'
    Info.BidiMode = bdLeftToRight
    Info.BorderSpacing.Top = 0
    Info.BorderStyle = 'bsSingle'
    Info.CharCase = 'ecNormal'
    Info.Color = -2147483647
    Info.Constraints.MaxWidth = 0
    Info.Constraints.MinHeight = 0
    Info.Constraints.MinWidth = 0
    Info.DragCursor = -12
    Info.DragKind = 'dkDrag'
    Info.DragMode = 'dmManual'
    Info.Enabled = true
    Info.Font.Color = 46848
    Info.Font.Height = 0
    Info.Font.Name = 'default'
    Info.Font.Orientation = 0
    Info.Font.Pitch = 'fpDefault'
    Info.Font.Quality = 'fqDefault'
    Info.Font.Size = 12
    Info.Font.Style = '[]'
    Info.HideSelection = true
    Info.MaxLength = 0
    Info.ParentBidiMode = true
    Info.ParentColor = false
    Info.ParentFont = false
    Info.ParentShowHint = true
    Info.ReadOnly = true
    Info.ScrollBars = 'ssNone'
    Info.ShowHint = false
    Info.TabOrder = 0
    Info.TabStop = true
    Info.Visible = true
    Info.WordWrap = true
    Info.SelStart = 0
    Info.Lines.Text = Information
    local t = createTimer(Notification)
    t.Interval = time
    t.OnTimer = function()
        Notification.destroy()
    end

    --------------------
    ------------------------------
    ---- END FORM: Notification
    ---- 
    --

end
function myShowMessage(title, texttoshow, time)
    local myform = createForm(false)
    myform.Caption = title
    myform.BorderStyle = 'bsDialog'
    myform.AutoSize = true
    myform.Position = 'poScreenCenter'

    local mylabel = createLabel(myform)
    mylabel.Caption = texttoshow
    mylabel.BorderSpacing.Around = 20

    local t = createTimer(myform)
    t.Interval = time
    t.OnTimer = function()
        myform.destroy()
    end

    myform.show()
end

function Mp3()
    -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
    -- + Project Name : CRDR MP3 Player Ver.5                                       +--
    -- + Creator : Corroder a.k.a VCL Bro                                           +--
    -- + Created Date : 25 Feb, 2018                                                +--
    -- + GUI Creator + Other Functions : Corroder                                   +--
    -- + MP3 Player Function Creator : mgr.inz.Player (Play,Stop,Pause,ResumemVol)  +--
    -- + CE Forum : http://forum.cheatengine.org/viewtopic.php?p=5736388#5736388    +--
    -- + Source Progamming Language : Lua 5.3 / Auto Assembler                      +--
    -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

    -- ========================================================================================--
    -- Main Form And Background
    -- ========================================================================================--
    getLuaEngine().cbShowOnPrint.Checked = false
    getLuaEngine().hide()

    Mform = createForm()
    Mform.Width = 400
    Mform.Height = 200
    Mform.Position = 'poScreenCenter'
    Mform.BorderStyle = 'bsNone'
    Mform.Color = '0x63523C'
    Mform.Name = 'Mform'
    Mform.OnMouseDown = function()
        Mform.DragNow()
    end

    local MPicbg = createImage(Mform) --- Main Image Background on Main Form
    MPicbg.Width = 400 -- Mform.Width
    MPicbg.Height = 200 -- Mform.Height
    MPicbg.Stretch = true
    MPicbg.Picture.loadFromStream(findTableFile('darkblue4.png').Stream) --- darkblue4.png
    MPicbg.OnMouseDown = function()
        Mform.DragNow()
    end

    -- ========================================================================================--
    -- Exit Icon And Hidden LabeL : Show while song playing
    -- ========================================================================================--
    local MF_Exit_Icon = createImage(Mform) --- Exit Icon on Main Form
    MF_Exit_Icon.Left = 5
    MF_Exit_Icon.Top = 5
    MF_Exit_Icon.Width = 23
    MF_Exit_Icon.Height = 23
    MF_Exit_Icon.Stretch = true
    MF_Exit_Icon.Cursor = -21
    MF_Exit_Icon.Name = 'MF_Exit_icon'
    MF_Exit_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)

    local MF_SongOnPause = createLabel(Mform) -- Label For Pause Song Playing
    MF_SongOnPause.Top = 5
    MF_SongOnPause.Caption = ' '
    MF_SongOnPause.Left = MF_Exit_Icon.Left + MF_Exit_Icon.Width + 30
    MF_SongOnPause.AutoSize = true
    MF_SongOnPause.Font.Size = 10
    MF_SongOnPause.Font.Color = '0x45CDDF'
    MF_SongOnPause.Font.Name = 'Calibri'
    MF_SongOnPause.Font.Style = 'fsBold'
    MF_SongOnPause.Visible = false

    local MF_SongOnMute = createLabel(Mform) -- Label For Mute Sound While Song Playing
    MF_SongOnMute.Top = 5
    MF_SongOnMute.Caption = ' '
    MF_SongOnMute.Left = MF_SongOnPause.Left + MF_SongOnPause.Width + 12
    MF_SongOnMute.AutoSize = true
    MF_SongOnMute.Font.Size = 10
    MF_SongOnMute.Font.Color = '0x45CDDF'
    MF_SongOnMute.Font.Name = 'Calibri'
    MF_SongOnMute.Font.Style = 'fsBold'
    MF_SongOnMute.Visible = false

    local MF_SongPathName = createLabel(Mform) -- Label For Show Dir + Path of Playing Song
    MF_SongPathName.Top = MF_Exit_Icon.Top + MF_Exit_Icon.Height + 10
    MF_SongPathName.Caption = '>   Path Name'
    MF_SongPathName.Left = 10
    MF_SongPathName.AutoSize = false
    MF_SongPathName.Font.Size = 9
    MF_SongPathName.Font.Color = '0xF2F2EF'
    MF_SongPathName.Font.Name = 'Calibri'
    MF_SongPathName.Font.Style = 'fsBold'
    MF_SongPathName.Visible = false

    local MF_SongPathName1 = createLabel(Mform) -- Sub Label For Show Dir + Path of Playing Song
    MF_SongPathName1.Top = MF_SongPathName.Top + MF_SongPathName.Height - 2
    MF_SongPathName1.Caption = ' '
    MF_SongPathName1.Left = 35
    MF_SongPathName1.Width = 220
    MF_SongPathName1.Font.Size = 8
    MF_SongPathName1.Font.Color = '0xFFEE24'
    MF_SongPathName1.Font.Name = 'Calibri'
    MF_SongPathName1.Font.Style = 'fsBold'
    MF_SongPathName1.Visible = false

    local MF_SongFileSize = createLabel(Mform) -- Label For Show Song File Size
    MF_SongFileSize.Top = MF_SongPathName1.Top + MF_SongPathName1.Height + 1
    MF_SongFileSize.Caption = '>   File Size'
    MF_SongFileSize.Left = 10
    MF_SongFileSize.AutoSize = false
    MF_SongFileSize.Font.Size = 9
    MF_SongFileSize.Font.Color = '0xF2F2EF'
    MF_SongFileSize.Font.Name = 'Calibri'
    MF_SongFileSize.Font.Style = 'fsBold'
    MF_SongFileSize.Visible = false

    local MF_SongFileSize1 = createLabel(Mform) -- Sub Label For Show Song File Size
    MF_SongFileSize1.Top = MF_SongFileSize.Top + MF_SongFileSize.Height - 2
    MF_SongFileSize1.Caption = ' '
    MF_SongFileSize1.Left = 35
    MF_SongFileSize1.Font.Size = 8
    MF_SongFileSize1.Font.Color = '0xFFEE24'
    MF_SongFileSize1.Font.Name = 'Calibri'
    MF_SongFileSize1.Font.Style = 'fsBold'
    MF_SongFileSize1.Visible = false

    local MF_SongOnPlay = createLabel(Mform) -- Marquee Label For Playing Song
    MF_SongOnPlay.Top = MF_SongFileSize1.Top + MF_SongFileSize1.Height + 6
    MF_SongOnPlay.Caption = ' '
    MF_SongOnPlay.Left = 35
    -- MF_SongOnPlay.Width = 50
    MF_SongOnPlay.Font.Size = 9
    MF_SongOnPlay.Font.Color = '0xF2F2EF' ---'0xFFEE24'
    MF_SongOnPlay.Font.Name = 'Calibri'
    MF_SongOnPlay.Font.Style = 'fsBold'
    MF_SongOnPlay.Visible = false

    local MF_Marker = createLabel(Mform) -- Marker Creator Label
    MF_Marker.Top = 135
    MF_Marker.Caption = 'Corroder CE MP3 Player Ver.5/2018'
    MF_Marker.Left = 10
    MF_Marker.Font.Size = 7
    MF_Marker.Font.Color = '0x85643B'
    MF_Marker.Font.Name = 'Calibri'
    -- MF_Marker.Font.Style = 'fsBold'
    MF_Marker.Visible = true

    local MF_SongDuration = createLabel(Mform) -- Dynamic Label to show Song Duration and Elapsed Time
    MF_SongDuration.Top = 132 --- Mform.Height - 68
    MF_SongDuration.Caption = ' '
    MF_SongDuration.Left = 280 --- Mform.Width - 120
    MF_SongDuration.Font.Size = 10
    MF_SongDuration.Font.Color = '0xFFEE24'
    MF_SongDuration.Font.Name = 'Calibri'
    MF_SongDuration.Font.Style = 'fsBold'
    MF_SongDuration.Visible = false

    MF_ProgBarBack = createPanel(Mform) --- Background Panel for showing progressbar
    MF_ProgBarBack.Left = 0
    MF_ProgBarBack.Top = 148 -- Mform.Height - 52
    MF_ProgBarBack.Width = 400 -- Mform.Width
    MF_ProgBarBack.Height = 12
    MF_ProgBarBack.BorderStyle = 'bsNone'
    MF_ProgBarBack.BevelInner = 'bvLowered'
    MF_ProgBarBack.BevelOuter = 'bvLowered'
    MF_ProgBarBack.Color = '0x63523C'
    MF_ProgBarBack.Visible = false

    MF_ProgBarFront = createPanel(MF_ProgBarBack) --- Foreground Panel for showing progressbar
    MF_ProgBarFront.Left = 2
    MF_ProgBarFront.Top = 4
    MF_ProgBarFront.Width = 0
    MF_ProgBarFront.Height = 4
    MF_ProgBarFront.BorderStyle = 'bsNone'
    MF_ProgBarFront.BevelInner = 'bvRaised'
    MF_ProgBarFront.BevelOuter = 'bvRaised'
    MF_ProgBarFront.Color = '0xF6FB8E'
    MF_ProgBarFront.Visible = false

    -- ========================================================================================--
    -- Show Current Day and Current Date and Time  ## LABEL and FUNCTION
    -- ========================================================================================--
    local daysoftheweek = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thrusday", "Friday", "Saturday"}
    local day = daysoftheweek[os.date("*t").wday]

    local MDateLabel1 = createLabel(Mform) --- Label to show curren day
    MDateLabel1.Top = 5
    MDateLabel1.Caption = day
    MDateLabel1.Left = Mform.Width - MDateLabel1.Width - 6
    MDateLabel1.Font.Size = 9
    MDateLabel1.Font.Color = '0xF2F2EF'
    MDateLabel1.Font.Name = 'Calibri'
    MDateLabel1.Font.Style = 'fsBold'

    local MDateLabel2 = createLabel(Mform) --- Label to show curren day
    MDateLabel2.Top = MDateLabel1.Top + MDateLabel1.Height + 1
    MDateLabel2.Caption = os.date("%d %B %Y")
    MDateLabel2.Left = Mform.Width - MDateLabel2.Width - 6
    MDateLabel2.Font.Size = 9
    MDateLabel2.Font.Color = '0xF2F2EF'
    MDateLabel2.Font.Name = 'Calibri'
    MDateLabel2.Font.Style = 'fsBold'

    local MDateLabel3 = createLabel(Mform) --- Label to show curren day
    MDateLabel3.Top = MDateLabel2.Top + MDateLabel2.Height + 5
    MDateLabel3.Left = Mform.Width - MDateLabel3.Width - 120
    MDateLabel3.Font.Size = 24
    MDateLabel3.Font.Color = '0xF2F2EF'
    MDateLabel3.Font.Name = 'Calibri'
    MDateLabel3.Font.Style = 'fsBold'
    c = createTimer(nil)
    c.Interval = 1000
    c.OnTimer = function(c)
        MDateLabel3.Caption = tostring(os.date('%H:%M:%S'))
    end
    c.Enabled = true

    -- ========================================================================================--
    -- Media Control Panel : Music Folder, Stop, Pause, Resume, Sound on, Mute, Volume, Playlist
    -- ========================================================================================--
    local CPanel = createPanel(Mform) --- Main Panel on Main Form
    CPanel.Left = 0
    CPanel.Top = 160 -- Mform.Height - 40
    CPanel.Width = 400 -- Mform.Width
    CPanel.Height = 40 -- 80
    CPanel.BorderStyle = 'bsNone'
    CPanel.BevelInner = 'bvRaised'
    CPanel.BevelOuter = 'bvLowered'
    CPanel.Color = '0x926D00'
    CPanel.OnMouseDown = function()
        Mform.DragNow()
    end

    local CP_Folder_Icon = createImage(CPanel) --- Finder Music Folder Icon on CPanel
    CP_Folder_Icon.Left = -1
    CP_Folder_Icon.Top = -2
    CP_Folder_Icon.Width = 40
    CP_Folder_Icon.Height = 45
    CP_Folder_Icon.Stretch = true
    CP_Folder_Icon.Cursor = -21
    CP_Folder_Icon.Name = 'CP_Folder_Icon'
    CP_Folder_Icon.Picture.loadFromStream(findTableFile('finder.png').Stream)

    local CP_Pause_Icon = createImage(CPanel) --- Pause Icon on CPanel
    CP_Pause_Icon.Left = CP_Folder_Icon.Left + CP_Folder_Icon.Width + 1
    CP_Pause_Icon.Top = -2
    CP_Pause_Icon.Width = 40
    CP_Pause_Icon.Height = 45
    CP_Pause_Icon.Stretch = true
    CP_Pause_Icon.Cursor = -21
    CP_Pause_Icon.Enabled = false
    CP_Pause_Icon.Name = 'CP_Pause_Icon'
    CP_Pause_Icon.Picture.loadFromStream(findTableFile('pause.png').Stream)

    local CP_Resume_Icon = createImage(CPanel) --- Resume Icon on CPanel
    CP_Resume_Icon.Left = CP_Folder_Icon.Left + CP_Folder_Icon.Width + 1
    CP_Resume_Icon.Top = -2
    CP_Resume_Icon.Width = 40
    CP_Resume_Icon.Height = 45
    CP_Resume_Icon.Stretch = true
    CP_Resume_Icon.Cursor = -21
    CP_Resume_Icon.Name = 'CP_Resume_Icon'
    CP_Resume_Icon.Visible = false
    CP_Resume_Icon.Picture.loadFromStream(findTableFile('resume.png').Stream)

    local CP_Stop_Icon = createImage(CPanel) --- Stop Icon on CPanel
    CP_Stop_Icon.Left = CP_Pause_Icon.Left + CP_Pause_Icon.Width + 1
    CP_Stop_Icon.Top = -2
    CP_Stop_Icon.Width = 40
    CP_Stop_Icon.Height = 45
    CP_Stop_Icon.Stretch = true
    CP_Stop_Icon.Cursor = -21
    CP_Stop_Icon.Name = 'CP_Stop_Icon'
    CP_Stop_Icon.Picture.loadFromStream(findTableFile('stop2.png').Stream)

    local CP_Mixer_Icon = createImage(CPanel) --- Mixer Icon on CPanel
    CP_Mixer_Icon.Left = CP_Stop_Icon.Left + CP_Stop_Icon.Width + 1
    CP_Mixer_Icon.Top = -2
    CP_Mixer_Icon.Width = 40
    CP_Mixer_Icon.Height = 45
    CP_Mixer_Icon.Stretch = true
    CP_Mixer_Icon.Cursor = -21
    CP_Mixer_Icon.Name = 'CP_Mixer_Icon'
    CP_Mixer_Icon.Picture.loadFromStream(findTableFile('mixer.png').Stream)

    local CP_Playlist_Icon = createImage(CPanel) --- Playlist Icon on CPanel
    CP_Playlist_Icon.Left = CP_Mixer_Icon.Left + CP_Mixer_Icon.Width + 1
    CP_Playlist_Icon.Top = -2
    CP_Playlist_Icon.Width = 40
    CP_Playlist_Icon.Height = 45
    CP_Playlist_Icon.Stretch = true
    CP_Playlist_Icon.Cursor = -21
    CP_Playlist_Icon.Name = 'CP_Playlist_Icon'
    CP_Playlist_Icon.Picture.loadFromStream(findTableFile('playlist.png').Stream)

    local CP_Sound_Icon = createImage(CPanel) --- Sound on Icon on CPanel
    CP_Sound_Icon.Left = CP_Playlist_Icon.Left + CP_Playlist_Icon.Width + 20
    CP_Sound_Icon.Top = 6
    CP_Sound_Icon.Width = 27
    CP_Sound_Icon.Height = 27
    CP_Sound_Icon.Stretch = true
    CP_Sound_Icon.Cursor = -21
    CP_Sound_Icon.Enabled = false
    CP_Sound_Icon.Name = 'CP_Sound_Icon'
    CP_Sound_Icon.Picture.loadFromStream(findTableFile('sound.png').Stream)

    local CP_Mute_Icon = createImage(CPanel) --- Sound Mute Icon on CPanel
    CP_Mute_Icon.Left = CP_Playlist_Icon.Left + CP_Playlist_Icon.Width + 20
    CP_Mute_Icon.Top = 6
    CP_Mute_Icon.Width = 27
    CP_Mute_Icon.Height = 27
    CP_Mute_Icon.Stretch = true
    CP_Mute_Icon.Cursor = -21
    CP_Mute_Icon.Name = 'CP_Mute_Icon'
    CP_Mute_Icon.Visible = false
    CP_Mute_Icon.Picture.loadFromStream(findTableFile('mute.png').Stream)

    local CP_Vol_TrckBar = createTrackBar(CPanel) --- Sound Volume track bar/slider
    CP_Vol_TrckBar.Top = 5
    CP_Vol_TrckBar.Left = CP_Sound_Icon.Left + CP_Sound_Icon.Width + 3
    CP_Vol_TrckBar.Width = 100
    CP_Vol_TrckBar.Height = 30
    CP_Vol_TrckBar.Orientation = 'trHorizontal'
    CP_Vol_TrckBar.Frequency = 10
    CP_Vol_TrckBar.Max = 100
    CP_Vol_TrckBar.Min = 0
    CP_Vol_TrckBar.Position = 50
    CP_Vol_TrckBar.Enabled = true
    CP_Vol_TrckBar.ShowSelRange = false
    CP_Vol_TrckBar.TickMarks = 'tmTopLeft'
    CP_Vol_TrckBar.BorderSpacing.Around = 25
    CP_Vol_TrckBar.BorderSpacing.CellAlignHorizontal = 'ccaCenter'
    CP_Vol_TrckBar.BorderSpacing.CellAlignVertical = 'ccaCenter'
    CP_Vol_TrckBar.BorderSpacing.Left = 25
    CP_Vol_TrckBar.BorderSpacing.Right = 25
    CP_Vol_TrckBar.BorderSpacing.Top = 25
    CP_Vol_TrckBar.Cursor = -21
    CP_Vol_TrckBar.Name = 'CP_Vol_TrckBar'

    local CP_Tool_Icon = createImage(CPanel) --- Tool Icon on CPanel
    CP_Tool_Icon.Width = 40
    CP_Tool_Icon.Left = CPanel.Width - CP_Tool_Icon.Width
    CP_Tool_Icon.Top = -2
    CP_Tool_Icon.Height = 45
    CP_Tool_Icon.Stretch = true
    CP_Tool_Icon.Cursor = -21
    CP_Tool_Icon.Name = 'CP_Tool_icon'
    CP_Tool_Icon.Picture.loadFromStream(findTableFile('tool.png').Stream)

    -- ========================================================================================--
    -- Playlist GUI and Control
    -- ========================================================================================--
    local PL_Panel = createPanel(Mform)
    PL_Panel.Top = 200
    PL_Panel.Width = 400
    PL_Panel.Height = 160
    PL_Panel.BorderStyle = 'bsNone'
    PL_Panel.BevelInner = 'bvLowered'
    PL_Panel.BevelOuter = 'bvLowered'
    PL_Panel.Color = MF_ProgBarBack.Color
    PL_Panel.Visible = true

    local PL_PanelTitle = createPanel(Mform)
    PL_PanelTitle.Top = 210
    PL_PanelTitle.Width = 384
    PL_PanelTitle.Height = 140
    PL_PanelTitle.Left = 8
    PL_PanelTitle.BorderStyle = 'bsNone'
    PL_PanelTitle.BevelInner = 'bvRaised'
    PL_PanelTitle.BevelOuter = 'bvRaised'
    PL_PanelTitle.Color = MDateLabel2.Font.Color
    PL_PanelTitle.Visible = true

    local PL_PTLabel1 = createLabel(PL_PanelTitle)
    PL_PTLabel1.Left = 5
    PL_PTLabel1.Top = 1
    PL_PTLabel1.Caption = 'Songs Playlist Table'
    PL_PTLabel1.Font.Size = 8
    PL_PTLabel1.Font.Name = 'Calibri'
    PL_PTLabel1.Font.Style = 'fsBold'
    PL_PTLabel1.Font.Color = Mform.Color

    local PL_PTLabel2 = createLabel(PL_PanelTitle)
    PL_PTLabel2.Left = 255
    PL_PTLabel2.Top = 1
    PL_PTLabel2.Caption = 'Double Click To Play Single'
    PL_PTLabel2.Font.Size = 8
    PL_PTLabel2.Font.Style = 'fsBold'
    PL_PTLabel2.Font.Name = 'Calibri'
    PL_PTLabel2.Font.Color = Mform.Color
    PL_PTLabel2.Visible = true

    local PL_listbox = createListBox(PL_PanelTitle)
    PL_listbox.Width = 378
    PL_listbox.Left = 3
    PL_listbox.Top = 15
    PL_listbox.Height = 122
    PL_listbox.TopIndex = 0
    PL_listbox.itemIndex = -1
    PL_listbox.BorderStyle = 'bsNone'
    PL_listbox.MultiSelect = true
    PL_listbox.Font.Name = 'Calibri'
    PL_listbox.Font.Size = 9
    PL_listbox.Font.Style = 'fsBold'
    PL_listbox.Font.Color = MDateLabel2.Font.Color
    PL_listbox.Color = Mform.Color -- '0xD4B627'
    
    local PL_CPanel = createPanel(Mform)
    PL_CPanel.Top = 360
    PL_CPanel.Width = 400
    PL_CPanel.Height = 40
    PL_CPanel.BorderStyle = 'bsNone'
    PL_CPanel.BevelInner = 'bvLowered'
    PL_CPanel.BevelOuter = 'bvLowered'
    PL_CPanel.Color = CPanel.Color
    PL_CPanel.Visible = true

    local PLCpnl_addSong_Icon = createImage(PL_CPanel) --- Add Song Icon on PL_CPanel
    PLCpnl_addSong_Icon.Left = -1
    PLCpnl_addSong_Icon.Top = -2
    PLCpnl_addSong_Icon.Width = 40
    PLCpnl_addSong_Icon.Height = 45
    PLCpnl_addSong_Icon.Stretch = true
    PLCpnl_addSong_Icon.Cursor = -21
    PLCpnl_addSong_Icon.Name = 'PLCpnl_addSong_Icon'
    PLCpnl_addSong_Icon.Picture.loadFromStream(findTableFile('plus.png').Stream)

    local PLCpnl_delSong_Icon = createImage(PL_CPanel) --- Del Song Icon on PL_CPanel
    PLCpnl_delSong_Icon.Left = PLCpnl_addSong_Icon.Left + PLCpnl_addSong_Icon.Width + 1
    PLCpnl_delSong_Icon.Top = -2
    PLCpnl_delSong_Icon.Width = 40
    PLCpnl_delSong_Icon.Height = 45
    PLCpnl_delSong_Icon.Stretch = true
    PLCpnl_delSong_Icon.Cursor = -21
    PLCpnl_delSong_Icon.Name = 'PLCpnl_delSong_Icon'
    PLCpnl_delSong_Icon.Picture.loadFromStream(findTableFile('minus.png').Stream)

    local PLCpnl_playAll_Icon = createImage(PL_CPanel) --- Play All Song Icon on PL_CPanel
    PLCpnl_playAll_Icon.Left = PLCpnl_delSong_Icon.Left + PLCpnl_delSong_Icon.Width + 1
    PLCpnl_playAll_Icon.Top = -2
    PLCpnl_playAll_Icon.Width = 40
    PLCpnl_playAll_Icon.Height = 45
    PLCpnl_playAll_Icon.Stretch = true
    PLCpnl_playAll_Icon.Cursor = -21
    PLCpnl_playAll_Icon.Name = 'PLCpnl_playAll_Icon'
    PLCpnl_playAll_Icon.Picture.loadFromStream(findTableFile('shuffle.png').Stream)

    local PLCpnl_savePL_Icon = createImage(PL_CPanel) --- Save Playlist Icon on PL_CPanel
    PLCpnl_savePL_Icon.Left = PLCpnl_playAll_Icon.Left + PLCpnl_playAll_Icon.Width + 40
    PLCpnl_savePL_Icon.Top = 8
    PLCpnl_savePL_Icon.Width = 24
    PLCpnl_savePL_Icon.Height = 24
    PLCpnl_savePL_Icon.Stretch = true
    PLCpnl_savePL_Icon.Cursor = -21
    PLCpnl_savePL_Icon.Name = 'PLCpnl_savePL_Icon'
    PLCpnl_savePL_Icon.Picture.loadFromStream(findTableFile('ok.png').Stream)

    local PLCpnl_loadPL_Icon = createImage(PL_CPanel) --- Load Playlist Icon on PL_CPanel
    PLCpnl_loadPL_Icon.Left = PLCpnl_savePL_Icon.Left + PLCpnl_savePL_Icon.Width + 1
    PLCpnl_loadPL_Icon.Top = 8
    PLCpnl_loadPL_Icon.Width = 24
    PLCpnl_loadPL_Icon.Height = 24
    PLCpnl_loadPL_Icon.Stretch = true
    PLCpnl_loadPL_Icon.Cursor = -21
    PLCpnl_loadPL_Icon.Name = 'PLCpnl_loadPL_Icon'
    PLCpnl_loadPL_Icon.Picture.loadFromStream(findTableFile('refresh.png').Stream)

    local PLCpnl_clearPL_Icon = createImage(PL_CPanel) --- Clear Playlist Icon on PL_CPanel
    PLCpnl_clearPL_Icon.Left = PLCpnl_loadPL_Icon.Left + PLCpnl_loadPL_Icon.Width + 1
    PLCpnl_clearPL_Icon.Top = 8
    PLCpnl_clearPL_Icon.Width = 24
    PLCpnl_clearPL_Icon.Height = 24
    PLCpnl_clearPL_Icon.Stretch = true
    PLCpnl_clearPL_Icon.Cursor = -21
    PLCpnl_clearPL_Icon.Name = 'PLCpnl_clearPL_Icon'
    PLCpnl_clearPL_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)

    local PLCpnl_closePL_Icon = createImage(PL_CPanel) --- Close Playlist Icon on PL_CPanel
    PLCpnl_closePL_Icon.Width = 40
    PLCpnl_closePL_Icon.Left = PL_CPanel.Width - PLCpnl_closePL_Icon.Width
    PLCpnl_closePL_Icon.Top = -2
    PLCpnl_closePL_Icon.Height = 45
    PLCpnl_closePL_Icon.Stretch = true
    PLCpnl_closePL_Icon.Cursor = -21
    PLCpnl_closePL_Icon.Name = 'PLCpnl_closePL_Icon'
    PLCpnl_closePL_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)

    -- ========================================================================================--
    -- ========================================================================================--
    -- FORM2 : Sub Form use to show messages and actions from users
    -- ========================================================================================--
    -- ========================================================================================--
    local Msgform = createForm()
    Msgform.Width = 250
    Msgform.Height = 150
    Msgform.Position = 'poScreenCenter'
    Msgform.BorderStyle = 'bsNone'
    Msgform.Color = '0x63523C'
    Msgform.Name = 'Msgform'
    Msgform.Visible = false

    local Msg_Panel = createPanel(Msgform)
    Msg_Panel.Width = 230
    Msg_Panel.Height = 130
    Msg_Panel.Top = 10
    Msg_Panel.Left = 10
    Msg_Panel.BorderStyle = 'bsNone'
    Msg_Panel.BevelOuter = 'bvLowered'
    Msg_Panel.BevelInner = 'bvLowered'
    Msg_Panel.Color = '0xF4F9F6'

    local Msg_Label = createLabel(Msg_Panel)
    Msg_Label.Caption = ' '
    Msg_Label.Left = (Msg_Panel.Width - Msg_Label.Width) / 2
    Msg_Label.Height = 30
    Msg_Label.Top = 30
    Msg_Label.Font.Name = 'Calibri'
    Msg_Label.Font.Size = 12

    local Msg_Ok_Icon = createImage(Msg_Panel) --- Confirm OK icon
    Msg_Ok_Icon.Width = 40
    Msg_Ok_Icon.Height = 40
    Msg_Ok_Icon.Left = 2
    Msg_Ok_Icon.Top = 90
    Msg_Ok_Icon.Stretch = true
    Msg_Ok_Icon.Cursor = -21
    Msg_Ok_Icon.Name = 'Msg_Ok_Icon'
    Msg_Ok_Icon.Visible = false
    Msg_Ok_Icon.Picture.loadFromStream(findTableFile('ok1.png').Stream)
    Msg_Ok_Icon.onClick = message_ok

    local Msg_Yes_Icon = createImage(Msg_Panel) --- Confirm YES icon
    Msg_Yes_Icon.Width = 27
    Msg_Yes_Icon.Height = 27
    Msg_Yes_Icon.Left = 159
    Msg_Yes_Icon.Top = 97
    Msg_Yes_Icon.Stretch = true
    Msg_Yes_Icon.Cursor = -21
    Msg_Yes_Icon.Name = 'Msg_Yes_Icon'
    Msg_Yes_Icon.Visible = false
    Msg_Yes_Icon.Picture.loadFromStream(findTableFile('yes.png').Stream)

    local Msg_No_Icon = createImage(Msg_Panel) --- Confirm NO icon
    Msg_No_Icon.Width = 27
    Msg_No_Icon.Height = 27
    Msg_No_Icon.Left = 193
    Msg_No_Icon.Top = 97
    Msg_No_Icon.Stretch = true
    Msg_No_Icon.Cursor = -21
    Msg_No_Icon.Name = 'Msg_No_Icon'
    Msg_No_Icon.Visible = false
    Msg_No_Icon.Picture.loadFromStream(findTableFile('no.png').Stream)

    -- ========================================================================================--
    -- Mixer GUI and Control
    -- ========================================================================================--
    local Mixer_Panel = createPanel(Mform)
    Mixer_Panel.Top = 210
    Mixer_Panel.Width = 380
    Mixer_Panel.Height = 180
    Mixer_Panel.Left = math.floor((Mform.Width - Mixer_Panel.Width) / 2)
    Mixer_Panel.BorderStyle = 'bsNone'
    Mixer_Panel.BevelInner = 'bvLowered'
    Mixer_Panel.BevelOuter = 'bvLowered'
    Mixer_Panel.Color = '0xFFEBEA'
    Mixer_Panel.Visible = true

    local Mixer_in_Panel = createPanel(Mixer_Panel)
    Mixer_in_Panel.Width = 370
    Mixer_in_Panel.Height = 170
    Mixer_in_Panel.Top = math.floor((Mixer_Panel.Height - Mixer_in_Panel.Height) / 2)
    Mixer_in_Panel.Left = math.floor((Mixer_Panel.Width - Mixer_in_Panel.Width) / 2)
    Mixer_in_Panel.BorderStyle = 'bsNone'
    Mixer_in_Panel.BevelInner = 'bvRasied'
    Mixer_in_Panel.BevelOuter = 'bvRaised'
    Mixer_in_Panel.Color = MF_ProgBarBack.Color -- '0x989898'
    
    Mixer_in_Panel.Visible = true

    local MixerLabel = createLabel(Mixer_in_Panel)
    MixerLabel.Top = 2
    MixerLabel.Left = 8
    MixerLabel.Font.Name = 'Calibri'
    MixerLabel.Font.Size = 8
    MixerLabel.Font.Color = MDateLabel1.Font.Color
    MixerLabel.Caption = 'Loud  Speaker  Control'

    local MixerExit_Icon = createImage(Mixer_in_Panel)
    MixerExit_Icon.Top = 3
    MixerExit_Icon.Left = 345
    MixerExit_Icon.Width = 20
    MixerExit_Icon.Height = 20
    MixerExit_Icon.Font.Size = 8
    MixerExit_Icon.Stretch = true
    MixerExit_Icon.Cursor = -21
    MixerExit_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)

    local MixerGrpBox_1 = createGroupBox(Mixer_in_Panel)
    MixerGrpBox_1.Left = 10
    MixerGrpBox_1.Width = 50
    MixerGrpBox_1.Top = MixerLabel.Top + 10
    MixerGrpBox_1.Height = 152
    MixerGrpBox_1.Caption = ''

    local Mgb_1_Label = createLabel(MixerGrpBox_1)
    Mgb_1_Label.Top = -7
    Mgb_1_Label.Caption = 'Balance'
    Mgb_1_Label.Font.Size = 8
    Mgb_1_Label.Font.Color = MDateLabel1.Font.Color
    Mgb_1_Label.Font.Name = 'Calibri'
    Mgb_1_Label.Left = 3

    local Mgb_1_VlmTrBar = createTrackBar(MixerGrpBox_1) --- Sound Volume track bar/slider on mixer
    Mgb_1_VlmTrBar.Top = 5
    Mgb_1_VlmTrBar.Width = 130
    Mgb_1_VlmTrBar.Left = 10
    Mgb_1_VlmTrBar.Height = 140
    Mgb_1_VlmTrBar.Orientation = 'trVertical'
    Mgb_1_VlmTrBar.Frequency = 1
    Mgb_1_VlmTrBar.Max = 100
    Mgb_1_VlmTrBar.Min = 0
    Mgb_1_VlmTrBar.Position = 50
    Mgb_1_VlmTrBar.ScalePos = 'trRight'
    Mgb_1_VlmTrBar.TickMarks = 'tmBottomRight'
    Mgb_1_VlmTrBar.TickStyle = 'tsAuto'
    Mgb_1_VlmTrBar.ShowSelRange = true
    Mgb_1_VlmTrBar.Reversed = true
    Mgb_1_VlmTrBar.Frequency = 10
    Mgb_1_VlmTrBar.Cursor = -21
    Mgb_1_VlmTrBar.Name = 'Mgb_1_VlmTrBar'

    ------------------------------------------ Groupbox 2
    local MixerGrpBox_2 = createGroupBox(Mixer_in_Panel)
    MixerGrpBox_2.Left = MixerGrpBox_1.Left + MixerGrpBox_1.Width + 8
    MixerGrpBox_2.Width = 95
    MixerGrpBox_2.Top = MixerLabel.Top + 10
    MixerGrpBox_2.Height = 152
    MixerGrpBox_2.Caption = ''

    local Mgb_2_LabelL = createLabel(MixerGrpBox_2)
    Mgb_2_LabelL.Top = -7
    Mgb_2_LabelL.Caption = 'Left'
    Mgb_2_LabelL.Font.Color = MDateLabel1.Font.Color
    Mgb_2_LabelL.Font.Size = 8
    Mgb_2_LabelL.Font.Name = 'Calibri'
    Mgb_2_LabelL.Left = 12

    local Mgb_2_LabelR = createLabel(MixerGrpBox_2)
    Mgb_2_LabelR.Top = -7
    Mgb_2_LabelR.Caption = 'Right'
    Mgb_2_LabelR.Font.Color = MDateLabel1.Font.Color
    Mgb_2_LabelR.Font.Size = 8
    Mgb_2_LabelR.Font.Name = 'Calibri'
    Mgb_2_LabelR.Left = 50

    local Mgb_2_VLTrBar = createTrackBar(MixerGrpBox_2) --- Sound Left Volume track bar/slider on mixer
    Mgb_2_VLTrBar.Top = 5
    Mgb_2_VLTrBar.Width = 130
    Mgb_2_VLTrBar.Left = 10
    Mgb_2_VLTrBar.Height = 140
    Mgb_2_VLTrBar.Orientation = 'trVertical'
    Mgb_2_VLTrBar.Frequency = 1
    Mgb_2_VLTrBar.Max = 100
    Mgb_2_VLTrBar.Min = 0
    Mgb_2_VLTrBar.Position = 50
    Mgb_2_VLTrBar.ScalePos = 'trRight'
    Mgb_2_VLTrBar.TickMarks = 'tmBottomRight'
    Mgb_2_VLTrBar.TickStyle = 'tsAuto'
    Mgb_2_VLTrBar.ShowSelRange = true
    Mgb_2_VLTrBar.Reversed = true
    Mgb_2_VLTrBar.Frequency = 10
    Mgb_2_VLTrBar.Cursor = -21
    Mgb_2_VLTrBar.Name = 'Mgb_2_VLTrBar'

    local Mgb_2_VRTrBar = createTrackBar(MixerGrpBox_2) --- Sound Right Volume track bar/slider on mixer
    Mgb_2_VRTrBar.Top = 5
    Mgb_2_VRTrBar.Width = 130
    Mgb_2_VRTrBar.Left = 50
    Mgb_2_VRTrBar.Height = 140
    Mgb_2_VRTrBar.Orientation = 'trVertical'
    Mgb_2_VRTrBar.Frequency = 1
    Mgb_2_VRTrBar.Max = 100
    Mgb_2_VRTrBar.Min = 0
    Mgb_2_VRTrBar.Position = 50
    Mgb_2_VRTrBar.ScalePos = 'trRight'
    Mgb_2_VRTrBar.TickMarks = 'tmBottomRight'
    Mgb_2_VRTrBar.TickStyle = 'tsAuto'
    Mgb_2_VRTrBar.ShowSelRange = true
    Mgb_2_VRTrBar.Reversed = true
    Mgb_2_VRTrBar.Frequency = 10
    Mgb_2_VRTrBar.Cursor = -21
    Mgb_2_VRTrBar.Name = 'Mgb_2_VRTrBar'

    ------------------------------------------ Groupbox 3
    local MixerGrpBox_3 = createGroupBox(Mixer_in_Panel)
    MixerGrpBox_3.Left = MixerGrpBox_2.Left + MixerGrpBox_2.Width + 8
    MixerGrpBox_3.Width = 95
    MixerGrpBox_3.Top = MixerLabel.Top + 10
    MixerGrpBox_3.Height = 152
    MixerGrpBox_3.Caption = ''

    local Mgb_3_LabelB = createLabel(MixerGrpBox_3)
    Mgb_3_LabelB.Top = -7
    Mgb_3_LabelB.Caption = 'Bass'
    Mgb_3_LabelB.Font.Color = MDateLabel1.Font.Color
    Mgb_3_LabelB.Font.Size = 8
    Mgb_3_LabelB.Font.Name = 'Calibri'
    Mgb_3_LabelB.Left = 10

    local Mgb_3_LabelT = createLabel(MixerGrpBox_3)
    Mgb_3_LabelT.Top = -7
    Mgb_3_LabelT.Caption = 'Treble'
    Mgb_3_LabelT.Font.Color = MDateLabel1.Font.Color
    Mgb_3_LabelT.Font.Size = 8
    Mgb_3_LabelT.Font.Name = 'Calibri'
    Mgb_3_LabelT.Left = 50

    local Mgb_3_VBTrBar = createTrackBar(MixerGrpBox_3) --- Sound Bass Volume track bar/slider on mixer
    Mgb_3_VBTrBar.Top = 5
    Mgb_3_VBTrBar.Width = 130
    Mgb_3_VBTrBar.Left = 10
    Mgb_3_VBTrBar.Height = 140
    Mgb_3_VBTrBar.Orientation = 'trVertical'
    Mgb_3_VBTrBar.Frequency = 1
    Mgb_3_VBTrBar.Max = 100
    Mgb_3_VBTrBar.Min = 0
    Mgb_3_VBTrBar.Position = 50
    Mgb_3_VBTrBar.ScalePos = 'trRight'
    Mgb_3_VBTrBar.TickMarks = 'tmBottomRight'
    Mgb_3_VBTrBar.TickStyle = 'tsAuto'
    Mgb_3_VBTrBar.ShowSelRange = true
    Mgb_3_VBTrBar.Reversed = true
    Mgb_3_VBTrBar.Frequency = 10
    Mgb_3_VBTrBar.Cursor = -21
    Mgb_3_VBTrBar.Name = 'Mgb_3_VBTrBar'

    local Mgb_3_VTTrBar = createTrackBar(MixerGrpBox_3) --- Sound Treble Volume track bar/slider on mixer
    Mgb_3_VTTrBar.Top = 5
    Mgb_3_VTTrBar.Width = 130
    Mgb_3_VTTrBar.Left = 50
    Mgb_3_VTTrBar.Height = 140
    Mgb_3_VTTrBar.Orientation = 'trVertical'
    Mgb_3_VTTrBar.Frequency = 1
    Mgb_3_VTTrBar.Max = 100
    Mgb_3_VTTrBar.Min = 0
    Mgb_3_VTTrBar.Position = 50
    Mgb_3_VTTrBar.ScalePos = 'trRight'
    Mgb_3_VTTrBar.TickMarks = 'tmBottomRight'
    Mgb_3_VTTrBar.TickStyle = 'tsAuto'
    Mgb_3_VTTrBar.ShowSelRange = true
    Mgb_3_VTTrBar.Reversed = true
    Mgb_3_VTTrBar.Frequency = 10
    Mgb_3_VTTrBar.Cursor = -21
    Mgb_3_VTTrBar.Name = 'Mgb_3_VTTrBar'

    local MixerMVol_Icon = createImage(Mixer_in_Panel)
    MixerMVol_Icon.Top = 118
    MixerMVol_Icon.Left = MixerGrpBox_3.Left + MixerGrpBox_3.Width + 10
    MixerMVol_Icon.Width = 85
    MixerMVol_Icon.Height = 20
    MixerMVol_Icon.Font.Size = 8
    MixerMVol_Icon.Stretch = true
    MixerMVol_Icon.Cursor = -21
    MixerMVol_Icon.Picture.loadFromStream(findTableFile('buttonmasvol.png').Stream)

    local MixerReset_Icon = createImage(Mixer_in_Panel)
    MixerReset_Icon.Top = 143
    MixerReset_Icon.Left = MixerGrpBox_3.Left + MixerGrpBox_3.Width + 10
    MixerReset_Icon.Width = 85
    MixerReset_Icon.Height = 20
    MixerReset_Icon.Font.Size = 8
    MixerReset_Icon.Stretch = true
    MixerReset_Icon.Cursor = -21
    MixerReset_Icon.Picture.loadFromStream(findTableFile('buttonreset.png').Stream)

    -- ========================================================================================--
    -- Tools GUI and Control
    -- ========================================================================================--
    local Tools_Panel = createPanel(Mform)
    Tools_Panel.Top = 210
    Tools_Panel.Width = 380
    Tools_Panel.Height = 180
    Tools_Panel.Left = math.floor((Mform.Width - Tools_Panel.Width) / 2)
    Tools_Panel.BorderStyle = 'bsNone'
    Tools_Panel.BevelInner = 'bvLowered'
    Tools_Panel.BevelOuter = 'bvLowered'
    Tools_Panel.Color = '0xFFEBEA'
    Tools_Panel.Visible = true

    local Tools_in_Panel = createPanel(Tools_Panel)
    Tools_in_Panel.Width = 370
    Tools_in_Panel.Height = 170
    Tools_in_Panel.Top = math.floor((Tools_Panel.Height - Tools_in_Panel.Height) / 2)
    Tools_in_Panel.Left = math.floor((Tools_Panel.Width - Tools_in_Panel.Width) / 2)
    Tools_in_Panel.BorderStyle = 'bsNone'
    Tools_in_Panel.BevelInner = 'bvRasied'
    Tools_in_Panel.BevelOuter = 'bvRaised'
    Tools_in_Panel.Color = MF_ProgBarBack.Color
    Tools_in_Panel.Visible = true

    local ToolExit_Icon = createImage(Tools_in_Panel)
    ToolExit_Icon.Top = 3
    ToolExit_Icon.Left = 345
    ToolExit_Icon.Width = 20
    ToolExit_Icon.Height = 20
    ToolExit_Icon.Font.Size = 8
    ToolExit_Icon.Stretch = true
    ToolExit_Icon.Cursor = -21
    ToolExit_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)

    local Tool_ThemeLabel = createLabel(Tools_in_Panel)
    Tool_ThemeLabel.Top = 5
    Tool_ThemeLabel.Left = 11
    Tool_ThemeLabel.Font.Size = 10
    Tool_ThemeLabel.Font.Style = 'fsBold'
    Tool_ThemeLabel.Font.Name = 'Calibri'
    Tool_ThemeLabel.Font.Color = MF_SongPathName1.Font.Color
    Tool_ThemeLabel.Caption = 'Themes Selection'

    local Tool_SetLabel = createLabel(Tools_in_Panel)
    Tool_SetLabel.Top = 5
    Tool_SetLabel.Left = 158
    Tool_SetLabel.Font.Size = 10
    Tool_SetLabel.Font.Style = 'fsBold'
    Tool_SetLabel.Font.Name = 'Calibri'
    Tool_SetLabel.Font.Color = MF_SongPathName1.Font.Color
    Tool_SetLabel.Caption = 'Setting'
    ----------------------------------------------------------------------- Themes Group Box
    local Tool_GrpTheme = createGroupBox(Tools_in_Panel)
    Tool_GrpTheme.Top = 15
    Tool_GrpTheme.Left = 10
    Tool_GrpTheme.Height = 145
    Tool_GrpTheme.Width = 140

    local TGtheme_Panel1 = createPanel(Tool_GrpTheme)
    TGtheme_Panel1.Top = 2
    TGtheme_Panel1.Left = 10
    TGtheme_Panel1.Height = 15
    TGtheme_Panel1.Width = 15
    TGtheme_Panel1.BevelInner = 'bvRasied'
    TGtheme_Panel1.BevelOuter = 'bvRaised'
    TGtheme_Panel1.BorderStyle = 'bsSingle'
    TGtheme_Panel1.Color = MDateLabel2.Font.Color
    TGtheme_Panel1.Cursor = -21
    TGtheme_Panel1.Enabled = false

    local TGtheme_Panel2 = createPanel(Tool_GrpTheme)
    TGtheme_Panel2.Top = 25
    TGtheme_Panel2.Left = 10
    TGtheme_Panel2.Height = 15
    TGtheme_Panel2.Width = 15
    TGtheme_Panel2.BevelInner = 'bvRasied'
    TGtheme_Panel2.BevelOuter = 'bvRaised'
    TGtheme_Panel2.BorderStyle = 'bsSingle'
    TGtheme_Panel2.Color = MF_SongPathName1.Font.Color
    TGtheme_Panel2.Cursor = -21

    local TGtheme_Panel3 = createPanel(Tool_GrpTheme)
    TGtheme_Panel3.Top = 47
    TGtheme_Panel3.Left = 10
    TGtheme_Panel3.Height = 15
    TGtheme_Panel3.Width = 15
    TGtheme_Panel3.BevelInner = 'bvRasied'
    TGtheme_Panel3.BevelOuter = 'bvRaised'
    TGtheme_Panel3.BorderStyle = 'bsSingle'
    TGtheme_Panel3.Color = MF_SongPathName1.Font.Color
    TGtheme_Panel3.Cursor = -21

    local TGtheme_Pn1Lbl = createLabel(Tool_GrpTheme)
    TGtheme_Pn1Lbl.Top = 3
    TGtheme_Pn1Lbl.Left = 33
    TGtheme_Pn1Lbl.Font.Style = 'fsBold'
    TGtheme_Pn1Lbl.Font.Name = 'Calibri'
    TGtheme_Pn1Lbl.Font.Color = MF_SongPathName1.Font.Color
    TGtheme_Pn1Lbl.Font.Size = 9
    TGtheme_Pn1Lbl.Caption = 'Blue City [Default]'
    TGtheme_Pn1Lbl.Name = 'TGtheme_Pn1Lbl'

    local TGtheme_Pn2Lb2 = createLabel(Tool_GrpTheme)
    TGtheme_Pn2Lb2.Top = 26
    TGtheme_Pn2Lb2.Left = 33
    TGtheme_Pn2Lb2.Font.Style = 'fsBold'
    TGtheme_Pn2Lb2.Font.Name = 'Calibri'
    TGtheme_Pn2Lb2.Font.Color = MDateLabel2.Font.Color
    TGtheme_Pn2Lb2.Font.Size = 9
    TGtheme_Pn2Lb2.Caption = 'Broken Red Music'
    TGtheme_Pn2Lb2.Name = 'TGtheme_Pn2Lb2'

    local TGtheme_Pn3Lb3 = createLabel(Tool_GrpTheme)
    TGtheme_Pn3Lb3.Top = 48
    TGtheme_Pn3Lb3.Left = 33
    TGtheme_Pn3Lb3.Font.Style = 'fsBold'
    TGtheme_Pn3Lb3.Font.Name = 'Calibri'
    TGtheme_Pn3Lb3.Font.Color = MDateLabel2.Font.Color
    TGtheme_Pn3Lb3.Font.Size = 9
    TGtheme_Pn3Lb3.Caption = 'Grey Cloudy Sky'
    TGtheme_Pn3Lb3.Name = 'TGtheme_Pn3Lb3'
    ----------------------------------------------------------------------- Setting Group Box
    local Tool_GrpSet = createGroupBox(Tools_in_Panel)
    Tool_GrpSet.Top = 15
    Tool_GrpSet.Left = 155
    Tool_GrpSet.Height = 145
    Tool_GrpSet.Width = 140

    local TGset_Panel1 = createPanel(Tool_GrpSet)
    TGset_Panel1.Top = 2
    TGset_Panel1.Left = 10
    TGset_Panel1.Height = 15
    TGset_Panel1.Width = 15
    TGset_Panel1.BevelInner = 'bvRasied'
    TGset_Panel1.BevelOuter = 'bvRaised'
    TGset_Panel1.BorderStyle = 'bsSingle'
    TGset_Panel1.Color = MDateLabel2.Font.Color
    TGset_Panel1.Cursor = -21

    local TGset_Panel2 = createPanel(Tool_GrpSet)
    TGset_Panel2.Top = 25
    TGset_Panel2.Left = 10
    TGset_Panel2.Height = 15
    TGset_Panel2.Width = 15
    TGset_Panel2.BevelInner = 'bvRasied'
    TGset_Panel2.BevelOuter = 'bvRaised'
    TGset_Panel2.BorderStyle = 'bsSingle'
    TGset_Panel2.Color = MDateLabel2.Font.Color
    TGset_Panel2.Cursor = -21

    local TGset_Panel3 = createPanel(Tool_GrpSet)
    TGset_Panel3.Top = 47
    TGset_Panel3.Left = 10
    TGset_Panel3.Height = 15
    TGset_Panel3.Width = 15
    TGset_Panel3.BevelInner = 'bvRasied'
    TGset_Panel3.BevelOuter = 'bvRaised'
    TGset_Panel3.BorderStyle = 'bsSingle'
    TGset_Panel3.Color = MDateLabel2.Font.Color
    TGset_Panel3.Cursor = -21

    local TGset_Panel4 = createPanel(Tool_GrpSet)
    TGset_Panel4.Top = 69
    TGset_Panel4.Left = 10
    TGset_Panel4.Height = 15
    TGset_Panel4.Width = 15
    TGset_Panel4.BevelInner = 'bvRasied'
    TGset_Panel4.BevelOuter = 'bvRaised'
    TGset_Panel4.BorderStyle = 'bsSingle'
    TGset_Panel4.Color = MDateLabel2.Font.Color
    TGset_Panel4.Cursor = -21

    local TGset_Panel5 = createPanel(Tool_GrpSet)
    TGset_Panel5.Top = 91
    TGset_Panel5.Left = 10
    TGset_Panel5.Height = 15
    TGset_Panel5.Width = 15
    TGset_Panel5.BevelInner = 'bvRasied'
    TGset_Panel5.BevelOuter = 'bvRaised'
    TGset_Panel5.BorderStyle = 'bsSingle'
    TGset_Panel5.Color = MDateLabel2.Font.Color
    TGset_Panel5.Cursor = -21

    local TGSet_Pn1Lbl = createLabel(Tool_GrpSet)
    TGSet_Pn1Lbl.Top = 3
    TGSet_Pn1Lbl.Left = 33
    TGSet_Pn1Lbl.Font.Style = 'fsBold'
    TGSet_Pn1Lbl.Font.Name = 'Calibri'
    TGSet_Pn1Lbl.Font.Color = MF_SongPathName1.Font.Color
    TGSet_Pn1Lbl.Font.Size = 9
    TGSet_Pn1Lbl.Caption = 'Date/Time   [ON]'
    TGSet_Pn1Lbl.Name = 'TGSet_Pn1Lbl'

    local TGSet_Pn2Lb2 = createLabel(Tool_GrpSet)
    TGSet_Pn2Lb2.Top = 26
    TGSet_Pn2Lb2.Left = 33
    TGSet_Pn2Lb2.Font.Style = 'fsBold'
    TGSet_Pn2Lb2.Font.Name = 'Calibri'
    TGSet_Pn2Lb2.Font.Color = MF_SongPathName1.Font.Color
    TGSet_Pn2Lb2.Font.Size = 9
    TGSet_Pn2Lb2.Caption = 'Clock      [ON]'
    TGSet_Pn2Lb2.Name = 'TGSet_Pn2Lb2'

    local TGSet_Pn3Lb3 = createLabel(Tool_GrpSet)
    TGSet_Pn3Lb3.Top = 48
    TGSet_Pn3Lb3.Left = 33
    TGSet_Pn3Lb3.Font.Style = 'fsBold'
    TGSet_Pn3Lb3.Font.Name = 'Calibri'
    TGSet_Pn3Lb3.Font.Color = MF_SongPathName1.Font.Color
    TGSet_Pn3Lb3.Font.Size = 9
    TGSet_Pn3Lb3.Caption = 'Path Name  [ON]'
    TGSet_Pn3Lb3.Name = 'TGSet_Pn3Lb3'

    local TGSet_Pn4Lb4 = createLabel(Tool_GrpSet)
    TGSet_Pn4Lb4.Top = 70
    TGSet_Pn4Lb4.Left = 33
    TGSet_Pn4Lb4.Font.Style = 'fsBold'
    TGSet_Pn4Lb4.Font.Name = 'Calibri'
    TGSet_Pn4Lb4.Font.Color = MF_SongPathName1.Font.Color
    TGSet_Pn4Lb4.Font.Size = 9
    TGSet_Pn4Lb4.Caption = 'File Size  [ON]'
    TGSet_Pn4Lb4.Name = 'TGSet_Pn4Lb4'

    local TGSet_Pn5Lb5 = createLabel(Tool_GrpSet)
    TGSet_Pn5Lb5.Top = 92
    TGSet_Pn5Lb5.Left = 33
    TGSet_Pn5Lb5.Font.Style = 'fsBold'
    TGSet_Pn5Lb5.Font.Name = 'Calibri'
    TGSet_Pn5Lb5.Font.Color = MF_SongPathName1.Font.Color
    TGSet_Pn5Lb5.Font.Size = 9
    TGSet_Pn5Lb5.Caption = 'Song Name [ON]'
    TGSet_Pn5Lb5.Name = 'TGSet_Pn5Lb5'

    -- ========================================================================================--
    -- Set functions for themes and MP3 env.'s
    -- ========================================================================================--
    ---=============================================================--- DEFAULT THEME
    function defaultTheme()
        CP_Vol_TrckBar.Visible = false
        CP_Vol_TrckBar.Enabled = false
        Mgb_1_VlmTrBar.Visible = false
        Mgb_1_VlmTrBar.Enabled = false
        Mgb_2_VLTrBar.Visible = false
        Mgb_2_VLTrBar.Enabled = false
        Mgb_2_VRTrBar.Visible = false
        Mgb_2_VRTrBar.Enabled = false
        Mgb_3_VBTrBar.Visible = false
        Mgb_3_VBTrBar.Enabled = false
        Mgb_3_VTTrBar.Visible = false
        Mgb_3_VTTrBar.Enabled = false
        TGtheme_Panel1.Enabled = false
        TGtheme_Panel2.Enabled = true
        TGtheme_Panel3.Enabled = true
        ----
        Mform.Color = '0x63523C'
        MPicbg.Picture.loadFromStream(findTableFile('darkblue4.png').Stream)
        MF_Exit_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)
        MF_Marker.Font.Color = '0x85643B'
        MF_SongOnPause.Font.Color = '0x45CDDF'
        MF_SongOnMute.Font.Color = '0x45CDDF'
        MF_SongPathName.Font.Color = '0xF2F2EF'
        MF_SongPathName1.Font.Color = '0xFFEE24'
        MF_SongFileSize.Font.Color = '0xF2F2EF'
        MF_SongFileSize1.Font.Color = '0xFFEE24'
        MF_SongOnPlay.Font.Color = '0xF2F2EF'
        MF_SongDuration.Font.Color = '0xFFEE24'
        MF_ProgBarBack.Color = '0x63523C'
        MF_ProgBarFront.Color = '0xF6FB8E'
        MDateLabel1.Font.Color = '0xF2F2EF'
        MDateLabel2.Font.Color = '0xF2F2EF'
        MDateLabel3.Font.Color = '0xF2F2EF'
        ----
        CPanel.Color = '0x926D00'
        CP_Folder_Icon.Picture.loadFromStream(findTableFile('finder.png').Stream)
        CP_Pause_Icon.Picture.loadFromStream(findTableFile('pause.png').Stream)
        CP_Resume_Icon.Picture.loadFromStream(findTableFile('resume.png').Stream)
        CP_Stop_Icon.Picture.loadFromStream(findTableFile('stop2.png').Stream)
        CP_Mixer_Icon.Picture.loadFromStream(findTableFile('mixer.png').Stream)
        CP_Playlist_Icon.Picture.loadFromStream(findTableFile('playlist.png').Stream)
        CP_Sound_Icon.Picture.loadFromStream(findTableFile('sound.png').Stream)
        CP_Mute_Icon.Picture.loadFromStream(findTableFile('mute.png').Stream)
        CP_Tool_Icon.Picture.loadFromStream(findTableFile('tool.png').Stream)
        ----
        PL_Panel.Color = MF_ProgBarBack.Color
        PL_PanelTitle.Color = MDateLabel2.Font.Color
        PL_PTLabel1.Font.Color = Mform.Color
        PL_PTLabel2.Font.Color = Mform.Color
        PL_listbox.Font.Color = MDateLabel2.Font.Color
        PL_listbox.Color = Mform.Color -- '0xD4B627'
        
        PL_CPanel.Color = CPanel.Color
        PLCpnl_addSong_Icon.Picture.loadFromStream(findTableFile('plus.png').Stream)
        PLCpnl_delSong_Icon.Picture.loadFromStream(findTableFile('minus.png').Stream)
        PLCpnl_playAll_Icon.Picture.loadFromStream(findTableFile('shuffle.png').Stream)
        PLCpnl_savePL_Icon.Picture.loadFromStream(findTableFile('ok.png').Stream)
        PLCpnl_loadPL_Icon.Picture.loadFromStream(findTableFile('refresh.png').Stream)
        PLCpnl_clearPL_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)
        PLCpnl_closePL_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)
        ----
        Mixer_Panel.Color = '0xFFEBEA'
        Mixer_in_Panel.Color = MF_ProgBarBack.Color
        MixerLabel.Font.Color = MDateLabel1.Font.Color
        MixerExit_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)
        MF_Marker.Font.Color = '0x85643B'
        Mgb_1_Label.Font.Color = MDateLabel1.Font.Color
        Mgb_2_LabelL.Font.Color = MDateLabel1.Font.Color
        Mgb_2_LabelR.Font.Color = MDateLabel1.Font.Color
        Mgb_3_LabelB.Font.Color = MDateLabel1.Font.Color
        Mgb_3_LabelB.Font.Name = 'Calibri'
        Mgb_3_LabelT.Font.Color = MDateLabel1.Font.Color
        MixerMVol_Icon.Picture.loadFromStream(findTableFile('buttonmasvol.png').Stream)
        MixerReset_Icon.Picture.loadFromStream(findTableFile('buttonreset.png').Stream)
        ----
        Tools_Panel.Color = '0xFFEBEA'
        Tools_in_Panel.Color = MF_ProgBarBack.Color
        ToolExit_Icon.Picture.loadFromStream(findTableFile('exit.png').Stream)
        Tool_ThemeLabel.Font.Color = MF_SongPathName1.Font.Color
        Tool_SetLabel.Font.Color = MF_SongPathName1.Font.Color
        TGtheme_Panel1.Color = MDateLabel2.Font.Color
        TGtheme_Panel2.Color = MF_SongPathName1.Font.Color
        TGtheme_Panel3.Color = MF_SongPathName1.Font.Color
        TGtheme_Pn1Lbl.Font.Color = MF_SongPathName1.Font.Color
        TGtheme_Pn2Lb2.Font.Color = MDateLabel2.Font.Color
        TGtheme_Pn3Lb3.Font.Color = MDateLabel2.Font.Color
        TGset_Panel1.Color = MDateLabel2.Font.Color
        TGset_Panel2.Color = MDateLabel2.Font.Color
        TGset_Panel3.Color = MDateLabel2.Font.Color
        TGset_Panel4.Color = MDateLabel2.Font.Color
        TGset_Panel5.Color = MDateLabel2.Font.Color
        TGSet_Pn1Lbl.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn2Lb2.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn3Lb3.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn4Lb4.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn5Lb5.Font.Color = MF_SongPathName1.Font.Color
        CP_Vol_TrckBar.Visible = true
        CP_Vol_TrckBar.Enabled = true
        Mgb_1_VlmTrBar.Visible = true
        Mgb_1_VlmTrBar.Enabled = true
        Mgb_2_VLTrBar.Visible = true
        Mgb_2_VLTrBar.Enabled = true
        Mgb_2_VRTrBar.Visible = true
        Mgb_2_VRTrBar.Enabled = true
        Mgb_3_VBTrBar.Visible = true
        Mgb_3_VBTrBar.Enabled = true
        Mgb_3_VTTrBar.Visible = true
        Mgb_3_VTTrBar.Enabled = true
    end
    ---=============================================================--- RED THEME
    function redBrTheme()
        colorON = MF_ProgBarFront.Color
        colorOFF = '0x1E2C84' --- MF_SongPathName1.Font.Color
        labelON = '0x1E2C84' --- MF_SongPathName1.Font.Color
        labelOFF = MDateLabel2.Font.Color
        CP_Vol_TrckBar.Visible = false
        CP_Vol_TrckBar.Enabled = false
        Mgb_1_VlmTrBar.Visible = false
        Mgb_1_VlmTrBar.Enabled = false
        Mgb_2_VLTrBar.Visible = false
        Mgb_2_VLTrBar.Enabled = false
        Mgb_2_VRTrBar.Visible = false
        Mgb_2_VRTrBar.Enabled = false
        Mgb_3_VBTrBar.Visible = false
        Mgb_3_VBTrBar.Enabled = false
        Mgb_3_VTTrBar.Visible = false
        Mgb_3_VTTrBar.Enabled = false
        TGtheme_Panel1.Enabled = true
        TGtheme_Panel2.Enabled = false
        TGtheme_Panel3.Enabled = true
        ----
        Mform.Color = '0x1D1324'
        MPicbg.Picture.loadFromStream(findTableFile('red_violin.jpg').Stream) -- 'red_sun.jpg'
        MF_Exit_Icon.Picture.loadFromStream(findTableFile('red_exit.png').Stream)
        MF_Marker.Font.Color = '0x5A5D73'
        MF_SongOnPause.Font.Color = '0x45CDDF'
        MF_SongOnMute.Font.Color = '0x45CDDF'
        MF_SongPathName.Font.Color = '0xF2F2EF'
        MF_SongPathName1.Font.Color = '0x8FEAF6'
        MF_SongFileSize.Font.Color = '0xF2F2EF'
        MF_SongFileSize1.Font.Color = '0x8FEAF6'
        MF_SongOnPlay.Font.Color = '0xF2F2EF'
        MF_SongDuration.Font.Color = '0x8FEAF6'
        MF_ProgBarBack.Color = '0x211E28' ---'0x3B64D4'
        MF_ProgBarFront.Color = '0x8FEAF6'
        MDateLabel1.Font.Color = '0xF2F2EF'
        MDateLabel2.Font.Color = '0xF2F2EF'
        MDateLabel3.Font.Color = '0xF2F2EF'
        ----
        CPanel.Color = '0x363FD0'
        CP_Folder_Icon.Picture.loadFromStream(findTableFile('red_finder.png').Stream)
        CP_Pause_Icon.Picture.loadFromStream(findTableFile('red_pause.png').Stream)
        CP_Resume_Icon.Picture.loadFromStream(findTableFile('red_resume.png').Stream)
        CP_Stop_Icon.Picture.loadFromStream(findTableFile('red_stop2.png').Stream)
        CP_Mixer_Icon.Picture.loadFromStream(findTableFile('red_mixer.png').Stream)
        CP_Playlist_Icon.Picture.loadFromStream(findTableFile('red_playlist.png').Stream)
        CP_Sound_Icon.Picture.loadFromStream(findTableFile('red_sound.png').Stream)
        CP_Mute_Icon.Picture.loadFromStream(findTableFile('red_mute.png').Stream)
        CP_Tool_Icon.Picture.loadFromStream(findTableFile('red_tool.png').Stream)
        ----
        PL_Panel.Color = '0x1D1324' ---MF_ProgBarBack.Color
        PL_PanelTitle.Color = MDateLabel2.Font.Color
        PL_PTLabel1.Font.Color = CPanel.Color
        PL_PTLabel2.Font.Color = CPanel.Color
        PL_listbox.Font.Color = MDateLabel2.Font.Color
        PL_listbox.Color = MF_ProgBarBack.Color -- PL_Panel.Color
        
        PL_CPanel.Color = CPanel.Color
        PLCpnl_addSong_Icon.Picture.loadFromStream(findTableFile('red_plus.png').Stream)
        PLCpnl_delSong_Icon.Picture.loadFromStream(findTableFile('red_minus.png').Stream)
        PLCpnl_playAll_Icon.Picture.loadFromStream(findTableFile('red_shuffle.png').Stream)
        PLCpnl_savePL_Icon.Picture.loadFromStream(findTableFile('red_ok.png').Stream)
        PLCpnl_loadPL_Icon.Picture.loadFromStream(findTableFile('red_refresh.png').Stream)
        PLCpnl_clearPL_Icon.Picture.loadFromStream(findTableFile('red_exit.png').Stream)
        PLCpnl_closePL_Icon.Picture.loadFromStream(findTableFile('red_exit.png').Stream)
        ----
        Mixer_Panel.Color = MDateLabel2.Font.Color
        Mixer_in_Panel.Color = MF_ProgBarBack.Color
        MixerLabel.Font.Color = MDateLabel1.Font.Color
        MixerExit_Icon.Picture.loadFromStream(findTableFile('red_exit.png').Stream)
        Mgb_1_Label.Font.Color = MDateLabel1.Font.Color
        Mgb_2_LabelL.Font.Color = MDateLabel1.Font.Color
        Mgb_2_LabelR.Font.Color = MDateLabel1.Font.Color
        Mgb_3_LabelB.Font.Color = MDateLabel1.Font.Color
        Mgb_3_LabelB.Font.Name = 'Calibri'
        Mgb_3_LabelT.Font.Color = MDateLabel1.Font.Color
        MixerMVol_Icon.Picture.loadFromStream(findTableFile('buttonmasvol.png').Stream)
        MixerReset_Icon.Picture.loadFromStream(findTableFile('buttonreset.png').Stream)
        ----
        Tools_Panel.Color = '0xFFEBEA'
        Tools_in_Panel.Color = MF_ProgBarBack.Color
        ToolExit_Icon.Picture.loadFromStream(findTableFile('red_exit.png').Stream)
        Tool_ThemeLabel.Font.Color = MDateLabel1.Font.Color
        Tool_SetLabel.Font.Color = MDateLabel1.Font.Color
        TGtheme_Panel1.Color = MF_SongPathName1.Font.Color
        TGtheme_Panel2.Color = MDateLabel2.Font.Color
        TGtheme_Panel3.Color = MF_SongPathName1.Font.Color
        TGtheme_Pn1Lbl.Font.Color = MDateLabel2.Font.Color
        TGtheme_Pn2Lb2.Font.Color = MF_SongPathName1.Font.Color
        TGtheme_Pn3Lb3.Font.Color = MDateLabel2.Font.Color
        TGset_Panel1.Color = MDateLabel2.Font.Color
        TGset_Panel2.Color = MDateLabel2.Font.Color
        TGset_Panel3.Color = MDateLabel2.Font.Color
        TGset_Panel4.Color = MDateLabel2.Font.Color
        TGset_Panel5.Color = MDateLabel2.Font.Color
        TGSet_Pn1Lbl.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn2Lb2.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn3Lb3.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn4Lb4.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn5Lb5.Font.Color = MF_SongPathName1.Font.Color
        CP_Vol_TrckBar.Visible = true
        CP_Vol_TrckBar.Enabled = true
        Mgb_1_VlmTrBar.Visible = true
        Mgb_1_VlmTrBar.Enabled = true
        Mgb_2_VLTrBar.Visible = true
        Mgb_2_VLTrBar.Enabled = true
        Mgb_2_VRTrBar.Visible = true
        Mgb_2_VRTrBar.Enabled = true
        Mgb_3_VBTrBar.Visible = true
        Mgb_3_VBTrBar.Enabled = true
        Mgb_3_VTTrBar.Visible = true
        Mgb_3_VTTrBar.Enabled = true
    end
    ---=============================================================--- GREEN THEME
    function greenTheme()
        colorON = MF_ProgBarFront.Color
        colorOFF = '0x1E2C84' --- MF_SongPathName1.Font.Color
        labelON = '0x1E2C84' --- MF_SongPathName1.Font.Color
        labelOFF = MDateLabel2.Font.Color
        CP_Vol_TrckBar.Visible = false
        CP_Vol_TrckBar.Enabled = false
        Mgb_1_VlmTrBar.Visible = false
        Mgb_1_VlmTrBar.Enabled = false
        Mgb_2_VLTrBar.Visible = false
        Mgb_2_VLTrBar.Enabled = false
        Mgb_2_VRTrBar.Visible = false
        Mgb_2_VRTrBar.Enabled = false
        Mgb_3_VBTrBar.Visible = false
        Mgb_3_VBTrBar.Enabled = false
        Mgb_3_VTTrBar.Visible = false
        Mgb_3_VTTrBar.Enabled = false
        TGtheme_Panel1.Enabled = true
        TGtheme_Panel2.Enabled = true
        TGtheme_Panel3.Enabled = false
        ----
        Mform.Color = '0x10543A'
        MPicbg.Picture.loadFromStream(findTableFile('green_party.jpg').Stream)
        MF_Exit_Icon.Picture.loadFromStream(findTableFile('green_exit.png').Stream)
        MF_Marker.Font.Color = '0x5A5D73'
        MF_SongOnPause.Font.Color = '0x45CDDF'
        MF_SongOnMute.Font.Color = '0x45CDDF'
        MF_SongPathName.Font.Color = '0xF2F2EF'
        MF_SongPathName1.Font.Color = '0x32CD32' ---'0x8FEAF6'
        MF_SongFileSize.Font.Color = '0xF2F2EF'
        MF_SongFileSize1.Font.Color = '0x32CD32' ---'0x8FEAF6'
        MF_SongOnPlay.Font.Color = '0xF2F2EF'
        MF_SongDuration.Font.Color = '0x32CD32' ---'0x8FEAF6'
        MF_ProgBarBack.Color = '0x393C32' ---'0x8CB280'
        MF_ProgBarFront.Color = '0x8CB280' ---'0x393C32'
        MDateLabel1.Font.Color = '0xF2F2EF'
        MDateLabel2.Font.Color = '0xF2F2EF'
        MDateLabel3.Font.Color = '0xF2F2EF'
        ----
        CPanel.Color = '0x8CB280'
        CP_Folder_Icon.Picture.loadFromStream(findTableFile('green_finder.png').Stream)
        CP_Pause_Icon.Picture.loadFromStream(findTableFile('green_pause.png').Stream)
        CP_Resume_Icon.Picture.loadFromStream(findTableFile('green_resume.png').Stream)
        CP_Stop_Icon.Picture.loadFromStream(findTableFile('green_stop2.png').Stream)
        CP_Mixer_Icon.Picture.loadFromStream(findTableFile('green_mixer.png').Stream)
        CP_Playlist_Icon.Picture.loadFromStream(findTableFile('green_playlist.png').Stream)
        CP_Sound_Icon.Picture.loadFromStream(findTableFile('green_sound.png').Stream)
        CP_Mute_Icon.Picture.loadFromStream(findTableFile('green_mute.png').Stream)
        CP_Tool_Icon.Picture.loadFromStream(findTableFile('green_tool.png').Stream)
        ----
        PL_Panel.Color = '0x393C32' ---MF_ProgBarBack.Color
        PL_PanelTitle.Color = MDateLabel2.Font.Color
        PL_PTLabel1.Font.Color = CPanel.Color
        PL_PTLabel2.Font.Color = CPanel.Color
        PL_listbox.Font.Color = MDateLabel2.Font.Color
        PL_listbox.Color = MF_ProgBarBack.Color -- PL_Panel.Color
        
        PL_CPanel.Color = CPanel.Color
        PLCpnl_addSong_Icon.Picture.loadFromStream(findTableFile('green_plus.png').Stream)
        PLCpnl_delSong_Icon.Picture.loadFromStream(findTableFile('green_minus.png').Stream)
        PLCpnl_playAll_Icon.Picture.loadFromStream(findTableFile('green_shuffle.png').Stream)
        PLCpnl_savePL_Icon.Picture.loadFromStream(findTableFile('green_ok.png').Stream)
        PLCpnl_loadPL_Icon.Picture.loadFromStream(findTableFile('green_refresh.png').Stream)
        PLCpnl_clearPL_Icon.Picture.loadFromStream(findTableFile('green_exit.png').Stream)
        PLCpnl_closePL_Icon.Picture.loadFromStream(findTableFile('green_exit.png').Stream)
        ----
        Mixer_Panel.Color = MDateLabel2.Font.Color
        Mixer_in_Panel.Color = MF_ProgBarBack.Color
        MixerLabel.Font.Color = MDateLabel1.Font.Color
        MixerExit_Icon.Picture.loadFromStream(findTableFile('green_exit.png').Stream)
        Mgb_1_Label.Font.Color = MDateLabel1.Font.Color
        Mgb_2_LabelL.Font.Color = MDateLabel1.Font.Color
        Mgb_2_LabelR.Font.Color = MDateLabel1.Font.Color
        Mgb_3_LabelB.Font.Color = MDateLabel1.Font.Color
        Mgb_3_LabelB.Font.Name = 'Calibri'
        Mgb_3_LabelT.Font.Color = MDateLabel1.Font.Color
        MixerMVol_Icon.Picture.loadFromStream(findTableFile('buttonmasvol.png').Stream)
        MixerReset_Icon.Picture.loadFromStream(findTableFile('buttonreset.png').Stream)
        ----
        Tools_Panel.Color = '0xFFEBEA'
        Tools_in_Panel.Color = MF_ProgBarBack.Color
        ToolExit_Icon.Picture.loadFromStream(findTableFile('green_exit.png').Stream)
        Tool_ThemeLabel.Font.Color = MDateLabel1.Font.Color
        Tool_SetLabel.Font.Color = MDateLabel1.Font.Color
        TGtheme_Panel1.Color = MF_SongPathName1.Font.Color
        TGtheme_Panel2.Color = MF_SongPathName1.Font.Color
        TGtheme_Panel3.Color = MDateLabel2.Font.Color
        TGtheme_Pn1Lbl.Font.Color = MDateLabel2.Font.Color
        TGtheme_Pn2Lb2.Font.Color = MDateLabel2.Font.Color
        TGtheme_Pn3Lb3.Font.Color = MF_SongPathName1.Font.Color
        TGset_Panel1.Color = MDateLabel2.Font.Color
        TGset_Panel2.Color = MDateLabel2.Font.Color
        TGset_Panel3.Color = MDateLabel2.Font.Color
        TGset_Panel4.Color = MDateLabel2.Font.Color
        TGset_Panel5.Color = MDateLabel2.Font.Color
        TGSet_Pn1Lbl.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn2Lb2.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn3Lb3.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn4Lb4.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn5Lb5.Font.Color = MF_SongPathName1.Font.Color
        CP_Vol_TrckBar.Visible = true
        CP_Vol_TrckBar.Enabled = true
        Mgb_1_VlmTrBar.Visible = true
        Mgb_1_VlmTrBar.Enabled = true
        Mgb_2_VLTrBar.Visible = true
        Mgb_2_VLTrBar.Enabled = true
        Mgb_2_VRTrBar.Visible = true
        Mgb_2_VRTrBar.Enabled = true
        Mgb_3_VBTrBar.Visible = true
        Mgb_3_VBTrBar.Enabled = true
        Mgb_3_VTTrBar.Visible = true
        Mgb_3_VTTrBar.Enabled = true
    end

    -------------------------------------------------------------------------------
    function shwdateoff()
        TGset_Panel1.Color = MF_SongPathName1.Font.Color
        TGset_Panel1.Enabled = false
        TGSet_Pn1Lbl.Cursor = -21
        TGSet_Pn1Lbl.Font.Style = 'fsBold'
        TGSet_Pn1Lbl.Font.Name = 'Calibri'
        TGSet_Pn1Lbl.Font.Color = MDateLabel2.Font.Color
        TGSet_Pn1Lbl.Font.Size = 9
        TGSet_Pn1Lbl.Caption = 'Date/Time   [OFF]'
        MDateLabel1.Visible = false
        MDateLabel2.Visible = false
    end

    function shwdateon()
        TGset_Panel1.Color = MDateLabel2.Font.Color
        TGset_Panel1.Enabled = true
        TGset_Panel1.Cursor = -21
        TGSet_Pn1Lbl.Font.Style = 'fsBold'
        TGSet_Pn1Lbl.Font.Name = 'Calibri'
        TGSet_Pn1Lbl.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn1Lbl.Font.Size = 9
        TGSet_Pn1Lbl.Caption = 'Date/Time   [ON]'
        MDateLabel1.Visible = true
        MDateLabel2.Visible = true
    end

    function shwclockoff()
        TGset_Panel2.Color = MF_SongPathName1.Font.Color
        TGset_Panel2.Enabled = false
        TGSet_Pn2Lb2.Cursor = -21
        TGSet_Pn2Lb2.Font.Style = 'fsBold'
        TGSet_Pn2Lb2.Font.Name = 'Calibri'
        TGSet_Pn2Lb2.Font.Color = MDateLabel2.Font.Color
        TGSet_Pn2Lb2.Font.Size = 9
        TGSet_Pn2Lb2.Caption = 'Clock      [OFF]'
        MDateLabel3.Visible = false
    end

    function shwclockon()
        TGset_Panel2.Color = MDateLabel2.Font.Color
        TGset_Panel2.Enabled = true
        TGset_Panel2.Cursor = -21
        TGSet_Pn2Lb2.Font.Style = 'fsBold'
        TGSet_Pn2Lb2.Font.Name = 'Calibri'
        TGSet_Pn2Lb2.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn2Lb2.Font.Size = 9
        TGSet_Pn2Lb2.Caption = 'Clock      [ON]'
        MDateLabel3.Visible = true
    end

    function shwpathoff()
        TGset_Panel3.Color = MF_SongPathName1.Font.Color
        TGset_Panel3.Enabled = false
        TGSet_Pn3Lb3.Cursor = -21
        TGSet_Pn3Lb3.Font.Style = 'fsBold'
        TGSet_Pn3Lb3.Font.Name = 'Calibri'
        TGSet_Pn3Lb3.Font.Color = MDateLabel2.Font.Color
        TGSet_Pn3Lb3.Font.Size = 9
        TGSet_Pn3Lb3.Caption = 'Path Name  [OFF]'
        MF_SongPathName.Visible = false
        MF_SongPathName1.Visible = false
    end

    function shwpathon()
        TGset_Panel3.Color = MDateLabel2.Font.Color
        TGset_Panel3.Enabled = true
        TGset_Panel3.Cursor = -21
        TGSet_Pn3Lb3.Font.Style = 'fsBold'
        TGSet_Pn3Lb3.Font.Name = 'Calibri'
        TGSet_Pn3Lb3.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn3Lb3.Font.Size = 9
        TGSet_Pn3Lb3.Caption = 'Path Name  [ON]'
        ck = tonumber(lengthMP3() / 1000)
        if ck == 0 then
            MF_SongPathName.Caption = ' '
        else
            MF_SongPathName.Caption = '>   Path Name'
        end
        MF_SongPathName.Visible = true
        MF_SongPathName1.Visible = true
    end

    function shwfileoff()
        TGset_Panel4.Color = MF_SongPathName1.Font.Color
        TGset_Panel4.Enabled = false
        TGSet_Pn4Lb4.Cursor = -21
        TGSet_Pn4Lb4.Font.Style = 'fsBold'
        TGSet_Pn4Lb4.Font.Name = 'Calibri'
        TGSet_Pn4Lb4.Font.Color = MDateLabel2.Font.Color
        TGSet_Pn4Lb4.Font.Size = 9
        TGSet_Pn4Lb4.Caption = 'File Size  [OFF]'
        MF_SongFileSize.Visible = false
        MF_SongFileSize1.Visible = false
    end

    function shwfileon()
        TGset_Panel4.Color = MDateLabel2.Font.Color
        TGset_Panel4.Enabled = true
        TGSet_Pn4Lb4.Cursor = -21
        TGSet_Pn4Lb4.Font.Style = 'fsBold'
        TGSet_Pn4Lb4.Font.Name = 'Calibri'
        TGSet_Pn4Lb4.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn4Lb4.Font.Size = 9
        TGSet_Pn4Lb4.Caption = 'File Size  [ON]'
        ck = tonumber(lengthMP3() / 1000)
        if ck == 0 then
            MF_SongFileSize.Caption = ' '
        else
            MF_SongFileSize.Caption = '>   File Size'
        end
        MF_SongFileSize.Visible = true
        MF_SongFileSize1.Visible = true
    end

    function shwsongoff()
        TGset_Panel5.Color = MF_SongPathName1.Font.Color
        TGset_Panel5.Enabled = false
        TGSet_Pn5Lb5.Cursor = -21
        TGSet_Pn5Lb5.Font.Style = 'fsBold'
        TGSet_Pn5Lb5.Font.Name = 'Calibri'
        TGSet_Pn5Lb5.Font.Color = MDateLabel2.Font.Color
        TGSet_Pn5Lb5.Font.Size = 9
        TGSet_Pn5Lb5.Caption = 'Song Name [OFF]'
        MF_SongOnPlay.Visible = false
    end

    function shwsongon()
        TGset_Panel5.Color = MDateLabel2.Font.Color
        TGset_Panel5.Enabled = true
        TGSet_Pn5Lb5.Cursor = -21
        TGSet_Pn5Lb5.Font.Style = 'fsBold'
        TGSet_Pn5Lb5.Font.Name = 'Calibri'
        TGSet_Pn5Lb5.Font.Color = MF_SongPathName1.Font.Color
        TGSet_Pn5Lb5.Font.Size = 9
        TGSet_Pn5Lb5.Caption = 'Song Name [ON]'
        MF_SongOnPlay.Visible = true
    end

    -- ========================================================================================--
    -- Expanse Main Form Size To Handle Song Playlist And Mixer Control
    -- ========================================================================================--
    Speed = 2
    Direction = ''
    PanelExpandSize = 400
    PanelBaseSize = 200
    p = Mform

    function PanelPop()
        if Direction == 'out' then
            if p.Height >= PanelExpandSize then
                Timer.Enabled = false
            else
                p.Height = p.Height + Speed
            end
        else
            if p.Height <= PanelBaseSize then
                Timer.Enabled = false
                PL_CPanel.Visible = true
                PL_listbox.Visible = true
                PL_PTLabel2Visible = true
                PL_PanelTitle.Visible = true
                PL_Panel.Visible = true
                Mixer_Panel.Visible = true
                Mixer_in_Panel.Visible = true
                Tools_Panel.Visible = true
                Tools_in_Panel.Visible = true
            else
                p.Height = p.Height - Speed
            end
        end
    end

    function showMenu()
        Direction = 'out'
        PL_CPanel.Visible = true
        PL_listbox.Visible = true
        PL_PTLabel2Visible = true
        PL_PanelTitle.Visible = true
        PL_Panel.Visible = true
        Mixer_Panel.Visible = false
        Mixer_in_Panel.Visible = false
        Tools_Panel.Visible = false
        Tools_in_Panel.Visible = false
        Timer.Enabled = true
        CP_Playlist_Icon.Enabled = false
        CP_Mixer_Icon.Enabled = true
        CP_Tool_Icon.Enabled = true
    end

    function closeMenu()
        Direction = 'in'
        Timer.Enabled = true
        CP_Playlist_Icon.Enabled = true
        CP_Mixer_Icon.Enabled = true
        CP_Tool_Icon.Enabled = true
    end

    function showMenu2()
        Direction = 'out'
        PL_CPanel.Visible = false
        PL_listbox.Visible = false
        PL_PTLabel2Visible = false
        PL_PanelTitle.Visible = false
        PL_Panel.Visible = false
        Tools_Panel.Visible = false
        Tools_in_Panel.Visible = false
        Mixer_Panel.Visible = true
        Mixer_in_Panel.Visible = true
        Timer.Enabled = true
        CP_Mixer_Icon.Enabled = false
        CP_Playlist_Icon.Enabled = true
        CP_Tool_Icon.Enabled = true
    end

    function closeMenu2()
        Direction = 'in'
        Timer.Enabled = true
        CP_Mixer_Icon.Enabled = true
        CP_Playlist_Icon.Enabled = true
        CP_Tool_Icon.Enabled = true
    end

    function showMenu3()
        Direction = 'out'
        PL_CPanel.Visible = false
        PL_listbox.Visible = false
        PL_PTLabel2Visible = false
        PL_PanelTitle.Visible = false
        PL_Panel.Visible = false
        Mixer_Panel.Visible = false
        Mixer_in_Panel.Visible = false
        Tools_Panel.Visible = true
        Tools_in_Panel.Visible = true
        Timer.Enabled = true
        CP_Mixer_Icon.Enabled = true
        CP_Playlist_Icon.Enabled = true
        CP_Tool_Icon.Enabled = false
    end

    function closeMenu3()
        Direction = 'in'
        Timer.Enabled = true
        CP_Mixer_Icon.Enabled = true
        CP_Playlist_Icon.Enabled = true
        CP_Tool_Icon.Enabled = true
    end

    Timer = createTimer(Mform)
    Timer.Interval = 1 --- 1/1000 second
    Timer.Enabled = false
    Timer.OnTimer = PanelPop

    -- ========================================================================================--
    -- Functions #1 : Load WINDOWS winmm.dll to manage media/MP3 player control
    -- ========================================================================================--
    --- Play sound using winmm.dll by mgr.Inz.Player Functions + some modifications by Corroder
    --- change here to get correct winmm.dll according to Windows version
    --- 32 bit---[[loadlibrary(C:\Windows\System32\winmm.dll)
    --- 64 bit---[[loadlibrary(C:\Windows\SysWOW64\winmm.dll)
    -- =========================================================================================--
    function initializeMP3Player()
        if initializeMP3Player_done then
            return true
        end

        local script64bit = [[loadlibrary(C:\Windows\System32\winmm.dll)
alloc(SimpleMp3Player,4096)
registersymbol(SimpleMp3Player)

SimpleMp3Player:
lea rsp,[rsp-28]
lea rsi,[rcx+400]

lea rdx,[rcx+300]
mov r8d,80
xor r9d,r9d
call mciSendStringW
mov rcx,rax
mov rdx,rsi
mov r8,200
call mciGetErrorStringW

lea rsp,[rsp+28]
ret]]

        local script32bit = [[loadlibrary(C:\Windows\System32\winmm.dll)
alloc(SimpleMp3Player,4096)
registersymbol(SimpleMp3Player)

SimpleMp3Player:
push ebp
mov ebp,esp
push ebx

mov ebx,[ebp+8]

sub esp,10
mov [esp],ebx
lea ebx,[ebx+300]
mov [esp+4],ebx
mov [esp+8],80
mov [esp+c],0
call mciSendStringW

mov ebx,[ebp+8]
lea ebx,[ebx+400]

sub esp,0c
mov [esp],eax
mov [esp+0x4],ebx
mov [esp+0x8],200
call mciGetErrorStringW

pop ebx
leave
ret 004]]

        if cheatEngineIs64Bit() then
            script = script64bit
        else
            script = script32bit
        end
        if autoAssemble(script, true) then
            initializeMP3Player_done = true
            MP3PlayerCommandMS = createMemoryStream()
            MP3PlayerCommandMS.Size = 2048
            return true
        else
            return false
        end
    end

    function MP3PlayerSendCommand(command)
        writeStringLocal(MP3PlayerCommandMS.Memory, command, true)
        writeBytesLocal(MP3PlayerCommandMS.Memory + 2 * #command, 0, 0)
        executeCodeLocal('SimpleMp3Player', MP3PlayerCommandMS.Memory)
        return readStringLocal(MP3PlayerCommandMS.Memory + 1024, 512, true),
            readStringLocal(MP3PlayerCommandMS.Memory + 768, 128, true)
    end

    function playMP3(path)
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('close MediaFile')
        MP3PlayerSendCommand(string.format('open "%s" type mpegvideo alias MediaFile', path))
        MP3PlayerSendCommand('play MediaFile')
    end

    function pauseMP3()
        if not initializeMP3Player() then
            return
        end
        if not MP3PlayerPaused then
            MP3PlayerSendCommand('pause MediaFile')
            MP3PlayerPaused = true
            -- MF_SongOnPlay.Visible = false
            MF_SongOnPause.Visible = true
            MF_SongOnPause.Caption = 'Pause '
            MF_SongOnMute.Left = MF_SongOnPause.Left + MF_SongOnPause.Width + 12
            CP_Pause_Icon.Visible = false
            CP_Resume_Icon.Visible = true
        else
            MP3PlayerSendCommand('resume MediaFile')
            MP3PlayerPaused = false
            MF_SongOnPause.Caption = ' '
            -- MF_SongOnPause.Visible = false
            MF_SongOnPlay.Visible = true
            CP_Pause_Icon.Visible = true
            CP_Resume_Icon.Visible = false
        end
    end

    function stopMP3()
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('stop MediaFile')
        MP3PlayerSendCommand('close MediaFile')
        progTimer.Enabled = false
        MF_SongOnPlay.Caption = ' '
        MF_SongOnPlay.Visible = false
        MF_SongPathName.Caption = ' '
        MF_SongPathName.Visible = false
        MF_SongPathName1.Caption = ' '
        MF_SongPathName1.Visible = false
        MF_SongFileSize.Caption = ' '
        MF_SongFileSize.Visible = false
        MF_SongFileSize1.Caption = ' '
        MF_SongFileSize1.Visible = false
        MF_ProgBarBack.Width = Mform.Width
        MF_ProgBarBack.Visible = false
        MF_ProgBarFront.Width = 0
        MF_ProgBarFront.Visible = false
        MF_SongDuration.Caption = ' '
        MF_SongDuration.Visible = false
        CP_Sound_Icon.Enabled = false
        CP_Pause_Icon.Enabled = false
        shuffleTimer.Enabled = false
    end

    function volumeMP3(vol)
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('setaudio MediaFile volume to ' .. vol)
    end

    function positionMP3()
        if not initializeMP3Player() then
            return
        end
        local a, b = MP3PlayerSendCommand('status MediaFile position')
        return tonumber(b) or 0
    end

    function lengthMP3()
        if not initializeMP3Player() then
            return
        end
        local a, b = MP3PlayerSendCommand('status MediaFile length')
        return tonumber(b) or 0
    end

    function durationMP3()
        if not initializeMP3Player() then
            return
        end
        local a, b = MP3PlayerSendCommand('status MediaFile length')
        return tonumber(b) or 0
    end

    function muteMP3()
        if not initializeMP3Player() then
            return
        end
        CP_Sound_Icon.Visible = false
        CP_Sound_Icon.Enabled = false
        CP_Mute_Icon.Visible = true
        CP_Mute_Icon.Enabled = true
        MP3PlayerSendCommand('setaudio MediaFile off')
        MF_SongOnMute.Caption = 'Sound off'
        MF_SongOnMute.Visible = true
        MF_SongOnMute.Left = MF_SongOnPause.Left + MF_SongOnPause.Width + 12
    end

    function UnmuteMP3()
        if not initializeMP3Player() then
            return
        end
        CP_Mute_Icon.Visible = false
        CP_Mute_Icon.Enabled = false
        CP_Sound_Icon.Visible = true
        CP_Sound_Icon.Enabled = true
        MP3PlayerSendCommand('setaudio MediaFile on')
        MF_SongOnMute.Caption = ' '
        MF_SongOnMute.Visible = false
    end

    function setBalanceMP3(balance)
        if not initializeMP3Player() then
            return
        end
        if (balance >= 0 and balance <= 1000) then
            MP3PlayerSendCommand('setaudio MediaFile left volume to ' .. (1000 - balance))
            MP3PlayerSendCommand('setaudio MediaFile right volume to ' .. balance)
        end
    end

    function volumeLeftMP3(volleft)
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('setaudio MediaFile left volume to ' .. volleft)
    end

    function volumeRightMP3(volright)
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('setaudio MediaFile right volume to ' .. volright)
    end

    function volumeBassMP3(volbass)
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('setaudio MediaFile bass to ' .. volbass)
    end

    function volumeTrebleMP3(voltreble)
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('setaudio MediaFile treble to ' .. voltreble)
    end

    function exploMP3()
        if not initializeMP3Player() then
            return
        end
        load_dialog = createOpenDialog(self)
        load_dialog.InitalDir = os.getenv('%USERPROFILE%')
        load_dialog.Filter = 'MP3 files|*.mp3|*'
        -- load_dialog.Filter = 'Audio files|*.mp3;*.mid;*.wav;*.wma|Mp3 files (*.mp3)|*.MP3|Mid files (*.mid)|*.MID|Wav files (*.wav)|*.WAV|Wma files (*.wma)|*.WMA|*'
        load_dialog.execute()
        local file = load_dialog.FileName
        local sfile = load_dialog.FileName
        local a = GetFileName(file)
        local b = GetFileName(sfile)
        if file then
            progTimer.Enabled = false
            default()
            local pathname, songname = file:match('(.*\\)(.*)%.mp3')
            if songname then
                filesize = fsize(b)
                MF_SongOnPause.Caption = ' '
                MF_SongOnPause.Visible = false
                MF_SongPathName.Caption = '>   Path Name'
                MF_SongPathName.Visible = true
                MF_SongPathName1.Visible = true
                MF_SongPathName1.Caption = pathname
                MF_SongFileSize.Caption = '>   File Size'
                MF_SongFileSize.Visible = true
                MF_SongFileSize1.Visible = true
                MF_SongFileSize1.Caption = filesize
                MF_SongOnPlay.Visible = true
                MF_SongOnPlay.Caption = '<  ' .. songname .. '.mp3   '
                MF_SongDuration.Caption = ' '
                MF_SongDuration.Visible = true
                MF_ProgBarBack.Visible = true
                MF_ProgBarFront.Width = 0
                MF_ProgBarFront.Visible = true
                playMP3(a)
                progTimer.Enabled = true
                volumeMP3(CP_Vol_TrckBar.Position * 10)
                CP_Sound_Icon.Enabled = true
                CP_Pause_Icon.Enabled = true
            end
        end
    end

    function volBarChg()
        volumeMP3(CP_Vol_TrckBar.Position * 10)
    end

    function openVolCtrl()
        -- shellExecute("C:\\Windows\\SysWOW64\\SndVol.exe") -- 64 but
        shellExecute("C:\\Windows\\System32\\SndVol.exe") -- 32 bit
    end

    function balanceChg()
        setBalanceMP3(Mgb_1_VlmTrBar.Position * 10)
    end

    function volLeftChg()
        volumeLeftMP3(Mgb_2_VLTrBar.Position * 10)
    end

    function volRightChg()
        volumeRightMP3(Mgb_2_VRTrBar.Position * 10)
    end

    function volBassChg()
        volumeBassMP3(Mgb_3_VBTrBar.Position * 10)
    end

    function volTrebleChg()
        volumeTrebleMP3(Mgb_3_VTTrBar.Position * 10)
    end

    function resetMixer()
        Mgb_1_VlmTrBar.Position = 50
        Mgb_2_VLTrBar.Position = 50
        Mgb_2_VRTrBar.Position = 50
        Mgb_3_VBTrBar.Position = 50
        Mgb_3_VTTrBar.Position = 50
    end

    progTimer = createTimer(nil, false)
    progTimer.Interval = 100
    progTimer.OnTimer = function()
        --- synchronizing bar max length with song duration
        songLength = tonumber(lengthMP3() / 1000) --- e.q = 200000/1000 = 200
        barMax = 399 --- = Progbar_back.width
        pos = tonumber(positionMP3() / 1000) --- get current elapse pos time in second
        ratio = pos / songLength * barMax --- get ratio
        
        MF_ProgBarFront.Width = ratio --- bind ratio to bar
        --- calculating elapsed to song duration in time format to show in label
        sglength = tonumber(lengthMP3())
        postime = (tonumber(durationMP3()) - (sglength - positionMP3())) / 1000
        elapsedTime = SecondsToClock(postime)
        sgd = SecondsToClock(songLength)
        MF_SongDuration.Caption = elapsedTime .. ' / ' .. sgd
        if elapsedTime == sgd then
            pos = 0
            ratio = 0
            sqlength = 0
            postime = 0
            songLength = 0
            elapsedTime = ' '
            sgd = ' '
            default()
        end
    end

    function default()
        MF_SongOnPause.Caption = ' '
        MF_SongOnPause.Visible = false
        MF_SongOnMute.Caption = ' '
        MF_SongOnMute.Visible = false
        MF_SongOnPlay.Caption = ' '
        MF_SongOnPlay.Visible = false
        MF_SongPathName.Caption = ' '
        MF_SongPathName.Visible = false
        MF_SongPathName1.Caption = ' '
        MF_SongPathName1.Visible = false
        MF_SongFileSize.Caption = ' '
        MF_SongFileSize.Visible = false
        MF_SongFileSize1.Caption = ' '
        MF_SongFileSize1.Visible = false
        MF_ProgBarBack.Width = Mform.Width
        MF_ProgBarBack.Visible = false
        MF_ProgBarFront.Width = 0
        MF_ProgBarFront.Visible = false
        MF_SongDuration.Caption = ' '
        MF_SongDuration.Visible = false
        CP_Sound_Icon.Enabled = false
        CP_Pause_Icon.Enabled = false
    end

    -- ===================================================================================================================--
    -- Functions #2 : Getting File With MP3 Filtering From Local Device Storage ++ Info : Name, Path Name, Size, Duration
    -- ===================================================================================================================--
    function GetFileName(f)
        local str = f
        local temp = ""
        local result = ""
        for i = str:len(), 1, -1 do
            if str:sub(i, i) ~= "/" then
                temp = temp .. str:sub(i, i)
            else
                break
            end
        end
        for j = temp:len(), 1, -1 do
            result = result .. temp:sub(j, j)
        end
        return result
    end

    function round(x, n)
        n = math.pow(10, n or 0)
        x = x * n
        if x >= 0 then
            x = math.floor(x + 0.5)
        else
            x = math.ceil(x - 0.5)
        end
        return x / n
    end

    function fsize(fl)
        fl, err = io.open(fl, "r")
        if fl then
            local current = fl:seek()
            local size = fl:seek("end")
            fl:seek("set", current)
            fl:close()
            size = size / 1024
            size = round(size, 2)
            stringsize = string.format(size) .. ' Kb'
        else
            print(err)
        end
        return stringsize
    end

    function SecondsToClock(seconds)
        local seconds = tonumber(seconds)
        if seconds <= 0 then
            return "00:00:00";
        else
            hours = string.format("%02.f", math.floor(seconds / 3600));
            mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
            secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
            return hours .. ":" .. mins .. ":" .. secs
        end
    end

    -- ========================================================================================--
    -- Functions #3 : Marquee Text to show playing song name  -- use for LABEL : MF_SongOnPlay
    -- ========================================================================================--
    local function getRoot(c)
        local p, q = c.Parent, c;
        while p do
            p, q = p.Parent, p
        end
        return q
    end
    local isTrainer = TrainerOrigin -- it is actually the path of cetrainer executed, nil during debug
    
    local function dp(...)
        if not isTrainer then
            print(...)
        end
    end
    local TimerPool = {}

    local function marquee(T)
        local NameID = getRoot(T).Name .. '|' .. T.Name
        if TimerPool[NameID] == nil then
            local tm = createTimer(T)
            TimerPool[NameID] = tm
            tm.toRight = function()
                tm.Direction = 1
            end
            tm.toLeft = function()
                tm.Direction = -1
            end
            tm.setText = function(t)
                if T.setCaption then
                    T.setCaption(t)
                end
                if T.Text then
                    T.Text = t
                end
            end
            tm.getText = function(t)
                if T.setCaption then
                    return T.getCaption(t)
                end
                if T.Text then
                    return T.Text
                end
            end
            tm.start = function()
                tm.Enabled = true
            end
            tm.stop = function()
                tm.Enabled = false
            end
            tm.OnTimer = function()
                local s = tm.getText();
                local l = string.len(s)
                local dir = tonumber(tm.Direction, 10) or tm.Direction or 1
                if l > 1 then
                    if dir < 0 then
                        tm.setText(string.sub(s, 2, l) .. string.sub(s, 1, 1))
                    else
                        tm.setText(string.sub(s, l, l) .. string.sub(s, 1, l - 1))
                    end
                    T.update()
                end
            end
            tm.release = function()
                TimerPool[NameID] = nil
                tm.Enabled = false
                tm.destroy()
                tm = nil
            end
        end
        TimerPool[NameID].Direction = 1
        TimerPool[NameID].Interval = 700 ---1000
        TimerPool[NameID].Enabled = false
        return TimerPool[NameID]
    end

    -- need to kill timers during debug, adapt to main form close handler
    Mform.OnClose = function(sender)
        local f = caHide
        if isTrainer then
            f = caFree
        end
        for k, v in pairs(TimerPool) do
            if v then
                v.destroy();
                TimerPool[k] = nil;
                dp('timer for ' .. k .. ' killed')
            end
        end
        return f
    end

    local marqE = marquee(MF_SongOnPlay)
    marqE.toLeft()
    marqE.start()

    function exitMP3()
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('close MediaFile')
        stopMP3()
        closeCE()
        return caFree
    end

    -- ==============================================================================--
    -- Functions #4 : Make Table, Save / Load Items For Song Playlist
    -- ==============================================================================--
    tab = {}

    do
        local function exportstring(s)
            s = string.format("%q", s)
            s = string.gsub(s, "\\\n", "\\n")
            s = string.gsub(s, "\r", "\\r")
            s = string.gsub(s, string.char(26), "\"..string.char(26)..\"")
            return s
        end

        function table.save(tbl, filename)
            local charS, charE = "   ", "\n"
            local file, err
            if not filename then
                file = {
                    write = function(self, newstr)
                        self.str = self.str .. newstr
                    end,
                    str = ""
                }
                charS, charE = "", ""
            elseif filename == true or filename == 1 then
                charS, charE, file = "", "", io.tmpfile()
            else
                file, err = io.open(filename, "w")
                if err then
                    return _, err
                end
            end
            local tables, lookup = {tbl}, {
                [tbl] = 1
            }
            file:write("return {" .. charE)
            for idx, t in ipairs(tables) do
                if filename and filename ~= true and filename ~= 1 then
                    file:write("-- Table: {" .. idx .. "}" .. charE)
                end
                file:write("{" .. charE)
                local thandled = {}
                for i, v in ipairs(t) do
                    thandled[i] = true
                    if type(v) ~= "userdata" then
                        if type(v) == "table" then
                            if not lookup[v] then
                                table.insert(tables, v)
                                lookup[v] = #tables
                            end
                            file:write(charS .. "{" .. lookup[v] .. "}," .. charE)
                        elseif type(v) == "function" then
                            file:write(charS .. "loadstring(" .. exportstring(string.dump(v)) .. ")," .. charE)
                        else
                            local value = (type(v) == "string" and exportstring(v)) or tostring(v)
                            file:write(charS .. value .. "," .. charE)
                        end
                    end
                end
                for i, v in pairs(t) do
                    if (not thandled[i]) and type(v) ~= "userdata" then
                        if type(i) == "table" then
                            if not lookup[i] then
                                table.insert(tables, i)
                                lookup[i] = #tables
                            end
                            file:write(charS .. "[{" .. lookup[i] .. "}]=")
                        else
                            local index = (type(i) == "string" and "[" .. exportstring(i) .. "]") or
                                              string.format("[%d]", i)
                            file:write(charS .. index .. "=")
                        end
                        if type(v) == "table" then
                            if not lookup[v] then
                                table.insert(tables, v)
                                lookup[v] = #tables
                            end
                            file:write("{" .. lookup[v] .. "}," .. charE)
                        elseif type(v) == "function" then
                            file:write("loadstring(" .. exportstring(string.dump(v)) .. ")," .. charE)
                        else
                            local value = (type(v) == "string" and exportstring(v)) or tostring(v)
                            file:write(value .. "," .. charE)
                        end
                    end
                end
                file:write("}," .. charE)
            end
            file:write("}")
            if not filename then
                return file.str .. "--|"
            elseif filename == true or filename == 1 then
                file:seek("set")
                return file:read("*a") .. "--|"
            else
                file:close()
                return 1
            end
        end

        function table.load(sfile)
            local tables, err, _
            if string.sub(sfile, -3, -1) == "--|" then
                tables, err = loadstring(sfile)
            else
                tables, err = loadfile(sfile)
            end
            if err then
                return _, err
            end
            tables = tables()
            for idx = 1, #tables do
                local tolinkv, tolinki = {}, {}
                for i, v in pairs(tables[idx]) do
                    if type(v) == "table" and tables[v[1]] then
                        table.insert(tolinkv, {i, tables[v[1]]})
                    end
                    if type(i) == "table" and tables[i[1]] then
                        table.insert(tolinki, {i, tables[i[1]]})
                    end
                end
                for _, v in ipairs(tolinkv) do
                    tables[idx][v[1]] = v[2]
                end
                for _, v in ipairs(tolinki) do
                    tables[idx][v[2]], tables[idx][v[1]] = tables[idx][v[1]], nil
                end
            end
            return tables[1]
        end
    end

    function clearTable(tb)
        for i, v in pairs(tb) do
            tb[i] = nil
        end
    end

    function tablelength(T)
        local count = 0
        for _ in pairs(T) do
            count = count + 1
        end
        return count
    end

    function file_check(file_name)
        local file_found = io.open(file_name, "r")
        if file_found == nil then
            return file_found
        else
            io.close(file_found)
            -- loadFromfile()
        end
        return file_found
    end

    function addSong2PL()
        list = PL_listbox
        load_dialog = createOpenDialog(self)
        load_dialog.InitalDir = os.getenv('%USERPROFILE%')
        load_dialog.Filter = 'MP3 files|*.mp3|*'
        load_dialog.execute()
        local file = load_dialog.FileName
        if file then
            list.Items.Add(file)
        end
        tab = {}
        clearTable(tab)
        list.itemIndex = 0
        z = list.items.Count
        for i = 0, z - 1 do
            tab[i] = list.items[i]
            list.Sorted = true
        end
        table.sort(tab)
        return tab
    end

    function message_ok()
        player_path = TrainerOrigin or getCheatEngineDir() -- getMainForm()
        Msg_Label.Caption = ' '
        Msgform.Hide()
        Msgform.Visible = false
        Msg_Yes_Icon.Visible = false
        Msg_No_Icon.Visible = false
        Mform.Enabled = true
        return player_path
    end

    function save2file()
        player_path = TrainerOrigin or getCheatEngineDir() -- getMainForm()
        table.save(tab, player_path .. '\\myplaylist.lua')
        Msgform.Visible = true
        Msgform.Show()
        Msg_Label.Caption = 'Playlist has been saved'
        Msg_Label.Left = (Msg_Panel.Width - Msg_Label.Width) / 2
        Msg_Ok_Icon.Visible = true
        Mform.Enabled = false
        -- return player_path
    end

    function loadFromfile()
        player_path = TrainerOrigin or getCheatEngineDir() -- getMainForm()
        if file_check('myplaylist.lua') == nil then
            return nil
        else
            tab = {}
            clearTable(tab)
            list = PL_listbox
            list.clear()
            player_path = TrainerOrigin or getCheatEngineDir() -- getMainForm()
            tab, err = table.load(player_path .. '\\myplaylist.lua')
            assert(err == nil)
            a = tablelength(tab)
            for x = 0, a do
                list.Items.Add(tab[x])
            end
        end
        return player_path
    end

    function removeSong()
        list = PL_listbox
        x = list.itemIndex
        list.items.Delete(x)
    end

    function message_yes()
        list = PL_listbox
        list.clear()
        clearTable(tab)
        save2file()
        Msg_Label.Caption = 'Playlist cleared and empty..!!'
        Msg_Label.Left = (Msg_Panel.Width - Msg_Label.Width) / 2
        Msg_Yes_Icon.Visible = false
        Msg_No_Icon.Visible = false
        Msg_Ok_Icon.Visible = true
        Mform.Enabled = false
    end

    function message_no()
        Msg_Label.Caption = 'Clearing Playlist Canceled'
        Msg_Label.Left = (Msg_Panel.Width - Msg_Label.Width) / 2
        Msg_Yes_Icon.Visible = false
        Msg_No_Icon.Visible = false
        Msg_Ok_Icon.Visible = true
        Mform.Enabled = false
    end

    function clearSongs()
        Msgform.Show()
        Msg_Label.Caption = 'Are you sure delete playlist?'
        Msg_Label.Left = (Msg_Panel.Width - Msg_Label.Width) / 2
        Msg_Ok_Icon.Visible = false
        Msg_Yes_Icon.Visible = true
        Msg_No_Icon.Visible = true
        Mform.Enabled = false
    end

    function playSinglePL()
        if not initializeMP3Player() then
            return
        end
        MP3PlayerSendCommand('stop MediaFile')
        MP3PlayerSendCommand('close MediaFile')
        list = PL_listbox
        f = list.itemIndex
        f_item = list.Items[f]
        if f_item then
            progTimer.Enabled = false
            default()
            local pathname, songname = f_item:match('(.*\\)(.*)%.mp3')
            if songname then
                filesize = fsize(f_item)
                MF_SongOnPause.Caption = ' '
                MF_SongOnPause.Visible = false
                MF_SongPathName.Caption = '>   Path Name'
                MF_SongPathName.Visible = true
                MF_SongPathName1.Visible = true
                MF_SongPathName1.Caption = pathname
                MF_SongFileSize.Caption = '>   File Size'
                MF_SongFileSize.Visible = true
                MF_SongFileSize1.Visible = true
                MF_SongFileSize1.Caption = filesize
                MF_SongOnPlay.Visible = true
                MF_SongOnPlay.Caption = '<  ' .. songname .. '.mp3   '
                MF_SongDuration.Caption = ' '
                MF_SongDuration.Visible = true
                MF_ProgBarBack.Visible = true
                MF_ProgBarFront.Width = 0
                MF_ProgBarFront.Visible = true
                playMP3(f_item)
                progTimer.Enabled = true
                volumeMP3(CP_Vol_TrckBar.Position * 10)
                CP_Sound_Icon.Enabled = true
                CP_Pause_Icon.Enabled = true
            end
        end
    end

    function shuffleIndex()
        if not initializeMP3Player() then
            return
        end
        if currentSong then
            local pathname, songname = currentSong:match('(.*\\)(.*)%.mp3')
            if songname then
                progTimer.Enabled = false
                default()
                filesize = fsize(currentSong)
                MF_SongOnPause.Caption = ' '
                MF_SongOnPause.Visible = false
                MF_SongPathName.Caption = '>   Path Name'
                MF_SongPathName.Visible = true
                MF_SongPathName1.Visible = true
                MF_SongPathName1.Caption = pathname
                MF_SongFileSize.Caption = '>   File Size'
                MF_SongFileSize.Visible = true
                MF_SongFileSize1.Visible = true
                MF_SongFileSize1.Caption = filesize
                MF_SongOnPlay.Visible = true
                MF_SongOnPlay.Caption = '<  ' .. songname .. '.mp3   '
                MF_SongDuration.Caption = ' '
                MF_SongDuration.Visible = true
                MF_ProgBarBack.Visible = true
                MF_ProgBarFront.Width = 0
                MF_ProgBarFront.Visible = true
                playMP3(currentSong)
                progTimer.Enabled = true
                shuffleTimer.Enabled = true
                volumeMP3(CP_Vol_TrckBar.Position * 10)
                CP_Sound_Icon.Enabled = true
                CP_Pause_Icon.Enabled = true
            end
        end
    end

    function playShuffle()
        list = PL_listbox
        song_index = list.itemIndex
        if song_index == -1 then
            return nil
        end
        song_index = 0
        song_numbers = list.Items.Count
        currentSong = list.Items[song_index]
        shuffleIndex()
        progTimer.Enabled = true
        shuffleTimer.Enabled = true
        if song_index > song_numbers then
            progTimer.Enabled = false
            shuffleTimer.Enabled = false
        end
    end

    shuffleTimer = createTimer(nil, false)
    shuffleTimer.Interval = 100
    shuffleTimer.OnTimer = function()
        ending = tonumber(lengthMP3())
        elapse = (tonumber(durationMP3()) - (ending - positionMP3()))
        if (ending - elapse) == 0 then
            if song_index < song_numbers - 1 then
                song_index = song_index + 1
                currentSong = list.Items[song_index]
                shuffleIndex()
            else
                song_index = 0
            end
        end
    end

    -- ==================================================================--
    -- Functions #5 : Drag Main Form followed by sub form (Mform2)
    -- ==================================================================--
    function DragIt()
        Mform.DragNow()
        Mform2.Top = Mform.Top + Mform.Height
        Mform2.Left = Mform.Left
    end

    function DragIt2()
        Mform.DragNow()
        Mform2.Top = Mform.Top + Mform.Height
        Mform2.Left = Mform.Left
    end

    ---==================================================================--
    --- Check and set trianer setting environement
    ---==================================================================--
    Mform.show()
    Msgform.hide()
    player_path = TrainerOrigin or getCheatEngineDir() -- getMainForm()
    file_check(player_path .. '\\myplaylist.lua')
    loadFromfile()

    ---============================== Event
    CP_Vol_TrckBar.onChange = volBarChg
    Mgb_1_VlmTrBar.onChange = balanceChg
    Mgb_2_VLTrBar.onChange = volLeftChg
    Mgb_2_VRTrBar.onChange = volRightChg
    Mgb_3_VBTrBar.onChange = volBassChg
    Mgb_3_VTTrBar.onChange = volTrebleChg

    CP_Folder_Icon.onClick = exploMP3
    CP_Pause_Icon.onClick = pauseMP3
    CP_Resume_Icon.onClick = pauseMP3
    CP_Stop_Icon.onClick = stopMP3
    CP_Sound_Icon.onClick = muteMP3
    CP_Mute_Icon.onClick = UnmuteMP3
    CP_Playlist_Icon.onClick = showMenu
    PLCpnl_closePL_Icon.onClick = closeMenu
    PLCpnl_addSong_Icon.onClick = addSong2PL
    PLCpnl_delSong_Icon.onClick = removeSong
    PLCpnl_playAll_Icon.onClick = playShuffle
    PLCpnl_savePL_Icon.onClick = save2file
    PLCpnl_loadPL_Icon.onClick = loadFromfile
    PLCpnl_clearPL_Icon.onClick = clearSongs
    PL_listbox.onDblClick = playSinglePL

    MixerMVol_Icon.onClick = openVolCtrl
    MixerReset_Icon.onClick = resetMixer
    CP_Mixer_Icon.onClick = showMenu2
    MixerExit_Icon.onClick = closeMenu2
    CP_Tool_Icon.onClick = showMenu3
    ToolExit_Icon.onClick = closeMenu3

    TGtheme_Panel1.onClick = defaultTheme
    TGtheme_Panel2.onClick = redBrTheme
    TGtheme_Panel3.onClick = greenTheme
    TGset_Panel1.onClick = shwdateoff
    TGSet_Pn1Lbl.onClick = shwdateon
    TGset_Panel2.onClick = shwclockoff
    TGSet_Pn2Lb2.onClick = shwclockon
    TGset_Panel3.onClick = shwpathoff
    TGSet_Pn3Lb3.onClick = shwpathon
    TGset_Panel4.onClick = shwfileoff
    TGSet_Pn4Lb4.onClick = shwfileon
    TGset_Panel5.onClick = shwsongoff
    TGSet_Pn5Lb5.onClick = shwsongon

    Msg_Yes_Icon.onClick = message_yes
    Msg_No_Icon.onClick = message_no
    Msg_Ok_Icon.onClick = message_ok
    MF_Exit_Icon.onClick = exitMP3

    -- ======================================--
    -- Add/Insert new menu to CE Main Menu
    -- ======================================--
    local mainForm = getMainForm()
    local musicMenu = createMenuItem(mainForm)
    musicMenu.Caption = [[CE Music]]

    musicMenu.onClick = musicMenuClick
    mainForm.PopupMenu2.Items.insert(15, musicMenu)

    local mainMenu = mainForm.Menu.Items
    local miMusic
    for i = 0, mainMenu.Count - 1 do
        if mainMenu[i].Name == 'miMusic' then
            miExtra = mainMenu[i]
        end
    end
    if miMusic == nil then
        miMusic = createMenuItem(mainForm)
        miMusic.Name = 'miMusic'
        miMusic.Caption = 'CE Music'
        mainMenu.insert(mainMenu.Count - 2, miMusic)
    end

    -- ==============================================--
    -- Add "CE Mp3 Player" item to "CE Music" submenu
    -- ==============================================--
    local miMP3Player = createMenuItem(miColor)
    miMP3Player.Caption = 'CE Mp3 Player'
    miMP3Player.onClick = musicMenuClick
    miMusic.add(miMP3Player)
end
