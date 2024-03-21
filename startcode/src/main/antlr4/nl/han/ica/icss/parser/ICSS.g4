grammar ICSS;

//--- LEXER: ---

// IF support:
IF: 'if';
ELSE: 'else';
BOX_BRACKET_OPEN: '[';
BOX_BRACKET_CLOSE: ']';

//Literals
TRUE: 'TRUE';
FALSE: 'FALSE';
PIXELSIZE: [0-9]+ 'px';
PERCENTAGE: [0-9]+ '%';
SCALAR: [0-9]+;

//Color value takes precedence over id idents
COLOR: '#' [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f];

//Specific identifiers for id's and css classes
ID_IDENT: '#' [a-z0-9\-]+;
CLASS_IDENT: '.' [a-z0-9\-]+;

//General identifiers
LOWER_IDENT: [a-z] [a-z0-9\-]*;
CAPITAL_IDENT: [A-Z] [A-Za-z0-9_]*;

//All whitespace is skipped
WS: [ \t\r\n]+ -> skip;

// Special characters
OPEN_BRACE: '{';
CLOSE_BRACE: '}';
SEMICOLON: ';';
COLON: ':';
PLUS: '+';
MIN: '-';
MUL: '*';
ASSIGNMENT_OPERATOR: ':=';

//--- PARSER: ---
stylesheet: variableAssignment* styleRule* EOF;

// --- Style rules ---
styleRule: selector OPEN_BRACE declaration* CLOSE_BRACE;

// --- Variable declaration and reference ---
variableAssignment: variableReference ASSIGNMENT_OPERATOR expression SEMICOLON;
variableReference: CAPITAL_IDENT;

// --- Selectors and declarations ---
selector: ID_IDENT
        | CLASS_IDENT
        | LOWER_IDENT
        ;
declaration: property COLON expression SEMICOLON;
property: LOWER_IDENT;

// --- Expressions: variable references, literals, and operations
expression:     variableReference           # variableReferenceExpression
            // --- Literal expressions ---
            |   (TRUE | FALSE)              # boolLiteral
            |   COLOR                       # colorLiteral
            |   PERCENTAGE                  # percentageLiteral
            |   PIXELSIZE                   # pixelLiteral
            |   SCALAR                      # scalarLiteral
            // --- Operations ---
            |   expression MUL expression   # multiplyOperation
            |   expression PLUS expression  # addOperation
            |   expression MIN expression   # subtractOperation
            ;

// --- Literal expressions ---
//literal:    (TRUE | FALSE)  # boolLiteral
//        |   COLOR           # pixelLiteral
//        |   PERCENTAGE      # colorLiteral
//        |   PIXELSIZE       # percentageLiteral
//        |   SCALAR          # scalarLiteral
//        ;