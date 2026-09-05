
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local TOGGLE_KEY = Enum.KeyCode.RightAlt

-- =========================================================
-- REMOTES
-- =========================================================

local remoteFolder = ReplicatedStorage:WaitForChild("AdminConsole")

local executeRemote = remoteFolder:WaitForChild("ExecuteCommand")
local logRemote = remoteFolder:WaitForChild("LogUpdate")

local saveRemote = remoteFolder:WaitForChild("SaveScript")
local deleteRemote = remoteFolder:WaitForChild("DeleteScript")
local renameRemote = remoteFolder:WaitForChild("RenameScript")

local getScriptsRemote = remoteFolder:WaitForChild("GetScripts")

-- =========================================================
-- THEME
-- =========================================================

local THEME = {
	bg = Color3.fromRGB(24, 24, 28),
	panel = Color3.fromRGB(32, 32, 38),
	panelLight = Color3.fromRGB(40, 40, 48),

	accent = Color3.fromRGB(88, 145, 255),

	text = Color3.fromRGB(230, 230, 235),
	subtext = Color3.fromRGB(150, 150, 160),

	success = Color3.fromRGB(96, 210, 130),
	error = Color3.fromRGB(240, 95, 95),
	warn = Color3.fromRGB(240, 190, 90),
	info = Color3.fromRGB(150, 170, 220),

	lineNum = Color3.fromRGB(100, 100, 115),
}

-- =========================================================
-- GUI
-- =========================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminConsoleGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.IgnoreGuiInset = true
screenGui.Enabled = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 700, 0, 460)
main.Position = UDim2.new(0.5, -350, 0.5, -230)
main.BackgroundColor3 = THEME.bg
main.BorderSizePixel = 0
main.Parent = screenGui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = THEME.accent
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.4

-- =========================================================
-- TITLE BAR
-- =========================================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = THEME.panel
titleBar.BorderSizePixel = 0
titleBar.Parent = main

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = THEME.panel
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleDot = Instance.new("Frame")
titleDot.Size = UDim2.new(0, 8, 0, 8)
titleDot.Position = UDim2.new(0, 14, 0.5, -4)
titleDot.BackgroundColor3 = THEME.accent
titleDot.Parent = titleBar

Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

local titleText = Instance.new("TextLabel")
titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0, 32, 0, 0)
titleText.Size = UDim2.new(1, -150, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 15
titleText.TextColor3 = THEME.text
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Text = "Admin Console"
titleText.Parent = titleBar

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 60, 0, 23)
clearBtn.Position = UDim2.new(1, -140, 0.5, -11)
clearBtn.BackgroundColor3 = THEME.panelLight
clearBtn.Text = "Clear"
clearBtn.Font = Enum.Font.Gotham
clearBtn.TextSize = 13
clearBtn.TextColor3 = THEME.subtext
clearBtn.Parent = titleBar

Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 23)
closeBtn.Position = UDim2.new(1, -34, 0.5, -11)
closeBtn.BackgroundColor3 = THEME.panelLight
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.TextColor3 = THEME.subtext
closeBtn.Parent = titleBar

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- =========================================================
-- TABS
-- =========================================================

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 34)
tabBar.Position = UDim2.new(0, 0, 0, 38)
tabBar.BackgroundColor3 = THEME.panel
tabBar.BorderSizePixel = 0
tabBar.Parent = main

local tabLogs = Instance.new("TextButton")
tabLogs.Size = UDim2.new(0, 80, 1, 0)
tabLogs.Position = UDim2.new(0, 12, 0, 0)
tabLogs.BackgroundTransparency = 1
tabLogs.Text = "Logs"
tabLogs.Font = Enum.Font.GothamBold
tabLogs.TextSize = 14
tabLogs.TextColor3 = THEME.accent
tabLogs.Parent = tabBar

local tabConsole = Instance.new("TextButton")
tabConsole.Size = UDim2.new(0, 90, 1, 0)
tabConsole.Position = UDim2.new(0, 92, 0, 0)
tabConsole.BackgroundTransparency = 1
tabConsole.Text = "Console"
tabConsole.Font = Enum.Font.Gotham
tabConsole.TextSize = 14
tabConsole.TextColor3 = THEME.subtext
tabConsole.Parent = tabBar

local tabSave = Instance.new("TextButton")
tabSave.Size = UDim2.new(0, 80, 1, 0)
tabSave.Position = UDim2.new(0, 190, 0, 0)
tabSave.BackgroundTransparency = 1
tabSave.Text = "Save"
tabSave.Font = Enum.Font.Gotham
tabSave.TextSize = 14
tabSave.TextColor3 = THEME.subtext
tabSave.Parent = tabBar

local tabIndicator = Instance.new("Frame")
tabIndicator.Size = UDim2.new(0, 55, 0, 2)
tabIndicator.Position = UDim2.new(0, 25, 1, -2)
tabIndicator.BackgroundColor3 = THEME.accent
tabIndicator.BorderSizePixel = 0
tabIndicator.Parent = tabBar

-- =========================================================
-- CONTENT
-- =========================================================

local contentFrame = Instance.new("Frame")
contentFrame.Position = UDim2.new(0, 10, 0, 72)
contentFrame.Size = UDim2.new(1, -20, 1, -82)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

-- =========================================================
-- LOG FRAME
-- =========================================================

local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1, 0, 1, 0)
logFrame.BackgroundColor3 = THEME.panel
logFrame.BorderSizePixel = 0
logFrame.ScrollBarThickness = 5
logFrame.ScrollBarImageColor3 = THEME.accent
logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
logFrame.Parent = contentFrame

