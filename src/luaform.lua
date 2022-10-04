local format = string.format
local strE = string.empty or STRING_EMPTY or ''
local t = translate


local LineEnd = '\r\n'

local CreateMainFormMenuItems = true
local MainMenuItemName = 'ools1' --'miTools' -- 'ools1'
local MainMenuItemCaption = t('Tools')
local ToolMenuItemCaption = t('CE Form to LUA')
local ToolFormCaption = t('Convert CE Form to Lua script')

local StringDel = { '\'', '\'' }

local controlPropertyList = {
   Tag = true,
   Left = true,
   Height = true,
   Hint = true,
   Top = true,
   Width = true,
   HelpType = true,
   HelpKeyword = true,
   HelpContext = true,
   Align = true,
   AllowDropFiles = true,
   AlphaBlend = true,
   AlphaBlendValue = true,
   Anchors = true,
   AutoScroll = true,
   AutoSize = true,
   BiDiMode = true,
   BorderIcons = true,
   BorderStyle = true,
   BorderWidth = true,
   Caption = true,
   ClientHeight = true,
   ClientWidth = true,
   Color = true,
   Constraints = true,
   MaxWidth = true,
   MinHeight = true,
   MinWidth = true,
   DefaultMonitor = true,
   DockSite = true,
   DragKind = true,
   DragMode = true,
   Font = true,
   Name = true,
   Orientation = true,
   Pitch = true,
   Quality = true,
   Size = true,
   Style = true,
   FormStyle = true,
   KeyPreview = true,
   Menu = true,
   ParentBiDiMode = true,
   ParentFont = true,
   PixelsPerInch = true,
   PopupMenu = true,
   Position = true,
   ShowInTaskBar = true,
   Visible = true,
   WindowState = true,
   DoNotSaveInTable = true,
   BidiMode = true,
   BorderSpacing = true,
   Cancel = true,
   Default = true,
   Enabled = true,
   ModalResult = true,
   ParentShowHint = true,
   ShowHint = true,
   TabOrder = true,
   TabStop = true,
   Alignment = true,
   Layout = true,
   ParentBidiMode = true,
   ParentColor = true,
   ShowAccelChar = true,
   Transparent = true,
   WordWrap = true,
   OptimalFill = true,
   AllowGrayed = true,
   Checked = true,
   DragCursor = true,
   State = true,
   AutoFill = true,
   ColumnLayout = true,
   ItemIndex = true,
   ClickOnSelChange = true,
   ExtendedSelect = true,
   IntegralHeight = true,
   ItemHeight = true,
   MultiSelect = true,
   Sorted = true,
   TopIndex = true,
   ArrowKeysTraverseList = true,
   AutoComplete = true,
   AutoCompleteText = true,
   AutoDropDown = true,
   AutoSelect = true,
   CharCase = true,
   DropDownCount = true,
   ItemWidth = true,
   MaxLength = true,
   ReadOnly = true,
   Text = true,
   Max = true,
   Min = true,
   Smooth = true,
   Step = true,
   BarShowText = true,
   Frequency = true,
   LineSize = true,
   PageSize = true,
   Reversed = true,
   ScalePos = true,
   SelEnd = true,
   SelStart = true,
   ShowSelRange = true,
   TickMarks = true,
   TickStyle = true,
   AutoExpand = true,
   BackgroundColor = true,
   DefaultItemHeight = true,
   ExpandSignColor = true,
   ExpandSignType = true,
   HideSelection = true,
   HotTrack = true,
   Indent = true,
   MultiSelectStyle = true,
   RightClickSelect = true,
   RowSelect = true,
   ScrollBars = true,
   SelectionColor = true,
   SelectionFontColor = true,
   SelectionFontColorUsed = true,
   SeparatorColor = true,
   ShowButtons = true,
   ShowLines = true,
   ShowRoot = true,
   SortType = true,
   StateImages = true,
   ToolTips = true,
   Options = true,
   TreeLineColor = true,
   TreeLinePenStyle = true,
   AllocBy = true,
   AutoSort = true,
   Checkboxes = true,
   ColumnClick = true,
   OwnerData = true,
   ShowColumnHeaders = true,
   SortColumn = true,
   SortDirection = true,
   ViewStyle = true,
   BevelInner = true,
   BevelOuter = true,
   BevelWidth = true,
   FullRepaint = true,
   UseDockManager = true,
   AutoSnap = true,
   Beveled = true,
   MinSize = true,
   ResizeAnchor = true,
   ResizeStyle = true,
   Center = true,
   Proportional = true,
   Stretch = true,
   -------------------------
   AnchorSideLeft = false,
   AnchorSideTop = false,
   AnchorSideRight = false,
   AnchorSideBottom = false,
   HorzScrollBar = false,
   VertScrollBar = false,
   ChildSizing = false,
   Cursor = false,
   Icon = false,
   IconOptions = false,
   Picture = false,
   Images = false,
   Columns = false,
   Items = false,
}
local controlPropertyStrings = {
   Name = true,
   Hint = true,
   HelpKeyword = true,
   Caption = true,
   Anchors = true,
   BorderIcons = true,
   Style = true,
   AutoCompleteText = true,
   MultiSelectStyle = true,
   Options = true,
}
local controlPropertyGroups = {
   Font = true,
   Constraints = true,
   BorderSpacing = true,
}

