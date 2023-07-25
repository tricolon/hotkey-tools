#Requires AutoHotkey v2.0

; Morse
; by Laszlo
; https://www.autohotkey.com/board/topic/15574-morse-find-hotkey-press-and-hold-patterns/

; Beispiel:
; !y::
; {
;    p := Morse() ; pattern
;    if (p = "0")
;       MsgBox "Kurz"
;    else if (p = "00")
;       MsgBox "Zweimal kurz"
;    else if (p = "01")
;       MsgBox "Lang und Kurz"
;    else
;       MsgBox "Muster gedrückt: " p
;  }

Morse(timeout := 400) {
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey, "[\*\~\$\#\+\!\^]")
   Loop {
      t := A_TickCount
      ErrorLevel := !KeyWait(key)
      Pattern .= A_TickCount-t > timeout
      ErrorLevel := !KeyWait(key, "DT" tout)
      If (ErrorLevel)
         Return Pattern
   }
}