--Adding ReGui

local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local PrefabsId = `rbxassetid://{ReGui.PrefabsId}`

--// Externally import the Prefabs asset
ReGui:Init({
	Prefabs = game:GetService("InsertService"):LoadLocalAsset(PrefabsId)
})

--Window without tabs

local Window = ReGui:Window({
	Title = "Hello world!",
	Size = UDim2.fromOffset(300, 200)
})

Window:Label({Text="Hello, world!"})
Window:Button({
	Text = "Save",
	Callback = function()
		MySaveFunction()
	end,
})
Window:InputText({Label="string"})
Window:SliderFloat({Label = "float", Minimum = 0.0, Maximum = 1.0})

--Window with tabs

local Window = ReGui:TabsWindow({
	Title = "Tabs window demo!",
	Size = UDim2.fromOffset(300, 200)
})

local Names = {"Avocado", "Broccoli", "Cucumber"}
for _, Name in next, Names do
	local Tab = Window:CreateTab({Name=Name})
	Tab:Label({
		Text = `This is the {Name} tab!`
	})
end

--DefineElement

-- This will be defined in the Elements class accessible by a Canvas
-- Or by ReGui.Elements:ElementName() but this method will not have theming
ReGui:DefineElement("ElementName", {
	-- These are the base values for the Config
	Base = {
		RichText = true,
		TextWrapped = true
	},
	--(OPTIONAL) This is the coloring infomation the theme system will use
	ColorData = {
		["ColorStyle Name"] = {
			TextColor3 = "ErrorText",
			FontFace = "TextFont",
		},
	},
	--(OPTIONAL) These values will be set in the base theme
	ThemeTags = {
		["ThemeTag"] = Color3.fromRGB(255, 69, 69),
		["CoolFont"] = Font.fromName("Ubuntu"),
	},
	--[[ This is the generation function for the element
	 self is the canvas class
	 Config is the configuration with overwrites to the Base config
	]]--
	Create = function(self, Config: Label)
		-- This MUST either return:
		  -- GuiObject
		  -- Class, GuiObject
	end,
})

--Basic TextLabel example:

ReGui:DefineElement("PurpleText", { --// Method name
	Base = { --// Configuration base
		IsBigText = true
	},
	Create = function(self, Config)
		local IsBigText = Config.Config -- true
		
		local Label = Instance.new("TextLabel")
		Label.TextSize = IsBigText and 30 or 14

		--// Must return: Instance or Table, Instance
		return Label
	end,
})

--Using other elements as a base:
--This is the code used for generating the ProgressBar element using the Slider element as a base

ReGui:DefineElement("ProgressBar", {
	Base = {
		Progress = true,
		ReadOnly = true,
		MinValue = 0,
		MaxValue = 100,
		Format = "% i%%"
	},
	Create = function(self, Config)
		function Config:SetPercentage(Value: number)
			Config:SetValue(Value)
		end

		return self:Slider(Config)
	end,
})

--When ReGui generates an element such as a Label from invoking Canvas:Label, it will check if the flag is a property or a global flag. If it is a global flag it will call the defined function but if it's a property such as Size it will be set as a property to the element as it is not a global flag
--Examples of some built-in flags are: Icon, Border, and Ratio

    type Data = {
        Object: Instance,
        Class: table,
        WindowClass: table? --// May not exist in some cases
    }
    
--Basic flag example for visibility:
    
    ReGui:DefineGlobalFlag({
        Properties = {"Hidden"}, --// These are trigger strings in the flags
        Callback = function(Data, Object, Value)
            Object.Visible = Value
        end,
    })

--Themes use the DarkTheme configuration as the base and any defined theme will act as overwrites to this configuration Accents
--ReGui comes with built-in accent colors that can be used for coloring. As seen in the source here

