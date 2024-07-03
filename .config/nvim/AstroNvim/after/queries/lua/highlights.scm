;; extends 

(("else" @conditional) (#set! conceal "!"))
(("elseif" @conditional) (#set! conceal "¿"))
(("end" @keyword.function) (#set! conceal ""))
(("for" @repeat) (#set! conceal ""))
(("function" @keyword.function) (#set! conceal "󰊕"))
(("if" @conditional) (#set! conceal "?"))
(("in" @keyword) (#set! conceal "i"))
((function_call name: (identifier) @function.builtin (#eq? @function.builtin "require")) (#set! conceal ""))
(("then" @conditional) (#set! conceal "↙"))
(("local" @keyword) (#set! conceal "~"))
(("and" @keyword.function) (#set! conceal "󰣡"))
(("return" @keyword.function) (#set! conceal "󱞱"))
(("do" @repeat) (#set! conceal "󱞭"))
