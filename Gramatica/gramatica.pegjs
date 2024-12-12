start 
    = newline first:rule rest:(newline rule)* newline { 
        return [first, ...rest.map(r => r[1])]; 
    }

rule 
    = name:identifier newline string? newline "=" _ expression:choices newline? (_ ";" _)?
    { 
        return { name: name, expression: expression }; 
    }

choices 
    = first:concat rest:(newline "/" newline concat)* { 
        // Devuelve una lista combinada de todas las elecciones
        return [first, ...rest.map(r => r[2])];
    }

concat 
    = pluck (_ pluck )*

pluck 
    = "@"? label

label
    = (identifier ":")? expression

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
    / (_ "." _)+ _ (newline)? _
    / (_"!."_)+ _ (newline)? _
    
    

groups
    = "(" _ choices _ ")"



locks
    = [?+*]
    / "|" _ (number / identifier) _ "|"
    / "|" _ (number / identifier)? _ ".." _ (number / identifier)? _ "|"
    / "|" _ (number / identifier)? _ "," _ choices _ "|"
    / "|" _ (number / identifier)? _ ".." _ (number / identifier)? _ "," _ choices _ "|"


identifier 
    = name:[_a-z]i[_a-z0-9]i* { return text(); }

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
    = [ \t]*  // Ignora espacios en blanco y tabs

newline 
    = ([ \t\n\r] / coms)*  // Maneja saltos de línea y espacios en blanco
    
coms 
	="//" (![\n] .)*
    / "/*" (!("*/") .)* "*/"