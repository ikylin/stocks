require 'win32api'

# system 'start cmd.exe'

find_window = Win32API.new 'user32', 'FindWindow', ['P', 'P'], 'L'
# Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
keybd_event = Win32API.new 'user32', 'keybd_event' , ['I' , 'I' , 'L' , 'L'], 'V'
set_fore_window = Win32API.new 'user32', 'SetForegroundWindow', ['L'], 'L'
# Declare Function SetForegroundWindow Lib "user32" Alias "SetForegroundWindow" (ByVal hwnd As Long) As Long
show_window = Win32API.new 'user32', 'ShowWindow', ['L' , 'L' ], 'L'
# Declare Function ShowWindow Lib "user32" Alias "ShowWindow" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
post_message = Win32API.new 'user32', 'PostMessage' , ['L' , 'L' , 'L' , 'L' ], 'L'
get_dlg_item = Win32API.new 'user32', 'GetDlgItem' , ['L' , 'L' ], 'L'
get_window_rect = Win32API.new 'user32', 'GetWindowRect' , ['L' , 'P' ], 'I'
set_cursor_pos = Win32API.new 'user32', 'SetCursorPos' , ['L' , 'L' ], 'I'
mouse_event = Win32API.new 'user32', 'mouse_event' , ['L' , 'L' , 'L' , 'L' , 'L' ], 'V'
set_focus =  Win32API.new 'user32', 'SetFocus', ['L']
# Declare Function SetFocusAPI& Lib "user32" Alias "SetFocus" (ByVal hwnd As Long)

KEYEVENTF_KEYDOWN = 0
KEYEVENTF_KEYUP = 2
WM_SYSCOMMAND = 0x0112
SC_CLOSE = 0xF060
MOUSEEVENTF_LEFTDOWN = 0x0002
MOUSEEVENTF_LEFTUP = 0x0004
SW_HIDE = 0x0000
SW_NORMAL = 0x0001
SW_MAXIMIZE = 0x0003
SW_SHOWNOACTIVATE = 0x0004
SW_SHOW = 0x0005
SW_MINIMIZE = 0x0006
SW_RESTORE = 0x0009
SW_SHOWDEFAULT = 0x0010



sleep 2

main_window = find_window.call 'Notepad', nil
# main_window = find_window.call 'Notepad', '无标题 - 记事本'
p main_window

show_window.call main_window, SW_MAXIMIZE
sleep 2

# show_window.call main_window, SW_MINIMIZE
sleep 1

set_fore_window.call main_window
# set_focus.call main_window

sleep 1
"this is some text".upcase.each_byte do |b|
	keybd_event.call b, 0, KEYEVENTF_KEYDOWN, 0
	sleep 0.05
	keybd_event.call b, 0, KEYEVENTF_KEYUP, 0
	sleep 0.05
end

# show_window.call main_window, SW_HIDE

sleep 3

# post_message.call main_window, WM_SYSCOMMAND, SC_CLOSE, 0


# dialog = find_window.call nil, 'Steganos LockNote' )
# IDNO = 7
# button = get_dlg_item.call dialog, IDNO


# rectangle = [0, 0, 0, 0].pack 'L*'
# get_window_rect.call button, rectangle
# left, top, right, bottom = rectangle.unpack 'L*'



# center = [(left + right) / 2, (top + bottom) / 2]
# set_cursor_pos.call *center
# mouse_event.call MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0
# mouse_event.call MOUSEEVENTF_LEFTUP, 0, 0, 0, 0