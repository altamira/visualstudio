CREATE PROCEDURE pr_consulta_nota_fiscal_servico
------------------------------------------------------------------------------------------------------
--GBS - Global Business Sollution              2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
------------------------------------------------------------------------------------------------------
--Autor(es)      : Daniel Duela 
--Banco de Dados : EGISSQL
--Objetivo       : - Listar Notas Fiscais no Periodo por Produto.
--Data           : 08/07/2003
--Atualizado     : 30.08.2006 - Pedido de Venda/Item - Carlos Fernandes
-- 04.11.2008    : Verificação de Duplicidade - Carlos Fernandes
-- 18.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------------------------------
@dt_inicial datetime,
@dt_final   datetime,
@cd_servico int

AS

 select
    ns.cd_identificacao_nota_saida,
    IsNull(s.qt_dia_garantia_servico,0) as 'DiasGarantia',
    case when IsNull(s.ic_garantia_servico, 'N') = 'S' and ( GetDate() - ns.dt_nota_saida) < IsNull(s.qt_dia_garantia_servico,0) then 1
     else 0 end as 'Garantia',
    nsi.cd_servico,
    s.nm_servico,
    ns.nm_fantasia_destinatario as nm_fantasia_nota_saida,
    td.nm_tipo_destinatario,
    v.nm_fantasia_vendedor,
    nsi.cd_nota_saida,
    ns.dt_nota_saida,
    ns.dt_saida_nota_saida,
    nsi.nm_produto_item_nota as 'nm_produto',
    nsi.cd_item_nota_saida,
    nsi.qt_item_nota_saida,
    nsi.cd_lote_produto,
    ns.cd_mascara_operacao,
    nsi.cd_pedido_venda,
    nsi.cd_item_pedido_venda,
    opf.nm_operacao_fiscal		
  from
    Nota_Saida ns                      with (nolock) 

  inner join Nota_Saida_Item nsi       with (nolock) on nsi.cd_nota_saida       = ns.cd_nota_saida 
  left outer join Servico s            with (nolock) on s.cd_servico            = nsi.cd_servico 
  left outer join Vendedor v           with (nolock) on v.cd_vendedor           = ns.cd_vendedor 
  left outer join Tipo_Destinatario td with (nolock) on td.cd_tipo_destinatario = ns.cd_tipo_destinatario
  left outer join Operacao_Fiscal opf  with (nolock) on opf.cd_operacao_fiscal  = nsi.cd_operacao_fiscal
  where
    ns.dt_cancel_nota_saida is null                    and
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    (nsi.cd_servico<>0 and nsi.cd_servico is not null) and
    (nsi.cd_servico = @cd_servico or @cd_servico=0)
order by
   ns.dt_nota_saida desc, s.nm_servico
    

