create view dbo.vw_retorna_cliente
/*---------------------------------------------------------------------------  
  view           : vw_retorna_cliente
  Autor(es)      : Paulo Noel 
  Banco de dados : EgisSql
  Objetivo       : Retornar os dados referente ao cadastro do cliente
  Data           : 23/01/2001
  Atualizado     :    
---------------------------------------------------------------------------  */
as
   select cliente.cd_cliente                   ,  cliente.nm_fantasia_cliente          ,
          cliente.nm_razao_social_cliente      ,  cliente.nm_razao_social_cliente_c    ,
          cliente.nm_dominio_cliente           ,  cliente.nm_email_cliente             ,
          cliente.ic_destinacao_cliente	       ,  cliente.cd_reparticao_origem         ,  
          cliente.pc_desconto_cliente          ,  cliente.dt_cadastro_cliente	       ,   
          cliente.ds_cliente                   ,  cliente.cd_conceito_cliente          ,  
          cliente_conceito.nm_conceito_cliente ,  cliente.cd_tipo_pessoa               ,  
          tipo_pessoa.nm_tipo_pessoa           ,  cliente.cd_ramo_atividade            ,  
          ramo_atividade.nm_ramo_atividade     ,  cliente.cd_status_cliente            ,   
          status_cliente.nm_status_cliente     ,  status_cliente.sg_status_cliente     ,  
          cliente.cd_transportadora            ,  transportadora.nm_transportadora     ,  
          cliente.cd_tipo_comunicacao          ,  tipo_comunicacao.nm_tipo_comunicacao ,
          cliente.cd_cliente_filial            ,  cliente.cd_identifica_cep            ,  
          cep.cd_cep                           ,  cliente.cd_cnpj_cliente              ,  
          cliente.cd_inscMunicipal             ,  cliente.nm_endereco_cliente          ,  
          cliente.cd_numero_endereco           ,  cliente.nm_complemento_endereco      , 
          cliente.nm_bairro		       ,  cidade.nm_cidade 	               ,  
          estado.sg_estado                     ,  pais.nm_pais                         ,  
          cliente.cd_ddd                       ,  cliente.cd_telefone                  ,  
          cliente.cd_fax                       ,  cliente.cd_usuario                   ,  
          cliente.dt_usuario
   from   cliente left outer join cep on cep.cd_identifica_cep = cliente.cd_identifica_cep 
                                  left outer join tipo_pessoa      on tipo_pessoa.cd_tipo_pessoa           =  cliente.cd_tipo_pessoa 
                                  left outer join ramo_atividade   on ramo_atividade.cd_ramo_atividade     =  cliente.cd_ramo_atividade
                                  left outer join transportadora   on transportadora.cd_transportadora     =  cliente.cd_transportadora
                                  left outer join tipo_comunicacao on tipo_comunicacao.cd_tipo_comunicacao =  cliente.cd_tipo_comunicacao
                                  left outer join status_cliente   on status_cliente.cd_status_cliente     =  cliente.cd_status_cliente
                                  left outer join cliente_conceito on cliente_conceito.cd_conceito_cliente =  cliente.cd_conceito_cliente  
                                  left outer join pais             on pais.cd_pais     = cliente.cd_pais 
                                  left outer join estado           on estado.cd_pais   = cliente.cd_pais   and 
                                                                      estado.cd_estado = cliente.cd_estado 
                                  left outer join cidade           on cidade.cd_pais   = cliente.cd_pais   and 
                                                                      cidade.cd_estado = cliente.cd_estado and 
                                                                      cidade.cd_cidade = cliente.cd_cidade
                                                         
