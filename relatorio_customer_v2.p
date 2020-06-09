    def input parameter vcli_ini like customer.cust-num.
    def input parameter vcli_fim like customer.cust-num.
    def input parameter vped_ini like order.order-num.
    def input parameter vped_fim like order.order-num.
    def input parameter vite_ini like item.item-num.
    def input parameter vite_fim like item.item-num.
    def var vtotal as decimal format "zzz,zzz,zz9.99".
    
   form order.order-num     column-label "Pedido"
         order.order-date    column-label "Data"
         order-line.item-num column-label "Item"
         item.item-name      column-label "Descricao"
         order-line.qty      column-label "Quant"
         order-line.price    column-label "Preco"
         vtotal              column-label "Total"
         with frame f-relatorio stream-io width 132 down.
         
    output to c:\curso\cliente.txt.
    
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
             no-lock
       break by customer.cust-num
             by order.order-num:
   
        ASSIGN vtotal = order-line.qty * order-line.price.
         
        ACCUMULATE order-line.qty  (TOTAL   BY order.order-num) 
                   order-line.price(AVERAGE BY order.order-num)
                   vtotal          (TOTAL   BY order.order-num)
                   
                   order-line.qty  (TOTAL   BY customer.cust-num) 
                   order-line.price(AVERAGE BY customer.cust-num)
                   vtotal          (TOTAL   BY customer.cust-num)
                   .                   

        if first-of(customer.cust-num) then
           put "Cliente: " 
               customer.cust-num
               " - "
               customer.name
               skip(1).

        if first-of(order.order-num) then
           display order.order-num
                   order.order-date
                   with frame f-relatorio.
                   
        display order-line.item-num
                item.item-name
                order-line.qty
                order-line.price
                vtotal
                with frame f-relatorio.
                
        down with frame f-relatorio.
        
        if last-of(order.order-num) then
           do:
              display "---------------" @ item.item-name 
                      "------"          @ order-line.qty
                      "-------------"   @ order-line.price
                      "--------------"  @ vtotal
                      with frame f-relatorio.
                
              down with frame f-relatorio.
              
              display "Total Pedido"    @ item.item-name
                      ACCUM TOTAL   BY order.order-num order-line.qty 
                                        @ order-line.qty
                      ACCUM AVERAGE BY order.order-num order-line.price          
                                        @ order-line.price
                      ACCUM TOTAL BY order.order-num vtotal
                                        @ vtotal
                      with frame f-relatorio.
                      
              down 2 with frame f-relatorio.

           end.
           
        if last-of(customer.cust-num) then
           do:
              display "---------------" @ item.item-name 
                      "------"          @ order-line.qty
                      "-------------"   @ order-line.price
                      "--------------"  @ vtotal
                      with frame f-relatorio.
                
              down with frame f-relatorio.
              
              
              
              display "Total Cliente"   @ item.item-name
                      ACCUM TOTAL BY customer.cust-num  order-line.qty 
                                        @ order-line.qty
                      ACCUM AVERAGE BY customer.cust-num order-line.price
                                        @ order-line.price
                      ACCUM TOTAL BY customer.cust-num vtotal
                                        @ vtotal
                      with frame f-relatorio.
                      
              down 2 with frame f-relatorio.

           end.
           
        if last(customer.cust-num) then
           do:
              display "---------------" @ item.item-name 
                      "------"          @ order-line.qty
                      "-------------"   @ order-line.price
                      "--------------"  @ vtotal
                      with frame f-relatorio.
                
              down with frame f-relatorio.
              
              display "Total Geral"                  @ item.item-name
                      ACCUM TOTAL order-line.qty     @ order-line.qty
                      ACCUM AVERAGE order-line.price @ order-line.price
                      ACCUM TOTAL vtotal             @ vtotal
                      with frame f-relatorio.
           end.           
    end.
    
    output close.
