    def input parameter vcli_ini like customer.cust-num.
    def input parameter vcli_fim like customer.cust-num.
    def input parameter vped_ini like order.order-num.
    def input parameter vped_fim like order.order-num.
    def input parameter vite_ini like item.item-num.
    def input parameter vite_fim like item.item-num.
    
    DEFINE OUTPUT  PARAMETER vretorno AS CHARACTER.   
    DEF INPUT-OUTPUT PARAMETER vnaosei  AS CHARACTER.
    
    MESSAGE "Parametro de chegada" SKIP(1)
            vnaosei
            VIEW-AS ALERT-BOX.
    
    ASSIGN vretorno = "ERRO Indefinido"
           vnaosei  = "Alterado !".
           
    def temp-table tt-dados
        field tt-cliente like customer.cust-num
        field tt-nome    like customer.name
        field tt-pedido  like order.order-num
        field tt-data    like order.order-date
        field tt-item    like item.item-num
        field tt-desc    like item.item-name
        field tt-quant   like order-line.qty
        field tt-preco   like order-line.price
        field tt-total   as   decimal format "zzz,zzz,zz9.99".
    
    form tt-pedido column-label "Pedido"
         tt-data   column-label "Data"
         tt-item   column-label "Item"
         tt-desc   column-label "Descricao"
         tt-quant  column-label "Quant"
         tt-preco  column-label "Preco"
         tt-total  column-label "Total"
         with frame f-relatorio stream-io width 132 down.
    
    empty temp-table tt-dados.
    
    for each customer            where
             customer.cust-num   >= vcli_ini and
             customer.cust-num   <= vcli_fim
             no-lock,
        each order of customer   where
             order.order-num     >= vped_ini and
             order.order-num     <= vped_fim
             no-lock,
        each order-line of order where 
             order-line.item-num >= vite_ini and
             order-line.item-num <= vite_fim
             no-lock,
        each item of order-line 
             no-lock:
    
        create tt-dados.
        assign tt-cliente = customer.cust-num
               tt-nome    = customer.name
               tt-pedido  = order.order-num
               tt-data    = order.order-date
               tt-item    = item.item-num
               tt-desc    = item.item-name
               tt-quant   = order-line.qty
               tt-preco   = order-line.price
               tt-total   = (order-line.qty
                          *  order-line.price).
    end.        

    output to d:\curso\relatorios\clientes.csv.
    
    for each tt-dados
       break by tt-cliente
             by tt-pedido:
        
        accumulate tt-quant (total by tt-pedido)
                   tt-total (total by tt-pedido)
                   tt-quant (total by tt-cliente)
                   tt-total (total by tt-cliente).
                   
        if first-of(tt-cliente) then
           put "Cliente: " 
               tt-cliente
               " - "
               tt-nome
               skip(1)
               "Pedido;Data;Item;Descricao;Quantidade;Preco;Total"
               SKIP.

        if first-of(tt-pedido) then
           PUT tt-pedido ";"
               tt-data   ";"
               tt-item   ";"
               tt-desc   ";"
               tt-quant  ";"
               tt-preco  ";"
               tt-total  ";"
               SKIP
        .
        ELSE 
                   
        display tt-item
                tt-desc
                tt-quant
                tt-preco
                tt-total
                with frame f-relatorio
        .
                
        down with frame f-relatorio.
        
        if last-of(tt-pedido) THEN
              PUT ";;Total Pedido" ";"
                  accum total  by tt-pedido tt-quant  ";"
                  (accum total by tt-pedido tt-total) /                                        
                  (accum total by tt-pedido tt-quant) ";"
                  accum total  by tt-pedido tt-total  ";"
                  SKIP(2)
              .
           
           
        if last-of(tt-cliente) then
           PUT ";;Total Cliente" ";"                  
                accum total  by tt-cliente tt-quant  ";"
                (accum total by tt-cliente tt-total) /                                        
                (accum total by tt-cliente tt-quant) ";"
                accum total  by tt-cliente tt-total  ";"
            .
           
           
        if last(tt-cliente) then
           PUT ";;Total Geral"           ";"
                  accum total  tt-quant  ";"
                  (accum total tt-total) /                                        
                  (accum total tt-quant) ";"
                  accum total  tt-total  FORMAT "zz,zzz,zz9.99" ";"
            .
    end.
    
    output close.
    
    ASSIGN vretorno = "OK".    
