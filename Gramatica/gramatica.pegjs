start 
    = rules:rule+ { return rules; }

rule 
    = name:identifier _ "=" _ expression:expressionlocks _ ";"? _ { 
        return { name: name, expression: expression }; 
    }
    /  name:identifier _ "=" _ expression:identifier _ ";"? _ (name2:identifier _ "=" _ expression2:identifier _ ";"?)+ { 
        return { name: name, expression: expression }; 
    }

expressionlocks
    = base:expression _ locks:locks? {
        if(locks == "?"){
            return {expression: [base, "*nada*"]};
        } else if(locks == "*"){
            return {expression: [base, "*cualquiera*"]};
        } else if(locks == "+"){
            return {expression: [base, "*al menos uno*"]};
        } else {
            return {expression: [base]};
        }
    }

locks
    = "?" { return "?"; }
    / "*" { return "*"; }
    / "+" { return "+"; }

identifier 
    = name:[_a-z][_a-z0-9]* { return text(); }

expression
    = or / range / concat / identifier / subex

// Cadenas de texto
literal
    = "'" chars:literal_chars "'" { return chars.join(""); }
    / '"' chars:literal_chars '"' { return chars.join(""); }

literal_chars
    = [^'"]*  // Captura cualquier carácter excepto las comillas delimitadoras

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

concat 
    = concate:literal+ { return concate.join(""); }

or
    = first:literal _ "/"? _ second:or? { 
        try {
            if(second){
                return [first, ...second];
            }else{
                return [first];
            }
        } catch (err) {
            // Si ocurre un error en la primera alternativa, ignoramos el error y continuamos con la siguiente.
            return second || [];
        }
    }

subex
    = "(" _ expression:expression _ ")" { return expression; }
// Espacios opcionales
_
    = [ \t\r\n]*  // Ignora espacios en blanco y saltos de línea