Instance.new("UICorner", logFrame).CornerRadius = UDim.new(0, 8)

local logPadding = Instance.new("UIPadding", logFrame)
logPadding.PaddingLeft = UDim.new(0, 10)
logPadding.PaddingRight = UDim.new(0, 10)
logPadding.PaddingTop = UDim.new(0, 8)
logPadding.PaddingBottom = UDim.new(0, 8)

local logList = Instance.new("UIListLayout", logFrame)
logList.SortOrder = Enum.SortOrder.LayoutOrder
logList.Padding = UDim.new(0, 3)

-- =========================================================
-- CONSOLE FRAME
-- =========================================================

local consoleFrame = Instance.new("Frame")
consoleFrame.Size = UDim2.new(1, 0, 1, 0)
consoleFrame.BackgroundTransparency = 1
consoleFrame.Visible = false
consoleFrame.Parent = contentFrame

-- =========================================================
-- CODE FRAME
-- =========================================================

local codeFrame = Instance.new("Frame")
codeFrame.Size = UDim2.new(1, 0, 1, -78)
codeFrame.BackgroundColor3 = THEME.panel
codeFrame.BorderSizePixel = 0
codeFrame.Parent = consoleFrame

Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0, 8)

-- =========================================================
-- LINE NUMBERS
-- =========================================================

local lineNumbersFrame = Instance.new("ScrollingFrame")
lineNumbersFrame.Position = UDim2.new(0, 4, 0, 6)
lineNumbersFrame.Size = UDim2.new(0, 28, 1, -12)
lineNumbersFrame.BackgroundTransparency = 1
lineNumbersFrame.BorderSizePixel = 0
lineNumbersFrame.ScrollBarThickness = 0
lineNumbersFrame.ScrollingEnabled = false
lineNumbersFrame.Parent = codeFrame

local lineNumbersLabel = Instance.new("TextLabel")
lineNumbersLabel.BackgroundTransparency = 1
lineNumbersLabel.Size = UDim2.new(1, 0, 0, 20)
lineNumbersLabel.Font = Enum.Font.Code
lineNumbersLabel.TextSize = 15
lineNumbersLabel.TextColor3 = THEME.lineNum
lineNumbersLabel.TextXAlignment = Enum.TextXAlignment.Right
lineNumbersLabel.TextYAlignment = Enum.TextYAlignment.Top
lineNumbersLabel.Text = "1"
lineNumbersLabel.Parent = lineNumbersFrame

-- =========================================================
-- INPUT SCROLL
-- =========================================================

local inputScroll = Instance.new("ScrollingFrame")
inputScroll.Position = UDim2.new(0, 36, 0, 6)
inputScroll.Size = UDim2.new(1, -42, 1, -12)
inputScroll.BackgroundTransparency = 1
inputScroll.BorderSizePixel = 0
inputScroll.ScrollBarThickness = 3
inputScroll.ScrollBarImageColor3 = THEME.accent
inputScroll.Parent = codeFrame

local inputBox = Instance.new("TextBox")
inputBox.BackgroundTransparency = 1
inputBox.Size = UDim2.new(1, -10, 0, 20)
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 15
inputBox.TextColor3 = THEME.text
inputBox.PlaceholderText = "print('Hello world')"
inputBox.PlaceholderColor3 = THEME.subtext
inputBox.Text = ""
inputBox.ClearTextOnFocus = false
inputBox.MultiLine = true
inputBox.TextWrapped = false
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.Parent = inputScroll

-- =========================================================
-- CONSOLE BOTTOM
-- =========================================================

local inputBar = Instance.new("Frame")
inputBar.Position = UDim2.new(0, 0, 1, -70)
inputBar.Size = UDim2.new(1, 0, 0, 62)
inputBar.BackgroundColor3 = THEME.panel
inputBar.Parent = consoleFrame

Instance.new("UICorner", inputBar).CornerRadius = UDim.new(0, 8)

local hintLabel = Instance.new("TextLabel")
hintLabel.BackgroundTransparency = 1
hintLabel.Position = UDim2.new(0, 8, 1, -22)
hintLabel.Size = UDim2.new(1, -100, 0, 18)
hintLabel.Font = Enum.Font.Gotham
hintLabel.TextSize = 11
hintLabel.TextColor3 = THEME.subtext
hintLabel.TextXAlignment = Enum.TextXAlignment.Left
hintLabel.Text = "Enter — новая строка   •   Ctrl+Z — отмена   •   Ctrl+Enter — Run"
hintLabel.Parent = inputBar

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0, 76, 0, 25)
runBtn.Position = UDim2.new(1, -84, 1, -31)
runBtn.BackgroundColor3 = THEME.accent
runBtn.Text = "Run ▶"
runBtn.Font = Enum.Font.GothamBold
runBtn.TextSize = 13
runBtn.TextColor3 = Color3.new(1, 1, 1)
runBtn.Parent = inputBar

Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 6)

-- =========================================================
-- SAVE FRAME
-- =========================================================

local saveFrame = Instance.new("Frame")
saveFrame.Size = UDim2.new(1, 0, 1, 0)
saveFrame.BackgroundColor3 = THEME.panel
saveFrame.Visible = false
saveFrame.Parent = contentFrame

Instance.new("UICorner", saveFrame).CornerRadius = UDim.new(0, 8)

