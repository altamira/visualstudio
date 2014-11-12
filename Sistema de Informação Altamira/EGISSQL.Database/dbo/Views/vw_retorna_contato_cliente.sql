create view dbo.vw_retorna_contato_cliente
/*---------------------------------------------------------------------------  
  view           : vw_retorna_contato_cliente
  Autor(es)      : Paulo Noel 
  Banco de dados : EgisSql
  Objetivo       : Retornar os dados referente ao contato do cliente 
  Data           : 25/01/2001
  Atualizado     :    
---------------------------------------------------------------------------  */
as
   select cliente_contato.cd_cliente                 , 
          cliente.nm_fantasia_cliente                ,
          cliente_contato.cd_contato                 ,
          cliente_contato.nm_contato_cliente         ,
          cliente_contato.nm_fantasia_contato        ,
          cliente_contato.cd_ddd_contato_cliente     ,
          cliente_contato.cd_telefone_contato        ,
          cliente_contato.cd_fax_contato             ,
          cliente_contato.cd_celular                 ,
          cliente_contato.cd_ramal                   ,
          cliente_contato.cd_email_contato_cliente   ,
          cliente_contato.ds_observacao_contato      ,
          cliente_contato.cd_cargo                   , 
          cargo.nm_cargo                             ,      
          cliente_contato.cd_departamento            ,
          departamento.nm_departamento
   from   cliente_contato left outer join departamento on departamento.cd_departamento = cliente_contato.cd_departamento
                          left outer join cargo        on cargo.cd_cargo               = cliente_contato.cd_cargo       , 
          cliente
   where  cliente_contato.cd_cliente = cliente.cd_cliente
