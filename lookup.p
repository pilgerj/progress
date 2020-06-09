DEFINE VARIABLE estados AS CHARACTER INITIAL "RS,SC,PR,SP,RJ".
DEFINE VARIABLE UF      AS CHARACTER FORMAT "!(2)". //exigira 2 caracteres apenas e botara em maiusculo

REPEAT:

    UPDATE uf  HELP "Informe UF de um estado brasileiro".
    
    IF LOOKUP(uf,estados) = 0 THEN
        MESSAGE "Estado nao ta na lista"
            VIEW-AS ALERT-BOX ERROR.
    ELSE 
        MESSAGE "estado informado esta na posicao "
        LOOKUP(uf, estados)
        " da lista."
        VIEW-AS ALERT-BOX INFORMATION.
    

END.
