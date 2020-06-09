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
          with frame f-cliente width 80 side-labels title " Inclusão de Clientes " three-d.
    
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
     
        update v-cli_nome        validate(length(input v-cli_nome) >= 7,
                                "ERRO: Nome do Cliente muito curto")
               v-cli_nascimento  validate(input v-cli_nascimento <= 01/01/2015,
                                "ERRO: Data de Nascimento inválida")
               v-cli_celular
               v-cep_codigo      validate(can-find (first cep where
                                                          cep.cep_codigo = input v-cep_codigo),
                                "ERRO: CEP não Cadastrado") 
               v-cli_complemento validate(v-cli_complemento <> "",
                                "ERRO: Complemento não pode ser branco")
               v-cli_cpf         validate(can-find (first b-cliente where
                                                          b-cliente.cli_cpf <> input v-cli_cpf),
                                "ERRO: Cliente já cadastrado com este CPF") 
               v-cli_email      validate (input v-cli_email matches "*@*",
                                "ERRO: Endereço de email inválido")
               v-cli_sexo                 
               with frame f-cliente.
        
        create cliente.
        assign cliente.cli_codigo      = next-value(cli_codigo)
               cliente.cli_nome        = v-cli_nome
               cliente.cli_nascimento  = v-cli_nascimento
               cliente.cli_celular     = v-cli_celular
               cliente.cep_codigo      = v-cep_codigo
               cliente.cli_complemento = v-cli_complemento
               cliente.cli_cpf         = v-cli_cpf
               cliente.cli_email       = v-cli_email
               cliente.cli_sexo        = v-cli_sexo.
               
        display  cliente.cli_codigo @ v-cli_codigo with frame f-cliente.
        pause.
     end.
     