local controlConstructors = {
   -- TRadioButton = 'createRadioGroup',
   TScrollBox = true,
   TRadioButton = true,
}

local usedKeys = {}
local printUnusedKeys = false



local function getConstructor(control)
   ---- Could use 'createComponentClass'
   local action = 'create' .. control.ClassName:gsub('TCE', strE)
   local callStr = '(%s)'
   local parentStr = (control.Parent and control.Parent.Name) or strE
   if controlConstructors[control.ClassName] == true then
      action = 'createComponentClass'
      callStr = '(' .. StringDel[1] .. control.ClassName .. StringDel[2] .. '%s)'
      if parentStr ~= strE then
         parentStr =  ', ' .. parentStr
      end
   elseif type(controlConstructors[control.ClassName]) == 'string' then
      action = controlConstructors[control.ClassName]
   end
   return action .. format(callStr, parentStr)
end


local function getPropertiesScript(control, parentStr)
   local script = strE
   local pl = getPropertyList(control)
   if pl then
      for i = 1, pl.Count - 1 do
         if controlPropertyGroups[pl[i]] then
            script = script .. getPropertiesScript(control[pl[i]], format('%s.%s', parentStr, pl[i]))
         elseif controlPropertyList[pl[i]] then
            if control[pl[i]] ~= nil then
               local v = control[pl[i]]
               if controlPropertyStrings[pl[i]] then
                  v = format('%s%s%s', StringDel[1], v, StringDel[2])
               end
               script = script .. format('%s.%s = %s', parentStr, pl[i], v) .. LineEnd
            end
         else
            if printUnusedKeys and not usedKeys[pl[i]]
            and controlPropertyList[pl[i]] ~= false then
               usedKeys[pl[i]] = true
               print(format('---- Key Not Used: "%s"', pl[i]))
            end
         end
      end
   end
   return script
end


local function getControlComponentScript(control)
   local script = strE
   if control.ControlCount ~= nil then
      for i = 0, control.ComponentCount - 1 do
         if control.Component[i].ClassName ~= 'TJvDesignHandle' then
            script = script .. '--' .. LineEnd .. '---- ' .. control.Component[i].Name .. LineEnd
            script = script .. '--------------------' .. LineEnd
            script = script .. format('%s = %s', control.Component[i].Name, getConstructor(control.Component[i])) .. LineEnd
            script = script .. getPropertiesScript(control.Component[i], control.Component[i].Name)
            if control.Component[i].ComponentCount then
               script = script .. getControlComponentScript(control.Component[i])
            end
            script = script .. '--------------------' .. LineEnd
         end
      end
   end
   return script
end


local function getControlScript(control)
   local parentStr = control.Name
   local script = '--' .. LineEnd .. '----' .. LineEnd .. '---- FORM: ' .. control.Name .. LineEnd
   script = script .. '------------------------------' .. LineEnd
   script = script .. format('%s = %s', parentStr, getConstructor(control)) .. LineEnd
   script = script .. getPropertiesScript(control, parentStr)
   script = script .. '------------------------------' .. LineEnd
   script = script .. '---- ' .. control.Name .. ' : Components' .. LineEnd
   script = script .. '------------------------------' .. LineEnd
   script = script .. getControlComponentScript(control)
   script = script .. '------------------------------' .. LineEnd
   script = script .. '---- END FORM: ' .. control.Name .. LineEnd .. '---- ' .. LineEnd .. '--' .. LineEnd
   return script
