
CREATE PROCEDURE pr_resumo_receber_aberto_portador
@cd_portador int,
@dt_inicial  datetime,
@dt_final    datetime

AS

--pr_resumo_receber_aberto_portador
---------------------------------------------------
--Polimold Industrial S/A                      2001
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Johnny/Daniel
--Banco de Dados: SapSql
--Objetivo: Consulta Resumo de Documentos a Receber
--	    Pagos
--Data: 14/12/2001
--Atualizado: 18/12/2001 - Acerto do Valor Percentual - Elias
--            13/03/2002 - Modificação do campo vl_saldo_documento
--            de flot p/ decimal - Daniel C. Neto
--            02/04/2002 - Migração p/ EGISSQL - Elias
--            14.02.2003 - Revisão - Carlos
---------------------------------------------------

  declare @vl_total numeric(25,2)

  set @vl_total = 0.00

  -- tabela temporária c/ os valores diários
  select
    dt_vencimento_documento 	as 'Data',
    count(cd_documento_receber) as 'Documentos',
    sum(vl_saldo_documento)     as 'ValorTotal',
    count(distinct cd_cliente)  as 'Clientes'
  into
    #Documento_receber
  from
    Documento_Receber
  where
    dt_vencimento_documento between @dt_inicial and 
                                    @dt_final   and
    dt_cancelamento_documento is null           and
    dt_devolucao_documento    is null           and
    cd_portador = @cd_portador                  and
    cast(str(vl_saldo_documento,25,2) as decimal(25,2)) > 0                     
  group by
    dt_vencimento_documento

  -- total dos registros p/ cálculo do percentual
  select
    @vl_total = sum(cast(ValorTotal as numeric(25,2)))
  from
    #Documento_receber

  -- listagem final c/ campo de percentual calculado
  select
    Data,
    Documentos,
    cast(ValorTotal as numeric(25,2)) as 'ValorTotal',
    cast((ValorTotal/@vl_total)*100 as numeric(25,2)) as 'Percentual',
    Clientes
  from
    #Documento_receber
  order by
    Data
    
