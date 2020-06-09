     DEF VAR v-cli_codigo      like cliente.cli_codigo.
     DEF VAR v-cli_nome        like cliente.cli_nome.
     DEF VAR v-cli_nascimento  like cliente.cli_nascimento.
     DEF VAR v-cli_celular     like cliente.cli_celular.
     DEF VAR v-cep_codigo      like cliente.cep_codigo.
     DEF VAR v-cli_complemento like cliente.cli_complemento.
     DEF VAR v-cli_cpf         like cliente.cli_cpf.
     def var v-cli_email       like cliente.cli_email.
     def var v-cli_sexo        like cliente.cli_sexo.
     def var v-resposta        as   logical format "Sim/N�o". 
     
     form v-cli_codigo      colon 15   
          v-cli_nome     no-label      
          v-cli_nascimento  colon 15
          v-cli_celular     colon 15
          v-cep_codigo      colon 15  
          v-cli_complemento colon 15
          v-cli_cpf         colon 15
          v-cli_email       colon 15
          v-cli_sexo        colon 15
          with frame f-cliente width 80 side-labels title " Exclus�o de Clientes " three-d.
    
     repeat:
     
        assign v-cli_codigo       = 0
               v-cli_nome         = ""
               v-cli_nascimento   = ?
               v-cli_celular      = ""
               v-cep_codigo       = ""
               v-cli_complemento  = ""
               v-cli_cpf          = ""
               v-cli_email        = ""
               v-cli_sexo         = ?
               v-resposta         = no.
               
        clear frame f-cliente all.       
     
        update v-cli_codigo with frame f-cliente.
        
        find cliente where
             cliente.cli_codigo = v-cli_codigo
             exclusive-lock no-error.
             
        if not avail cliente then
           do:
              message "Cliente informado n�o cadastrado"
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
    
         update v-resposta label "Deseja excluir o registro (Sim/N�o) ? "
                with frame f-resposta row 21 no-box side-labels three-d.
                
         if v-resposta = yes then
            do:
               /* Verifica se n�o tem dados de movimento */
               delete cliente.
            end.
     end.
     








