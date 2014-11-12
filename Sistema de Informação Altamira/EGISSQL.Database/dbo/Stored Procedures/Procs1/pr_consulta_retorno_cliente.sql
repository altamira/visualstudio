
CREATE PROCEDURE pr_consulta_retorno_cliente
@dt_analise_inicial datetime,
@dt_analise_final datetime,
@nm_fantasia_cliente varchar(15)
AS

  Declare @sSQL varchar(2000)

  set @sSQL = 'Select * from (
                Select 
                cd_cliente,
                cd_sequencia_historico,
                dt_historico_lancamento,
		ds_historico_lancamento,
		(Select top 1 nm_vendedor from vendedor where cd_vendedor = chist.cd_vendedor) as nm_vendedor,
                (Select top 1 nm_fantasia_cliente from Cliente where cd_cliente = chist.cd_cliente) as nm_fantasia_cliente,
                dt_historico_retorno,
                nm_assunto,                
                (Select top 1 nm_fantasia_contato from Cliente_Contato where cd_cliente = chist.cd_cliente and cd_contato = chist.cd_contato) as nm_fantasia_contato,
                (Select top 1 nm_cliente_fase from Cliente_Fase where cd_cliente_fase = chist.cd_cliente_fase) as nm_cliente_fase
            from 
                cliente_historico chist
            where dt_historico_retorno between ' + QuoteName(cast(@dt_analise_inicial as varchar),'''') +
            + 'and '  + QuoteName(cast(@dt_analise_final as varchar),'''') + ') as vw_Consulta_Retorno_Cliente'

    if @nm_fantasia_cliente != ''
       set @sSQL = @sSQL + ' where nm_fantasia_cliente like ' + QuoteName(@nm_fantasia_cliente + '%','''')

    exec (@sSQL)