end


function CEForm2Lua(form, noPrint)
   if form == nil then return end
   local vis = form.Visible
   form.Visible = true
   local s = getControlScript(form)
   form.Visible = vis
   if not noPrint then
      print(s)
   end
   return s
end

--
----
---- GUI
local function showModalForm()
   local fW = 400 -- Form width
   local lPush = 90 -- Label width
   local sX = fW - (lPush + 10) -- Size X
   local sY = 23 -- Size Y
   local pX = 3 -- Position X
   local pY = 3 -- Position Y
   local bW = 75 -- Button Width
   local bH = 24 -- Button Hight
   local padF = 5 -- Form Padding

   local pad1 = 3
   local pad2 = 1
   local row = 0

   local frmGenerate = createForm(false)
   frmGenerate.centerScreen()
   frmGenerate.setSize(fW, fH)
   frmGenerate.Name = 'frmGenerate'
   frmGenerate.Caption = t(ToolFormCaption)

   local lblFormName = createLabel(frmGenerate)
   lblFormName.Name = 'lblFormName'
   lblFormName.setPosition(pX, pY + sY * row + pad1)
   lblFormName.Caption = 'Form Name' .. ':'
   local edFormName = createEdit(frmGenerate)
   edFormName.Name ='edFormName'
   edFormName.setSize(sX, sY)
   edFormName.setPosition(pX + lPush, pY + sY * row + pad2)
   edFormName.Text = strE
   row = row + 1

   local btnOk = createButton(frmGenerate)
   btnOk.Name = 'btnOk'
   btnOk.Caption = 'OK'
   btnOk.setSize(bW, bH)
   btnOk.setPosition((fW / 3) - (bW / 2), pY + sY * row + pad2)
   btnOk.ModalResult = mrOK
   btnOk.Default = true
   local btnCancel = createButton(frmGenerate)
   btnCancel.Name = 'btnCancel'
   btnCancel.Caption = 'Cancel'
   btnCancel.setSize(bW, bH)
   btnCancel.setPosition(((fW / 3) * 2) - (bW / 2), pY + sY * row + pad2)
   btnCancel.ModalResult = mrCancel
   btnCancel.Cancel = true
   row = row + 1

   frmGenerate.setSize(fW, pY + sY * row + padF)

   local mr = frmGenerate.showModal()
   local dt = {
      Result = mr,
      Name = edFormName.Text,
      Form = _G[edFormName.Text],
   }
   return dt
end


local function form2LuaTool( ... )
   local rdt = showModalForm()
   if rdt.Result == mrOK then
      CEForm2Lua(rdt.Form)
   end
end


--
----
---- Setup and load
local function addMenuItem(parent, caption)
   if parent == nil then return nil end
   local newItem = createMenuItem(parent)
   parent.add(newItem)
   newItem.Caption = caption
   return newItem
end

local function createMainFormMenu()
   if MainForm.Menu == nil then return end
   local menuItems = MainForm.Menu.Items
   local miTools = nil
   for i = 0, menuItems.Count - 1 do
      if menuItems[i].Name == MainMenuItemName then
         miTools = menuItems[i]
         miTools.visible = true
         -- addMenuItem(miTools, '-')
      end
   end
   if miTools == nil then
      miTools = createMenuItem(MainForm)
      miTools.Name = MainMenuItemName
      miTools.Caption = MainMenuItemCaption
      menuItems.insert(menuItems.Count - 2, miTools)
   end
   return miTools
end

local function loadMenuAddCEForm2Lua()
   local function loadloadMenuAddCEForm2LuaTimer_tick(timer)
      timer.destroy()
      if CreateMainFormMenuItems then
         local miTools = createMainFormMenu()
         addMenuItem(miTools, t(ToolMenuItemCaption)).setOnClick(form2LuaTool)
      end
   end
   local intervals = 100
   local timer = createTimer(MainForm)
   timer.Interval = intervals
   timer.OnTimer = loadloadMenuAddCEForm2LuaTimer_tick
end

loadMenuAddCEForm2Lua()