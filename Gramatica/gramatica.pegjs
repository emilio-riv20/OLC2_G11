start 
    = rules:rule+ { return rules; }

rule 
    = name:identifier "=" expression:expression { return { name: name, expression: expression }; }

identifier 
    = name:[_a-z][_a-z0-9]* { return text(); }

expression
    = literal / range / sequence 

//Cadenas de texto
literal
    = "'" chars:[^"]+ "'" { return chars.join(""); }
    / '"' chars:[^']+ '"' { return chars.join(""); }    

//Rango de caracteres
range 
    = "[" chars:range_chars "]" { return chars.join(""); }

range_chars 
    = range:[a-zA-Z0-9]"-"[a-zA-Z0-9] { return range.join(""); }
    / char:[^]+ { return chars.join(""); }

sequence
 = []