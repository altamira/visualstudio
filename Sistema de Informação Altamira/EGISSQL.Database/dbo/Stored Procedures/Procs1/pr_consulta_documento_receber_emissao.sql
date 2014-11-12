
CREATE PROCEDURE pr_consulta_documento_receber_emissao
--------------------------------------------------------------------------------
-- pr_consulta_documento_receber_emissao
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                       2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta informações das duplicatas geradas no sistema
--Data			: 20.03.2003
--Alteração             : Fabio - Desconsiderar no resumo de faturamento x documentos a receber notas canceladas
--                      : 25/03/2003 - Inclusão do Campo Portador que, depois de a stp alterada no dia 20/03, sumiu - ELIAS
--                      : 25/03/2003 - Inclusão do Campo de vl_faturamento_comercial que havia sido incluído em
--                                     versão diferente desta STP na SMC - ELIAS
--                      : 07/07/2004 - Acerto para buscar corretamente o Valor Faturado - ELIAS
--                      : 15/07/2004 - Estava filtrando indevidamente os títulos devolvidos, passa a mostrá-los - ELIAS
--                      : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 01/09/2005 - Relacionamento entre as tabelas Cliente - Cliente_Grupo e acréscimo do campo
--                                     nm_cliente_grupo - WELLINGTON SOUZA FAGUNDES
--                      : 27/01/2006 - Inclusão do  d.dt_cancelamento_documento is null   -  Wilder Mendes de Souza
--                      : 23.03.2007 - Revisão - Carlos Fernandes
-- 20.04.2010 - Coluna do Pedido/Nota Fiscal - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-- 25.10.2010 - Novo Campo para mostrar o Total de Documentos sem a Nota Fiscal - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------------------
@cd_parametro int,
@dt_inicial   datetime,
@dt_final     datetime

AS

declare @ic_comercial char(1) 

set @ic_comercial = 'S'

--Analítico--------------------------------------------------------------------------------------

If @cd_parametro = 1
Begin

  select
    d.cd_identificacao        as 'Documento',
    d.dt_emissao_documento    as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    cast(str(d.vl_documento_receber,25,2) as numeric(25,2)) as 'Valor',
    cast(str(d.vl_saldo_documento,25,2)   as numeric(25,2)) as 'Saldo',
    --c.nm_fantasia_cliente                                   as 'Fantasia',
    vw.nm_fantasia                                          as 'Fantasia',
    d.dt_devolucao_documento                                as 'DataDev',
    d.nm_devolucao_documento                                as 'Motivo',
    ( select top 1 v.nm_fantasia_vendedor from Vendedor v where v.cd_vendedor = d.cd_vendedor) as 'Vendedor',
    p.nm_portador as 'Portador',
    cg.nm_cliente_grupo,
    d.cd_pedido_venda,
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
       ns.cd_identificacao_nota_saida
    else
       ns.cd_nota_saida
    end                                                  as 'cd_nota_saida'

    --d.cd_nota_saida

  from
    documento_receber d                with (nolock) 
    left outer join cliente c          on c.cd_cliente            = d.cd_cliente
    left outer join Portador p         on p.cd_portador           = d.cd_portador
    left outer join cliente_grupo cg   on c.cd_cliente_grupo      = cg.cd_cliente_grupo  	
    left outer join Nota_saida ns      on ns.cd_nota_saida        = d.cd_nota_saida
    left outer join vw_destinatario vw on vw.cd_tipo_destinatario = d.cd_tipo_destinatario and
                                          vw.cd_destinatario      = d.cd_cliente  
  where
    d.dt_emissao_documento between @dt_inicial and @dt_final and
    --d.cd_cliente = c.cd_cliente                              and
    d.dt_devolucao_documento    is null and
    d.dt_cancelamento_documento is null                      

  order by
    Emissao,
    Documento

End

--Resumo-----------------------------------------------------------------------------------