local saveHeader = Instance.new("TextLabel")
saveHeader.BackgroundTransparency = 1
saveHeader.Position = UDim2.new(0, 14, 0, 10)
saveHeader.Size = UDim2.new(1, -28, 0, 24)
saveHeader.Font = Enum.Font.GothamBold
saveHeader.TextSize = 15
saveHeader.TextColor3 = THEME.text
saveHeader.TextXAlignment = Enum.TextXAlignment.Left
saveHeader.Text = "Saved Scripts"
saveHeader.Parent = saveFrame

local saveInfo = Instance.new("TextLabel")
saveInfo.BackgroundTransparency = 1
saveInfo.Position = UDim2.new(0, 14, 0, 35)
saveInfo.Size = UDim2.new(1, -28, 0, 18)
saveInfo.Font = Enum.Font.Gotham
saveInfo.TextSize = 11
saveInfo.TextColor3 = THEME.subtext
saveInfo.TextXAlignment = Enum.TextXAlignment.Left
saveInfo.Text = "Выберите сохранение для редактирования или запуска"
saveInfo.Parent = saveFrame

-- =========================================================
-- SAVE FILTERS
-- =========================================================

local personalFilterBtn = Instance.new("TextButton")
personalFilterBtn.Size = UDim2.new(0, 100, 0, 27)
personalFilterBtn.Position = UDim2.new(0, 14, 0, 58)
personalFilterBtn.BackgroundColor3 = THEME.accent
personalFilterBtn.Text = "Personal"
personalFilterBtn.Font = Enum.Font.GothamBold
personalFilterBtn.TextSize = 11
personalFilterBtn.TextColor3 = Color3.new(1, 1, 1)
personalFilterBtn.Parent = saveFrame

Instance.new("UICorner", personalFilterBtn).CornerRadius = UDim.new(0, 6)

local publicFilterBtn = Instance.new("TextButton")
publicFilterBtn.Size = UDim2.new(0, 100, 0, 27)
publicFilterBtn.Position = UDim2.new(0, 120, 0, 58)
publicFilterBtn.BackgroundColor3 = THEME.panelLight
publicFilterBtn.Text = "Public"
publicFilterBtn.Font = Enum.Font.Gotham
publicFilterBtn.TextSize = 11
publicFilterBtn.TextColor3 = THEME.subtext
publicFilterBtn.Parent = saveFrame

Instance.new("UICorner", publicFilterBtn).CornerRadius = UDim.new(0, 6)

local newSaveBtn = Instance.new("TextButton")
newSaveBtn.Size = UDim2.new(0, 100, 0, 28)
newSaveBtn.Position = UDim2.new(1, -114, 0, 10)
newSaveBtn.BackgroundColor3 = THEME.accent
newSaveBtn.Text = "+ New Save"
newSaveBtn.Font = Enum.Font.GothamBold
newSaveBtn.TextSize = 12
newSaveBtn.TextColor3 = Color3.new(1, 1, 1)
newSaveBtn.Parent = saveFrame

Instance.new("UICorner", newSaveBtn).CornerRadius = UDim.new(0, 6)

local savesList = Instance.new("ScrollingFrame")
savesList.Position = UDim2.new(0, 10, 0, 94)
savesList.Size = UDim2.new(1, -20, 1, -104)
savesList.BackgroundTransparency = 1
savesList.BorderSizePixel = 0
savesList.ScrollBarThickness = 5
savesList.ScrollBarImageColor3 = THEME.accent
savesList.AutomaticCanvasSize = Enum.AutomaticSize.Y
savesList.CanvasSize = UDim2.new(0, 0, 0, 0)
savesList.Parent = saveFrame

local savesLayout = Instance.new("UIListLayout", savesList)
savesLayout.SortOrder = Enum.SortOrder.LayoutOrder
savesLayout.Padding = UDim.new(0, 6)

-- =========================================================
-- SAVE DIALOG
-- =========================================================

local dialogOverlay = Instance.new("Frame")
dialogOverlay.Size = UDim2.new(1, 0, 1, 0)
dialogOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
dialogOverlay.BackgroundTransparency = 0.35
dialogOverlay.Visible = false
dialogOverlay.ZIndex = 20
dialogOverlay.Parent = screenGui

local dialog = Instance.new("Frame")
dialog.Size = UDim2.new(0, 360, 0, 170)
dialog.Position = UDim2.new(0.5, -180, 0.5, -85)
dialog.BackgroundColor3 = THEME.panel
dialog.ZIndex = 21
dialog.Parent = dialogOverlay

Instance.new("UICorner", dialog).CornerRadius = UDim.new(0, 10)

local dialogTitle = Instance.new("TextLabel")
dialogTitle.BackgroundTransparency = 1
dialogTitle.Position = UDim2.new(0, 16, 0, 12)
dialogTitle.Size = UDim2.new(1, -32, 0, 24)
dialogTitle.Font = Enum.Font.GothamBold
dialogTitle.TextSize = 15
dialogTitle.TextColor3 = THEME.text
dialogTitle.TextXAlignment = Enum.TextXAlignment.Left
dialogTitle.Text = "Save Script"
dialogTitle.ZIndex = 22
dialogTitle.Parent = dialog

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -32, 0, 36)
nameBox.Position = UDim2.new(0, 16, 0, 50)
nameBox.BackgroundColor3 = THEME.bg
nameBox.BorderSizePixel = 0
nameBox.TextColor3 = THEME.text
nameBox.PlaceholderColor3 = THEME.subtext
nameBox.PlaceholderText = "Название сохранения..."
nameBox.Text = ""
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 13
nameBox.ClearTextOnFocus = false
nameBox.ZIndex = 22
nameBox.Parent = dialog

Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)