ReGui.Accent = {
	--// ReGui acent colors
	Light = Color3.fromRGB(60, 150, 250),
	Dark = Color3.fromRGB(29, 66, 115),
	White = Color3.fromRGB(240, 240, 240),
	Gray = Color3.fromRGB(127, 126, 129),
	Black = Color3.fromRGB(15, 19, 24),
	Yellow = Color3.fromRGB(217, 180, 62),
	Orange = Color3.fromRGB(234, 157, 57),
	Green = Color3.fromRGB(130, 188, 91),
	Red = Color3.fromRGB(255, 69, 69),

--Creating a theme

--For this example, we'll create a basic pink theme

ReGui:DefineTheme("Pink Theme", {
	Text = Color3.fromRGB(200, 180, 200),
	WindowBg = Color3.fromRGB(35, 30, 35),
	TitleBarBg = Color3.fromRGB(35, 30, 35),
	TitleBarBgActive = Color3.fromRGB(50, 45, 50),
	Border = Color3.fromRGB(50, 45, 50),
	ResizeGrab = Color3.fromRGB(50, 45, 50),
})

--Usage in a Window

--Now to use the theme we have just created, set the Themeflag to the name of the theme we have created - RedTheme

local Window = ReGui:Window({
	Title = "My theme demo",
	Theme = "Pink Theme",
	Size = UDim2.fromOffset(300, 200)
})

Window:Label({
	Text = "Hello, world!"
})

--:Label

type Label = {
	Text: string?,
	Bold: boolean?,
	Italic: boolean?,
	Font: string?
}

--Example usage:

:Label({
    Text = "Hello world!"
})

--:Error

type Error = {
	Text: string?
}

--Example usage:

:Error({
    Text = "Hello world!"
})

--:Button

type Button = {
	Text: string?,
	Callback: ((...any) -> unknown)?
}

--Example usage:

:Button({
	Text = "Print",
	Callback = function(self)
		print("Hello world!")
	end
})

--:SmallButton

type SmallButton = {
	Text: string?,
	Callback: ((...any) -> unknown)?
}

--Example usage:

:SmallButton({
	Text = "Print",
	Callback = function(self)
		print("Hello world!")
	end
})

--:Image

type Image = {
	Image: (string|number),
	Callback: ((...any) -> unknown)
}

--Example usage:

:Image({
	Image = 5205790785 --roblox image id
})

--:VideoPlayer

export type VideoPlayer = {
	Video: (string|number)
}

--Example usage:

local Video = ...:VideoPlayer({
    Video = 5608327482,
    Looped = true,
    Size = UDim2.fromOffset(200, 300)
})
Video:Play()

--:RadioButton

type RadioButton = {
	Icon: string?,
	IconRotation: number?,
	Callback: ((...any) -> unknown)?,
}

--Example usage:

:RadioButton({
	Icon = 18754976792,
	Callback = function(self)
		print("Hello world!")
	end
})

--:Checkbox

type RadioButton = {
	Label: string?,
	IsRadio: boolean?,
	Value: boolean,
	NoAnimation: boolean?,
	Callback: ((...any) -> unknown)?,
	SetTicked: (self: Checkbox, Value: boolean, NoAnimation: boolean) -> ...any,
	Toggle: (self: Checkbox) -> ...any
}

--Example usage:

:Checkbox({
	Value = true,
	Label = "Check box",
	Callback = function(self, Value: boolean)
		print("Ticked", Value)
	end
})

--:Radiobox

type Radiobox = {
	Label: string?,
	IsRadio: boolean?,
	Value: boolean,
	NoAnimation: boolean?,
	Callback: ((...any) -> unknown)?,
	SetTicked: (self: Checkbox, Value: boolean, NoAnimation: boolean) -> ...any,
	Toggle: (self: Checkbox) -> ...any
}

--Example usage:

:Radiobox({
	Value = true,
	Label = "Radio box",
	Callback = function(self, Value: boolean)
		print("Ticked", Value)
	end
})

--:Viewport

type Viewport = {
	Model: Instance,
	WorldModel: WorldModel?,
	Viewport: ViewportFrame?,
	Camera: Camera?,
	Clone: boolean?, --// Otherwise will parent
	SetCamera: (self: Viewport, Camera: Camera) -> Viewport,
	SetModel: (self: Viewport, Model: Model, PivotTo: CFrame?) -> Model
}

--Example usage:

:Viewport({
	Size = UDim2.new(1, 0, 0, 200),
	Clone = true,
	Model = workspace.Rig
})

--// Rotate example
local Model = Viewport.Model

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function(DeltaTime)
	local Rotation = CFrame.Angles(0, math.rad(30*DeltaTime), 0) 
	local Pivot = Model:GetPivot() * Rotation
	
	Model:PivotTo(Pivot)
end)

