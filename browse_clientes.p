    DEF VAR v-cli_ini       LIKE cliente.cli_codigo.
    DEF VAR v-cli_fin       LIKE cliente.cli_codigo INITIAL 99999.
    DEF QUERY q-browse      FOR  cliente.
    DEF BROWSE b-browse QUERY q-browse
        display Cliente.cli_codigo 
                Cliente.cli_nome  format "x(20)"
                Cliente.cli_cpf 
                Cliente.cli_nascimento 
                Cliente.cli_email
                with SEPARATORS TITLE " Clientes Cadastrados " WIDTH 80 20 DOWN.       
    FORM b-browse
         WITH FRAME f-browse     WIDTH 80 NO-BOX OVERLAY ROW 2.   

    REPEAT WITH FRAME f-consulta WIDTH 80 SIDE-LABEL 1 DOWN ROW 4 TITLE " Parametros ": 
        UPDATE v-cli_ini v-cli_fin WITH FRAME f-parametros SIDE-LABELS WIDTH 80.
        RUN pro-open-query.
    END.                                               /* repeat */
    PROCEDURE pro-open-query.
       OPEN QUERY q-browse
           FOR EACH cliente WHERE
                    cliente.cli_codigo >= v-cli_ini AND
                    cliente.cli_codigo <= v-cli_fin
                 BY cliente.cli_codigo.
       ENABLE b-browse WITH FRAME f-browse.
       WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.      
    END.