-- =========================================================
-- SAVE TYPE SELECTOR
-- =========================================================

local typeLabel = Instance.new("TextLabel")
typeLabel.BackgroundTransparency = 1
typeLabel.Position = UDim2.new(0, 16, 0, 94)
typeLabel.Size = UDim2.new(0, 75, 0, 20)
typeLabel.Font = Enum.Font.Gotham
typeLabel.TextSize = 11
typeLabel.TextColor3 = THEME.subtext
typeLabel.TextXAlignment = Enum.TextXAlignment.Left
typeLabel.Text = "Save type:"
typeLabel.ZIndex = 22
typeLabel.Parent = dialog

local personalTypeBtn = Instance.new("TextButton")
personalTypeBtn.Size = UDim2.new(0, 100, 0, 25)
personalTypeBtn.Position = UDim2.new(0, 92, 0, 91)
personalTypeBtn.BackgroundColor3 = THEME.accent
personalTypeBtn.Text = "Personal"
personalTypeBtn.Font = Enum.Font.GothamBold
personalTypeBtn.TextSize = 11
personalTypeBtn.TextColor3 = Color3.new(1, 1, 1)
personalTypeBtn.ZIndex = 22
personalTypeBtn.Parent = dialog

Instance.new("UICorner", personalTypeBtn).CornerRadius = UDim.new(0, 5)

local publicTypeBtn = Instance.new("TextButton")
publicTypeBtn.Size = UDim2.new(0, 100, 0, 25)
publicTypeBtn.Position = UDim2.new(0, 200, 0, 91)
publicTypeBtn.BackgroundColor3 = THEME.panelLight
publicTypeBtn.Text = "Public"
publicTypeBtn.Font = Enum.Font.Gotham
publicTypeBtn.TextSize = 11
publicTypeBtn.TextColor3 = THEME.subtext
publicTypeBtn.ZIndex = 22
publicTypeBtn.Parent = dialog

Instance.new("UICorner", publicTypeBtn).CornerRadius = UDim.new(0, 5)

local cancelDialogBtn = Instance.new("TextButton")
cancelDialogBtn.Size = UDim2.new(0, 90, 0, 28)
cancelDialogBtn.Position = UDim2.new(1, -196, 1, -40)
cancelDialogBtn.BackgroundColor3 = THEME.panelLight
cancelDialogBtn.Text = "Cancel"
cancelDialogBtn.Font = Enum.Font.Gotham
cancelDialogBtn.TextSize = 12
cancelDialogBtn.TextColor3 = THEME.subtext
cancelDialogBtn.ZIndex = 22
cancelDialogBtn.Parent = dialog

Instance.new("UICorner", cancelDialogBtn).CornerRadius = UDim.new(0, 6)

local confirmDialogBtn = Instance.new("TextButton")
confirmDialogBtn.Size = UDim2.new(0, 90, 0, 28)
confirmDialogBtn.Position = UDim2.new(1, -100, 1, -40)
confirmDialogBtn.BackgroundColor3 = THEME.accent
confirmDialogBtn.Text = "Save"
confirmDialogBtn.Font = Enum.Font.GothamBold
confirmDialogBtn.TextSize = 12
confirmDialogBtn.TextColor3 = Color3.new(1, 1, 1)
confirmDialogBtn.ZIndex = 22
confirmDialogBtn.Parent = dialog

Instance.new("UICorner", confirmDialogBtn).CornerRadius = UDim.new(0, 6)

-- =========================================================
-- VARIABLES
-- =========================================================

local currentTab = "Logs"

local savedScripts = {}
local selectedScriptId = nil

local dialogMode = "new"

local saveFilter = "Personal"
local newSaveType = "Personal"

-- =========================================================
-- SAVE FILTER BUTTONS
-- =========================================================

local function updateSaveFilterButtons()

	if saveFilter == "Personal" then

		personalFilterBtn.BackgroundColor3 = THEME.accent
		personalFilterBtn.Font = Enum.Font.GothamBold
		personalFilterBtn.TextColor3 = Color3.new(1, 1, 1)

		publicFilterBtn.BackgroundColor3 = THEME.panelLight
		publicFilterBtn.Font = Enum.Font.Gotham
		publicFilterBtn.TextColor3 = THEME.subtext

	else

		publicFilterBtn.BackgroundColor3 = THEME.accent
		publicFilterBtn.Font = Enum.Font.GothamBold
		publicFilterBtn.TextColor3 = Color3.new(1, 1, 1)

		personalFilterBtn.BackgroundColor3 = THEME.panelLight
		personalFilterBtn.Font = Enum.Font.Gotham
		personalFilterBtn.TextColor3 = THEME.subtext

	end

end

-- =========================================================
-- SAVE TYPE BUTTONS
-- =========================================================

local function updateSaveTypeButtons()

	if newSaveType == "Personal" then

		personalTypeBtn.BackgroundColor3 = THEME.accent
		personalTypeBtn.Font = Enum.Font.GothamBold
		personalTypeBtn.TextColor3 = Color3.new(1, 1, 1)

		publicTypeBtn.BackgroundColor3 = THEME.panelLight
		publicTypeBtn.Font = Enum.Font.Gotham
		publicTypeBtn.TextColor3 = THEME.subtext

	else

		publicTypeBtn.BackgroundColor3 = THEME.accent
		publicTypeBtn.Font = Enum.Font.GothamBold
		publicTypeBtn.TextColor3 = Color3.new(1, 1, 1)

		personalTypeBtn.BackgroundColor3 = THEME.panelLight
		personalTypeBtn.Font = Enum.Font.Gotham
		personalTypeBtn.TextColor3 = THEME.subtext

	end