--:InputText

type InputText = {
	Value: string,
	Placeholder: string?,
	MultiLine: boolean?,
	Label: string?,
	Callback: ((string, ...any) -> unknown)?,
	Clear: (InputText) -> InputText,
	SetValue: (InputText, Value: string) -> InputText
}

--Example usage:

:InputText({
    Label = "Input text",
    Value = "Hello world!"
})

--:InputTextMultiline

type InputText = {
	Value: string,
	Placeholder: string?,
	Label: string?,
	Callback: ((string, ...any) -> unknown)?,
	Clear: (InputText) -> InputText,
	SetValue: (InputText, Value: string) -> InputText
}

--Example usage:

:InputTextMultiline({
    Value = "Hello world!"
})

--:Console

type Console = {
	Enabled: boolean?,
	ReadOnly: boolean?,
	Value: string?,
	RichText: boolean?,
	TextWrapped: boolean?,
	LineNumbers: boolean?,
	AutoScroll: boolean,
	LinesFormat: string,
	MaxLines: number,
	UpdateLineNumbers: (Console) -> Console,
	UpdateScroll: (Console) -> Console,
	SetValue: (Console, Value: string) -> Console,
	GetValue: (Console) -> string,
	Clear: (Console) -> Console,
	AppendText: (Console, ...string) -> Console,
	CheckLineCount: (Console) -> Console
}

--Example usage:

:Console({
    LineNumbers = true
})

--:Region

type Region = {
	Scroll: boolean?
}

--Example usage:

--// Canvas
local Region = ...:Region()

Region:Label({
    Text="Hello world!"
})

--:List

type List = {
	Padding: number?
}

--Example usage:

:List()

--// Canvas
List:Label({Text="Hello world!"})

--:CollapsingHeader

type CollapsingHeader = {
	Title: string,
	Icon: string?,
	IsTree: boolean?,
	NoAnimation: boolean?,
	Collapsed: boolean?,
	Offset: number?,
	SetCollapsed: (CollapsingHeader, Open: boolean) -> CollapsingHeader
}

--Example usage:

:CollapsingHeader()

--// Canvas
CollapsingHeader:Label({Text="Hello world!"})

--:TreeNode

type TreeNode = {
	Title: string,
	Icon: string?,
	NoAnimation: boolean?,
	Collapsed: boolean?,
	Offset: number?,
	SetCollapsed: (CollapsingHeader, Open: boolean) -> CollapsingHeader
}

--Example usage:

:TreeNode()

--// Canvas
TreeNode:Label({Text="Hello world!"})

--:Separator

type Separator = {
	Text: string?
}

--Example usage:

:Separator({Text="Separator"}) --// With text
:Separator()

--:Indent

type Indent = {
	Offset: number?
}

--Example usage:

:Indent({Offset=30})

--// Canvas
Indent:Label({Text="This is indented by 30 pixels"})

--:BulletText

type BulletText = {
	Padding: number,
	Icon: (string|number)?,
	Rows: {
		[number]: string?,
	}
} 

--Example usage:

:BulletText({
	Rows = {
		"This is point 1",
		"This is point 2"
	}
})

--:Bullet

type Bullet = {
	Padding: number?
}

--Example usage:

:Bullet()

--// Canvas
Bullet:Label({
    Text = "Hello world!"
})

--:Row

type Row = {
	Spacing: number?,
	Expand: (Row) -> Row
}

--Example usage:

:Row()

--// Canvas
Row:Label({
    Text = "Hello world!"
})

--:SliderInt

type SliderInt = {
	Value: number?,
	Format: string?,
	Label: string?,
	Minimum: number,
	Maximum: number,
	Disabled = boolean?,
	NoGrab = boolean?,
	NoClick = boolean?, //-- Drag only if true
	NoAnimation: boolean?,
	Callback: (number) -> any?,
	ReadOnly: boolean?,
	SetValue: (Slider, Value: number, IsSlider: boolean?) -> Slider?
}

