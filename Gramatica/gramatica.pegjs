start 
    = rule+ _

rule 
    = _ name:identifier _ string? _ "=" _ expression:choices _ (_ ";")? { 
        return { name: name, expression: expression }; 
    }

choices 
    = first:concat rest:(_ "/" _ concat)* { 
        // Devuelve una lista combinada de todas las elecciones
        return [first, ...rest.map(r => r[2])];
    }

concat 
    = pluck (_ pluck !"=")*

pluck 
    = "@"? _ label

label
    = (identifier _ ":")? _ expression

expression
    = "$"* _ parserexpression locks?

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
    = [ \t\n\r]*  // Maneja saltos de línea y espacios en blanco