end

personalTypeBtn.MouseButton1Click:Connect(function()

	newSaveType = "Personal"

	updateSaveTypeButtons()

end)

publicTypeBtn.MouseButton1Click:Connect(function()

	newSaveType = "Public"

	updateSaveTypeButtons()

end)

-- =========================================================
-- UNDO
-- =========================================================

local MAX_UNDO = 100

local undoHistory = {""}
local undoIndex = 1
local isUndoing = false
local undoSaveToken = 0
local UNDO_GROUP_DELAY = 0.35

local function resetUndo()

	isUndoing = true

	undoHistory = {
		inputBox.Text
	}

	undoIndex = 1

	isUndoing = false

end

local function saveUndoStateNow(text)

	if isUndoing then
		return
	end

	if undoIndex < #undoHistory then

		for i = #undoHistory, undoIndex + 1, -1 do
			table.remove(undoHistory, i)
		end

	end

	if undoHistory[#undoHistory] == text then

		undoIndex = #undoHistory

		return
	end

	table.insert(
		undoHistory,
		text
	)

	if #undoHistory > MAX_UNDO then

		table.remove(
			undoHistory,
			1
		)

	end

	undoIndex = #undoHistory

end

local function scheduleUndoSave()

	if isUndoing then
		return
	end

	undoSaveToken += 1

	local token = undoSaveToken

	task.delay(UNDO_GROUP_DELAY, function()

		if token ~= undoSaveToken then
			return
		end

		if isUndoing then
			return
		end

		saveUndoStateNow(
			inputBox.Text
		)

	end)

end

local function undo()

	undoSaveToken += 1

	if undoHistory[#undoHistory] ~= inputBox.Text then
		saveUndoStateNow(inputBox.Text)
	end

	if undoIndex <= 1 then
		return
	end

	undoIndex -= 1

	local previousText =
		undoHistory[undoIndex] or ""

	isUndoing = true

	inputBox.Text = previousText

	isUndoing = false

	task.defer(function()

		if inputBox:IsFocused() then

			local pos =
				#inputBox.Text + 1

			inputBox.CursorPosition = pos
			inputBox.SelectionStart = pos

		end

	end)

end

-- =========================================================
-- LINE NUMBERS
-- =========================================================

local function updateLineNumbers()

	local text = inputBox.Text

	local count = 1

	for _ in string.gmatch(text, "\n") do
		count += 1
	end

	local lines = {}

	for i = 1, count do

		table.insert(
			lines,
			tostring(i)
		)

	end

	lineNumbersLabel.Text =
		table.concat(lines, "\n")

end

local function updateInputSize()

	task.defer(function()

		local textHeight = math.max(
			inputBox.TextBounds.Y,
			20
		)

		local visibleHeight = math.max(
			inputScroll.AbsoluteSize.Y - 12,
			20
		)

		local newHeight = math.max(
			textHeight + 10,
			visibleHeight
		)

		inputBox.Size = UDim2.new(
			1,
			-10,
			0,
			newHeight
		)

		inputScroll.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				math.max(
					newHeight + 20,
					visibleHeight + 20
				)
			)

		updateLineNumbers()

		lineNumbersFrame.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				newHeight + 10
			)

	end)

end

inputBox:GetPropertyChangedSignal("Text"):Connect(function()

	updateInputSize()

	if not isUndoing then
		scheduleUndoSave()
	end

end)

inputScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()

	lineNumbersFrame.CanvasPosition =
		Vector2.new(
			0,
			inputScroll.CanvasPosition.Y
		)

end)

-- =========================================================
-- LOGS
-- =========================================================

local function addLogEntry(entry)

	local color = THEME.info

	if entry.kind == "success" then

		color = THEME.success

	elseif entry.kind == "error" then

		color = THEME.error

	elseif entry.kind == "warn" then

		color = THEME.warn

	end

	local displayText = string.format(
		"[%s] [%s] %s",
		entry.time,
		entry.player,
		entry.text
	)

	local row = Instance.new("TextLabel")

	row.Name = "LogEntry"
	row.BackgroundTransparency = 1
	row.Font = Enum.Font.Code
	row.TextSize = 14
	row.TextColor3 = color
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.TextYAlignment = Enum.TextYAlignment.Top
	row.TextWrapped = true
	row.Text = displayText
	row.Size = UDim2.new(1, 0, 0, 0)
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.Parent = logFrame

	task.defer(function()

		logFrame.CanvasPosition =
			Vector2.new(
				0,
				math.huge
			)

	end)

end

logRemote.OnClientEvent:Connect(addLogEntry)

-- =========================================================
-- TAB SWITCH
-- =========================================================

