#!/bin/bash

SS2=$'\eN'        # Single Shift Two
SS3=$'\eO'        # Single Shift Three
DCS=$'\eP'        # Device Control String
CSI=$'\e['        # Control Sequence Introducer
ST=$'\e\\'        # String Terminator
OSC=$'\e]'        # Operating System Command
SOS=$'\eX'        # Start of String
PM=$'\e^'         # Privacy Message
APC=$'\e_'        # Application Program Command
RIS=$'\ec'        # Reset to Initial State

function cursorUp() {
  echo -n "${CSI}${1}A"
}

function cursorDown() {
  echo -n "${CSI}${1}B"
}

function cursorRight() {
  echo -n "${CSI}${1}C"
}

function cursorLeft() {
  echo -n "${CSI}${1}D"
}

function cursorDownAtStart() {
  echo -n "${CSI}${1}E"
}

function cursorUpAtStart() {
  echo -n "${CSI}${1}F"
}

function cursorToColumn() {
  echo -n "${CSI}${1}G"
}

function cursorPosition() {
  echo -n "${CSI}${1};${2}H"
}

function clearScreen() {
  echo -n "${CSI}2J"
}

function tabsForward() {
  echo -n "${CSI}${1}I"
}

function tabsBackward() {
  echo -n "${CSI}${1}Z"
}

# 0: Clear current column
# 3: Clear all
function tabsClear() {
  echo -n "${CSI}${1}g"
}

function repeatPrecedingCharacter() {
  echo -n "${CSI}${1}b"
}

# 0 To end of screen
# 1 To beginning of screen
# 2 Clear screen
# 3 Clear scrollbuffer
function eraseDisplay() {
  echo -n "${CSI}${1}J"
}

# 0 To end of line
# 1 To beginning of line
# 2 The full line
function eraseLine() {
  echo -n "${CSI}${1}K"
}

function scrollUp() {
  echo -n "${CSI}${1}S"
}

function scrollDown() {
  echo -n "${CSI}${1}T"
}

# Answers with the cursor position as CSI n;m R as if typed on a keyboard
function deviceStatusReport() {
  echo -n "${CSI}6n"
}

function saveCursorPosition() {
  echo -n "${CSI}s"
}

function restoreCursorPosition() {
  echo -n "${CSI}u"
}

function showCursor() {
  echo -n "${CSI}?25h"
}

function hideCursor() {
  echo -n "${CSI}?25l"
}

function enableAlternativeBuffer() {
  echo -n "${CSI}?1049l"
}

function disableAlternativeBuffer() {
  echo -n "${CSI}?1049h"
}

function setVerticalScrollMargins() {
  echo -n "${CSI}${1};${2}r"
}

# 0 or 1: Blinking block
# 2: Steady block
# 3: Blinking underline
# 4: Steady underline
function setCursorStyle() {
  echo -n "${CSI}${1} q"
}

function beep() {
  echo -ne "\07"
}

function lightBackground() {
  echo -n "${CSI}?5h"
}

function darkBackground() {
  echo -n "${CSI}?5l"
}

function deleteCharacters() {
  echo -n "${CSI}${1}P"
}

function deleteLines() {
  echo -n "${CSI}${1}M"
}

function eraseCharacters() {
  echo -n "${CSI}${1}X"
}

function insertCharacters() {
  echo -n "${CSI}${1}@"
}

function insertLines() {
  echo -n "${CSI}${1}L"
}

function setInsertMode() {
  echo -n "${CSI}4h"
}

function setReplaceMode() {
  echo -n "${CSI}4l"
}

function localEchoOff() {
  echo -n "${CSI}12h"
}

function localEchoOn() {
  echo -n "${CSI}12l"
}

function setSendMousePositionOnButtonPress() {
  echo -n "${CSI}?9h"
}

function resetSendMousePositionOnButtonPress() {
  echo -n "${CSI}?9l"
}

function setSendMousePositionOnButtonPressAndRelease() {
  echo -n "${CSI}?1000h"
}

function resetSendMousePositionOnButtonPressAndRelease() {
  echo -n "${CSI}?1000l"
}

function setMouseHiliteTracking() {
  echo -n "${CSI}?1001h"
}

function resetMouseHiliteTracking() {
  echo -n "${CSI}?1001l"
}

function setMouseCellMotionTracking() {
  echo -n "${CSI}?1002h"
}

function resetMouseCellMotionTracking() {
  echo -n "${CSI}?1002l"
}

function setMouseMotionTracking() {
  echo -n "${CSI}?1003h"
}

function resetMouseMotionTracking() {
  echo -n "${CSI}?1003l"
}

function setBracketedPasteMode() {
  echo -n "${CSI}?2004h"
}

function resetBracketedPasteMode() {
  echo -n "${CSI}?2004l"
}

function useAlternateBuffer() {
  echo -n "${CSI}?47h"
}

function useNormalBuffer() {
  echo -n "${CSI}?47l"
}
