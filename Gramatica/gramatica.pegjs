start 
    = rule+ _

rule 
    = _ identifier _ string? _ "=" _ choices (_ ";")?

choices 
    = concat (_ "/" _ concat)*

concat 
    = pluck (_ pluck !(_ string? _ "="))*

pluck 
    = "@"? _ label

label
    = (identifier _ ":")? _ expression

expression
    = par:parserexpression l:locks? 
    / "$"? _ parserexpression _ locks?
    / "&"? _ parserexpression _ locks?
    / "!"? _ parserexpression _ locks?
    / ":"? _ parserexpression _ locks?
    / "?"? _ parserexpression _ locks?
    / "+"? _ parserexpression _ locks?

parserexpression
    = identifier
    / range "i"?
    / groups
    / string "i"?
    / (_ "." _)+ _ (_)? _
    / (_"!."_)+ _ (_)? _

groups
    = "(" _ choices _ ")"

locks
    = [?+*]
    / "|" _ (number / identifier) _ "|"
    / "|" _ (number / identifier)? _ ".." _ (number / identifier)? _ "|"
    / "|" _ (number / identifier)? _ "," _ choices _ "|"
    / "|" _ (number / identifier)? _ ".." _ (number / identifier)? _ "," _ choices _ "|"


identifier 
    = [_a-z]i[_a-z0-9]i*

// Cadenas de texto
string
	= ["] [^"]* ["]
    / ['] [^']* [']

// Rango de caracteres
range = "[" input_range+ "]"

number
    = [0-9]+

input_range = [^[\]-] "-" [^[\]-]
			/ [^[\]]+
_ 
    = ([ \t\n\r] / coms)*  // Maneja saltos de línea y espacios en blanco
    
coms 
	="//" (![\n] .)*
    / "/*" (!("*/") .)* "*/"