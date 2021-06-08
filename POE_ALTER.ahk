#Persistent
#SingleInstance, Force

global mouseX
global mouseY
global isRun = false
global getAlterX = 0
global getAlterY = 0
global getAugX = 0
global getAugY = 0
global getItemX = 0
global getItemY = 0
global getItemOption := []
global DUMMY_STRING = "DUMMYDUMMY"

Gui, Add, Checkbox, x10 y10 w130 h20 gWinAlwaysOnTop vWinAlwaysOnTop, 항상 위에
Gui, Add, Text, x10 y37 w100 h20, 변화의 오브(F5)
Gui, Add, Edit, x110 y35 w50 h20 vEditAlterX, 0
Gui, Add, Edit, x160 y35 w50 h20 vEditAlterY, 0
Gui, Add, Text, x10 y57 w100 h20, 확장의 오브(F6)
Gui, Add, Edit, x110 y55 w50 h20 vEditAugX, 0
Gui, Add, Edit, x160 y55 w50 h20 vEditAugY, 0
Gui, Add, Text, x10 y77 w100 h20, 아이템 칸(F7)
Gui, Add, Edit, x110 y75 w50 h20 vEditItemX, 0
Gui, Add, Edit, x160 y75 w50 h20 vEditItemY, 0

Gui, Add, Text, x10 y117 w100 h20, 아이템 옵션1
Gui, Add, Edit, x110 y115 w180 h20 vEditItemOption1,
Gui, Add, Text, x10 y137 w100 h20, 아이템 옵션2
Gui, Add, Edit, x110 y135 w180 h20 vEditItemOption2,
Gui, Add, Text, x10 y157 w100 h20, 아이템 옵션3
Gui, Add, Edit, x110 y155 w180 h20 vEditItemOption3,
Gui, Add, Text, x10 y177 w100 h20, 아이템 옵션4
Gui, Add, Edit, x110 y175 w180 h20 vEditItemOption4,
Gui, Add, Text, x10 y197 w100 h20, 아이템 옵션5
Gui, Add, Edit, x110 y195 w180 h20 vEditItemOption5,

Gui, Add, Text, x140 y10 w150 h20, 시작(F3) / 정지(F4)

Gui, Show, w300 h300, 똥

Gui, -MaximizeBox -MinimizeBox

CoordMode, Mouse, Screen
return

GuiClose:
	ExitApp
return

WinAlwaysOnTop:
	Gui, Submit, NoHide
	if (WinAlwaysOnTop == 1)
	{
		Gui, +AlwaysOnTop
	}
	else
	{
		Gui, -AlwaysOnTop
	}
return

;; 시작
$F3::
	GuiControlGet, getAlterX,,EditAlterX
	GuiControlGet, getAlterY,,EditAlterY
	
	GuiControlGet, getAugX,,EditAugX
	GuiControlGet, getAugY,,EditAugY
	
	GuiControlGet, getItemX,,EditItemX
	GuiControlGet, getItemY,,EditItemY
	
	loop % getItemOption.Length()
	{
		getItemOption.Pop()
	}
	
	i := 1
	loop, 5
	{
		GuiControlGet, txt,,EditItemOption%i%
		if (txt != "")
		{
			getItemOption.Push(txt)
		}
		i++
	}
	
	if (getItemOption.length() == 0)
	{
		MsgBox, "Option is Empty"
		return
	}
	
	isRun := true
	loop
	{
		MouseMoveToAlter()
		MouseMoveToItem()
		
		CheckItemOption()
		
		if (isRun = false)
		{
			return
		}
	}
return

;; 종료
$F4::
	MsgBox, "END"
	clipboard =
	isRun := false
return

;; 변화의 오브
$F5::
	MouseGetpos, mouseX, mouseY
	GuiControl, Text, EditAlterX, %mouseX%
	GuiControl, Text, EditAlterY, %mouseY%
return

;; 확장의 오브
$F6::
	MouseGetpos, mouseX, mouseY
	GuiControl, Text, EditAugX, %mouseX%
	GuiControl, Text, EditAugY, %mouseY%
return

;; 아이템 칸
$F7::
	MouseGetpos, mouseX, mouseY
	GuiControl, Text, EditItemX, %mouseX%
	GuiControl, Text, EditItemY, %mouseY%
return

$F9::
	CheckItemOption()
return

MouseMoveToAlter()
{
	Random, randX, -5,5
	Random, randY, -5,5
	MouseClick, R, getAlterX + randX, getAlterY + randY, 1, 0
}

MouseMoveToAug()
{
	Random, randX, -5,5
	Random, randY, -5,5
	MouseClick, R, getAugX + randX, getAugY + randY, 1, 0
}

MouseMoveToItem()
{
	Random, randX, -5,5
	Random, randY, -5,5
	MouseClick, L, getItemX + randX, getItemY + randY, 1, 0
}

CheckItemOption()
{
	clipboard = 
	Random, randTime, 150, 500
	Sleep, %randTime%
	send, ^c
	ClipWait
	
	clipSaved := Clipboard
	StringGetPos, Num1, clipSaved, --------, L2
	StringGetPos, Num2, clipSaved, --------, L3
	if (Num1 = -1 || Num2 = -1)
	{
		return
	}
	txtSub := % SubStr(clipSaved, Num1+11, (Num2-1)-(Num1+11))
	
	check2Option := 0
	Loop, Parse, txtSub, `n
	{
		txtOption .= A_LoopField "`n"
		i := 1
		Loop % getItemOption.length()
		{
			if ( CheckItemOptionDetail(txtOption, i) == true)
			{
				;MsgBox, "FIND"
				isRun := false
				return
			}
			i++
		}
		check2Option++
	}
	if (check2Option < 2)
	{
		MouseMoveToAug()
		MouseMoveToItem()
		CheckItemOption()
	}
}

CheckItemOptionDetail(option, i)
{
	StringGetPos, Num, option, % getItemOption[i]
	if (Num != -1)
	{
		return true
	}
	return false
}