local function switchTab(tab)

	currentTab = tab

	logFrame.Visible = false
	consoleFrame.Visible = false
	saveFrame.Visible = false

	tabLogs.Font = Enum.Font.Gotham
	tabConsole.Font = Enum.Font.Gotham
	tabSave.Font = Enum.Font.Gotham

	tabLogs.TextColor3 = THEME.subtext
	tabConsole.TextColor3 = THEME.subtext
	tabSave.TextColor3 = THEME.subtext

	clearBtn.Visible = false

	if tab == "Logs" then

		logFrame.Visible = true

		clearBtn.Visible = true

		tabLogs.Font = Enum.Font.GothamBold
		tabLogs.TextColor3 = THEME.accent

		TweenService:Create(
			tabIndicator,
			TweenInfo.new(
				0.15,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Position = UDim2.new(
					0,
					25,
					1,
					-2
				)
			}
		):Play()

		task.defer(function()

			logFrame.CanvasPosition =
				Vector2.new(
					0,
					math.huge
				)

		end)

	elseif tab == "Console" then

		consoleFrame.Visible = true

		tabConsole.Font =
			Enum.Font.GothamBold

		tabConsole.TextColor3 =
			THEME.accent

		TweenService:Create(
			tabIndicator,
			TweenInfo.new(
				0.15,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Position = UDim2.new(
					0,
					110,
					1,
					-2
				)
			}
		):Play()

		task.defer(function()

			updateInputSize()
			inputBox:CaptureFocus()

		end)

	elseif tab == "Save" then

		saveFrame.Visible = true

		tabSave.Font =
			Enum.Font.GothamBold

		tabSave.TextColor3 =
			THEME.accent

		TweenService:Create(
			tabIndicator,
			TweenInfo.new(
				0.15,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Position = UDim2.new(
					0,
					208,
					1,
					-2
				)
			}
		):Play()

	end

end

tabLogs.MouseButton1Click:Connect(function()
	switchTab("Logs")
end)

tabConsole.MouseButton1Click:Connect(function()
	switchTab("Console")
end)

tabSave.MouseButton1Click:Connect(function()
	switchTab("Save")
end)

-- =========================================================
-- FORMAT DATE
-- =========================================================

local function formatDate(timestamp)

	if not timestamp then
		return "unknown"
	end

	local success, result = pcall(function()

		return os.date(
			"%d.%m.%Y %H:%M:%S",
			timestamp
		)

	end)

	if success then
		return result
	end

	return "unknown"

end

-- =========================================================
-- SAVE LIST
-- =========================================================

local function clearSaveList()

	for _, child in ipairs(savesList:GetChildren()) do

		if child:IsA("Frame") then
			child:Destroy()
		end

	end

end

