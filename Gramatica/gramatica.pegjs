start 
    = first:rule rest:(newline rule)* { 
        return [first, ...rest.map(r => r[1])]; 
    }

rule 
    = name:identifier newline "=" _ expression:choices newline ";" { 
        return { name: name, expression: expression }; 
    }

choices 
    = first:concat rest:(newline "/" newline concat)* { 
        // Devuelve una lista combinada de todas las elecciones
        return [first, ...rest.map(r => r[2])];
    }


concat 
    = first:expression rest:(_ expression)* { 
        // Devuelve una lista combinada de las expresiones concatenadas
        return [first, ...rest.map(r => r[1])];
    }

expression
    = par:parserexpression l:locks? { 
        return l ? { type: "locked", base: par, modifier: l } : par;
    }

parserexpression
    = identifier
    / literal
    / range
    / parexpression

parexpression
    = "(" _ expression:choices _ expression2:(choices _)* ")" { return expression; }

locks
    = "?" { return "?"; }
    / "*" { return "*"; }
    / "+" { return "+"; }

identifier 
    = name:[_a-z]i[_a-z0-9]i* { return text(); }

// Cadenas de texto
literal
    = "'" chars:[^']* "'" { return chars.join(""); }
    / '"' chars:[^"]* '"' { return chars.join(""); }

// Rango de caracteres
range = "[" input_range+ "]"

input_range = [^[\]-] "-" [^[\]-]
			/ [^[\]]+
_ 
    = [ \t]*  // Ignora espacios en blanco y tabs

newline 
    = [ \t\n\r]*  // Maneja saltos de línea y espacios en blanco