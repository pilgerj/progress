def input parameter vcli_ini like customer.cust-num.
    def input parameter vcli_fim like customer.cust-num.
    def input parameter vped_ini like order.order-num.
    def input parameter vped_fim like order.order-num.
    def input parameter vite_ini like item.item-num.
    def input parameter vite_fim like item.item-num.
        
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

    output to c:\curso\relatorios\cliente.txt.
    
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
               skip(1).

        if first-of(tt-pedido) then
           display tt-pedido
                   tt-data
                   with frame f-relatorio.
                   
        display tt-item
                tt-desc
                tt-quant
                tt-preco
                tt-total
                with frame f-relatorio.
                
        down with frame f-relatorio.
        
        if last-of(tt-pedido) then
           do:
              display "---------------" @ tt-desc 
                      "------"          @ tt-quant
                      "-------------"   @ tt-preco
                      "--------------"  @ tt-total
                      with frame f-relatorio.
                
              down with frame f-relatorio.
              
              display "Total Pedido"                  @ tt-desc
                  accum total  by tt-pedido tt-quant  @ tt-quant
                  (accum total by tt-pedido tt-total) /                                        
                  (accum total by tt-pedido tt-quant) @ tt-preco
                  accum total  by tt-pedido tt-total  @ tt-total
                      with frame f-relatorio.
                      
              down 2 with frame f-relatorio.
           end.
           
        if last-of(tt-cliente) then
           do:
              display "---------------" @ tt-desc 
                      "------"          @ tt-quant
                      "-------------"   @ tt-preco
                      "--------------"  @ tt-total
                      with frame f-relatorio.
                
              down with frame f-relatorio.

              display "Total Cliente"                  @ tt-desc
                  accum total  by tt-cliente tt-quant  @ tt-quant
                  (accum total by tt-cliente tt-total) /                                        
                  (accum total by tt-cliente tt-quant) @ tt-preco
                  accum total  by tt-cliente tt-total  @ tt-total
                      with frame f-relatorio.
                      
              down 2 with frame f-relatorio.
           end.
           
        if last(tt-cliente) then
           do:
              display "---------------" @ tt-desc 
                      "------"          @ tt-quant
                      "-------------"   @ tt-preco
                      "--------------"  @ tt-total
                      with frame f-relatorio.
                
              down with frame f-relatorio.

              display "Total Geral"      @ tt-desc
                  accum total  tt-quant  @ tt-quant
                  (accum total tt-total) /                                        
                  (accum total tt-quant) @ tt-preco
                  accum total  tt-total  @ tt-total
                      with frame f-relatorio.
           end.           
    end.
    
    output close.