local function refreshSaveList()

	clearSaveList()

	for _, scriptData in ipairs(savedScripts) do

		local scriptType =
			scriptData.saveType or "Personal"

		-- Показываем только выбранную категорию.

		if scriptType ~= saveFilter then
			continue
		end

		local card = Instance.new("Frame")

		card.Name =
			"Save_" .. tostring(scriptData.id)

		card.Size =
			UDim2.new(1, -10, 0, 76)

		card.BackgroundColor3 =
			THEME.bg

		card.BorderSizePixel = 0
		card.Parent = savesList

		Instance.new("UICorner", card).CornerRadius =
			UDim.new(0, 8)

		-- =================================================
		-- NAME
		-- =================================================

		local nameLabel = Instance.new("TextLabel")

		nameLabel.BackgroundTransparency = 1
		nameLabel.Position =
			UDim2.new(0, 12, 0, 8)

		nameLabel.Size =
			UDim2.new(1, -410, 0, 22)

		nameLabel.Font =
			Enum.Font.GothamBold

		nameLabel.TextSize = 14
		nameLabel.TextColor3 = THEME.text
		nameLabel.TextXAlignment =
			Enum.TextXAlignment.Left

		nameLabel.Text =
			tostring(
				scriptData.name or "Untitled"
			)

		nameLabel.Parent = card

		-- =================================================
		-- TYPE LABEL
		-- =================================================

		local typeLabel = Instance.new("TextLabel")

		typeLabel.BackgroundTransparency = 1

		typeLabel.Position =
			UDim2.new(
				1,
				-205,
				0,
				8
			)

		typeLabel.Size =
			UDim2.new(
				0,
				75,
				0,
				18
			)

		typeLabel.Font =
			Enum.Font.GothamBold

		typeLabel.TextSize = 10

		typeLabel.TextXAlignment =
			Enum.TextXAlignment.Right

		if scriptType == "Public" then

			typeLabel.Text = "PUBLIC"
			typeLabel.TextColor3 =
				THEME.accent

		else

			typeLabel.Text = "PERSONAL"
			typeLabel.TextColor3 =
				THEME.success

		end

		typeLabel.Parent = card

		-- =================================================
		-- INFO
		-- =================================================

		local infoLabel = Instance.new("TextLabel")

		infoLabel.BackgroundTransparency = 1

		infoLabel.Position =
			UDim2.new(0, 12, 0, 34)

		infoLabel.Size =
			UDim2.new(1, -300, 0, 18)

		infoLabel.Font =
			Enum.Font.Code

		infoLabel.TextSize = 11
		infoLabel.TextColor3 =
			THEME.subtext

		infoLabel.TextXAlignment =
			Enum.TextXAlignment.Left

		local author =
			scriptData.updatedBy
			or scriptData.createdBy
			or "Unknown"

		infoLabel.Text = string.format(
			"%d строк  •  %s  •  %s",
			tonumber(scriptData.lines) or 1,
			tostring(author),
			formatDate(
				scriptData.updatedAt
					or scriptData.createdAt
			)
		)

		infoLabel.Parent = card

		-- =================================================
		-- EDIT
		-- =================================================

		local editBtn = Instance.new("TextButton")

		editBtn.Size =
			UDim2.new(0, 58, 0, 27)

		editBtn.Position =
			UDim2.new(
				1,
				-280,
				0.5,
				-13
			)

		editBtn.BackgroundColor3 =
			THEME.panelLight

		editBtn.Text = "Edit"

		editBtn.Font =
			Enum.Font.Gotham

		editBtn.TextSize = 11
		editBtn.TextColor3 =
			THEME.text

		editBtn.Parent = card

		Instance.new("UICorner", editBtn).CornerRadius =
			UDim.new(0, 5)

		editBtn.MouseButton1Click:Connect(function()

			selectedScriptId =
				scriptData.id

			newSaveType =
				scriptType

			isUndoing = true

			inputBox.Text =
				scriptData.code or ""

			isUndoing = false

			resetUndo()
			updateInputSize()

			switchTab("Console")

		end)

		-- =================================================
		-- ACTIVATE
		-- =================================================

		local activateBtn =
			Instance.new("TextButton")

		activateBtn.Size =
			UDim2.new(0, 76, 0, 27)

		activateBtn.Position =
			UDim2.new(
				1,
				-214,
				0.5,
				-13
			)

		activateBtn.BackgroundColor3 =
			THEME.accent

		activateBtn.Text =
			"Activate ▶"

		activateBtn.Font =
			Enum.Font.GothamBold

		activateBtn.TextSize = 10

		activateBtn.TextColor3 =
			Color3.new(1, 1, 1)

		activateBtn.Parent = card

		Instance.new("UICorner", activateBtn).CornerRadius =
			UDim.new(0, 5)

		activateBtn.MouseButton1Click:Connect(function()

			if not scriptData.code
				or scriptData.code == "" then

				return
			end

			executeRemote:FireServer(
				scriptData.code
			)

			switchTab("Logs")

		end)

		-- =================================================
		-- RENAME
		-- =================================================

		local renameBtn =
			Instance.new("TextButton")

		renameBtn.Size =
			UDim2.new(0, 65, 0, 27)

		renameBtn.Position =
			UDim2.new(
				1,
				-132,
				0.5,
				-13
			)

		renameBtn.BackgroundColor3 =
			THEME.panelLight

		renameBtn.Text = "Rename"

		renameBtn.Font =
			Enum.Font.Gotham

		renameBtn.TextSize = 10
		renameBtn.TextColor3 =
			THEME.text

		renameBtn.Parent = card

		Instance.new("UICorner", renameBtn).CornerRadius =
			UDim.new(0, 5)

		renameBtn.MouseButton1Click:Connect(function()

			selectedScriptId =
				scriptData.id

			newSaveType =
				scriptType

			dialogMode =
				"rename"

			dialogTitle.Text =
				"Rename Script"

			nameBox.Text =
				scriptData.name or ""

			confirmDialogBtn.Text =
				"Rename"

			-- При rename тип не меняем,
			-- поэтому кнопки просто отображают
			-- текущий тип.

			updateSaveTypeButtons()

			dialogOverlay.Visible = true

			task.defer(function()

				nameBox:CaptureFocus()

				nameBox.CursorPosition =
					#nameBox.Text + 1

			end)

		end)

		-- =================================================
		-- DELETE
		-- =================================================

		local deleteBtn =
			Instance.new("TextButton")

		deleteBtn.Size =
			UDim2.new(0, 55, 0, 27)

		deleteBtn.Position =
			UDim2.new(
				1,
				-62,
				0.5,
				-13
			)

		deleteBtn.BackgroundColor3 =
			Color3.fromRGB(100, 45, 45)

		deleteBtn.Text = "Delete"

		deleteBtn.Font =
			Enum.Font.Gotham

		deleteBtn.TextSize = 10
		deleteBtn.TextColor3 =
			THEME.text

		deleteBtn.Parent = card

		Instance.new("UICorner", deleteBtn).CornerRadius =
			UDim.new(0, 5)

		deleteBtn.MouseButton1Click:Connect(function()

			deleteRemote:FireServer(
				scriptData.id
			)

			task.delay(
				0.5,
				function()

					local success, result =
						pcall(function()

							return getScriptsRemote:InvokeServer()

						end)

					if success
						and type(result) == "table" then

						savedScripts = result

						refreshSaveList()

					end

				end
			)

		end)

	end

end

-- =========================================================
-- LOAD SAVES
-- =========================================================

local function loadSavedScripts()

	local success, result =
		pcall(function()

			return getScriptsRemote:InvokeServer()

		end)

	if success and type(result) == "table" then

		savedScripts = result

		refreshSaveList()

	else

		savedScripts = {}

		refreshSaveList()

	end

end

-- =========================================================
-- FILTER EVENTS
-- =========================================================

personalFilterBtn.MouseButton1Click:Connect(function()

	saveFilter = "Personal"

	updateSaveFilterButtons()

	refreshSaveList()

end)

publicFilterBtn.MouseButton1Click:Connect(function()

	saveFilter = "Public"

	updateSaveFilterButtons()

	refreshSaveList()

end)

-- =========================================================
-- NEW SAVE
-- =========================================================

local function openNewSaveDialog()

	dialogMode = "new"

	selectedScriptId = nil

	newSaveType = "Personal"

	dialogTitle.Text =
		"Save Script"

	nameBox.Text = ""

	confirmDialogBtn.Text =
		"Save"

	updateSaveTypeButtons()

	dialogOverlay.Visible = true

	task.defer(function()

		nameBox:CaptureFocus()

	end)