If @cd_parametro = 2
Begin

  --Documento Receber
  select
    d.dt_emissao_documento                                       as 'Emissao',     
    count(*)                                                     as 'Documento',
    sum(cast(str(d.vl_saldo_documento,25,2) as numeric(25,2)))   as 'Saldo',
    sum(cast(str(d.vl_documento_receber,25,2) as numeric(25,2))) as 'Valor',
    sum(    
      case when isnull(d.cd_nota_saida,0)=0 then
        cast(str(d.vl_documento_receber,25,2) as numeric(25,2))
      else
        case when isnull(ns.cd_cliente,0) <> isnull(d.cd_cliente,0) then
           cast(str(d.vl_documento_receber,25,2) as numeric(25,2))
        else
           0.00
        end
      end
    )                                                             as 'Valor_Sem_Faturamento'

  INTO
    #ConsultaPreliminar

  from
    documento_receber d with (nolock) 
    left outer join nota_saida ns on ns.cd_nota_saida = d.cd_nota_saida

  where
    d.dt_emissao_documento      between @dt_inicial and @dt_final and
    d.dt_devolucao_documento    is null and
    d.dt_cancelamento_documento is null 

  group by
    d.dt_emissao_documento

  --Faturamento

   Select 
     vw.dt_nota_saida,
     sum(isnull(vw.vl_unitario_item_total,0)) as 'vl_faturamento_comercial',
     sum(isnull(vl_ipi,0))                    as 'vl_ipi'

   into
     #ConsultaPreliminarFaturamento

   from
     vw_faturamento_bi vw

   where
     vw.cd_status_nota not in (4,7) and --Desconsidera as notas devolvidas totalmente e canceladas
     vw.dt_nota_saida between @dt_inicial and @dt_final

   group by
     vw.dt_nota_saida

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------

  select 
    vw.dt_nota_saida,
    sum(isnull(vw.vl_unitario_item_total,0))  as DevolucaoMes
  
  into 
    #FaturaDevolucao

  from
    vw_faturamento_devolucao vw

  where 
    IsNull(vw.ic_analise_op_fiscal,'S') = ( case 
                                              when ( @ic_comercial = 'S' ) then 'S'
                                              else IsNull(vw.ic_analise_op_fiscal,'S')
                                             end ) and
    ( IsNull(vw.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(vw.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(vw.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(vw.cd_tipo_destinatario,2)
                                          end ) ) and
  	vw.dt_nota_saida between @dt_inicial and @dt_final
  group by 
    vw.dt_nota_saida
  order by 1 desc


  ----------------------------------------------------
  --Devolução dos Meses Anteriores
  ----------------------------------------------------

  select 
    vw.dt_restricao_item_nota,
    --vw_dt_nota_saida,
    sum(isnull(vw.vl_unitario_item_total,0)) 	as DevolucaoAnterior
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior vw
  where 
    IsNull(vw.ic_analise_op_fiscal,'S') = ( case 
                                              when ( @ic_comercial = 'S' ) then 'S'
                                              else IsNull(vw.ic_analise_op_fiscal,'S')
                                             end ) and
    ( IsNull(vw.cd_tipo_destinatario,1) = ( case 
                                            when ( @ic_comercial = 'S' ) then 1
                                            else IsNull(vw.cd_tipo_destinatario,1)
                                          end ) or
    IsNull(vw.cd_tipo_destinatario,2) = ( case 
                                            when ( @ic_comercial = 'S' ) then 2
                                            else IsNull(vw.cd_tipo_destinatario,2)
                                          end ) ) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
  group by 
    vw.dt_restricao_item_nota

   Select 
     d.*,
     isnull(f.vl_ipi,0)                                                          as vl_ipi,
--     f.vl_faturamento_comercial - isnull(dv.DevolucaoAnterior,0)                 as vl_faturamento_comercial,
     f.vl_faturamento_comercial                                                  as vl_faturamento_comercial,
     round(d.Valor - f.vl_faturamento_comercial,2)                               as Diferenca,                                       
     dm.DevolucaoMes                                                             as DevolucaoMes,
     f.vl_faturamento_comercial - isnull(dv.DevolucaoAnterior,0)
                                                                                 as Total,
     dv.DevolucaoAnterior                                                        as DevolucaoAnterior


   From
     #ConsultaPreliminar d 
     left outer join  #ConsultaPreliminarFaturamento f  on d.Emissao = f.dt_nota_saida
     left outer join  #FaturaDevolucao               dm on d.Emissao = dm.dt_nota_saida
     left outer join  #FaturaDevolucaoAnoAnterior    dv on d.Emissao = dv.dt_restricao_item_nota

   order by
     d.Emissao
     
End

--------------------------------------------------------------------
--Testando a Stored Procedure
--------------------------------------------------------------------
--exec pr_consulta_documento_receber_emissao
--------------------------------------------------------------------