--Example usage:

:SliderInt({
    Label = "Slider",
    Value = 5,
    Minimum = 1,
    Maximum = 32,
})

--:SliderFloat

type SliderFloat = {
	Value: number?,
	Format: string?,
	Label: string?,
	Minimum: number,
	Maximum: number,
	NoAnimation: boolean?,
	Callback: (number) -> any?,
	ReadOnly: boolean?,
	SetValue: (Slider, Value: number, IsSlider: boolean?) -> Slider?
}

--Example usage:

:SliderFloat({
    Label = "Slider Float", 
    Minimum = 0.0, 
    Maximum = 1.0,
    Value = 0.5,
    Format = "Ratio = %.3f"
})

--:SliderProgress

type SliderProgress = {
	Value: number?,
	Format: string?,
	Label: string?,
	Minimum: number,
	Maximum: number,
	NoAnimation: boolean?,
	Callback: (number) -> any?,
	ReadOnly: boolean?,
	SetValue: (Slider, Value: number, IsSlider: boolean?) -> Slider?
}

--Example usage:

:SliderProgress({
    Label = "Progress Slider",
    Value = 8,
    Minimum = 1,
    Maximum = 32,
})

--:SliderEnum

type SliderEnum = {
	Items: {
		[number]: any
	},
	Label: string,
	Value: number,
	Callback: (SliderEnum, Value: string?) -> any?,
} & SliderIntFlags

--Example usage:

:SliderEnum({
    Items = {"Fire", "Earth", "Air", "Water"},
    Value = 2, -- Index
    Label = "Item"
})

--:DragInt

type DragInt = {
	Format: string?,
	Label: string?,
	Callback: (DragInt, number) -> any,
	Minimum: number?,
	Maximum: number?,
	Value: number?,
	ReadOnly: boolean?,

	SetValue: (DragIntFlags, number) -> DragIntFlags,
}

--Example usage:

:DragInt({
    Maximum = 100,
    Minimum = 0,
    Label = "Drag Int 0..100"
})

--:DragFloat

type DragFloat = {
	Format: string?,
	Label: string?,
	Callback: (DragInt, number) -> any,
	Minimum: number?,
	Maximum: number?,
	Value: number?,
	ReadOnly: boolean?,

	SetValue: (DragIntFlags, number) -> DragIntFlags,
}

--Example usage:

:DragFloat({
    Maximum = 1,
    Minimum = 0,
    Value = 0.5
})

--:InputColor3

type InputColor3 = {
	Label: string?,
	Value: Color3?,
	Callback: (InputColor3, Value: Color3) -> any,
	SetValue: (InputColor3, Value: Color3) -> InputColor3,
}

--Example usage:

:InputColor3({
    Value = Color3.fromRGB(255,255,255),
    Label = "Color 1"
})

--:InputCFrame

type InputCFrame = {
	Label: string?,
	Value: CFrame?,
	Callback: (InputCFrame, Value: CFrame) -> any,
	SetValue: (InputCFrame, Value: CFrame) -> InputCFrame,
}

--Example usage:

:InputCFrame({
    Value = CFrame.new(1,1,1),
    Minimum = -200,
    Maximum = 200,
    --Callback = print
})

--:InputInt

type InputInt = {
	Value: number,
	Maximum: number?,
	Minimum: number?,
	Placeholder: string?,
	MultiLine: boolean?,
	Increment: number?,
	Label: string?,
	Callback: ((string, ...any) -> unknown)?,
	SetValue: (InputInt, Value: number, NoTextUpdate: boolean?) -> InputInt,
	Decrease: (InputInt) -> nil,
	Increase: (InputInt) -> nil,
}

--Example usage:

:InputInt({
    Label = "InputInt (w/ limit)",
    Value = 5,
    Maximum = 10,
    Minimum = 1
})

--:InputText

type InputText = {
	Value: string,
	Placeholder: string?,
	MultiLine: boolean?,
	Label: string?,
	Callback: ((string, ...any) -> unknown)?,
	Clear: (InputText) -> InputText,
	SetValue: (InputText, Value: string) -> InputText,
}