end

newSaveBtn.MouseButton1Click:Connect(
	openNewSaveDialog
)

-- =========================================================
-- DIALOG CANCEL
-- =========================================================

cancelDialogBtn.MouseButton1Click:Connect(function()

	dialogOverlay.Visible = false

	nameBox:ReleaseFocus()

end)

-- =========================================================
-- DIALOG CONFIRM
-- =========================================================

confirmDialogBtn.MouseButton1Click:Connect(function()

	local name = nameBox.Text

	if name:gsub("%s+", "") == "" then
		name = "Untitled"
	end

	-- =====================================================
	-- NEW
	-- =====================================================

	if dialogMode == "new" then

		saveRemote:FireServer({

			name = name,

			code = inputBox.Text,

			saveType = newSaveType,

		})

		-- =====================================================
		-- RENAME
		-- =====================================================

	elseif dialogMode == "rename" then

		if selectedScriptId then

			renameRemote:FireServer(
				selectedScriptId,
				name
			)

		end

	end

	dialogOverlay.Visible = false

	nameBox:ReleaseFocus()

	task.delay(
		0.6,
		function()

			loadSavedScripts()

		end
	)

end)

-- =========================================================
-- SAVE CURRENT SCRIPT
-- =========================================================

local function saveCurrentScript()

	if selectedScriptId then

		local currentName =
			"Untitled"

		for _, scriptData in ipairs(savedScripts) do

			if scriptData.id ==
				selectedScriptId then

				currentName =
					scriptData.name

				break

			end

		end

		saveRemote:FireServer({

			id = selectedScriptId,

			name = currentName,

			code = inputBox.Text,

			saveType = newSaveType,

		})

		task.delay(
			0.6,
			function()

				loadSavedScripts()

			end
		)

	else

		openNewSaveDialog()

	end

end

-- =========================================================
-- RUN
-- =========================================================

local function submit()

	local text =
		inputBox.Text:gsub(
			"%s+$",
			""
		)

	if text == "" then
		return
	end

	executeRemote:FireServer(text)

	isUndoing = true

	inputBox.Text = ""

	isUndoing = false

	selectedScriptId = nil

	undoSaveToken += 1

	undoHistory = {
		""
	}

	undoIndex = 1

	updateInputSize()

	inputBox:CaptureFocus()

end

runBtn.MouseButton1Click:Connect(
	submit
)

-- =========================================================
-- CLEAR LOGS
-- =========================================================

clearBtn.MouseButton1Click:Connect(function()

	for _, child in ipairs(logFrame:GetChildren()) do

		if child.Name == "LogEntry" then
			child:Destroy()
		end

	end

end)

-- =========================================================
-- KEYBOARD
-- =========================================================

UserInputService.InputBegan:Connect(function(
	input,
	gameProcessed
)

	if not screenGui.Enabled then
		return
	end

	-- =====================================================
	-- CTRL + Z
	-- =====================================================

	if input.KeyCode ==
		Enum.KeyCode.Z then

		if inputBox:IsFocused() then

			local ctrlHeld =
				UserInputService:IsKeyDown(
					Enum.KeyCode.LeftControl
				)
				or
				UserInputService:IsKeyDown(
					Enum.KeyCode.RightControl
				)

			if ctrlHeld then

				undo()

				return

			end

		end

	end

	-- =====================================================
	-- CTRL + ENTER
	-- =====================================================

	if input.KeyCode ==
		Enum.KeyCode.Return
		or
		input.KeyCode ==
		Enum.KeyCode.KeypadEnter then

		if inputBox:IsFocused() then

			local ctrlHeld =
				UserInputService:IsKeyDown(
					Enum.KeyCode.LeftControl
				)
				or
				UserInputService:IsKeyDown(
					Enum.KeyCode.RightControl
				)

			if ctrlHeld then

				task.defer(
					submit
				)

				return

			end

		end

	end

end)

-- =========================================================
-- OPEN / CLOSE
-- =========================================================

local function setOpen(open)

	screenGui.Enabled = open

	if open then

		main.Position =
			UDim2.new(
				0.5,
				-350,
				0.5,
				-200
			)

		TweenService:Create(
			main,
			TweenInfo.new(
				0.18,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			),
			{
				Position =
					UDim2.new(
						0.5,
						-350,
						0.5,
						-230
					)
			}
		):Play()

		loadSavedScripts()

	end

end

closeBtn.MouseButton1Click:Connect(function()

	setOpen(false)

end)

UserInputService.InputBegan:Connect(function(input)

	if input.KeyCode == TOGGLE_KEY then

		setOpen(
			not screenGui.Enabled
		)

	end

end)

-- =========================================================
-- DRAG
-- =========================================================

local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or
		input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End then

				dragging = false

			end

		end)

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if dragging
		and
		(
			input.UserInputType ==
				Enum.UserInputType.MouseMovement

				or

				input.UserInputType ==
				Enum.UserInputType.Touch
		) then

		local delta =
			input.Position - dragStart

		main.Position =
			UDim2.new(

				startPos.X.Scale,

				startPos.X.Offset + delta.X,

				startPos.Y.Scale,

				startPos.Y.Offset + delta.Y

			)

	end

end)

-- =========================================================
-- INITIALIZATION
-- =========================================================

updateLineNumbers()
updateInputSize()

resetUndo()

updateSaveFilterButtons()
updateSaveTypeButtons()

switchTab("Logs")
