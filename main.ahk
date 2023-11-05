#Requires AutoHotkey v2.0
; Optimized for German keyboards
#SingleInstance Force
TraySetIcon "img/main.png",,1
#Include lib/jax.ahk
#Hotstring EndChars -()[]{}:;'"/\,.?!`n `t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Custom

#HotIf IniRead("PRESETS.ini", "module_main", "custom") = "on"

    :x?:#me::Send IniRead("PRESETS.ini", "general", "username")
    :x*?:#@::Send IniRead("PRESETS.ini", "general", "email")
    
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Typographic

#HotIf IniRead("PRESETS.ini", "module_main", "typographic") = "on"

    ; wrapper
    !2::Send "»«{left 1}"
    !#::Send "›‹{left 1}"
    :*?:( ::(){left 1}
    :*?:[ ::[]{left 1}
    :*?:{ ::{{}{}}{left 1}
    <^>!+<::Send "⟨⟩{left 1}"
    
    ; typographic replacement
    <^>!Space::Send "{U+2009}"   ; thin space: " "            ; altgr + space
    >^<^>!Space::Send "{U+202F}" ; narrow no-break space: " " ; altgr + ctrl (right) + space
    >^Space::Send "{U+00A0}"     ; no-break space: " "        ; ctrl (right) + space
    ^!-::Send "{U+00AD}"         ; soft hyphen: "­"            ; ctrl (right) + alt + -
    :?:?!::‽
    :?:!?::‽
    ::<3::❦
    ::E>::❧
    !-::Send "–" ; en dash
    !+-::Send "—" ; em dash
    +NumpadAdd::Send "†" ; dagger
    !+NumpadAdd::Send "‡" ; double dagger
    <^>!-::Send "⸻"
    !.::Send "…"
    <^>!.::Send "…"
    <^>!#::Send "’"
    :?:(c)::©
    :?:(r)::®
    :*?:^^tm::™
    :?:(tm)::™
    <^>!c::Send "°C"
    ::***::⁂
    ::**::⁑
    :::~::⍨
    :?c:#No::№
    :?:##finger::☛
    :?:#finger::☞
    :?:#arrow::➳
    :?:#flower::✾
    :?:#cut::✂
    :?:#ok::✓
    :?:#no::✗
    ::#box::☐
    ::#tickbox::☒
    :?:#star::✢✤✥✦✧⛤✩✪✫✬✭✮✯✵✶✸✹✻✼✽✾✿❀❁❂❃❅❆❈❉❊❋
    :?:#kauderwelsch::𖣺𖠆𖠪𖥨𖠜𖠏𖠐𖠑𖦽𖠍𖡒𖡡𖠌𖠲𖠃𖤈𖠖𖠘𖠊𖠱𖨆𖡅𖠽𖠴𖡊𖡀𖧼𖠋𖠂𖡆𖡠𖤱𖡥𖣞𖤃𖤖𖤡𖤯𖥊𖦋𖧄𖤿𖧰𖠈𖧽𖥙𖣥𖡰𖢥𖨳𖤏𖢃𖡷𖥾𖣲𖥶𖡎𖧩𖢾𖥘𖤍𖠓𖣤𖡀𖥽𖥸𖧏𖣳𖣶𖤛𖧀𖤫𖥂

    :*?:#vio::𝄞
    :*?:#bas::𝄢

    :*?:##benz::⏣
    :*?:#benz::⌬

    :*?:#schwa::​ə
    :*?c:~N::Ñ
    :*?c:~n::ñ

    ; invisible plus
    :*?:{+}::⁤

#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Math

#HotIf IniRead("PRESETS.ini", "module_main", "math") = "on"

    ; numpad shortcuts
    +NumpadMult::Send "·"    ; shift + *
    !NumpadMult::Send "×"    ; alt   + *
    <^>!NumpadMult::Send "×" ; altgr + *
    +NumpadSub::Send "−"     ; shift + -
    +NumpadDiv::Send "÷"     ; shift + /

    ; math
    <^>!u::Send "∞"
    !=::Send "≠" ; not equal to
    <^>!=::Send "≠"
    :?:#ne::≠
    <^>!++::Send "≈" ; almost equal to
    !<::Send "≤"
    !+<::Send "≥"
    :?:+-::±
    :?:-+::∓
    :?:#<<::≪ ; much less than
    :?:#>>::≫ ; much greater than
    :*?:#prop::∝ ; proportional To
    :*?:#ele::∈ ; element
    :*?:#equ::≡ ; congruent, equivalent to
    :?:#sqr::√ ; square root
    :?:#cbr::∛ ; cube root
    :?:#4thr::∜ ; fourth root
    :?:#5thr::⁵√ ; fifth root
    :?:#d::∂ ; partial differential
    :*?:#integ::∫ ; integral
    :*?:#nab::∇ ; nabla
    :*?:#lapl::Δ ; laplacian
    :*?:#ham::Ĥ ; hamilton
    :*?:#emp::∅ ; empty set
    :*?:#ave::Ø ; average
    :*?:#sum::∑ ; summation
    :*?:#prod::∏ ; product

    :*?:#angle::∠ ; angle
    :*?:#winkel::∠ ; [DE]
    :*?:#rang:: ∟ ; right angle
    :*?:#angmsd::∡ ; measured angle
    :*?:#messwinkel::∡ ; [DE]
    :*?:#perp::⟂ ; perpendicular to
    :*?:#normal::⟂ ; [DE]

    :?:#not::¬ ; Logical NOT
    :?:#and::∧ ; Logical AND
    :?:#or::∨ ; Logical OR
    :?:#all::∀ ; for all
    :?:#exist::∃ ; there exists
    :?:#nexist::∄ ; there does not exist

    ; irrational numbers (first 100 decimal digits)
    :?:<pi>::π     ; pi
    :?:<eu>::ℯ     ; euler’s number
    :?:<sqrt2>::√2 ; square root of two
    :?:<sqrt3>::√3 ; square root of three
    :?:<phi>::ϕ    ; golden ratio

    :?:<pi,>::3,1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
    :?:<eu,>::2,7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274
    :?:<sqrt2,>::1,4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727
    :?:<sqrt3,>::1,7320508075688772935274463415058723669428052538103806280558069794519330169088000370811461867572485756
    :?:<phi,>::1,6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374

    :?:<pi.>::3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
    :?:<eu.>::2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274
    :?:<sqrt2.>::1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727
    :?:<sqrt3.>::1.7320508075688772935274463415058723669428052538103806280558069794519330169088000370811461867572485756
    :?:<phi.>::1.6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374

    ; superscript hotkeys
    <^>!1::Send "¹"
    ;<^>!2::Send "²" ; default
    ;<^>!3::Send "³" ; default
    <^>!4::Send "⁴"
    <^>!5::Send "⁵"
    <^>!6::Send "⁶"

#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Special characters

; subscript and superscript hotstrings
#HotIf IniRead("PRESETS.ini", "module_main", "sub_super_script") = "on"
    :*?:^^0::⁰
    :*?:^^1::¹
    :*?:^^2::²
    :*?:^^3::³
    :*?:^^4::⁴
    :*?:^^5::⁵
    :*?:^^6::⁶
    :*?:^^7::⁷
    :*?:^^8::⁸
    :*?:^^9::⁹
    :*?:^^+::⁺
    :*?:^^-::⁻
    :*?:^^=::⁼
    :*?:^^(::⁽
    :*?:^^)::⁾
    :*?c:^^i::ⁱ
    :*?c:^^n::ⁿ

    :*?:__0::₀
    :*?:__1::₁
    :*?:__2::₂
    :*?:__3::₃
    :*?:__4::₄
    :*?:__5::₅
    :*?:__6::₆
    :*?:__7::₇
    :*?:__8::₈
    :*?:__9::₉
    :*?:__+::₊
    :*?:__-::₋
    :*?:__=::₌
    :*?:__(::₍
    :*?:__)::₎
    :*?c:__a::ₐ
    :*?c:__e::ₑ
    :*?c:__x::ₓ
    :*?c:__i::ᵢ
    :*?c:__j::ⱼ
    :*?c:__k::ₖ
    :*?c:__l::ₗ
    :*?c:__m::ₘ
    :*?c:__n::ₙ
    :*?c:__s::ₛ
    :*?c:__t::ₜ
#HotIf

; fraction hotstrings
#HotIf IniRead("PRESETS.ini", "module_main", "fractions") = "on"
    ::1/2::½
    ::1/3::⅓
    ::2/3::⅔
    ::1/4::¼
    ::3/4::¾
    ::1/5::⅕
    ::2/5::⅖
    ::3/5::⅗
    ::4/5::⅘
    ::1/6::⅙
    ::5/6::⅚
    ::1/7::⅐
    ::1/8::⅛
    ::3/8::⅜
    ::5/8::⅝
    ::7/8::⅞
    ::1/9::⅑
    ::1/10::⅒
#HotIf	

; scientific notation hotstrings
#HotIf IniRead("PRESETS.ini", "module_main", "scientific_notation") = "on"
    :*?:#e+0:: · 10⁰
    :*?:#e+1:: · 10¹
    :*?:#e+2:: · 10²
    :*?:#e+3:: · 10³
    :*?:#e+4:: · 10⁴
    :*?:#e+5:: · 10⁵
    :*?:#e+6:: · 10⁶
    :*?:#e+7:: · 10⁷
    :*?:#e+8:: · 10⁸
    :*?:#e+9:: · 10⁹
    :*?:#e-1:: · 10⁻¹
    :*?:#e-2:: · 10⁻²
    :*?:#e-3:: · 10⁻³
    :*?:#e-4:: · 10⁻⁴
    :*?:#e-5:: · 10⁻⁵
    :*?:#e-6:: · 10⁻⁶
    :*?:#e-7:: · 10⁻⁷
    :*?:#e-8:: · 10⁻⁸
    :*?:#e-9:: · 10⁻⁹
#HotIf

; arrow hotstrings
#HotIf IniRead("PRESETS.ini", "module_main", "arrows") = "on"
    :?:<=>::⇔
    :?:=>::⇒
    :?:<=::⇐
    :?:<_>::⇌
    :?:_>::⇀
    :?:<_::↼
    :?:->>::↠
    ::<<-::↞ ; no "?" to prevent e. g. -1000<<-1 from becoming -2↞1
    :?:>->::↣
    :?:<-<::↢
    :?:|->::↦
    :?:<-|::↤
    :?:->|::⇥
    :?:|<-::⇤
    :?:<->::↔
    :?:->::→
    ::<-::← ; no "?" to prevent e. g. -2<-1 from becoming -2←1
    :?:#up::↑
    :?:#down::↓
    :?:<~>::↭
    :?:~>::↝
    :?:<~::↜
#HotIf

; greek letter hotkeys
#HotIf IniRead("PRESETS.ini", "module_main", "greek_hotkeys") = "on"
    <^>!+d::Send "Δ"
    <^>!+t::Send "Θ"
    <^>!+l::Send "Λ"
    <^>!+x::Send "Ξ"
    <^>!+p::Send "Π"
    <^>!+s::Send "Σ"
    <^>!+o::Send "Ω"

    <^>!b::Send "β"
    <^>!a::Send "α"
    <^>!g::Send "γ"
    <^>!d::Send "δ"
    <^>!t::Send "θ"
    <^>!l::Send "λ"
    <^>!n::Send "ν"
    <^>!x::Send "ξ"
    <^>!p::Send "π"
    <^>!r::Send "ρ"
    <^>!s::Send "σ"
    <^>!o::Send "ω"
#HotIf

; greek letter hotstrings
#HotIf IniRead("PRESETS.ini", "module_main", "greek_hotstrings") = "on"
    :*?c:#Gam::Γ
    :*?c:#Del::Δ
    :*?c:#The::Θ
    :*?c:#Lam::Λ
    :*?c:#Xi::Ξ
    :*?c:#Pi::Π
    :*?c:#Sig::Σ
    :*?c:#Phi::Φ
    :*?c:#Psi::Ψ
    :*?c:#Ome::Ω

    :*?c:#alp::α
    :*?c:#bet::β
    :*?c:#gam::γ
    :*?c:#del::δ
    :*?c:##eps::ϵ
    :*?c:#eps::ε
    :*?c:#zet::ζ
    :*?c:#eta::η
    :*?c:##the::ϑ
    :*?c:#the::θ
    :*?c:#iot::ι
    :*?c:#kap::κ
    :*?c:#lam::λ
    :*?c:#my::μ
    :*?c:#mü::μ
    :*?c:#mu::μ
    :*?c:#ny::ν
    :*?c:#nü::ν
    :*?c:#nu::ν
    :*?c:#xi::ξ
    :*?c:#pi::π
    :*?c:#rho::ρ
    :*?c:##sig::ς
    :*?c:#sig::σ
    :*?c:#tau::τ
    :*?c:#yps::υ
    :*?c:#ups::υ
    :*?c:##phi::φ
    :*?c:#phi::ϕ
    :*?c:#chi::χ
    :*?c:#psi::ψ
    :*?c:#ome::ω
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Constants and units

#HotIf IniRead("PRESETS.ini", "module_main", "constants_units") = "on"

    ; nature constants
    :?:<c>::299792458 m s⁻¹                   ; speed of light in vacuum
    :?:<hq>::1,054571817 · 10⁻³⁴ J s          ; reduced planck constant
    :?:<h>::6,62607015 · 10⁻³⁴ J s            ; planck constant
    :?:<e>::1,602176634 · 10⁻¹⁹ C             ; elementary charge
    :?:<kB>::1,380649 · 10⁻²³ J K⁻¹           ; boltzmann constant
    :?:<alp>::7,2973525693 · 10⁻³             ; fine-structure constant α
    :?:<Ri>::1,0973731568160 · 10⁷ m⁻¹        ; rydberg constant R∞
    :?:<NA>::6,02214076 · 10²³ mol⁻¹          ; avogadro constant
    :?c:<F>::96485,33212 C mol⁻¹              ; faraday constant
    :?c:<R>::8,31446261815324 J mol⁻¹ K⁻¹     ; gas constant
    :?:<Kcd>::683,002 lm W⁻¹                  ; luminous efficacy
    :?:<my0>::1,25663706212 · 10⁻⁶ N A⁻²      ; vacuum magnetic permeability µ0
    :?:<eps0>::8,8541878128 · 10⁻¹² C V⁻¹ m⁻¹ ; vacuum permittivity ε0
    :?:<me>::9,1093837015 · 10⁻³¹ kg          ; mass of an electron
    :?:<mp>::1,67262192369 · 10⁻²⁷ kg         ; mass of an protron
    :?:<mn>::1,67492749804 · 10⁻²⁷ kg         ; mass of an neutron
    :?:<u>::1,66053906660 · 10⁻²⁷ kg          ; unified atomic mass unit
    :?:<atm>::1,01325 bar                     ; standard atmosphere
    :?c:<G>::6,67430 · 10⁻¹¹ m³ kg⁻¹ s⁻²      ; gravitational constant

    :?:<c,>::299792458
    :?:<hq,>::1,054571817e-34
    :?:<h,>::6,62607015e-34
    :?:<e,>::1,602176634e-19
    :?:<kB,>::1,380649e-23
    :?:<alp,>::7,2973525693e-3
    :?:<Ri,>::1,0973731568160e7
    :?:<NA,>::6,02214076e+23
    :?c:<F,>::96485,33212
    :?c:<R,>::8,31446261815324
    :?:<Kcd,>::683,002
    :?:<my0,>::1,25663706212e-6
    :?:<eps0,>::8,8541878128e-12
    :?:<me,>::9,1093837015e-31
    :?:<mp,>::1,6726219236e-27
    :?:<mn,>::1,67492749804e-27
    :?:<u,>::1,66053906660e-27
    :?:<atm,>::1,01325
    :?c:<G,>::6,67430e-11

    :?:<c.>::299792458
    :?:<hq.>::1.054571817e-34
    :?:<h.>::6.62607015e-34
    :?:<e.>::1.602176634e-19
    :?:<kB.>::1.380649e-23
    :?:<alp.>::7.2973525693e-3
    :?:<Ri.>::1.0973731568160e7
    :?:<NA.>::6.02214076e+23
    :?c:<F.>::96485.33212
    :?c:<R.>::8.31446261815324
    :?:<Kcd.>::683.002
    :?:<my0.>::1.25663706212e-6
    :?:<eps0.>::8.8541878128e-12
    :?:<me.>::9.1093837015e-31
    :?:<mp.>::1.6726219236e-27
    :?:<mn.>::1.67492749804e-27
    :?:<u.>::1.66053906660e-27
    :?:<atm.>::1.01325
    :?c:<G.>::6.67430e-11

    ; units
    :*:s^-1::s⁻¹ ; per second
    <^>!+5::Send "‰" ; per mille
    :*?:#cent::¢ ; cents
    :*?:#angstrom::Å ; angstrom

    ; paper formats
    :*?:#DinA0::841 × 1189 mm
    :*?:#DinA1::594 × 841 mm
    :*?:#DinA2::420 × 594 mm
    :*?:#DinA3::297 × 420 mm
    :*?:#DinA4::210 × 297 mm
    :*?:#DinA5::148 × 210 mm
    :*?:#DinA6::105 × 148 mm
    :*?:#DinA7::74 × 105 mm
    :*?:#DinA8::52 × 74 mm
    :*?:#DinA9::37 × 52 mm

#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Text selection commands

; Second clipboard with right ctrl key
#HotIf IniRead("PRESETS.ini", "module_main", "2nd_clipboard") = "on"
    extra_clipboard := ""
    >^c::
    >^x::
    {
        prevClip := A_Clipboard ; get clipboard
            A_Clipboard := "" ; empty the clipboard
            Send InStr(A_ThisHotkey, "c") ? "^c" : "^x"
            if !ClipWait(2)
            {
                A_Clipboard := prevClip ; reset clipboard
                return ; attempt to copy text onto clipboard failed
            }
            global extra_clipboard := A_Clipboard ; get selection
        A_Clipboard := prevClip ; reset clipboard
    }
    >^v::
    {
        prevClip := A_Clipboard ; get clipboard
            A_Clipboard := extra_clipboard ; set clipboard
            Send "^v"
        Sleep 100
        A_Clipboard := prevClip ; reset clipboard
    }
#HotIf

; Ballot boxes
#HotIf IniRead("PRESETS.ini", "module_main", "ballot_boxes") = "on"
    #+x:: ; toggle ☐ ↔ ☒
    #+y:: ; toggle ☐ ↔ ☑
    {
        toggleBallotBoxes(sel)
        {
            sel := StrReplace(sel, "☐", "{☐-placeholder}") ; replace empty ballot boxes with with placeholder
            sel := RegexReplace(sel, "☒|☑", "☐") ; replace "☒|☑" with "☐"
            sel := StrReplace(sel, "{☐-placeholder}", InStr(A_ThisHotkey, "x") ? "☒" : "☑") ; replace placeholder with "☒" (shortcut with x) or "☑" (shortcut with y)
            return sel
        }

        replaceSelection(toggleBallotBoxes) ; replace selected text
    }
#HotIf

; Quickly escape file names
#HotIf IniRead("PRESETS.ini", "module_main", "file_name_escape") = "on"
    #+f::
    {
        escapeFileName(sel)
        {
            replace := [ ; replacement pairs
                ["ä", "ae"], ["ö", "oe"], ["ü", "ue"],
                ["Ä", "Ae"], ["Ö", "Oe"], ["Ü", "Ue"], ["ß", "sz"],
                [", ", "-"],
                ["; ", "-"],
                [": ", "_"],
                ["regex/[\/\\,;]", "-"],
                ["regex/[\s   ()[\]{}:+]", "_"],
                ["regex/[`"'*#]", ""]
            ]
            return replaceChars(sel, replace)
        }

        replaceSelection(escapeFileName) ; replace selected text
    }
#HotIf

; Convert selection to chemical equation
; shortcut: Win + Shift + C
; e.g.
;     Ca6Al2[(OH)12|(SO4)3]*26H2O              | Ca₆Al₂[(OH)₁₂|(SO₄)₃] · 26H₂O
;     Mg(HCO3)2 <=> Mg2+ + 2 H+ + 2 CO3^2-      | Mg(HCO₃)₂ ⇌ Mg²⁺ + 2 H⁺ + 2 CO₃²⁻
;     SO42- + Ba2+ + 2Cl- -> BaSO4\> + 2 NO_3- | SO₄²⁻ + Ba²⁺ + 2Cl⁻ → BaSO₄↓ + 2 NO₃⁻
;     6FeS + 13O2 -> 2Fe3O4 (s) + 6SO3 (s)     | 6FeS + 13O₂ → 2Fe₃O₄ (s) + 6SO₃ (s)
;     H2O + 6 CO2 ->hn C6H12O6 + 6 O2^ + 6 H2O | H₂O + 6 CO₂ -hν→ C₆H₁₂O₆ + 6 O₂↑ + 6 H₂O
;     15 O2 + 2 C6H6 ->D 6 H2O + 12 CO2/>      | 15 O₂ + 2 ⌬ -Δ→ 6 H₂O + 12 CO₂↑
#HotIf IniRead("PRESETS.ini", "module_main", "chemistry") = "on"
    subnum := ["₀","₁","₂","₃","₄","₅","₆","₇","₈","₉"]
    supernum := ["⁰","¹","²","³","⁴","⁵","⁶","⁷","⁸","⁹"]
    chemnum(op, expr, arr) {
        while RegExMatch(op, expr, &m)
            op := m[1] arr[m[2] + 1] m[3]
        return op
    }
    #+c::
    {
        chemEquation(sel)
        {
            ; symbols
            replace := [ ; replacement pairs
                ["regex/\s*\*\s*", " · "],
                ["<=>", "⇌"],
                ["<->", "↔"],
                ["->hn", "-hν→"],
                ["->d", "-Δ→"],
                ["->", "→"],
                ["<-", "←"],
                ["/>", "↑"],
                ["regex/\^(?![\d+-])", "↑"],
                ["\>", "↓"],
                [" C6H6 ", " ⌬ "]
            ]
            sel := replaceChars(sel, replace)
            
            ; subscript numbers
            
            sel := chemNum(sel, "^(.*_)(\d)(.*)$", subnum) ; subscript by "_"
            sel := chemNum(sel, "^(.*[A-Za-z\(\)\[\]₀-₉])(\d)(?![+\-−–])(.*)$", subnum)
            
            ; superscript numbers
            sel := chemNum(sel, "^(.*[\^⁰¹²³⁴-⁹])(\d)(.*)$", supernum) ; superscript by "^"
            sel := chemNum(sel, "^(.*)(\d)([+\-−–⁰¹²³⁴-⁹].*)$", supernum)

            ; superscript charge
            sel := RegExReplace(sel, "(?<!\s)\+", "⁺")
            sel := RegExReplace(sel, "(?<!\s)[-−–]", "⁻")

            ; remove modifier characters
            sel := StrReplace(sel, "^", "")
            sel := StrReplace(sel, "_", "")

            return sel
        }

        replaceSelection(chemEquation) ; replace selected text
    }
#HotIf