--Example usage:

:InputText({
    Placeholder = "Enter text here",
    Label = "Input text (w/ hint)",
    Value = "Hello world!"
})

--:ProgressBar

type ProgressBar= {
	Value: number?,
	Format: string?,
	Label: string?,
	NoAnimation: boolean?,
	SetPercentage: (Slider, Value: number, IsSlider: boolean?) -> Slider?
}

--Example usage:

:ProgressBar({
    Label = "Progress Slider",
    Value = 50
})

--:Combo

type Combo = {
	Label: string?,
	Placeholder: string?,
	Callback: ((Combo, Value: any) -> any)?,
	Items: {[number?]: any}?,
	GetItems: (() -> table)?
}

--Example usage:

--// Array
:Combo({
	Label = "Combo",
	Selected = "AAAA",
	Items = {
		"AAAA", 
		"BBBB", 
		"CCCC"
	}
})

--// Dict
:Combo({
	Label = "Combo",
	Selected = "Apple",
	Items = {
		Apple = "AAA",
		Banana = "BBB",
		Orange = "CCC",
	},
})

--// Function
:Combo({
	Label = "Combo",
	Selected = "aaa",
	GetItems = function()
		return {
			"aaa",
			"bbb",
			"ccc",
		}
	end,
})

--:Keybind

type Keybind = {
	Value: Enum.KeyCode?,
	DeleteKey: Enum.KeyCode?,
	Enabled: boolean?,
	IgnoreGameProcessed: boolean?,
	Callback: ((Enum.KeyCode) -> any)?,

	SetValue: ((Keybind, New: Enum.KeyCode) -> any)?,
	WaitForNewKey: ((Keybind) -> any)?,
}

--Example usage:

:Keybind({
	Label = "Keybind",
	Value = Enum.KeyCode.Q,
	Callback = function(self, KeyCode)
		print(KeyCode)
	end,
})

--:PlotHistogram

type PlotHistogram = {
	Label: string?,
	Points: {
		[number]: number
	},
	Minimum: number?, // Otherwise automatic
	Maximum: number?, // Otherwise automatic
	GetBaseValues: (PlotHistogram) -> (number, number),
	UpdateGraph: (PlotHistogram) -> PlotHistogram,
	PlotGraph: (PlotHistogram, Points: {
		[number]: number
	}) -> PlotHistogram,
	Plot: (PlotHistogram, Value: number) -> {
		SetValue: (Plot, Value: number) -> nil,
		GetPointIndex: (Plot) -> number,
		Remove: (Plot, Value: number) -> nil,
	},
}

--Example usage:

:PlotHistogram({
    Points = {0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2}
})

--:Table

type Table = {
	Align: string?,
	Border: boolean?,
	RowBackground: boolean?,
	RowBgTransparency: number?,

	Row: (Table) -> {
		Column: (Row) -> Elements
	},
	ClearRows: (Table) -> unknown,
}

--Example usage:

local Table = ...:Table()

local Row = Table:Row()

local Column1 = Row:Column()
Column1:Label({Text="Column 1!"})

local Column2 = Row:Column()
Column2 :Label({Text="Column 2!"})

--:TabSelector

type TabSelector = {
	NoTabsBar: boolean?,
	NoAnimation: boolean?,
	AutoSelectNewTabs: boolean?,

	CreateTab: (TabsBox, {
		Name: string,
		AutoSize: string?,
		TabButton: boolean?,
		Closeable: boolean?,
		Icon: (string|number)?
	}) -> Elements,
	RemoveTab: (TabsBox, Target: (table|string)) -> nil,
	SetActiveTab: (TabsBox, Target: (table|string)) -> nil,
}

--Example usage:

local TabSelector = ...:TabSelector()
		
local Names = {"Avocado", "Broccoli", "Cucumber"}
for _, Name in next, Names do
	TabSelector:CreateTab({Name=Name}):Label({
		Text = `This is the {Name} tab!\nblah blah blah blah blah`
	})
end

--:Window

