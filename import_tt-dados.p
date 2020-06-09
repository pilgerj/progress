DEF TEMP-TABLE tt-dados
    FIELD tt-codigo AS CHAR
    FIELD tt-empresa AS CHAR
    FIELD tt-email AS CHAR FORMAT "x(40)"
    .
    
EMPTY TEMP-TABLE tt-dados.

IF SEARCH ("c:\curso\email.csv") = ? THEN
    DO:
        MESSAGE "Arquivo nao existe" VIEW-AS ALERT-BOX ERROR.
        UNDO.
    END.

INPUT FROM "c:\curso\email.csv" NO-ECHO. //quebra de linha quando enter
    REPEAT WHILE TRUE:
        CREATE tt-dados.
        IMPORT DELIMITER ";" tt-dados.
    END.
INPUT CLOSE.

FOR EACH tt-dados:
    DISPLAY tt-codigo
            tt-empresa
            tt-email.
END.
