
CREATE PROCEDURE pr_consulta_documentos_receber_lote
--------------------------------------------------------------------
--pr_consulta_documentos_receber_lote
--------------------------------------------------------------------
--GBS - Global Business Solution Ltda                           2004
--------------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Paulo Santos
--Banco de Dados          : EGISSQL
--Objetivo                : Consultar documentos à receber em aberto dentro do período selecionado.
--Data                    : 15/10/2004
--Atualização             : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso 
--                        : 30.04.2005 - Ordem de Vencimento
-- 23.03.2009 - 
-----------------------------------------------------------------------------------------------------

@dt_inicial   datetime   ,
@dt_final     datetime   ,
@ic_parametro int        = 0

as
  
  select 
    0 as 'Selecionado', 
    d.cd_identificacao, 
    d.cd_documento_receber, 
    d.dt_emissao_documento                                             as Emissao, 
    d.dt_vencimento_documento                                          as Vencimento, 
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2))              as 'vl_saldo_documento',
    vw.nm_fantasia as 'nm_fantasia_destinatario', tp.nm_tipo_documento as Tipo,
    d.cd_plano_financeiro,
    d.cd_moeda
  into
    #Selecao
  from 
    documento_receber d 
    inner join vw_destinatario_rapida vw on d.cd_cliente           = vw.cd_destinatario and 
                                            d.cd_tipo_destinatario = vw.cd_tipo_destinatario
    left outer join Tipo_Documento tp    on tp.cd_tipo_documento   = d.cd_tipo_documento
  where 
    d.dt_vencimento_documento between @dt_inicial and @dt_final 
    and d.dt_cancelamento_documento is null 
    and cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0 
  order by
    5 desc  --Ordem de Vencimento 

if isnull(@ic_parametro,0) = 0
  select * from #Selecao
else
  select 
    *
  from
    #Selecao S with(nolock)
  where
    S.cd_documento_receber not in (select top 1 
                                     cd_documento_receber
                                   from
                                     Documento_Receber_Desconto 
                                   where
                                     cd_documento_receber = S.cd_documento_receber)   
