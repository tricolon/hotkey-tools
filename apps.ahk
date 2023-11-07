#Requires AutoHotkey v2.0
; Optimized for German keyboards
#SingleInstance Force
TraySetIcon "img/apps.png",,1
#Include lib/Morse.ahk
#Include lib/jax.ahk
#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; App shortcuts

#HotIf IniRead("PRESETS.ini", "module_apps", "app_shortcuts") = "on"

    ; Open apps

    #f:: ; open firefox and create new tab
    {
        if (PID := ProcessExist("firefox.exe")) {
            WinActivate "ahk_exe firefox.exe" ; activate the window of the application firefox.exe
            if WinWaitActive("ahk_exe firefox.exe",,2) ; timeout after 2 s
                Send "^t" ; new tab
        } else {
            Run "C:\Program Files\Mozilla Firefox\firefox.exe" ; open firefox
            if WinWait("ahk_exe firefox.exe",,5) { ; timeout after 5 s
                WinActivate ; activate the window
                Send "^t" ; new tab
            }
        }
            
    }
    #c:: ; open calculator
    {
        if (WinExist("Calculator")) {
            WinActivate "Calculator" ; activate the window of the application thunderbird.exe
        } else {
            Run "calc.exe" ; open thunderbird
            if WinWait("Calculator",,5) ; timeout after 5 s
                WinActivate ; activate the window
        }
            
    }

    ; Web search

    #!q:: ; open browser and search qwant for selected text
    {
        A_Clipboard := "" ; empty the clipboard
        Send "^c"
        if !ClipWait(2)
            return ; attempt to copy text onto clipboard failed
        Run "https://www.qwant.com/?q=" A_Clipboard
    }

#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; APIs

#HotIf IniRead("PRESETS.ini", "module_apps", "apis") = "on"

    ; DeepL API

    #!d::deepl("DE") ; translate to German
    #!e::deepl("EN") ; translate to English
    #!f::deepl("FR") ; translate to French
    #!s::deepl("ES") ; translate to Spanish
    #!i::deepl("IT") ; translate to Italian
    #!h::deepl("EL") ; translate to Greek
    #!r::deepl("RU") ; translate to Russian
    #!j::deepl("JA") ; translate to Japanese
    #!k::deepl("KO") ; translate to Korean


    deepl(targetLang) ; translate selected text, show translation via tooltip and copy it to the clipboard
    {
        prevClip := A_Clipboard ; get clipboard
            A_Clipboard := "" ; empty the clipboard
            Send "^c"
            if !ClipWait(.2) || !A_Clipboard
            {
                A_Clipboard := prevClip ; reset clipboard (attempt to copy text onto clipboard failed)
                if !prevClip ; try to process previous clipboard content
                    return ; if previous clipboard was empty, return
            }
            
            ; get & encode selection
            txt := str2url(A_Clipboard)
            
            ; set up http request (DeepL API)
            whr := ComObject("WinHttp.WinHttpRequest.5.1")
            whr.Open("POST", "https://api-free.deepl.com/v2/translate", true)
            whr.SetRequestHeader("authorization", IniRead("PRESETS.ini", "module_apps", "DeepL_Auth_Key")) ; change authentication key in .ini file
            whr.SetRequestHeader("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36")
            whr.SetRequestHeader("content-type", "application/x-www-form-urlencoded")
            
            ; send request
            whr.Send("text=" txt "&target_lang=" targetLang)
            
            ; get output
            whr.WaitForResponse()
            resp := whr.ResponseText
            
            ; parse output
            translation := json2str( utf82str( getJsonVal(resp, "text") ) )
            lang := json2str( utf82str( getJsonVal(resp, "detected_source_language") ) )
            
            ; display output
            multiline := InStr(translation, "`n") ; check if translation is multiline
            op := lang ":" (multiline ? "`n" : " ") translation ; merge output strings
            tt(op, 5, false)
            
        A_Clipboard := translation ; copy translation only to clipboard
    }

    ; Open Thesaurus API

    #!a::openthesaurus() ; find German synonyms (#!a = *a*lternative word)

    openthesaurus() ; find synonyms for selected German word and show via tooltip
    {
        prevClip := A_Clipboard ; get clipboard

        A_Clipboard := "" ; empty the clipboard
        Send "^c"
        if !ClipWait(.2) || !A_Clipboard
        {
            A_Clipboard := prevClip ; reset clipboard (attempt to copy text onto clipboard failed)
            if !prevClip ; try to process previous clipboard content
                return ; if previous clipboard was empty, return
        }
        
        ; get & encode selection
        txt := str2url(A_Clipboard)
        
        ; set up http request (Open Thesaurus API)
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", "https://www.openthesaurus.de/synonyme/search?q=" txt "&format=application/json", true)
        
        ; send request
        whr.Send()
        
        ; get output
        whr.WaitForResponse()
        resp := whr.ResponseText

        ; parse output
        syn := unicode2str( getJsonVal(resp, "term") )

        ; display output
        if (StrLen(syn) < 400) {
            syn := StrReplace(syn, ", ", "`n") ; seperate synonyms by newline if there are not to many (length of string < 400)
            ;tt(syn, 20, false) ; show short response for up to 20 s
        } else {
            ;tt(syn, 30, false) ; show long response for up to 30 s
        }

        A_Clipboard := prevClip ; reset clipboard
    }


    ; DWDS API

    #!p::dwds() ; get pronunciation of German words (IPA)

    dwds() ; get pronunciation (IPA) of selected German word, show it via tooltip and copy it to the clipboard
    {
        prevClip := A_Clipboard ; get clipboard

        A_Clipboard := "" ; empty the clipboard
        Send "^c"
        if !ClipWait(.2) || !A_Clipboard
        {
            A_Clipboard := prevClip ; reset clipboard (attempt to copy text onto clipboard failed)
            if !prevClip ; try to process previous clipboard content
                return ; if previous clipboard was empty, return
        }

        ; get & encode selection
        txt := str2url(A_Clipboard)
        
        ; set up http request (DWDS API)
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", "https://www.dwds.de/api/ipa/?q=" txt, true)
        
        ; send request
        whr.Send()
        
        ; get output
        whr.WaitForResponse()
        resp := whr.ResponseText
        
        ; parse output
        ipa := "[" utf82str( getJsonVal(resp, "ipa") ) "]"

        ; display output & copy it to clipboard
        tt(ipa, 5)
    }

#HotIf