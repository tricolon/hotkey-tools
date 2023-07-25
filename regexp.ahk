#Requires AutoHotkey v2.0
; Optimized for German keyboards
#SingleInstance Force
TraySetIcon "img/regexp.png",,1
#Include lib/RegExHotstring.ahk
#Include lib/jax.ahk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Calculator

; Super fast calculator
; ending characters: {=} {space} {tab} {enter}
;
; arithmetic operations:
;     + - * / ^ r
;     eu = Euler’s number, pi = Pi
;     Exp() Ln() Sq() Sin() Cos() Tan() Asin() Acos() Atan() Abs()
;     Mod(dividend; divisor) Round(number, decimal_places)
;
; e.g.
;     #2*(4+4)/9    1,7777777778
;     #2*pi         6,2831853072
;     #eu           2,7182818285
;     #4/0          ☹            (not defined)
;     #4,5^4e-2     1,0620097418
;     #sqrt(30)     5,4772255751
;     #30r2         5,4772255751
;     #sin(3)       0,1411200081
;     #sin(pi)      0
;     #atan(,5)     0,463647609

if (IniRead("PRESETS.ini", "module_regexp", "calculator") = "on") {

    ; regex
    calcExpr := "#("
            .   "(?:[\d\+\-\(]|\de[\d+-]|eu|pi|Exp|Ln|Sqrt|Sin|Cos|Tan|Asin|Acos|Atan|Mod|Abs|Round)"                      ; possible start characters
            .   "(?:[\d\.,;\+\-\*\/\(\)]|\^\d|r\d+|\de[\d+-]|eu|pi|Exp|Ln|Sqrt|Sin|Cos|Tan|Asin|Acos|Atan|Mod|Abs|Round)*" ; for !English version remove ";"
            .   ")"

    ; trigger
    RegExHotstring(calcExpr, calc, "?")
    RegExHotstring(calcExpr . "=", calc, "?*")

    ; parse input
    calc(match) {
        str := match[1] ; get match
        
        ; root operator
        str := RegExReplace(str, "r(\d+)", "**(1/$1)")

        ; replacement pairs
        replace := [
            [",", "."],  ; for !English version remove this
            [";", ","],  ; for !English version remove this
            ["^", "**"],
            ["pi", "3.14159265358979323846264"],
            ["eu", "2.71828182845904523536029"]
        ]
        
        ; replacement
        for i, pair in replace {
            str := StrReplace(str, pair[1], pair[2])
        }
        
        script :=
        ( ; error handling: send ☹ (U+2639) on error

            "OnError LogError            `n"
            "LogError(exception, mode) { `n"
            "    Send '{U+2639}'         `n"
            "    return true             `n"
            "}                           `n"

        ) . ( ; calculate and send output string, for !English version send op_str instead german_op_str
        
            "num := " str "                              `n"
            "num := Round(num, 10)                       `n"
            "op_str := RegExReplace('' . num, '\.?0+$')  `n" ; rem0()
            "german_op_str := StrReplace(op_str,'.',',') `n" ; dt()
            "Send(german_op_str)                           "
        )
        execute(script)
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Text commands

; Repeat string
; ending characters: {space} {tab} {enter}
; e.g.
;     #a*20          aaaaaaaaaaaaaaaaaaaa
;     #hi*3          hihihi
;     #hi_*3         hi hi hi [underscore (_) is placeholder for space character]
;     #(rdm)*5       o2qVf [random characters: (rdm)]
;     #(i)*9         12345 [index: (i)]
;     #(up)(bs_2)*5  [presses the UP key and then 2 times BACKSPACE for 5 times in a row]
;     #+a*5          AAAAA [supports native AHK key shortcuts (#win ^ctrl +shift !alt)]
;     #^v(enter)*5   [pastes the clipboard 5 times in new lines – in some programs this might not work because it is "typing" too fast]

if (IniRead("PRESETS.ini", "module_regexp", "repeat_string") = "on") {

    RegExHotstring("#([#\^\+!\w\-\(\).,;<>°*'\/\\=%$@€§&|~?ÄÖÜäöüß]+)\*(\d{1,3})", repeat)
    repeat(match) {
        single := StrReplace( StrReplace( StrReplace( match[1], "(", "{" ), ")", "}" ), "_", " " ) ; replace paranthesis "()" with special key escaping curly brackets "{}" and underscore "_" with space " "

        if (single = "{rdm}") { ; output: random characters
            op := randm(match[2], "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        } else { ; output: repeated input characters
            loop match[2]
                op .= StrReplace( single, "{i}", A_Index )
        }
        Send op
    }
}

; Unicode markup
; ending characters: {space} {tab} {enter}
;
; e.g.
;     ~(123hi!)          ¡ᴉɥ↋↊Ɩ
;     <(123hi!)          !iʜԐ𐑕ᛚ
;     #flip(123hi!)      !ih321
;     #inv(123hi!)       Ɩ↊↋ɥᴉ¡
;     #rev(123hi!)       !ᛚ𐑕Ԑʜi
;     #sub(123hi)        ₁₂₃ₕᵢ
;     #super(123hi)      ¹²³ʰⁱ
;     #sans_bold(123hi)  𝟭𝟮𝟯𝗵𝗶
;     #serif_bold(123hi) 𝟏𝟐𝟑𝐡𝐢
;     #fraktur(Hallo)    ℌ𝔞𝔩𝔩𝔬
;     #cirled(Hallo)     Ⓗⓐⓛⓛⓞ
;     #squared(Hallo)    🄷🄰🄻🄻🄾

if (IniRead("PRESETS.ini", "module_regexp", "unicode_markup") = "on") {

    ; character list
    unicodeMarkup := Map(
        "rev",               ["A","ꓭ","Ↄ","ꓷ","Ǝ","ᖷ","Ә","H","I","Ⴑ","ꓘ","⅃","M","И","O","Գ","Ϙ","ᴙ","Ƨ","T","U","V","W","X","Y","S","ɒ","d","ↄ","b","ɘ","ʇ","g","ʜ","i","į","ʞ","l","m","ᴎ","o","q","p","ɿ","ƨ","Ɉ","υ","v","w","x","ჸ","s","Ä","Ö","Ü","ƧƧ","ɒ̈","ö","ϋ","ƨƨ","0","ᛚ","𐑕","Ԑ","𐊀","ट","მ","٢","8","୧",")","(","]","[","}","{","!","⸮",".","⹁","*",":","⁏"],
        "inv",               ["Ɐ","ꓭ","ꓛ","ꓷ","Ǝ","ꓞ","ꓨ","H","I","ſ","ꓘ","ꓶ","W","N","O","ꓒ","Ὸ","ꓤ","S","ꓕ","ꓵ","ꓥ","M","X","⅄","Z","ɐ","q","ɔ","p","ǝ","ɟ","ɓ","ɥ","ᴉ","ꓩ","ʞ","ן","ɯ","u","o","d","b","ɹ","s","ʇ","n","ʌ","ʍ","x","ʎ","z","Ɐ̤","O̤","ꓵ̤","SS","̤ɐ","̤o","̤n","ss","0","Ɩ","↊","↋","Һ","ꞔ","9","L","8","6","(",")","[","]","{","}","¡","¿","·","ʻ","ₓ",":","⸵"],
        "sub",               ["ₐ","B","C","D","ₑ","F","G","ₕ","ᵢ","ⱼ","ₖ","ₗ","ₘ","ₙ","ₒ","ₚ","Q","ᵣ","ₛ","ₜ","ᵤ","ᵥ","W","ₓ","Y","Z","ₐ","b","c","d","ₑ","f","g","ₕ","ᵢ","ⱼ","ₖ","ₗ","ₘ","ₙ","ₒ","ₚ","q","ᵣ","ₛ","ₜ","ᵤ","ᵥ","w","ₓ","y","z","ₐₑ","ₒₑ","ᵤₑ","ₛₛ","ₐₑ","ₒₑ","ᵤₑ","ᵦ","₀","₁","₂","₃","₄","₅","₆","₇","₈","₉","₍","₎"],
        "super",             ["ᴬ","ᴮ","ᶜ","ᴰ","ᴱ","ᶠ","ᴳ","ᴴ","ᴵ","ᴶ","ᴷ","ᴸ","ᴹ","ᴺ","ᴼ","ᴾ","ꟴ","ᴿ","ˢ","ᵀ","ᵁ","ⱽ","ᵂ","ˣ","ʸ","ᶻ","ᵃ","ᵇ","ᶜ","ᵈ","ᵉ","ᶠ","ᵍ","ʰ","ⁱ","ʲ","ᵏ","ˡ","ᵐ","ⁿ","ᵒ","ᵖ","𐞥","ʳ","ˢ","ᵗ","ᵘ","ᵛ","ʷ","ˣ","ʸ","ᶻ","ᴬᵉ","ᴼᵉ","ᵁᵉ","ˢˢ","ᵃᵉ","ᵒᵉ","ᵘᵉ","ᵝ","⁰","¹","²","³","⁴","⁵","⁶","⁷","⁸","⁹","⁽","⁾"],
        "small_caps",        ["ᴀ","ʙ","ᴄ","ᴅ","ᴇ","ꜰ","ɢ","ʜ","ɪ","ᴊ","ᴋ","ʟ","ᴍ","ɴ","ᴏ","ᴩ","ꞯ","ʀ","ꜱ","ᴛ","ᴜ","ᴠ","ᴡ","x","ʏ","ᴢ","ᴀ","ʙ","ᴄ","ᴅ","ᴇ","ꜰ","ɢ","ʜ","ɪ","ᴊ","ᴋ","ʟ","ᴍ","ɴ","ᴏ","ᴩ","q","ʀ","ꜱ","ᴛ","ᴜ","ᴠ","ᴡ","x","ʏ","ᴢ","ᴀ̈","ᴏ̈","ᴜ̈","ꜱꜱ","ᴀ̈","ᴏ̈","ᴜ̈","ꜱꜱ"],
        "sans",              ["𝖠","𝖡","𝖢","𝖣","𝖤","𝖥","𝖦","𝖧","𝖨","𝖩","𝖪","𝖫","𝖬","𝖭","𝖮","𝖯","𝖰","𝖱","𝖲","𝖳","𝖴","𝖵","𝖶","𝖷","𝖸","𝖹","𝖺","𝖻","𝖼","𝖽","𝖾","𝖿","𝗀","𝗁","𝗂","𝗃","𝗄","𝗅","𝗆","𝗇","𝗈","𝗉","𝗊","𝗋","𝗌","𝗍","𝗎","𝗏","𝗐","𝗑","𝗒","𝗓","Ä","Ö","Ü","ẞ","ä","ö","ü","ß","𝟢","𝟣","𝟤","𝟥","𝟦","𝟧","𝟨","𝟩","𝟪","𝟫"],
        "sans_bold",         ["𝗔","𝗕","𝗖","𝗗","𝗘","𝗙","𝗚","𝗛","𝗜","𝗝","𝗞","𝗟","𝗠","𝗡","𝗢","𝗣","𝗤","𝗥","𝗦","𝗧","𝗨","𝗩","𝗪","𝗫","𝗬","𝗭","𝗮","𝗯","𝗰","𝗱","𝗲","𝗳","𝗴","𝗵","𝗶","𝗷","𝗸","𝗹","𝗺","𝗻","𝗼","𝗽","𝗾","𝗿","𝘀","𝘁","𝘂","𝘃","𝘄","𝘅","𝘆","𝘇","𝗔𝗲","𝗢𝗲","𝗨𝗲","𝗦𝗦","𝗮𝗲","𝗼𝗲","𝘂𝗲","𝝱","𝟬","𝟭","𝟮","𝟯","𝟰","𝟱","𝟲","𝟳","𝟴","𝟵"],
        "sans_bold_italic",  ["𝘼","𝘽","𝘾","𝘿","𝙀","𝙁","𝙂","𝙃","𝙄","𝙅","𝙆","𝙇","𝙈","𝙉","𝙊","𝙋","𝙌","𝙍","𝙎","𝙏","𝙐","𝙑","𝙒","𝙓","𝙔","𝙕","𝙖","𝙗","𝙘","𝙙","𝙚","𝙛","𝙜","𝙝","𝙞","𝙟","𝙠","𝙡","𝙢","𝙣","𝙤","𝙥","𝙦","𝙧","𝙨","𝙩","𝙪","𝙫","𝙬","𝙭","𝙮","𝙯","𝘼𝙚","𝙊𝙚","𝙐𝙚","𝙎𝙎","𝙖𝙚","𝙤𝙚","𝙪𝙚","𝞫"],
        "sans_italic",       ["𝘈","𝘉","𝘊","𝘋","𝘌","𝘍","𝘎","𝘏","𝘐","𝘑","𝘒","𝘓","𝘔","𝘕","𝘖","𝘗","𝘘","𝘙","𝘚","𝘛","𝘜","𝘝","𝘞","𝘟","𝘠","𝘡","𝘢","𝘣","𝘤","𝘥","𝘦","𝘧","𝘨","𝘩","𝘪","𝘫","𝘬","𝘭","𝘮","𝘯","𝘰","𝘱","𝘲","𝘳","𝘴","𝘵","𝘶","𝘷","𝘸","𝘹","𝘺","𝘻","𝘈𝘦","𝘖𝘦","𝘜𝘦","𝘚𝘚","𝘢𝘦","𝘰𝘦","𝘶𝘦","𝛽"],
        "serif_bold",        ["𝐀","𝐁","𝐂","𝐃","𝐄","𝐅","𝐆","𝐇","𝐈","𝐉","𝐊","𝐋","𝐌","𝐍","𝐎","𝐏","𝐐","𝐑","𝐒","𝐓","𝐔","𝐕","𝐖","𝐗","𝐘","𝐙","𝐚","𝐛","𝐜","𝐝","𝐞","𝐟","𝐠","𝐡","𝐢","𝐣","𝐤","𝐥","𝐦","𝐧","𝐨","𝐩","𝐪","𝐫","𝐬","𝐭","𝐮","𝐯","𝐰","𝐱","𝐲","𝐳","𝐀𝐞","𝐎𝐞","𝐔𝐞","𝐒𝐒","𝐚𝐞","𝐨𝐞","𝐮𝐞","𝛃","𝟎","𝟏","𝟐","𝟑","𝟒","𝟓","𝟔","𝟕","𝟖","𝟗"],
        "serif_bold_italic", ["𝑨","𝑩","𝑪","𝑫","𝑬","𝑭","𝑮","𝑯","𝑰","𝑱","𝑲","𝑳","𝑴","𝑵","𝑶","𝑷","𝑸","𝑹","𝑺","𝑻","𝑼","𝑽","𝑾","𝑿","𝒀","𝒁","𝒂","𝒃","𝒄","𝒅","𝒆","𝒇","𝒈","𝒉","𝒊","𝒋","𝒌","𝒍","𝒎","𝒏","𝒐","𝒑","𝒒","𝒓","𝒔","𝒕","𝒖","𝒗","𝒘","𝒙","𝒚","𝒛","𝑨𝒆","𝑶𝒆","𝑼𝒆","𝑺𝑺","𝒂𝒆","𝒐𝒆","𝒖𝒆","𝜷"],
        "monospace",         ["𝙰","𝙱","𝙲","𝙳","𝙴","𝙵","𝙶","𝙷","𝙸","𝙹","𝙺","𝙻","𝙼","𝙽","𝙾","𝙿","𝚀","𝚁","𝚂","𝚃","𝚄","𝚅","𝚆","𝚇","𝚈","𝚉","𝚊","𝚋","𝚌","𝚍","𝚎","𝚏","𝚐","𝚑","𝚒","𝚓","𝚔","𝚕","𝚖","𝚗","𝚘","𝚙","𝚚","𝚛","𝚜","𝚝","𝚞","𝚟","𝚠","𝚡","𝚢","𝚣","𝙰𝚎","𝙾𝚎","𝚄𝚎","𝚂𝚂","𝚊𝚎","𝚘𝚎","𝚞𝚎","ß","𝟶","𝟷","𝟸","𝟹","𝟺","𝟻","𝟼","𝟽","𝟾","𝟿"],
        "script",            ["𝒜","ℬ","𝒞","𝒟","ℰ","ℱ","𝒢","ℋ","ℐ","𝒥","𝒦","ℒ","ℳ","𝒩","𝒪","𝒫","𝒬","ℛ","𝒮","𝒯","𝒰","𝒱","𝒲","𝒳","𝒴","𝒵","𝒶","𝒷","𝒸","𝒹","ℯ","𝒻","ℊ","𝒽","𝒾","𝒿","𝓀","𝓁","𝓂","𝓃","ℴ","𝓅","𝓆","𝓇","𝓈","𝓉","𝓊","𝓋","𝓌","𝓍","𝓎","𝓏","𝒜ℯ","𝒪ℯ","𝒰ℯ","𝒮𝒮","𝒶ℯ","ℴℯ","𝓊ℯ","𝓈𝓈"],
        "script_bold",       ["𝓐","𝓑","𝓒","𝓓","𝓔","𝓕","𝓖","𝓗","𝓘","𝓙","𝓚","𝓛","𝓜","𝓝","𝓞","𝓟","𝓠","𝓡","𝓢","𝓣","𝓤","𝓥","𝓦","𝓧","𝓨","𝓩","𝓪","𝓫","𝓬","𝓭","𝓮","𝓯","𝓰","𝓱","𝓲","𝓳","𝓴","𝓵","𝓶","𝓷","𝓸","𝓹","𝓺","𝓻","𝓼","𝓽","𝓾","𝓿","𝔀","𝔁","𝔂","𝔃","𝓐𝓮","𝓞𝓮","𝓤𝓮","𝓢𝓢","𝓪𝓮","𝓸𝓮","𝓾𝓮","𝓼𝓼"],
        "fraktur",           ["𝔄","𝔅","ℭ","𝔇","𝔈","𝔉","𝔊","ℌ","ℑ","𝔍","𝔎","𝔏","𝔐","𝔑","𝔒","𝔓","𝔔","ℜ","𝔖","𝔗","𝔘","𝔙","𝔚","𝔛","𝔜","ℨ","𝔞","𝔟","𝔠","𝔡","𝔢","𝔣","𝔤","𝔥","𝔦","𝔧","𝔨","𝔩","𝔪","𝔫","𝔬","𝔭","𝔮","𝔯","𝔰","𝔱","𝔲","𝔳","𝔴","𝔵","𝔶","𝔷","𝔄𝔢","𝔒𝔢","𝔘𝔢","𝔖ℨ","𝔞𝔢","𝔬𝔢","𝔲𝔢","𝔰𝔷"],
        "fraktur_bold",      ["𝕬","𝕭","𝕮","𝕯","𝕰","𝕱","𝕲","𝕳","𝕴","𝕵","𝕶","𝕷","𝕸","𝕹","𝕺","𝕻","𝕼","𝕽","𝕾","𝕿","𝖀","𝖁","𝖂","𝖃","𝖄","𝖅","𝖆","𝖇","𝖈","𝖉","𝖊","𝖋","𝖌","𝖍","𝖎","𝖏","𝖐","𝖑","𝖒","𝖓","𝖔","𝖕","𝖖","𝖗","𝖘","𝖙","𝖚","𝖛","𝖜","𝖝","𝖞","𝖟","𝕬𝖊","𝕺𝖊","𝖀𝖊","𝕾𝖅","𝖆𝖊","𝖔𝖊","𝖚𝖊","𝖘𝖟"],
        "double-struck",     ["𝔸","𝔹","ℂ","𝔻","𝔼","𝔽","𝔾","ℍ","𝕀","𝕁","𝕂","𝕃","𝕄","ℕ","𝕆","ℙ","ℚ","ℝ","𝕊","𝕋","𝕌","𝕍","𝕎","𝕏","𝕐","ℤ","𝕒","𝕓","𝕔","𝕕","𝕖","𝕗","𝕘","𝕙","𝕚","𝕛","𝕜","𝕝","𝕞","𝕟","𝕠","𝕡","𝕢","𝕣","𝕤","𝕥","𝕦","𝕧","𝕨","𝕩","𝕪","𝕫","𝔸𝕖","𝕆𝕖","𝕌𝕖","𝕊𝕊","𝕒𝕖","𝕠𝕖","𝕦𝕖","𝕤𝕤","𝟘","𝟙","𝟚","𝟛","𝟜","𝟝","𝟞","𝟟","𝟠","𝟡"],
        "fullwidth",         ["Ａ","Ｂ","Ｃ","Ｄ","Ｅ","Ｆ","Ｇ","Ｈ","Ｉ","Ｊ","Ｋ","Ｌ","Ｍ","Ｎ","Ｏ","Ｐ","Ｑ","Ｒ","Ｓ","Ｔ","Ｕ","Ｖ","Ｗ","Ｘ","Ｙ","Ｚ","ａ","ｂ","ｃ","ｄ","ｅ","ｆ","ｇ","ｈ","ｉ","ｊ","ｋ","ｌ","ｍ","ｎ","ｏ","ｐ","ｑ","ｒ","ｓ","ｔ","ｕ","ｖ","ｗ","ｘ","ｙ","ｚ","Ä","Ö","Ü","ẞ","ä","ö","ü","ß","０","１","２","３","４","５","６","７","８","９","（","）","［","］","｛","｝","！","？","．","，","＊","：","；"],
        "circled",           ["Ⓐ","Ⓑ","Ⓒ","Ⓓ","Ⓔ","Ⓕ","Ⓖ","Ⓗ","Ⓘ","Ⓙ","Ⓚ","Ⓛ","Ⓜ","Ⓝ","Ⓞ","Ⓟ","Ⓠ","Ⓡ","Ⓢ","Ⓣ","Ⓤ","Ⓥ","Ⓦ","Ⓧ","Ⓨ","Ⓩ","ⓐ","ⓑ","ⓒ","ⓓ","ⓔ","ⓕ","ⓖ","ⓗ","ⓘ","ⓙ","ⓚ","ⓛ","ⓜ","ⓝ","ⓞ","ⓟ","ⓠ","ⓡ","ⓢ","ⓣ","ⓤ","ⓥ","ⓦ","ⓧ","ⓨ","ⓩ","Ⓐⓔ","Ⓞⓔ","Ⓤⓔ","ⓈⓈ","ⓐⓔ","ⓞⓔ","ⓤⓔ","ⓢⓢ","⓪","①","②","③","④","⑤","⑥","⑦","⑧","⑨","(",")","[","]","{","}","(!)","(?)","⨀","(,)","⊛"],
        "negative_circled",  ["🅐","🅑","🅒","🅓","🅔","🅕","🅖","🅗","🅘","🅙","🅚","🅛","🅜","🅝","🅞","🅟","🅠","🅡","🅢","🅣","🅤","🅥","🅦","🅧","🅨","🅩","🅐","🅑","🅒","🅓","🅔","🅕","🅖","🅗","🅘","🅙","🅚","🅛","🅜","🅝","🅞","🅟","🅠","🅡","🅢","🅣","🅤","🅥","🅦","🅧","🅨","🅩","🅐🅔","🅞🅔","🅤🅔","🅢🅢","🅐🅔","🅞🅔","🅤🅔","🅢🅢","⓿","❶","❷","❸","❹","❺","❻","❼","❽","❾"],
        "squared",           ["🄰","🄱","🄲","🄳","🄴","🄵","🄶","🄷","🄸","🄹","🄺","🄻","🄼","🄽","🄾","🄿","🅀","🅁","🅂","🅃","🅄","🅅","🅆","🅇","🅈","🅉","🄰","🄱","🄲","🄳","🄴","🄵","🄶","🄷","🄸","🄹","🄺","🄻","🄼","🄽","🄾","🄿","🅀","🅁","🅂","🅃","🅄","🅅","🅆","🅇","🅈","🅉","🄰🄴","🄾🄴","🅄🄴","🅂🅂","🄰🄴","🄾🄴","🅄🄴","🅂🅂","⧇","[1]","[2]","[3]","[4]","[5]","[6]","[7]","[8]","[9]","(",")","[","]","{","}","!","?","⊡",",","⧆"],
        "negative_squared",  ["🅰","🅱","🅲","🅳","🅴","🅵","🅶","🅷","🅸","🅹","🅺","🅻","🅼","🅽","🅾","🅿","🆀","🆁","🆂","🆃","🆄","🆅","🆆","🆇","🆈","🆉","🅰","🅱","🅲","🅳","🅴","🅵","🅶","🅷","🅸","🅹","🅺","🅻","🅼","🅽","🅾","🅿","🆀","🆁","🆂","🆃","🆄","🆅","🆆","🆇","🆈","🆉","🅰🅴","🅾🅴","🆄🅴","🆂🆂","🅰🅴","🅾🅴","🆄🅴","🆂🆂"],
        "parenthesized",     ["🄐","🄑","🄒","🄓","🄔","🄕","🄖","🄗","🄘","🄙","🄚","🄛","🄜","🄝","🄞","🄟","🄠","🄡","🄢","🄣","🄤","🄥","🄦","🄧","🄨","🄩","⒜","⒝","⒞","⒟","⒠","⒡","⒢","⒣","⒤","⒥","⒦","⒧","⒨","⒩","⒪","⒫","⒬","⒭","⒮","⒯","⒰","⒱","⒲","⒳","⒴","⒵","🄐🄔","🄞🄔","🄤🄔","🄢🄢","⒜⒠","⒪⒠","⒰⒠","⒮⒮",,"(0)","⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼"],
        "region",            ["🇦","🇧","🇨","🇩","🇪","🇫","🇬","🇭","🇮","🇯","🇰","🇱","🇲","🇳","🇴","🇵","🇶","🇷","🇸","🇹","🇺","🇻","🇼","🇽","🇾","🇿","🇦","🇧","🇨","🇩","🇪","🇫","🇬","🇭","🇮","🇯","🇰","🇱","🇲","🇳","🇴","🇵","🇶","🇷","🇸","🇹","🇺","🇻","🇼","🇽","🇾","🇿"],
        "morse",             [".- ","-... ","-.-. ","-.. ",". ","..-. ","--. ",".... ",".. ",".--- ","-.- ",".-.. ","-- ","-. ","--- ",".--. ","--.- ",".-. ","... ","- ","..- ","...- ",".-- ","-..- ","-.-- ","--.. ",".- ","-... ","-.-. ","-.. ",". ","..-. ","--. ",".... ",".. ",".--- ","-.- ",".-.. ","-- ","-. ","--- ",".--. ","--.- ",".-. ","... ","- ","..- ","...- ",".-- ","-..- ","-.-- ","--.. ",".-.- ","---. ","..-- ","...--.. ",".-.- ","---. ","..-- ","...--.. ","----- ",".---- ","..--- ","...-- ","....- ","..... ","-.... ","--... ","---.. ","----. ","-.--. ","-.--.- ","-.--. ","-.--.- ","-.--. ","-.--.- ","-.-.-- ","..--.. ",".-.-.- ","--..-- ","...-. ","---... ","-.-.-."], ; (* = sign for verified)
        "buchstabieren_at",  ["Anton ","Berta ","Cäsar ","Dora ","Emil ","Friedrich ","Gustav ","Heinrich ","Ida ","Julius ","Konrad ","Ludwig ","Martha ","Nordpol ","Otto ","Paula ","ku ","Richard ","Siegfried ","Theodor ","Ulrich ","Viktor ","Wilhelm ","Xaver ","Ypsilon ","Zürich ","Anton ","Berta ","Cäsar ","Dora ","Emil ","Friedrich ","Gustav ","Heinrich ","Ida ","Julius ","Konrad ","Ludwig ","Martha ","Nordpol ","Otto ","Paula ","ku ","Richard ","Siegfried ","Theodor ","Ulrich ","Viktor ","Wilhelm ","Xaver ","Ypsilon ","Zürich ","Ärger ","Österreich ","Übel ","Scharfes S ","Ärger ","Österreich ","Übel ","Scharfes S "],
        "buchstabieren_de",  ["Aachen ","Berlin ","Chemnitz ","Düsseldorf ","Essen ","Frankfurt ","Goslar ","Hamburg ","Ingelheim ","Jena ","Köln ","Leipzig ","München ","Nürnberg ","Offenbach ","Potsdam ","Quickborn ","Rostock ","Salzwedel ","Tübingen ","Unna ","Völklingen ","Wuppertal ","Xanten ","Ypsilon ","Zwickau ","Aachen ","Berlin ","Chemnitz ","Düsseldorf ","Essen ","Frankfurt ","Goslar ","Hamburg ","Ingelheim ","Jena ","Köln ","Leipzig ","München ","Nürnberg ","Offenbach ","Potsdam ","Quickborn ","Rostock ","Salzwedel ","Tübingen ","Unna ","Völklingen ","Wuppertal ","Xanten ","Ypsilon ","Zwickau ","Umlaut Aachen ","⁠Umlaut Offenbach ","⁠Umlaut Unna ","Eszett ","Umlaut Aachen ","⁠Umlaut Offenbach ","⁠Umlaut Unna ","Eszett "],
        "buchstabieren_icao",["Alfa ","Bravo ","Charlie ","Delta ","Echo ","Foxtrot ","Golf ","Hotel ","India ","Juliett ","Kilo ","Lima ","Mike ","November ","Oscar ","Papa ","Quebec ","Romeo ","Sierra ","Tango ","Uniform ","Victor ","Whiskey ","X-Ray ","Yankee ","Zulu ","Alfa ","Bravo ","Charlie ","Delta ","Echo ","Foxtrot ","Golf ","Hotel ","India ","Juliett ","Kilo ","Lima ","Mike ","November ","Oscar ","Papa ","Quebec ","Romeo ","Sierra ","Tango ","Uniform ","Victor ","Whiskey ","X-Ray ","Yankee ","Zulu "],
    )

    ; regex
    allowedChars := "[\wÄÖÜẞäöüß()[\]{}!?.,*:;\-_\/]" ; unchanged characters: "-_/"
    unicodeMarkupExpr := "("
    for key, val in unicodeMarkup
        unicodeMarkupExpr .= key . "|"
    unicodeMarkupExpr := SubStr(unicodeMarkupExpr,1,StrLen(unicodeMarkupExpr)-1) ; remove last "|" from string
    unicodeMarkupExpr .= ")"

    ; trigger
    RegExHotstring("~\((" allowedChars "*)\)", upsideDown)
    RegExHotstring("<\((" allowedChars "*)\)", mirror)
    RegExHotstring("#flip\((" allowedChars "*)\)", reverse)
    RegExHotstring("#" unicodeMarkupExpr "\((" allowedChars "*)\)", markup)

    ; parse input
    markup(match) {
        op := changeCharacters( match[2], match[1] )
        op := StrReplace( op, "!", "{!}" ) ; escape wildcard character "!" (alt)
        Send op
    }
    reverse(match) {
        op := flip(match[1])
        op := StrReplace( op, "!", "{!}" ) ; escape wildcard character "!" (alt)
        Send op
    }
    mirror(match) {
        op := flip(match[1])
        op := changeCharacters( op, "rev" )
        op := StrReplace( op, "!", "{!}" ) ; escape wildcard character "!" (alt)
        Send op
    }
    upsideDown(match) {
        op := flip(match[1])
        op := changeCharacters( op, "inv" )
        op := StrReplace( op, "!", "{!}" ) ; escape wildcard character "!" (alt)
        Send op
    }

    ; replace characters
    changeCharacters(str, markupType) {
        src := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÄÖÜẞäöüß0123456789()[]{}!?.,*:;"
        dest := unicodeMarkup[markupType]
        op := ""
        
        i := 0
        while i++ < StrLen(str)
        {
            srcChar := SubStr(str, i, 1)
            j := InStr(src, srcChar, true) ; get index of current character in src (case-sensitive)
            destChar := (j && j <= dest.Length) ? dest[j] : srcChar ; srcChar is default
            op .= destChar ; add destination character to output string 
        }

        return op
    }
}