     DEF VAR v-cli_codigo      like cliente.cli_codigo.
     DEF VAR v-cli_nome        like cliente.cli_nome.
     DEF VAR v-cli_nascimento  like cliente.cli_nascimento.
     DEF VAR v-cli_celular     like cliente.cli_celular.
     DEF VAR v-cep_codigo      like cliente.cep_codigo.
     DEF VAR v-cli_complemento like cliente.cli_complemento.
     DEF VAR v-cli_cpf         like cliente.cli_cpf.
     def var v-cli_email       like cliente.cli_email.
     def var v-cli_sexo        like cliente.cli_sexo.
     
     def buffer b-cliente for cliente.
     
     form v-cli_codigo      colon 15   
          v-cli_nome     no-label      
          v-cli_nascimento  colon 15
          v-cli_celular     colon 15
          v-cep_codigo      colon 15  
          v-cli_complemento colon 15
          v-cli_cpf         colon 15
          v-cli_email       colon 15
          v-cli_sexo        colon 15
          with frame f-cliente width 80 side-labels title " Alteração de Clientes " three-d.
    
     repeat:
     
        assign v-cli_codigo       = 0
               v-cli_nome         = ""
               v-cli_nascimento   = ?
               v-cli_celular      = ""
               v-cep_codigo       = ""
               v-cli_complemento  = ""
               v-cli_cpf          = ""
               v-cli_email        = ""
               v-cli_sexo         = ?.
               
        clear frame f-cliente all.       
     
        update v-cli_codigo with frame f-cliente.
        
        find cliente where
             cliente.cli_codigo = v-cli_codigo
             exclusive-lock no-error.
             
        if not avail cliente then
           do:
              message "Cliente informado não cadastrado"
                      view-as alert-box.
              undo.
           end.
     
        assign v-cli_nome        = cliente.cli_nome       
               v-cli_nascimento  = cliente.cli_nascimento 
               v-cli_celular     = cliente.cli_celular    
               v-cep_codigo      = cliente.cep_codigo     
               v-cli_complemento = cliente.cli_complemento
               v-cli_cpf         = cliente.cli_cpf        
               v-cli_email       = cliente.cli_email      
               v-cli_sexo        = cliente.cli_sexo.       
        
        display v-cli_nome       
                v-cli_nascimento 
                v-cli_celular    
                v-cep_codigo     
                v-cli_complemento
                v-cli_cpf        
                v-cli_email      
                v-cli_sexo       
                with frame f-cliente.
    
        update v-cli_nome with frame f-cliente.
         
        if length(v-cli_nome) < 7 then
           do:
              message "Nome do Cliente muito curto"
                      view-as alert-box error.
              undo.
           end.
           
        update v-cli_nascimento with frame f-cliente.    
       
        if v-cli_nascimento > 01/01/2015 then
           do:
               message "Data de Nascimento inválida"
                       view-as alert-box error.
               undo.
           end.
          
        update v-cli_celular with frame f-cliente. 
        
        update v-cep_codigo  with frame f-cliente.
        
        find cep where
             cep.cep_codigo = v-cep_codigo
             no-lock no-error.
             
        if not avail cep then
           do:
               message "CEP não Cadastrado"
                       view-as alert-box error.
               undo.
           end.
        
        update v-cli_complemento with frame f-cliente.
        
        if v-cli_complemento = "" then
           do:
               message "Complemento não pode ser branco"
                       view-as alert-box error.
               undo.
           end.
           
        update v-cli_cpf    with frame f-cliente.
        
        find b-cliente where 
             b-cliente.cli_cpf     = v-cli_cpf and
             b-cliente.cli_codigo <> v-cli_codigo
             no-lock no-error.
             
        if avail b-cliente then
           do:
               message "Cliente já cadastrado com este CPF"
                       view-as alert-box error.
               undo.
           end.
        
        update v-cli_email  with frame f-cliente.
        
        if not v-cli_email matches "*@*" then
           do:
               message "Endereço de email inválido"
                       view-as alert-box error.
               undo.
           end.
           
        update v-cli_sexo   with frame f-cliente.
        
        assign cliente.cli_nome        = v-cli_nome
               cliente.cli_nascimento  = v-cli_nascimento
               cliente.cli_celular     = v-cli_celular
               cliente.cep_codigo      = v-cep_codigo
               cliente.cli_complemento = v-cli_complemento
               cliente.cli_cpf         = v-cli_cpf
               cliente.cli_email       = v-cli_email
               cliente.cli_sexo        = v-cli_sexo.
         pause.
     end.
     








