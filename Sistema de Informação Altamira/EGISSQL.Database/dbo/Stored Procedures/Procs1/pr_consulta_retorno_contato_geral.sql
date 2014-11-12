
CREATE PROCEDURE pr_consulta_retorno_contato_geral
@cd_operador integer
AS


  Select * 
  from (
        Select 
          cd_operador_telemarketing,
          dt_previsto_retorno as dt_historico_lancamento,
	  ds_registro_contato as ds_historico_lancamento,
          (case when cd_tipo_contato = 1 then
  	    (Select top 1 nm_vendedor from vendedor where cd_vendedor = chist.cd_vendedor) 
           when cd_tipo_contato = 2 then
            (Select top 1 nm_comprador from comprador where cd_comprador = chist.cd_comprador)
           else  '' end ) as nm_tipo_compr,

          (case when cd_tipo_contato = 1 then
            (Select top 1 nm_fantasia_cliente from Cliente where cd_cliente = chist.cd_cliente) 
           when cd_tipo_contato = 2 then
            (Select top 1 nm_fantasia_fornecedor from Fornecedor where cd_fornecedor = chist.cd_fornecedor)
           else
            (Select top 1 nm_agencia_banco from agencia_banco where cd_agencia_banco = chist.cd_agencia_banco) end ) as nm_fantasia,

          (case when cd_tipo_contato = 1 then
            (Select top 1 nm_cliente_assunto from Cliente_assunto where cd_cliente_assunto = chist.cd_assunto_contato) 
           when cd_tipo_contato = 2 then
            (Select top 1 nm_fornecedor_assunto from Fornecedor_assunto where cd_fornecedor_assunto = chist.cd_assunto_contato) 
           else
            (Select top 1 nm_banco_assunto from Banco_assunto where cd_banco_assunto = chist.cd_assunto_contato) end ) as nm_assunto,                

	  (case when cd_tipo_contato = 1 then
            (Select top 1 nm_fantasia_contato from Cliente_Contato where cd_cliente = chist.cd_cliente and cd_contato = chist.cd_contato_cliente) 
           when cd_tipo_contato = 2 then
  	    (Select top 1 nm_fantasia_contato_forne from Fornecedor_Contato where cd_fornecedor = chist.cd_fornecedor and cd_contato_fornecedor = chist.cd_contato_fornecedor)
           else
            (case when IsNull((select ab.nm_contato_agencia_banco from Agencia_Banco ab where ab.cd_agencia_banco = chist.cd_agencia_banco),'') = '' then
    	      (Select top 1 nm_fantasia_contato from Agencia_Banco_Contato where cd_agencia_banco = chist.cd_agencia_banco and cd_contato_agencia = chist.cd_contato_agencia)
             else (select ab.nm_contato_agencia_banco from Agencia_Banco ab where ab.cd_agencia_banco = chist.cd_agencia_banco) end )
           end ) as nm_fantasia_contato
--          (Select top 1 nm_cliente_fase from Cliente_Fase where cd_cliente_fase = chist.cd_cliente_fase) as nm_fase_contato
        from 
           registro_contato chist 
        where 
          dt_real_retorno is null) as vw_Consulta_Retorno
  where cd_operador_telemarketing = ( case when @cd_operador = 0 then IsNull(cd_operador_telemarketing,0)
                                      else @cd_operador end ) 
  order by dt_historico_lancamento desc




