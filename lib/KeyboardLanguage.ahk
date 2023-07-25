#Requires AutoHotkey v2.0

; inspired by https://www.autohotkey.com/board/topic/116538-detect-which-language-is-currently-on/

GetKeyboardLanguage()
{
	If !LangID := GetKeyboardLanguageCode()
		return
	
	if (LangID = "0409" || LangID = "0809") ; "English_United_States" || "English_United_Kingdom"
		return "EN"
	else if (LangID = "0407" || LangID = "0c07" || LangID = "0807") ; "German_Standard" || "German_Austrian" || "German_Swiss"
		return "DE"
}
GetKeyboardLanguageCode()
{
	if !InputLocaleID:=Format("0x{:x}", DllCall("GetKeyboardLayout", "UInt", 0))
		return false
	return SubStr(InputLocaleID, -4)
}