type Window = {
	AutoSize: string?,
	CloseCallback: (Window) -> boolean?,
	Collapsed: boolean?,
	IsDragging: boolean?,
	MinSize: Vector2?,
	Theme: any?,
	Title: string?,
	NoTabs: boolean?,
	NoMove: boolean?,
	NoGradients: boolean?,
	NoResize: boolean?,
	NoClose: boolean?,
	NoCollapse: boolean?,
	NoScrollBar: boolean?,
	NoSelectEffect: boolean?,
	NoFocusOnAppearing: boolean?,
	NoDefaultTitleBarButtons: boolean?,
	NoWindowRegistor: boolean?,
	OpenOnDoubleClick: boolean?,
	SetTheme: (Window, ThemeName: string) -> Window,
	SetTitle: (Window, Title: string) -> Window,
	UpdateConfig: (Window, Config: table) -> Window,
	SetCollapsed: (Window, Collapsed: boolean, NoAnimation: boolean?) -> Window,
	SetCollapsible: (Window, Collapsible: boolean) -> Window,
	SetFocused: (Window, Focused: boolean) -> Window,
	Center: (Window) -> Window,
	SetVisible: (Window, Visible: boolean) -> Window,
	TagElements: (Window, Objects: {
		[GuiObject]: string
	}) -> nil,
	Close: (Window) -> nil,
}

--Example usage:

:Window({
	Title = "Hello world!",
	Size = UDim2.fromOffset(300, 200)
})

--// Canvas
Window:Label({
    Text = "Hello world!"
})

--:TabsWindow

type TabsWindow = {
	AutoSize: string?,
	CloseCallback: (Window) -> boolean?,
	Collapsed: boolean?,
	IsDragging: boolean?,
	MinSize: Vector2?,
	Theme: any?,
	Title: string?,
	NoTabs: boolean?,
	NoMove: boolean?,
	NoGradients: boolean?,
	NoResize: boolean?,
	NoTitleBar: boolean?,
	NoClose: boolean?,
	NoCollapse: boolean?,
	NoScrollBar: boolean?,
	NoSelectEffect: boolean?,
	NoFocusOnAppearing: boolean?,
	NoDefaultTitleBarButtons: boolean?,
	NoWindowRegistor: boolean?,
	OpenOnDoubleClick: boolean?,
	SetTheme: (Window, ThemeName: string) -> Window,
	SetTitle: (Window, Title: string) -> Window,
	UpdateConfig: (Window, Config: table) -> Window,
	SetCollapsed: (Window, Collapsed: boolean, NoAnimation: boolean?) -> Window,
	SetCollapsible: (Window, Collapsible: boolean) -> Window,
	SetFocused: (Window, Focused: boolean) -> Window,
	Center: (Window) -> Window,
	SetVisible: (Window, Visible: boolean) -> Window,
	TagElements: (Window, Objects: {
		[GuiObject]: string
	}) -> nil,
	Close: (Window) -> nil,
}

--Example usage:

:TabsWindow({
	Title = "Hello world!",
	Size = UDim2.fromOffset(300, 200)
})

--// Create Tab
local Tab = TabsWindow:CreateTab({
	Name="Tab"
})

--// Canvas
Tab:Label({
    Text = "Hello world!"
})

--:PopupModal

type PopupModal = {
	NoResize: boolean?,
	NoAnimation: boolean?,
	NoClose: boolean?,
	NoCollapse: boolean?,
	Theme: string,
	Parent: GuiObject?
}

--Example usage:

local ModalWindow = ...:PopupModal({
	Title = "Delete?"
})

ModalWindow:Label({
	Text = "All those beautiful files will be deleted.\nThis operation cannot be undone!",
	TextWrapped = true
})
ModalWindow:Separator()

ModalWindow:Checkbox({
	Value = false,
	Label = "Don't ask me next time"
})

local Row = ModalWindow:Row({
	Expanded = true
})
Row:Button({
	Text = "Okay",
	Callback = function()
		ModalWindow:ClosePopup()
	end,
})
Row:Button({
	Text = "Cancel",
	Callback = function()
		ModalWindow:ClosePopup()
	end,