#Requires AutoHotkey v2.0
; Optimized for German keyboards
#SingleInstance Force
TraySetIcon "img/comp.png",,1
#Include lib/jax.ahk
#Include lib/KeyboardLanguage.ahk
#Hotstring ? o c x ; for the whole script: trigger inside words; omit the ending character; execute
#Hotstring EndChars ​ ; only ending character: zero-width space (not visible)
DE := GetKeyboardLanguage() = "DE" ; language check for conditional hotstrings; imporant: reload required when language is changed!

; variables
compose := 0
modified := 0

; presets
defaultLanguage := IniRead("PRESETS.ini", "general", "default_language")
if (defaultLanguage != "auto")
	DE := defaultLanguage = "DE"

; compose key
*CapsLock:: ; CapsLock (or modifier key + CapsLock)
{
	shiftPressed := GetKeyState("Shift")
	global compose := 1, modified := 0

	Hotstring "Reset"
	
    KeyWait "CapsLock"	; wait till CapsLock key is released
	; When ("CapsLock" is released) {

		compose := 0
		
		if (modified = -1) { ; not triggered by hotstring but hotkeys
			return
		} else {
			SendLevel 1
			SendEvent "​" ; zero width space
		}
		
		; if hotstring is now triggered, modified will chage to 1
		if (!modified) { ; CapsLock not used as compose key
			SendInput "{bs}" ; delete unused ending character
			if (IniRead("PRESETS.ini", "module_compose", "shift_trigger") != "true" || shiftPressed) ; if ShiftTrigger not activated or shift pressed
				SetCapsLockState !GetKeyState("CapsLock", "T")  ; trigger common CapsLock behavior: toggle CapsLock to its opposite state
		}

	; }
}

