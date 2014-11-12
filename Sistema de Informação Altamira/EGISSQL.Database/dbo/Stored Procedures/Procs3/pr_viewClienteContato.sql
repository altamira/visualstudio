

/****** Object:  Stored Procedure dbo.pr_viewClienteContato    Script Date: 13/12/2002 15:08:45 ******/

CREATE PROCEDURE dbo.pr_viewClienteContato
/*---------------------------------------------------------------------------  
  procedure      : pr_viewClienteContato
  Autor(es)      : Paulo Noel 
  Banco de dados : EgisSql
  Objetivo       : Efetua a seleção dos contatos por empresa
  Data           : 31/01/2001
  Atualizado     :    
---------------------------------------------------------------------------  */
(
 @cd_cliente int 
 )

as

   SELECT Cliente.nm_fantasia_cliente               , 
          Cliente.cd_cliente                        , 
          Cliente_Contato.cd_contato                , 
          Cliente_Contato.nm_contato_cliente        , 
          Cliente_Contato.nm_fantasia_contato       , 
          Cliente_Contato.cd_ddd_contato_cliente    , 
          Cliente_Contato.cd_telefone_contato       , 
          Cliente_Contato.cd_fax_contato            , 
          Cliente_Contato.cd_celular                , 
          Cliente_Contato.cd_email_contato_cliente  , 
          Cliente_Contato.ds_observacao_contato     , 
          Cliente_Contato.cd_tipo_endereco          , 
          Cliente_Contato.cd_cargo                  , 
          Cliente_Contato.cd_departamento           , 
          Cliente_Contato.cd_ramal                  , 
          Cliente_Contato.cd_acesso_cliente_contato , 
          Cargo.nm_cargo, Cargo.sg_cargo            , 
          Departamento.nm_departamento
   FROM  Cliente left outer join cliente_Contato on Cliente.cd_cliente              = Cliente_Contato.cd_cliente
                 left outer join cargo           on cliente_contato.cd_cargo        = cargo.cd_cargo  
                 left outer join departamento    on cliente_contato.cd_departamento = departamento.cd_departamento
   WHERE (Cliente.cd_cliente = @cd_cliente)



