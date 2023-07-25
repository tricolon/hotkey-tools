#Requires AutoHotkey v2.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Useful functions by Jakob Hansbauer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; converts number to string with n decimal places
decPl(num, n) {
    return Format("{:0." n "f}", num)
}

; remove unnecessary "0" followed by "." from string
rem0(num) {
    return RegExReplace('' . num, '\.?0+$')
}

; converts number string to one with German commas "," instead of "."
dt(str) {
    return StrReplace(str,'.',',')
}

; inverts string
flip(str) {
    arr := StrSplit(str)
    loop StrLen(str)
        rev .= arr[StrLen(str) + 1 - A_Index]
    return rev
}

; outputs n random characters from the string charPool
randm(n, charPool) {
	loop n {
		r := Random(1, StrLen(charPool))
		rdmStr .= SubStr(charPool, r, 1)
	}
	return rdmStr
}

; run script. warning: do not let the user execute any code! [inspired by https://www.autohotkey.com/docs/v2/lib/Run.htm#ExecScript]
execute(Script, Wait:=true)
{
    shell := ComObject("WScript.Shell")
    exec := shell.Exec("AutoHotkey.exe /ErrorStdOut *")
    exec.StdIn.Write(script)
    exec.StdIn.Close()
    if Wait
        return exec.StdOut.ReadAll()
}

; show tooltip "(text)" for (time in s) or until a click and put it into the clipboard if (setClipboard) parameter is true
tt(text, time := 3, setClipboard := true) {
    
	ToolTip text ; tooltip
	if (setClipboard)
        A_Clipboard := text ; copy text to clipboard
    
	; hide tooltip on click
	KeyWait "LButton", "D T" time ; wait for a click or timeout after specified time
		; When ("LButton" is pushed down) {
			Tooltip ; hide tooltip
		; }
}

; replace certain characters in string (str). The two-dimensional array (replace) defines the pairs of replacements. "regex/" will trigger regex replacement.
replaceChars(str, replace)
{
    for i, pair in replace {
        if (SubStr(pair[1],1,6) = "regex/") ; string starts with "regex/"
            str := RegExReplace(str, SubStr(pair[1],7,StrLen(pair[1])), pair[2]) ; RegExReplace
        else
            str := StrReplace(str, pair[1], pair[2]) ; StrReplace
    }
    return str
}

; replace selected text by using the function f(selection). whether text has been selected is only checked by changing the clipboard. if a program copies text without any being selected, errors may occur if the function is triggered without anything being selected.
replaceSelection(f)
{
    prevClip := A_Clipboard ; get clipboard
        A_Clipboard := "" ; empty the clipboard
        Send "^c"
        if !ClipWait(.5) ; if nothing was copied
        {
            A_Clipboard := prevClip ; reset clipboard
            return ; attempt to copy text onto clipboard failed
        }

        A_Clipboard := f(A_Clipboard) ; do something with clipboard and copy it again, alternative to copying would be something like this: Send "{bs}" StrReplace(op, "+", "{+}")
        Sleep 50
        Send "{bs}^v"
        Sleep 50
    A_Clipboard := prevClip ; reset clipboard
}

; get JSON values (if string) by JSON property and seperate them by ", " if there are multiple
getJsonVal(jsonStr, prop, seperator := ", ")
{
    spo := 1 ; starting position
    op := ""
    while (fpo := RegExMatch(jsonStr, '"' prop '":"((?:\\"|[^"])+)"', &m, spo)) ; find all values with the given property
    {
        op .= m[1] seperator ; add value to output string
        spo := fpo + StrLen(m[0]) ; new starting position is found position plus length of the match
    }
    op := SubStr(op, 1, StrLen(op)-StrLen(seperator)) ; remove last seperator
    return op
}

; encode string to via uri escape codes, e.g. Café → Caf%C3%A9 [inspired by https://www.autohotkey.com/boards/viewtopic.php?t=112741&p=502093]
str2url(str, allowed := "[0-9A-Za-z]")
{
    bufferSize := StrPut(str, "UTF-8")
    bufferUtf8 := Buffer(bufferSize)
    StrPut(str,  bufferUtf8, "UTF-8")
    while charCode := NumGet(bufferUtf8, A_Index - 1, "UChar")
    {
        if (RegExMatch(char := Chr(charCode), allowed)) {
            str_uri .= char
        } else {
            str_uri .= Format("%{:02X}", charCode)
        }
    }
    return str_uri
}

; converts UTF-8 byte (as string) to string, e.g. CafÃ© → Café
; The performance of this solution may be not the best, but it is the fastest work-around without bit-wise operations that I have found and works for my computer.
utf82str(str_utf8)
{
    spo := 1 ; starting position
    str_utf8_new := ""

    while (fpo := RegexMatch(str_utf8, "[\x{00C0}-\x{00DF}].|[\x{00E0}-\x{00EF}]..|\x{00F0}...", &m, spo))
        ; regex:
        ; find 2-byte character (byte is starting with binary 110_ = x00C_ or x00D_) or
        ; find 3-byte character (byte is starting with binary 1110 = x00E_) or
        ; find 4-byte character (byte is starting with binary 11110 = x00F0)
    {
        str_utf8_new .= SubStr(str_utf8, spo, fpo-spo) ; add beginning of str_utf8 to str_utf8_new
        spo := fpo + StrLen(m[0]) ; new starting position is found position plus length of the match
        
        ; convert last bytes via file encoding
        FileOpen(".utf8", "w", "UTF-8-RAW").Write(SubStr(m[0], 2))
        str_utf8_ending := FileRead(".utf8")
        FileDelete ".utf8"
        
            ; (if the first byte had also been converted,
            ;    strings like "Ã" would have been converted to  "ÃƒÂ„"   instead of "Ã" and "Â„"
            ; or strings like "æ¬" would have been converted to "Ã¦ÂœÂ¬" instead of "æ" and "ÂœÂ¬")

        ; add ending bytes to first byte
        str_utf8_combined := SubStr(m[0], 1, 1) StrReplace(str_utf8_ending, "Â") ; remove x00C2 ("Â") from string, add to first byte of character
        
        ; add decoded string to output variable and proceed with next 2-byte character
        str_utf8_new .= str_utf8_combined
    }
    str_utf8_new .= SubStr(str_utf8, spo) ; add ending of str_utf8 to str_utf8_new
    
        ; (now strings like "Ã" are converted to  "Ã„"
        ;   or strings like "æ¬" are converted to "æœ¬")
    
    ; convert everything using buffers
    bufferSize := StrPut(str_utf8_new, "CP0")
    bufferCP0 := Buffer(bufferSize)
    bufferSize := StrPut(str_utf8_new, bufferCP0, bufferSize, "CP0")
    str := StrGet(bufferCP0, "UTF-8")
    
        ; (now strings like "Ã„" are converted to "Ä"
        ;   or strings like "Ã„" are converted to "本")
    
    ; return result
    return str
}

; unescape JSON string, e.g. \"hi\" → "hi"
json2str(str_json)
{
    replace := [ ; replacement pairs
        ["\b", "`b"],  ; backspace
        ["\f", "`f"],  ; form feed
        ["\n", "`n"],  ; newline
        ["\r", "`r"],  ; return
        ["\t", "`t"],  ; tab
        ["\`"", "`""], ; double quote
        ["\\", "\"]    ; backslash
    ]
    return replaceChars(str_json, replace)
}

; unescape Unicode string, e.g. Caf\u00E9 → Café
unicode2str(str_unicodeEsc)
{
    
    spo := 1 ; starting position
    escaped := ""
    while (fpo := RegexMatch(str_unicodeEsc,"\\u([A-Fa-f0-9]{4})", &m, spo)) ; find escaped characters
    {
        str .= SubStr(str_unicodeEsc, spo, fpo-spo) ; add beginning of str_unicodeEsc to str
        spo := fpo + StrLen(m[0]) ; new starting position is found position plus length of the match
        
        charCode := "0x" m[1]
        charCode += 0 ; convert to number
        char := Chr(charCode) ; get character
        
        str .= char ; add char to str
    }
    str .= SubStr(str_unicodeEsc, spo) ; add ending of str_unicodeEsc to str
    return str
}