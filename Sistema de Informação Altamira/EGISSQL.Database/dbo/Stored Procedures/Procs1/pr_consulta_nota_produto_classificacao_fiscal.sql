
--sp_helptext 

CREATE PROCEDURE pr_consulta_nota_produto_classificacao_fiscal
------------------------------------------------------------------------------------------------------
--GBS - Global Business Sollution              
------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Daniel Carrasco Neto 
--Banco de Dados   : EGISSQL
--Objetivo         : Listar Notas Fiscais no Periodo por Produto.
--Data             : 05/06/2002
--Atualizado       : 12/08/2002 - Daniel C. Neto - Acertado para trazer produtos especiais.
--                   08/01/2003 - Rafael M, Santiago - Acertado para trazer o Tipo de destinatário.
--                   30/01/2003 - Igor Gama - Trocado o campo de nm_fantasia_nota_saida, p/ o destinatário.
--                   03/10/2003 - Adicionado 4 novos campos: - sg_estado, cidade e vl_unitario e vl_total
--                   19/04/2004 - Colocado IsNull no filtro de produto. - Daniel C. Neto.
--                   08.01.2005 - Colocado o Valor Net Unitário de Venda
--                   27/01/2006 - Adicionado o campo nm_fantasia_cliente - Dirceu
--                   08.02.2006 - Despesas e Impostos - Carlos Fernandes
--                   30.08.2006 - Pedido/Item na Consulta - Carlos Fernandes
--                   10/10/2006 - Incluído valor do IPI - Daniel C. Neto.
--                   21.06.2007 - Classificação Fiscal - Carlos Fernandes
--                   08.10.2007 - Ajuste na Busca da Cotação de Outra Moeda - Carlos Fernandes
-- 21.11.2007 - Categoria do Produto - Carlos Fernandes
-- 10.03.2009 - Checagem de performance - Carlos Fernandes
-- 30.03.2009 - Veículo - Carlos Fernandes
-- 22.04.2009 - Ajuste da Unidade de Medida da Nota Fiscal - Carlos Fernandes
-- 17.06.2009 - Custo do Produto - Carlos Fernandes
-- 24.08.2009 - Destinação do Produto - Carlos Fernandes
-- 29.09.2009 - Flag de Valor Comercial - Carlos Fernandes
------------------------------------------------------------------------------------------------------
@dt_inicial              datetime    = '',
@dt_final                datetime    = '',
@cd_classificacao_fiscal int         = 0

AS

 select 

    identity(int,1,1)                               as cd_controle,
    nsi.cd_classificacao_fiscal,
    substring(max(cf.cd_mascara_classificacao),1,2) as cd_grupo_classificacao,
    max(cf.cd_mascara_classificacao)                as cd_mascara_classificacao,

    --Quantidade de faturamento do Produto

    sum(nsi.qt_item_nota_saida)                     as qt_item_nota_saida,

    sum(
    case when IsNull(cd_servico,0) = 0
    then nsi.vl_unitario_item_nota
    else nsi.vl_servico
    end)
                                              as vl_unitario_item_nota,

    --Total do Item
    sum(nsi.vl_total_item)                    as vl_total_item,

    sum(IsNull(nsi.vl_desp_acess_item,0))     as vl_desp_acess_item,    
    sum(IsNull(nsi.vl_icms_item,0))           as vl_icms_item,    
    sum(IsNull(nsi.vl_desp_aduaneira_item,0)) as vl_desp_aduaneira_item,    
    sum(IsNull(nsi.vl_ii,0))                  as vl_ii,  
    sum(IsNull(nsi.vl_pis,0))                 as vl_pis,
    sum(IsNull(nsi.vl_ipi,0))                 as vl_ipi,
    sum(IsNull(nsi.vl_cofins,0))              as vl_confis,

    sum(cast( (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
     IsNull(nsi.vl_ipi,0) -     
     IsNull(nsi.vl_desp_acess_item,0) -    
     IsNull(nsi.vl_icms_item,0) -    
     IsNull(nsi.vl_desp_aduaneira_item,0) -    
     IsNull(nsi.vl_ii,0) -    
     IsNull(nsi.vl_pis,0) -    
    IsNull(nsi.vl_cofins,0) as money ))       as TotalLiquido

  into
    #ConsultaNotaClFiscal

  from
    Nota_Saida ns           with (nolock)                           
    inner join  
    Nota_Saida_Item nsi        with (nolock) on nsi.cd_nota_saida            = ns.cd_nota_saida           left outer join
    Produto p                  with (nolock) on p.cd_produto                 = nsi.cd_produto             left outer join
    Produto_Fiscal pf          with (nolock) on pf.cd_produto                = p.cd_produto               left outer join
    Classificacao_Fiscal cf    with (nolock) on cf.cd_classificacao_fiscal   = pf.cd_classificacao_fiscal left outer join
    Operacao_Fiscal opf        with (nolock) on opf.cd_operacao_fiscal       = nsi.cd_operacao_fiscal     left outer join
    Grupo_Operacao_Fiscal gof  with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
 
--select * from grupo_operacao_fiscal

  where
    nsi.cd_classificacao_fiscal = case when @cd_classificacao_fiscal = 0 then nsi.cd_classificacao_fiscal else @cd_classificacao_fiscal end and
    ns.dt_cancel_nota_saida is null and
    ns.dt_nota_saida        between @dt_inicial and @dt_final 
    --Nota Fiscal Cancelada
    and isnull(ns.cd_status_nota,0) <> 7 

    --Carlos --> 05.07.2010
    and isnull(opf.ic_comercial_operacao,'N')='S'
    and gof.cd_tipo_operacao_fiscal = 2  --SAIDAS

    --and nsi.nm_fantasia_produto like IsNull(@nm_produto,'') + '%'

group by
   nsi.cd_classificacao_fiscal

order by
   nsi.cd_classificacao_fiscal

select
  *
from
  #ConsultaNotaClFiscal

order by
   cd_classificacao_fiscal

