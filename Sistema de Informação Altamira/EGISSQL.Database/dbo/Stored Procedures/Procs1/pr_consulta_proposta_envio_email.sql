

CREATE PROCEDURE pr_consulta_proposta_envio_email
--pr_consulta_proposta_envio_email
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Fabio Cesar
--Banco de Dados: Egissql
--Objetivo: Consultar as Propostas Enviadas por e-mail
--Data: 20/11/2002
--Atualizado:
---------------------------------------------------

@cd_cliente int,
@cd_vendedor int,
@cd_vendedor_interno int,
@ic_status_envio varchar(100), -- '' - Todas, S-Enviadas com sucesso, N-Não Enviadas, P-Com problemas
@nm_email_destino varchar(100)
as

declare @SQL varchar(2000)

set @SQL =  'select '
	    + 'c.cd_consulta, '
	    + 'ic_status_email, '
	    + 'se.nm_from_address, '
	    + 'se.dt_servico_email, '
	    + 'se.nm_email_destino_servico, '
	    + 'se.qt_tentativa_envio, '
	    + 'c.cd_cliente, '
	    + '(Select nm_fantasia_cliente from Cliente where cd_cliente = c.cd_cliente) as nm_fantasia_cliente, '
	    + 'c.cd_contato, '
	    + '(Select nm_fantasia_contato from Cliente_Contato where cd_cliente = c.cd_cliente and cd_contato = c.cd_contato) as nm_contato_fantasia, '
	    + 'c.cd_vendedor_interno, '
	    + '(Select nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor_interno) as nm_vendedor_int, '
	    + 'c.cd_vendedor, '
	    + '(Select nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor) as nm_vendedor_ext '
	+ 'from '
	    + 'servico_email se, '
	    + 'consulta c '
        + 'where '
	    + 'se.cd_documento_email = c.cd_consulta '
	    + 'and ic_email_consulta = ''S'''

	--Verifica se deseja realizar filtragem por cliente
	if @cd_cliente > 0
   	   set @SQL = @SQL + ' and c.cd_cliente = ' + cast(@cd_cliente as varchar)

	--Verifica se deseja realizar filtragem por vendedor - Externo
	if @cd_vendedor > 0
   	   set @SQL = @SQL + ' and c.cd_vendedor = ' + cast(@cd_vendedor as varchar)

	--Verifica se deseja realizar filtragem por vendedor - Interno
	if @cd_vendedor_interno > 0
   	   set @SQL = @SQL + ' and c.cd_vendedor_interno = ' + cast(@cd_vendedor_interno as varchar)

	--Verifica se deseja realizar filtragem por status de envio
	if (@ic_status_envio != '')
	   set @SQL = @SQL + @ic_status_envio

	--Verifica se deseja realizar filtragem por e-mail destino
	if (@nm_email_destino != '')
	   set @SQL = @SQL + ' and se.nm_email_destino_servico = ' + QUOTENAME(@nm_email_destino,'''')	  

	--Executa o procedimento do SQL
	exec(@SQL)