; hotstring compose function
cp(char) {
	global modified := 1  ; set modified state to 1
	Hotstring "Reset"     ; reset
	SendInput char        ; send replacement
}
; hotkey compose function
hotkeyCp(char) {
	global modified := -1 ; set modified state to -1
	SendInput char        ; send characters
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; keys
; note that:
; 1. the escape character (`), the ending character (zero-width space) nor space ( ) is not allowed
; 2. the colon (:) is not allowed in the last position
; 3. the hotstring priority decreases from top to bottom
; 4. when pressing the compose key only the script sends nothing and thus deletes the selection

; condition: compose key pressed
#HotIf compose

; shortcuts
:*c0:re::Reload ; reload script: type "re" while holding the compose key
::now::cp(A_Hour ":" A_Min ":" A_Sec) ; current time
::rdm::cp(Random(0, 9)) ; random number
::y/n::cp(Random(0, 1)? "yes" : "no") ; decision maker ("yes or no") [English]
::j/n::cp(Random(0, 1)? "ja" : "nein") ; Entscheidungstreffer ("ja oder nein") [German]

; media control
Numpad5::     hotkeyCp("{Media_Play_Pause}")
NumpadClear:: hotkeyCp("{Media_Play_Pause}")
Numpad4::     hotkeyCp("{Media_Prev}")
NumpadLeft::  hotkeyCp("{Media_Prev}")
Numpad6::     hotkeyCp("{Media_Next}")
NumpadRight:: hotkeyCp("{Media_Next}")
Numpad8::     hotkeyCp("{Volume_Up}")
NumpadUp::    hotkeyCp("{Volume_Up}")
Numpad2::     hotkeyCp("{Volume_Down}")
NumpadDown::  hotkeyCp("{Volume_Down}")
Numpad0::     hotkeyCp("{Volume_Mute}")
NumpadIns::   hotkeyCp("{Volume_Mute}")
Numpad1::
NumpadEnd::
{ ; rewind
	active_win := WinGetID("A")
	WinActivate "ahk_exe firefox.exe" ; or other browser where the media is played
	hotkeyCp("{Left}")
	WinActivate("ahk_id " active_win)
}
Numpad3::
NumpadPgDn::
{ ; skip
	active_win := WinGetID("A")
	WinActivate "ahk_exe firefox.exe" ; or other browser where the media is played
	hotkeyCp("{Right}")
	WinActivate("ahk_id " active_win)
}

; tooltip special numbers
:*:#pi::tt("3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679")
:*:#eu::tt("2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274")
:*:#sqrt2::tt("1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727")

; tooltip nature constants
:*:#c::tt("299792458 m s⁻¹")                   ; speed of light in vacuum
:*:#hq::tt("1.054571817 · 10⁻³⁴ J s")          ; reduced planck constant
:*:#h::tt("6.62607015 · 10⁻³⁴ J s")            ; planck constant
:*:#e::tt("1.602176634 · 10⁻¹⁹ C")             ; elementary charge
:*:#kB::tt("1.380649 · 10⁻²³ J K⁻¹")           ; boltzmann constant
:*:#alp::tt("7.2973525693 · 10⁻³")             ; fine-structure constant α
:*:#Ri::tt("1.0973731568160 · 10⁷ m⁻¹")        ; rydberg constant R∞
:*:#NA::tt("6.02214076 · 10²³ mol⁻¹")          ; avogadro constant
:*:#F::tt("96485.33212 C mol⁻¹")               ; faraday constant
:*:#R::tt("8.31446261815324 J mol⁻¹ K⁻¹")      ; gas constant
:*:#Kcd::tt("683.002 lm W⁻¹")                  ; luminous efficacy
:*:#my0::tt("1.25663706212 · 10⁻⁶ N A⁻²")      ; vacuum magnetic permeability µ0
:*:#eps0::tt("8.8541878128 · 10⁻¹² C V⁻¹ m⁻¹") ; vacuum permittivity ε0
:*:#me::tt("9.1093837015 · 10⁻³¹ kg")          ; mass of an electron
:*:#mp::tt("1.67262192369 · 10⁻²⁷ kg")         ; mass of an protron
:*:#mn::tt("1.67492749804 · 10⁻²⁷ kg")         ; mass of an neutron
:*:#u::tt("1.66053906660 · 10⁻²⁷ kg")          ; unified atomic mass unit
:*:#atm::tt("1.01325 bar")                     ; standard atmosphere
:*:#G::tt("6.67430 · 10⁻¹¹ m³ kg⁻¹ s⁻²")       ; gravitational constant

; tooltip paper formats
:*c0:#A0::tt("841 × 1189 mm")
:*c0:#A1::tt("594 × 841 mm")
:*c0:#A2::tt("420 × 594 mm")
:*c0:#A3::tt("297 × 420 mm")
:*c0:#A4::tt("210 × 297 mm")
:*c0:#A5::tt("148 × 210 mm")
:*c0:#A6::tt("105 × 148 mm")
:*c0:#A7::tt("74 × 105 mm")
:*c0:#A8::tt("52 × 74 mm")
:*c0:#A9::tt("37 × 52 mm")

; greek (with µ, which is available on German keyboards; use double µ to type alternative letters)
::µG::cp("Γ")
::µD::cp("Δ")
::µT::cp("Θ")
::µL::cp("Λ")
::µX::cp("Ξ")
::µPi::cp("Π")
::Pi::cp("Π")
::PI::cp("Π")
::µS::cp("Σ")
::µF::cp("Φ")
::Phi::cp("Φ")
::µP::cp("Ψ")
::µPs::cp("Ψ")
::Psi::cp("Ψ")
::µO::cp("Ω")
::µa::cp("α")
::µb::cp("β")
::µg::cp("γ")
::µd::cp("δ")
::µµe::cp("ϵ")
::µe::cp("ε")
::µz::cp("ζ")
::µet::cp("η")
::µµt::cp("ϑ")
::µt::cp("θ")
::µi::cp("ι")
::µk::cp("κ")
::µl::cp("λ")
::my::cp("µ")
::mü::cp("µ")
::mu::cp("µ")
::µn::cp("ν")
::ny::cp("ν")
::nü::cp("ν")
::nu::cp("ν")
::µx::cp("ξ")
::µpi::cp("π")
::pi::cp("π")
::µr::cp("ρ")
::rho::cp("ρ")
::µµs::cp("ς")
::µs::cp("σ")
::µta::cp("τ")
::tau::cp("τ")
::µy::cp("υ")
::µu::cp("υ")
::µµf::cp("φ")
::µf::cp("ϕ")
::phi::cp("ϕ")
::µc::cp("χ")
::µp::cp("ψ")
::µps::cp("ψ")
::psi::cp("ψ")
::µo::cp("ω")

; ligatures
::AE::cp("Æ")
::OE::cp("Œ")
::ae::cp("æ")
::oe::cp("œ")
::ff::cp("ﬀ")
::fi::cp("ﬁ")
::fl::cp("ﬂ")
::st::cp("ﬆ")
::et::cp("&")
::AV::cp("Ꜹ")
::av::cp("ꜹ")
::ue::cp("ᵫ")
::db::cp("ȸ")
::qp::cp("ȹ")
::dz::cp("ʣ")
::ts::cp("ʦ")
::tc::cp("ʨ")
::lz::cp("ʫ")
::ww::cp("ʬ")

; invisible characters
:: ~::cp("{U+2009}")  ; thin space
:: !::cp("{U+00A0}")  ; no-break space
:: !~::cp("{U+202F}") ; narrow no-break space
:: ~!::cp("{U+202F}") ; narrow no-break space
::(-)::cp("{U+00AD}") ; soft hyphen
::(+)::cp("{U+2064}") ; invisible plus
::(*)::cp("{U+2062}") ; invisible times

; diacritics
::[']::cp("{U+00B4}") ; acute
::[\]::cp("{U+0060}") ; grave
::[,]::cp("¸")        ; cedilla
::[;]::cp("˛")        ; ogonek
::[.]::cp("˙")        ; dot
::["]::cp("¨")        ; diaeresis
::[o]::cp("˚")	      ; ring
::[c]::cp("ˇ")        ; caron
::[<]::cp("˘")
::[>]::cp("ˆ")        ; circumflex
::[U]::cp("˘")        ; breve
::[)]::cp("˘")
::[b]::cp("˘")
::[-]::cp("¯")	      ; macron

; combining diacritics
; double:
::~__::cp("{U+0360}")  ; double tilde above           ͠
::(__::cp("{U+035C}")  ; double breve below           ͜
::)__::cp("{U+0361}")  ; double inverted breve above  ͡
::->__::cp("{U+0362}") ; double arrow below           ͢
; strikethrough:
::/~_::cp("{U+0334}")  ; tilde strikethrough          ̴
::~/_::cp("{U+0334}")
::/_::cp("{U+0335}")   ; strikethrough                ̵
; below:
::_\_::cp("{U+0316}")  ; grave           ̖
::_'_::cp("{U+0317}")  ; acute           ̗
::_^_::cp("{U+032D}")  ; circumflex      ̭
::_>_::cp("{U+032D}")
::_~_::cp("{U+0330}")  ; tilde           ̰
::_-_::cp("{U+0331}")  ; macron          ̱
::_UU_::cp("{U+032B}") ; double arch     ̫
::_((_::cp("{U+032B}")
::_U_::cp("{U+032E}")  ; breve           ̮
::_b_::cp("{U+032E}")
::_(_::cp("{U+032E}")
::_))_::cp("{U+033C}") ; seagull         ̼
::_)_::cp("{U+032F}")  ; inverted breve  ̯
::_._::cp("{U+0323}")  ; dot             ̣
::_"_::cp("{U+0324}")  ; diaeresis       ̤
::_o_::cp("{U+0325}")  ; ring            ̥
::_?_::cp("{U+0321}")  ; hook            ̡
::_c_::cp("{U+032C}")  ; caron           ̬
::_<_::cp("{U+032C}")
::_[_::cp("{U+033A}")  ; inverted bridge ̺
::_]_::cp("{U+032A}")  ; bridge          ̪
::_,_::cp("{U+0327}")  ; cedilla         ̧
::,_::cp("{U+0327}")
::_;_::cp("{U+0328}")  ; ogonek          ̨
::;_::cp("{U+0328}")
; above:
::\\_::cp("{U+030F}")  ; double grave    ̏
::\_::cp("{U+0300}")   ; grave           ̀
::''_::cp("{U+030B}")  ; double acute    ̋
::'_::cp("{U+0301}")   ; acute           ́
::^_::cp("{U+0302}")   ; circumflex      ̂
::<_::cp("{U+0302}")
::(._::cp("{U+0310}")  ; chandrabindu    ̐
::.)_::cp("{U+0352}")  ; fermata         ͒
::~_::cp("{U+0303}")   ; tilde           ̃
::-_::cp("{U+0304}")   ; macron          ̄
::U_::cp("{U+0306}")   ; breve           ̆
::b_::cp("{U+0306}")
::(_::cp("{U+0306}")
::)_::cp("{U+0311}")   ; inverted breve  ̑
::._::cp("{U+0307}")   ; dot             ̇
::"_::cp("{U+0308}")   ; diaeresis       ̈
::o_::cp("{U+030A}")   ; ring            ̊
::°_::cp("{U+030A}")   ; ring            ̊
::?_::cp("{U+0309}")   ; hook            ̉
::c_::cp("{U+030C}")   ; caron           ̌
::<_::cp("{U+030C}")

; letters
::\A::cp("À")
::>A::cp("Â")
::'A::cp("Á")
::~A::cp("Ã")
::"A::cp("Ä")
::oA::cp("Å")
::°A::cp("Å")
::-A::cp("Ā")
::UA::cp("Ă")
::(A::cp("Ă")
::bA::cp("Ă")
::;A::cp("Ą")
::cA::cp("Ǎ")
::<A::cp("Ǎ")
::AA::cp("∀") ; for all
::\a::cp("à")
::>a::cp("â")
::'a::cp("á")
::~a::cp("ã")
::"a::cp("ä")
::oa::cp("å")
::°a::cp("å")
::-a::cp("ā")
::Ua::cp("ă")
::(a::cp("ă")
::ba::cp("ă")
::;a::cp("ą")
::ca::cp("ǎ")
::<a::cp("ǎ")
::aa::cp("​ɐ")

::.B::cp("Ḃ")
::?B::cp("Ɓ")

::/b::cp("ƀ")
::.b::cp("ḃ")
::~b::cp("ᵬ")

::'C::cp("Ć")
::>C::cp("Ĉ")
::,C::cp("Ç")
::cC::cp("Č")
::<C::cp("Č")
::.C::cp("Ċ")
::?C::cp("Ƈ")
::'c::cp("ć")
::>c::cp("ĉ")
::,c::cp("ç")
::cc::cp("č")
::<c::cp("č")
::.c::cp("ċ")
::?c::cp("ƈ")

::,D::cp("Ḑ")
::cD::cp("Ď")
::<D::cp("Ď")
::/D::cp("Đ")
::DH::cp("Ð")
::.D::cp("Ḋ")
::?D::cp("Ɗ")
::,d::cp("ḑ")
::cd::cp("ď")
::<d::cp("ď")
::/d::cp("đ")
::dh::cp("ð")
::.d::cp("ḋ")
::~d::cp("ᵭ")

::\E::cp("È")
::>E::cp("Ê")
::'E::cp("É")
::"E::cp("Ë")
::-E::cp("Ē")
::UE::cp("Ĕ")
::(E::cp("Ĕ")
::bE::cp("Ĕ")
::,E::cp("Ȩ")
::/E::cp("Ɇ")
::;E::cp("Ę")
::cE::cp("Ě")
::<E::cp("Ě")
::~E::cp("Ẽ")
::.E::cp("Ė")
::/EE::cp("∄") ; there does not exist
::EE::cp("∃")  ; there exists
::\e::cp("è")
::>e::cp("ê")
::'e::cp("é")
::"e::cp("ë")
::-e::cp("ē")
::Ue::cp("ĕ")
::(e::cp("ĕ")
::be::cp("ĕ")
::,e::cp("ȩ")
::/e::cp("ɇ")
::;e::cp("ę")
::ce::cp("ě")
::<e::cp("ě")
::~e::cp("ẽ")
::.e::cp("ė")
::ee::cp("​ə")
::schwa::cp("​ə")

::.F::cp("Ḟ")
::?F::cp("Ƒ")
::fs::cp("ſ")
::.f::cp("ḟ")
::~f::cp("ᵮ")

::'G::cp("Ǵ")
::>G::cp("Ĝ")
::UG::cp("Ğ")
::(G::cp("Ğ")
::bG::cp("Ğ")
::,G::cp("Ģ")
::/G::cp("Ǥ")
::cG::cp("Ǧ")
::<G::cp("Ǧ")
::-G::cp("Ḡ")
::.G::cp("Ġ")
::?G::cp("Ɠ")
::'g::cp("ǵ")
::>g::cp("ĝ")
::Ug::cp("ğ")
::(g::cp("ğ")
::bg::cp("ğ")
::,g::cp("ģ")
::/g::cp("ǥ")
::cg::cp("ǧ")
::<g::cp("ǧ")
::-g::cp("ḡ")
::.g::cp("ġ")

::>H::cp("Ĥ")
::cH::cp("Ȟ")
::<H::cp("Ȟ")
::/H::cp("Ħ")
::"H::cp("Ḧ")
::,H::cp("Ḩ")
::>h::cp("ĥ")
::ch::cp("ȟ")
::<h::cp("ȟ")
::/h::cp("ħ")
::"h::cp("ḧ")
::,h::cp("ḩ")

::\I::cp("Ì")
::>I::cp("Î")
::'I::cp("Í")
::"I::cp("Ï")
::~I::cp("Ĩ")
::-I::cp("Ī")
::UI::cp("Ĭ")
::(I::cp("Ĭ")
::bI::cp("Ĭ")
::;I::cp("Į")
::.I::cp("İ")
::/I::cp("Ɨ")
::cI::cp("Ǐ")
::<I::cp("Ǐ")
::\i::cp("ì")
::>i::cp("î")
::'i::cp("í")
::"i::cp("ï")
::~i::cp("ĩ")
::-i::cp("ī")
::Ui::cp("ĭ")
::(i::cp("ĭ")
::bi::cp("ĭ")
::;i::cp("į")
::i.::cp("ı")
::.i::cp("ı")
::ci::cp("ǐ")
::<i::cp("ǐ")
::/i::cp("ɨ")

::>J::cp("Ĵ")
::>j::cp("ĵ")
::cj::cp("ǰ")
::<j::cp("ǰ")

::'K::cp("Ḱ")
::,K::cp("Ķ")
::cK::cp("Ǩ")
::<K::cp("Ǩ")
::?K::cp("Ƙ")
::'k::cp("ḱ")
::,k::cp("ķ")
::kk::cp("ĸ")
::ck::cp("ǩ")
::<k::cp("ǩ")
::?k::cp("ƙ")

::'L::cp("Ĺ")
::,L::cp("Ļ")
::/L::cp("Ł")
::cL::cp("Ľ")
::<L::cp("Ľ")
::'l::cp("ĺ")
::,l::cp("ļ")
::cl::cp("ľ")
::<l::cp("ľ")
::/l::cp("ł")

::'M::cp("Ḿ")
::.M::cp("Ṁ")
::'m::cp("ḿ")
::.m::cp("ṁ")
::~m::cp("ᵯ")

::\N::cp("Ǹ")
::~N::cp("Ñ")
::'N::cp("Ń")
::,N::cp("Ņ")
::cN::cp("Ň")
::<N::cp("Ň")
::NG::cp("Ŋ")
::?N::cp("Ɲ")
::\n::cp("ǹ")
::~n::cp("ñ")
::'n::cp("ń")
::,n::cp("ņ")
::cn::cp("ň")
::<n::cp("ň")
::ng::cp("ŋ")

::\O::cp("Ò")
::>O::cp("Ô")
::'O::cp("Ó")
::~O::cp("Õ")
::"O::cp("Ö")
::/O::cp("Ø")
::-O::cp("Ō")
::UO::cp("Ŏ")
::(O::cp("Ŏ")
::BO::cp("Ŏ")
::cO::cp("Ǒ")
::=O::cp("Ő")
::;O::cp("Ǫ")
::\o::cp("ò")
::>o::cp("ô")
::'o::cp("ó")
::~o::cp("õ")
::"o::cp("ö")
::/o::cp("ø")
::-o::cp("ō")
::Uo::cp("ŏ")
::(o::cp("ŏ")
::bo::cp("ŏ")
::co::cp("ǒ")
::=o::cp("ő")
::;o::cp("ǫ")

::'P::cp("Ṕ")
::.P::cp("Ṗ")
::?P::cp("Ƥ")
::'p::cp("ṕ")
::.p::cp("ṗ")
::~p::cp("ᵱ")
::?p::cp("ƥ")

::'R::cp("Ŕ")
::,R::cp("Ŗ")
::cR::cp("Ř")
::<R::cp("Ř")
::'r::cp("ŕ")
::,r::cp("ŗ")
::cr::cp("ř")
::<r::cp("ř")
::~r::cp("ᵲ")
::rr::cp("​ɹ")

::SS::cp("ẞ")
::'S::cp("Ś")
::>S::cp("Ŝ")
::,S::cp("Ş")
::cS::cp("Š")
::<S::cp("Š")
::.S::cp("Ṡ")
:::S::cp("Ṩ")
::ss::cp("ß")
::'s::cp("ś")
::>s::cp("ŝ")
::,s::cp("ş")
::cs::cp("š")
::<s::cp("š")
::.s::cp("ṡ")
:::s::cp("ṩ")
::~s::cp("ᵴ")
::sh::cp("ʃ⁠")
::sch::cp("ʃ⁠")

::,T::cp("Ţ")
::cT::cp("Ť")
::<T::cp("Ť")
::/T::cp("Ŧ")
::TH::cp("Þ")
::.T::cp("Ṫ")
::?T::cp("Ƭ")
::,t::cp("ţ")
::ct::cp("ť")
::<t::cp("ť")
::/t::cp("ŧ")
::th::cp("þ")
::"t::cp("ẗ")
::.t::cp("ṫ")
::~t::cp("ᵵ")
::?t::cp("ƭ")

::\U::cp("Ù")
::>U::cp("Û")
::'U::cp("Ú")
::"U::cp("Ü")
::~U::cp("Ũ")
::-U::cp("Ū")
::~u::cp("ũ")
::UU::cp("Ŭ")
::(U::cp("Ŭ")
::bU::cp("Ŭ")
::cU::cp("Ǔ")
::<U::cp("Ǔ")
::oU::cp("Ů")
::°U::cp("Ů")
::=U::cp("Ű")
::;U::cp("Ų")
::\u::cp("ù")
::>u::cp("û")
::'u::cp("ú")
::"u::cp("ü")
::-u::cp("ū")
::Uu::cp("ŭ")
::(u::cp("ŭ")
::bu::cp("ŭ")
::cu::cp("ǔ")
::<u::cp("ǔ")
::ou::cp("ů")
::°u::cp("ů")
::=u::cp("ű")
::;u::cp("ų")

::~V::cp("Ṽ")
::~v::cp("ṽ")

::\W::cp("Ẁ")
::>W::cp("Ŵ")
::'W::cp("Ẃ")
::"W::cp("Ẅ")
::>w::cp("ŵ")
::\w::cp("ẁ")
::'w::cp("ẃ")
::"w::cp("ẅ")
::ow::cp("ẘ")
::°w::cp("ẘ")

::"X::cp("Ẍ")
::Xi::cp("Ξ")
::"x::cp("ẍ")
::xi::cp("ξ")

::\Y::cp("Ỳ")
::>Y::cp("Ŷ")
::'Y::cp("Ý")
::"Y::cp("Ÿ")
::-Y::cp("Ȳ")
::oY::cp("Y̊")
::°Y::cp("Y̊")
::~Y::cp("Ỹ")
::?Y::cp("Ƴ")
::\y::cp("ỳ")
::>y::cp("ŷ")
::'y::cp("ý")
::"y::cp("ÿ")
::-y::cp("ȳ")
::oy::cp("ẙ")
::°y::cp("ẙ")
::~y::cp("ỹ")
::?y::cp("ƴ")

::>Z::cp("Ẑ")
::/Z::cp("Ƶ")
::cZ::cp("Ž")
::<Z::cp("Ž")
::'Z::cp("Ź")
::.Z::cp("Ż")
::>z::cp("ẑ")
::cz::cp("ž")
::<z::cp("ž")
::'z::cp("ź")
::/z::cp("ƶ")
::.z::cp("ż")
::~z::cp("ᵶ")

; ipa
::<g>::cp("ʔ")
::<:>::cp("ː")

; mushroom
::-}::cp("𓋼")    ; parasol
::=B::cp("𓍊𓋼𓍊𓋼𓍊") ; pilzfamilie
::-D::cp("⍾")   ; steinpilz
::-)::cp("🍄")   ; fliegenpilz

; emoticons
::=)::cp("🙂")
:::D::cp("😄")
::=D::cp("😃")
::xd::cp("😂")
::xD::cp("😂")
::XD::cp("😂")
::x)::cp("😆")
::;)::cp("😉")
:::|::cp("😐")
:::l::cp("😐")
:::(::cp("🙁")
:::<::cp("☹️")
::;(::cp("😞")
::x(::cp("😣")
::X(::cp("😣")
::>_<::cp("😣")
:::'::cp("😢")
:::=(::cp("😭")
::qq::cp("😭")
:::E::cp("😬")
:::/::cp("😕")
:::L::cp("🤔")
::',:-|::cp("🤨")
::',:|::cp("🤨")
::$)::cp("🤑")
::$$::cp("🤑")
:::$::cp("😳")
::o_o::cp("😳")
::>:(::cp("😠")
::>=(::cp("😡")
::>:[::cp("😡")
::^o^::cp("🥳")
::\^^/::cp("🥳")
::^^::cp("😁")
:::c)::cp("😁")
::v.v::cp("😔")
:::S::cp("😖")
:::{::cp("😖")
::>w<::cp("😖")
::><::cp("😣")
::>.<::cp("😣")
::D8::cp("😱")
::D`:::cp("😩")
::D`:::cp("😩") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::D=::cp("😨")
::Dx::cp("😫")
::DX::cp("😫")
:::p::cp("😛")
:::P::cp("😛")
::;p::cp("😜")
::;P::cp("😜")
::xp::cp("😝")
::xP::cp("😝")
::XP::cp("😝")
:::\::cp("🫤")
:::o::cp("😮")
:::O::cp("😮")
::=o::cp("😯")
::=O::cp("😯")
::8)::cp("😎")
::B)::cp("😎")
::^0_0^::cp("🤓")
::8)=::cp("🤓")
:::*::cp("😙")
::;*::cp("😘")
::<3<3::cp("😍")
::^°^::cp("🥰")
:::#::cp("🤐")
:::x::cp("😶")
::o7::cp("🫡")
::%)::cp("😵")
::zzz::cp("💤")
::zz::cp("😴")
::0:)::cp("😇")
::o:)::cp("😇")
::O:)::cp("😇")
::(:)::cp("🐽")
:::)::cp("😊")
::3:)::cp("😈")
::}:)::cp("😈")
:::o)::cp("🤡")
:::0)::cp("🤡")
::8x::cp("☠️")
::ox::cp("☠️")
::<|::cp("💩")
:::j::cp("😏")
:::J::cp("😏")
::-q::cp("🧐")
:::3::cp("😺")
:::>::cp("😺")
::pq::cp("🙈")
::(@::cp("🙈")
::><>::cp("🐟")
::<><::cp("🐠")
::(^^^)::cp("🦈")
::[$]::cp("💵")
::=[$]::cp("💸")
::[€]::cp("💶")
::[Y]::cp("💴")
::[L]::cp("💷")
::*)::cp("⭐")
::<3)::cp("❤️")
::</3::cp("💔")
::z::cp("⚡") ; (!) single letter code
::<)::cp("💧")
::-<<::cp("🪶")
::{}z::cp("🌩")
::{}*::cp("🌨")
::{}<)::cp("🌧")
::{}s::cp("🌪")
::{}o::cp("⛅")
::{}::cp("☁")
::levi::cp("🐮") ; :)
::ok::cp("👍")
::ok::cp("👍")
::ew::cp("🤢")
::äh::cp("🤨")
::[:`:]::cp("🎲")
::[:`:]::cp("🎲") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
:::`:`:::cp("🎲")
:::`:`:::cp("🎲") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::._.::cp("( ͡° ͜ʖ ͡°)")

; subscript
::_0::cp("₀")
::_1::cp("₁")
::_2::cp("₂")
::_3::cp("₃")
::_4::cp("₄")
::_5::cp("₅")
::_6::cp("₆")
::_7::cp("₇")
::_8::cp("₈")
::_9::cp("₉")
::_10::cp("₁₀")
::_11::cp("₁₁")
::_12::cp("₁₂")
::_13::cp("₁₃")
::_14::cp("₁₄")
::_15::cp("₁₅")
::_16::cp("₁₆")
::_17::cp("₁₇")
::_18::cp("₁₈")
::_19::cp("₁₉")
::_20::cp("₂₀")
::_+::cp("₊")
::_-::cp("₋")
::_=::cp("₌")
::_(::cp("₍")
::_)::cp("₎")

::_a::cp("ₐ")
::_e::cp("ₑ")
::_h::cp("ₕ")
::_i::cp("ᵢ")
::_j::cp("ⱼ")
::_k::cp("ₖ")
::_l::cp("ₗ")
::_m::cp("ₘ")
::_n::cp("ₙ")
::_o::cp("ₒ")
::_p::cp("ₚ")
::_r::cp("ᵣ")
::_s::cp("ₛ")
::_t::cp("ₜ")
::_u::cp("ᵤ")
::_v::cp("ᵥ")
::_x::cp("ₓ")	

; superscript
::^0::cp("⁰")
::^1::cp("¹")
::^2::cp("²")
::^3::cp("³")
::^4::cp("⁴")
::^5::cp("⁵")
::^6::cp("⁶")
::^7::cp("⁷")
::^8::cp("⁸")
::^9::cp("⁹")
::^10::cp("¹⁰")
::^11::cp("¹¹")
::^12::cp("¹²")
::^13::cp("¹³")
::^14::cp("¹⁴")
::^15::cp("¹⁵")
::^16::cp("¹⁶")
::^17::cp("¹⁷")
::^18::cp("¹⁸")
::^19::cp("¹⁹")
::^20::cp("²⁰")
::^-1::cp("⁻¹")
::^-2::cp("⁻²")
::^-3::cp("⁻³")
::^-4::cp("⁻⁴")
::^-5::cp("⁻⁵")
::^-6::cp("⁻⁶")
::^-7::cp("⁻⁷")
::^-8::cp("⁻⁸")
::^-9::cp("⁻⁹")
::^-10::cp("⁻¹⁰")
::^-11::cp("⁻¹¹")
::^-12::cp("⁻¹²")
::^-13::cp("⁻¹³")
::^-14::cp("⁻¹⁴")
::^-15::cp("⁻¹⁵")
::^-16::cp("⁻¹⁶")
::^-17::cp("⁻¹⁷")
::^-18::cp("⁻¹⁸")
::^-19::cp("⁻¹⁹")
::^-20::cp("⁻²⁰")
::^+::cp("⁺")
::^-::cp("⁻")
::^=::cp("⁼")
::^(::cp("⁽")
::^)::cp("⁾")

::^A::cp("ᴬ")
::^AE::cp("ᴭ")
::^B::cp("ᴮ")
::^C::cp("ꟲ")
::^D::cp("ᴰ")
::^E::cp("ᴱ")
::^F::cp("ꟳ")
::^G::cp("ᴳ")
::^H::cp("ᴴ")
::^I::cp("ᴵ")
::^J::cp("ᴶ")
::^K::cp("ᴷ")
::^L::cp("ᴸ")
::^M::cp("ᴹ")
::^N::cp("ᴺ")
::^O::cp("ᴼ")
::^P::cp("ᴾ")
::^Q::cp("ꟴ")
::^R::cp("ᴿ")
::^T::cp("ᵀ")
::^U::cp("ᵁ")
::^V::cp("ⱽ")
::^W::cp("ᵂ")
::^a::cp("ᵃ")
::^ae::cp("𐞃")
::^b::cp("ᵇ")
::^c::cp("ᶜ")
::^d::cp("ᵈ")
::^e::cp("ᵉ")
::^f::cp("ᶠ")
::^g::cp("ᵍ")
::^h::cp("ʰ")
::^i::cp("ⁱ")
::^j::cp("ʲ")
::^k::cp("ᵏ")
::^l::cp("ˡ")
::^m::cp("ᵐ")
::^n::cp("ⁿ")
::^o::cp("ᵒ")
::^p::cp("ᵖ")
::^q::cp("𐞥")
::^r::cp("ʳ")
::^s::cp("ˢ")
::^t::cp("ᵗ")
::^u::cp("ᵘ")
::^v::cp("ᵛ")
::^w::cp("ʷ")
::^x::cp("ˣ")
::^y::cp("ʸ")
::^z::cp("ᶻ")

; fractions
::12::cp("½")
::1/2::cp("½")
::13::cp("⅓")
::1/3::cp("⅓")
::23::cp("⅔")
::2/3::cp("⅔")
::14::cp("¼")
::1/4::cp("¼")
::34::cp("¾")
::3/4::cp("¾")
::15::cp("⅕")
::1/5::cp("⅕")
::25::cp("⅖")
::2/5::cp("⅖")
::35::cp("⅗")
::3/5::cp("⅗")
::45::cp("⅘")
::4/5::cp("⅘")
::16::cp("⅙")
::1/6::cp("⅙")
::56::cp("⅚")
::5/6::cp("⅚")
::17::cp("⅐")
::1/7::cp("⅐")
::18::cp("⅛")
::1/8::cp("⅛")
::78::cp("⅞")
::7/8::cp("⅞")
::19::cp("⅑")
::1/9::cp("⅑")
::110::cp("⅒")
::10::cp("⅒")
::1/10::cp("⅒")
::03::cp("↉")
::0/3::cp("↉")
::1/::cp("⅟")

; scientific notation
::e0::cp(" · 10⁰")
::e1::cp(" · 10¹")
::e2::cp(" · 10²")
::e3::cp(" · 10³")
::e4::cp(" · 10⁴")
::e5::cp(" · 10⁵")
::e6::cp(" · 10⁶")
::e7::cp(" · 10⁷")
::e8::cp(" · 10⁸")
::e9::cp(" · 10⁹")
::e-1::cp(" · 10⁻¹")
::e-2::cp(" · 10⁻²")
::e-3::cp(" · 10⁻³")
::e-4::cp(" · 10⁻⁴")
::e-5::cp(" · 10⁻⁵")
::e-6::cp(" · 10⁻⁶")
::e-7::cp(" · 10⁻⁷")
::e-8::cp(" · 10⁻⁸")
::e-9::cp(" · 10⁻⁹")

; arrows
::=>>::cp("⇉")
::<<=::cp("⇇")
:://>>::cp("⇈")
::\\>>::cp("⇊")
::=>>::cp("⇉")
::=>>::cp("⇉")
::|<=>|::cp("↹")
::<=>::cp("⇔")
::=>::cp("⇒")
::<=::cp("⇐")
::<>::cp("⇄")
::\=\::cp("⇌")
::/=/::cp("⇋")
::-\::cp("⇀")
::-/::cp("⇁")
::/-::cp("↼")
::\-::cp("↽")
::->>::cp("↠")
::<<-::cp("↞")
::>->::cp("↣")
::<-<::cp("↢")
::|->::cp("↦")
::<-|::cp("↤")
::->|::cp("⇥")
::|<-::cp("⇤")
::-->::cp("⇢")
::<--::cp("⇠")
::<->::cp("↔")
::->::cp("→")
::<-::cp("←")
::/>::cp("↑")
::\>::cp("↓")
::<~>::cp("↭")
::~>::cp("↝")
::<~::cp("↜")
::+>::cp("➨")
::L_::cp("└")
::L>::cp("↳")
::<O::cp("↺")
::O>::cp("↻")
::z>::cp("↯")
::<s::cp("⭍")

; symbols
::(c)::cp("©")
::oC::cp("©")
::Oc::cp("©")
::OC::cp("©")
::(r)::cp("®")
::oR::cp("®")
::Or::cp("®")
::OR::cp("®")
::^TM::cp("™")
::TM::cp("™")
::tm::cp("™")
::^SM::cp("℠")
::SM::cp("℠")
::sm::cp("℠")
::%o::cp("‰")
::0/00::cp("‰")
::0/0::cp("%")
::\/::cp("✓")
::/\::cp("✗")
::8<::cp("✂")
::[]::cp("☐")
::[x]::cp("☒")
::[/\]::cp("☒")
::[y]::cp("☑")
::[/]::cp("☑")
::[\/]::cp("☑")
::***::cp("⁂")
::**::cp("⁑")
::*5::cp("✩")
::*::cp("✻") ; (!) single letter code
::p!::cp("¶")
::P!::cp("¶")
::PP::cp("¶")
::o..::cp("⚇")
::o`:::cp("⚇")
::o`:::cp("⚇") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::o.::cp("☉")
:::_::cp("⸚")
::))::cp("‿")
::((::cp("⁀")
::##::cp("⩩")
::.2::cp("∶")
::.3::cp("⁝")
::.'.::cp("∴")
::'.'::cp("∵")
::.4::cp("∷")
:::`:::cp("∷")
:::`:::cp("∷") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
:::2::cp("⁞")
:::3::cp("⸽")
::z|::cp("⦚")
::~|::cp("⌇")
::^~~::cp("﹌")
::~~::cp("〰")
::^~::cp("﹋")
::_~::cp("﹏")
::00::cp("○")
::33::cp("△")
::44::cp("□")
::55::cp("⬠")
::66::cp("⬡")
::Oo::cp("⧂")
::oO::cp("⭗")
::6o::cp("⏣")
::Lo::cp("◷")
::<3::cp("♡")

::&g::cp("𝄞")
::g`:::cp("𝄞")
::g`:::cp("𝄞") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::&f::cp("𝄢")
::f`:::cp("𝄢")
::f`:::cp("𝄢") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::.|::cp("𝅘𝅥")
::o|::cp("𝅗𝅥")
::.\::cp("𝅘𝅥𝅮")

; math
::oo::cp("∞")
::8::cp("∞") ; (!) single letter code
::x::cp("×") ; (!) single letter code
:::-::cp("÷")
::-`:::cp("÷")
::-`:::cp("÷") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::+-::cp("±")
::-+::cp("∓")
::5,/::cp("⁵√")
::5r::cp("⁵√")
::4,/::cp("∜")
::4r::cp("∜")
::3,/::cp("∛")
::cb::cp("∛")
::3r::cp("∛")
::2,/::cp("√")
::,/::cp("√")
::sq::cp("√")
::2r::cp("√")
::-<::cp("≤")
::>-::cp("≥")
::<<<::cp("≪")
::>>>::cp("≫")
::,-::cp("¬")
::-,::cp("¬")
::u<::cp("⊂")
::u>::cp("⊃")
::uand::cp("∩")
::uor::cp("∪")
::not::cp("¬")
::and::cp("∧")
::or::cp("∨")
::=~::cp("≈")
::~=::cp("≈")
::/=::cp("≠")
::=/::cp("≠")
::e=::cp("∈")
::elem::cp("∈")
:::`:=::cp("⩴")
:::`:=::cp("⩴") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
:::=::cp("≔")
::=`:::cp("≕")
::=`:::cp("≕") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::==::cp("≡")
::=3::cp("≡")
::oc::cp("∝")
::ang::cp("∠")
::/)::cp("∡")
::L)::cp("∡")
::_|_::cp("⟂")
::||::cp("∥")
::/|::cp("∤")
::/~::cp("≉")
::~/::cp("≉")
::*=::cp("⩮")
::-~::cp("⋍")
::~-::cp("⋍")
::</::cp("≮")
::>/::cp("≯")
::>~::cp("≳")
::~<::cp("≲")
::<o::cp("⩹")
::o>::cp("⩺")
::o~::cp("⸛")
::.~::cp("⩪")
::~.::cp("⩪")
::"~::cp("⍨")
::">::cp("⍩")
:::~::cp("∻")
::<+::cp("⨣")
::~+::cp("⨤")
::.+::cp("⨥")
::o+::cp("⨢")
::+~::cp("⨦")
::'-::cp("⨩")
::.-::cp("⨪")
::'-.::cp("⋱")
::.-'::cp("⋰")
::D::cp("Δ") ; (!) single letter code
::d::cp("∂") ; (!) single letter code
::,|'::cp("∫")
::.|'::cp("∫")
::|s::cp("∫")
::s|::cp("∫")
::S|::cp("∫")
::int::cp("∫")
::S+::cp("∑")
::P*::cp("∏")
::|N::cp("ℕ")
::|Z::cp("ℤ")
::|Q::cp("ℚ")
::|R::cp("ℝ")
::|C::cp("ℂ")

; currency
::ox::cp("¤")
::xo::cp("¤")
:::O`:::cp("¤")
:::O`:::cp("¤") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::C=::cp("€")
::=C::cp("€")
::c=::cp("€")
::=c::cp("€")
::E=::cp("€")
::=E::cp("€")
::CE::cp("₠")
::|c::cp("¢")
::c|::cp("¢")
::c/::cp("¢")
::/c::cp("¢")
::C/::cp("₡")
::/C::cp("₡")
::Cr::cp("₢")
::d-::cp("₫")
::Fr::cp("₣")
::L-::cp("£")
::-L::cp("£")
::L=::cp("₤")
::=L::cp("₤")
::m/::cp("₥")
::/m::cp("₥")
::N=::cp("₦")
::=N::cp("₦")
::Pt::cp("₧")
::Rs::cp("₨")
::W=::cp("₩")
::=W::cp("₩")
::Y=::cp("¥")
::=Y::cp("¥")

; typographic
::!!::cp("¡")
::??::cp("¿")
::;;::cp("⸵")
::!?::cp("‽")
::?!::cp("‽")
::2|::cp("¦")
::|2::cp("¦")
::so::cp("§")
::os::cp("§")
::<(::cp("⟨")
::)>::cp("⟩")
::^,::cp("’")
::''::cp("’")
::^.::cp("·")
::-.::cp("·")
::...::cp("…")
::..::cp("…")
:::.::cp("⁝")
::.`:::cp("⁝") ; due to a bug of AHK, hotstrings ending with a colon have to be repeated to execute the following hotstring (remove this line if fixed!!!)
::.`:::cp("⁝")
::++::cp("‡")
::+::cp("†") ; (!) single letter code
::E>::cp("❧")
::/::cp("⁄") ; fraction slash ; (!) single letter code

; dashes
::-----::cp("⸻")
::3m::cp("⸻")
::----::cp("⸺")
::2m::cp("⸺")
::---::cp("—") ; em dash
::1m::cp("—")  ; em dash
::-m::cp("—")  ; em dash
::m-::cp("—")  ; em dash
::--::cp("–")  ; en dash
::-n::cp("–")  ; en dash
::n-::cp("–")  ; en dash

; quotes (partly conditional hotstrings related to the input language)
::<"::cp(DE ? "„" : "“")
::"<::cp(DE ? "„" : "“")
::>"::cp(DE ? "“" : "”")
::">::cp(DE ? "“" : "”")

::<'::cp(DE ? "‚" : "‘")
::'<::cp(DE ? "‚" : "‘")
::>'::cp(DE ? "‘" : "’")
::'>::cp(DE ? "‘" : "’")

::>>::cp("»")
::<<::cp("«")
::.>::cp("›")
::>.::cp("›")
::>::cp("›") ; (!) single letter code
::.<::cp("‹")
::<.::cp("‹")
::<::cp("‹") ; (!) single letter code

::,,::cp("„")
::,"::cp("„")
::",::cp("„")
::,'::cp("‚")
::',::cp("‚")

; primes
::""::cp("⁗")
::"'::cp("‴")
::'"::cp("‴")
::'''::cp("‴")
::"::cp("″") ; (!) single letter code
::'::cp("′") ; (!) single letter code

; wrapper
::(::cp("(){left}") ; (!) single letter code
::[::cp("[]{left}") ; (!) single letter code
::{::cp("{}{left}") ; (!) single letter code
::?::cp("¿?{left}") ; (!) single letter code
::!::cp("¡{!}{left}") ; (!) single letter code
::2::cp(DE ? "„“{left}" : "“”{left}") ; [2/"]-key ; (!) single letter code
::#::cp(DE ? "‚‘{left}" : "‘’{left}") ; [#/']-key ; (!) single letter code
!2::hotkeyCp("»«{left}") ; with alt → guillemets
!#::hotkeyCp("›‹{left}") ; with alt → guillemets

; super short shortcuts
::i::cp(IniRead("PRESETS.ini", "general", "username")) ; (!) single letter code
::@::cp(IniRead("PRESETS.ini", "general", "email")) ; (!) single letter code