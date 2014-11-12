CREATE PROCEDURE pr_consulta_analise_contato_cliente
@dt_analise_inicial datetime,
@dt_analise_final datetime,
@nm_fantasia_cliente varchar(15),
@cd_vendedor int
AS

Declare @sSQL    varchar(2000),
        @sSQLAux varchar(2000)

set @sSQL = 'Select * from (
                Select 
                cd_cliente,
                (Select top 1 nm_fantasia_cliente from Cliente where cd_cliente = chist.cd_cliente) as nm_fantasia_cliente,
                dt_historico_retorno,
                dt_historico_lancamento,
                nm_assunto,                
                cd_sequencia_historico,                
                (Select top 1 nm_fantasia_contato from Cliente_Contato where cd_cliente = chist.cd_cliente and cd_contato = chist.cd_contato) as nm_fantasia_contato,
                (Select top 1 nm_cliente_fase from Cliente_Fase where cd_cliente_fase = chist.cd_cliente_fase) as nm_cliente_fase,
                (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = chist.cd_vendedor) as nm_fantasia_vendedor,
								(Select top 1 cd_vendedor from Vendedor where cd_vendedor = chist.cd_vendedor)  as cd_vendedor
            from 
                cliente_historico chist
            where dt_historico_lancamento between ' + QuoteName(cast(@dt_analise_inicial as varchar),'''') +
            + 'and '  + QuoteName(cast(@dt_analise_final as varchar),'''') + ') as vw_Consulta_Retorno_Cliente'

    set @sSQLAux = ''

    if @nm_fantasia_cliente != ''
       set @sSQLAux = ' where nm_fantasia_cliente like ' + QuoteName(@nm_fantasia_cliente + '%','''')

    if @cd_vendedor > 0
    begin
        if @sSQLAux != ''
           set @sSQLAux = @sSQLAux + ' and '
        else
           set @sSQLAux = @sSQLAux + ' where '
        set @sSQLAux = @sSQLAux + 'cd_vendedor = ' + cast(@cd_vendedor as varchar)
    end
    
    exec (@sSQL  + @sSQLAux)
print (@sSQL  + @sSQLAux)


