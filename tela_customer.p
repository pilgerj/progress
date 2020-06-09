    def var vcli_ini like customer.cust-num.
    def var vcli_fim like customer.cust-num.
    def var vped_ini like order.order-num.
    def var vped_fim like order.order-num.
    def var vite_ini like item.item-num.
    def var vite_fim like item.item-num.
    
    DEF VAR vretorno AS CHARACTER.
    DEF VAR vnaosei AS CHARACTER INITIAL "Valor de ida".
    
    form vcli_ini  colon 20 label "Cliente"
         vcli_fim  colon 50 label "Até"
         vped_ini  colon 20 label "Pedido"
         vped_fim  colon 50 label "Até"
         vite_ini  colon 20 label "Item"
         vite_fim  colon 50 label "Até"
         with frame f-parametros width 80 side-labels title " Parâmetros do Relatório " three-d.
         
    repeat: 
    
       assign vcli_ini = 0
              vcli_fim = 99999
              vped_ini = 0
              vped_fim = 99999
              vite_ini = 0
              vite_fim = 99999.
       
       update vcli_ini
              vcli_fim validate(input vcli_fim >= input vcli_ini,
                                "ERRO: Cliente inicial deve ser menor ou igual ao final")
              vped_ini
              vped_fim validate(input vped_fim >= input vped_ini,
                                "ERRO: Pedido inicial deve ser menor ou igual ao final")
              vite_ini
              vite_fim validate(input vite_fim >= input vped_ini,
                                "ERRO: Item inicial deve ser menor ou igual ao final")
              with frame f-parametros.
                      
              
     
    run d:\curso\fontes\relatorio_customer_v5.p (input vcli_ini,
                                                 input vcli_fim,
                                                 input vped_ini,
                                                 input vped_fim,
                                                 input vite_ini,
                                                 input vite_fim,
                                                 OUTPUT vretorno,
                                                 INPUT-OUTPUT vnaosei). 
                                                 
    IF vretorno = "OK" THEN
        MESSAGE "Relatório Gerado com sucesso"
        VIEW-AS ALERT-BOX INFORMATION.
    ELSE
        MESSAGE "Erro ao gerar."
        VIEW-AS ALERT-BOX INFORMATION.
        
        
    MESSAGE "Parametro de retorno de programa" SKIP(1)
            vnaosei
            VIEW-AS ALERT-BOX.
            
    END.
    
    
