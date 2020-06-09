def input parameter vcli_ini like customer.cust-num.
    def input parameter vcli_fim like customer.cust-num.
    def input parameter vped_ini like order.order-num.
    def input parameter vped_fim like order.order-num.
    def input parameter vite_ini like item.item-num.
    def input parameter vite_fim like item.item-num.
    def var vtotal as decimal format "zzz,zzz,zz9.99".
    def var vqtd_ped as integer.
    def var vtot_ped as decimal.
    def var vmed_ped as decimal.
    def var vqtd_cli as integer.
    def var vtot_cli as decimal.
    def var vmed_cli as decimal.
    def var vqtd_tot as integer.
    def var vmed_tot as decimal.
    def var vtot_tot as decimal.
    
    form order.order-num     column-label "Pedido"
         order.order-date    column-label "Data"
         order-line.item-num column-label "Item"
         item.item-name      column-label "Descricao"
         order-line.qty      column-label "Quant"
         order-line.price    column-label "Preco"
         vtotal              column-label "Total"
         with frame f-relatorio stream-io width 132 down.
         
    output to c:\curso\relatorios\cliente.txt.
    
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
             
        assign vtotal   = order-line.qty * order-line.price
               vqtd_ped = vqtd_ped       + order-line.qty
               vtot_ped = vtot_ped       + vtotal
               vqtd_cli = vqtd_cli       + order-line.qty
               vtot_cli = vtot_cli       + vtotal
               vqtd_tot = vqtd_tot       + order-line.qty
               vtot_tot = vtot_tot       + vtotal.
        
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
              
              assign vmed_ped = vtot_ped / vqtd_ped.
              
              display "Total Pedido"    @ item.item-name
                      vqtd_ped          @ order-line.qty
                      vmed_ped          @ order-line.price
                      vtot_ped          @ vtotal
                      with frame f-relatorio.
                      
              down 2 with frame f-relatorio.
              
              assign vqtd_ped = 0
                     vmed_ped = 0
                     vtot_ped = 0.
           end.
           
        if last-of(customer.cust-num) then
           do:
              display "---------------" @ item.item-name 
                      "------"          @ order-line.qty
                      "-------------"   @ order-line.price
                      "--------------"  @ vtotal
                      with frame f-relatorio.
                
              down with frame f-relatorio.
              
              assign vmed_cli = vtot_cli / vqtd_cli.
              
              display "Total Cliente"    @ item.item-name
                      vqtd_cli          @ order-line.qty
                      vmed_cli          @ order-line.price
                      vtot_cli          @ vtotal
                      with frame f-relatorio.
                      
              down 2 with frame f-relatorio.
              
              assign vqtd_cli = 0
                     vmed_cli = 0
                     vtot_cli = 0.
           end.
           
        if last(customer.cust-num) then
           do:
              display "---------------" @ item.item-name 
                      "------"          @ order-line.qty
                      "-------------"   @ order-line.price
                      "--------------"  @ vtotal
                      with frame f-relatorio.
                
              down with frame f-relatorio.
              
              assign vmed_tot = vtot_tot / vqtd_tot.
              
              display "Total Geral"     @ item.item-name
                      vqtd_tot          @ order-line.qty
                      vmed_tot          @ order-line.price
                      vtot_tot          @ vtotal
                      with frame f-relatorio.
           end.           
    end.
    
    output close.
