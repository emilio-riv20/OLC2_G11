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
    / concat:concat rest:(newline "(" newline concat newline ")" )* {
        return [concat, ...rest.map(r => r[3])];
    }

concat 
    = first:expression rest:(_ expression)* { 
        // Devuelve una lista combinada de las expresiones concatenadas
        return [first, ...rest.map(r => r[1])];
    }

expression
    = par:parexpression l:locks? { 
        return l ? { type: "locked", base: par, modifier: l } : par;
    }

parexpression
    = identifier
    / literal
    / range

locks
    = "?" { return "?"; }
    / "*" { return "*"; }
    / "+" { return "+"; }

identifier 
    = name:[_a-z][_a-z0-9]* { return text(); }

// Cadenas de texto
literal
    = "'" chars:[^']* "'" { return chars.join(""); }
    / '"' chars:[^"]* '"' { return chars.join(""); }

// Rango de caracteres
range 
    = "[" chars:range_chars "]" { return chars; }

range_chars 
    = start:[a-zA-Z0-9] "-" end:[a-zA-Z0-9] { 
        const startCode = start.charCodeAt(0);
        const endCode = end.charCodeAt(0);
        if (startCode > endCode) {
            throw new Error(`Rango inválido: '${start}' no puede ser mayor que '${end}'`);
        }
        return Array.from({ length: endCode - startCode + 1 }, (_, i) => String.fromCharCode(startCode + i));
    }
    / chars:[a-zA-Z0-9]+ { 
        return chars; 
    }
_ 
    = [ \t]*  // Ignora espacios en blanco y tabs

newline 
    = [ \t\n\r]*  // Maneja saltos de línea y espacios en blanco