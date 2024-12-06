start 
    = identifier "=" expression

identifier 
    = [_a-z][_a-z0-9]*

expression
    = sequence

sequence
    = head:primary tail:( "," primary)* { return [head].concat(tail.map(function(element) { return element[1]; })); }

primary
    = identifier
    / "(" expression ")"