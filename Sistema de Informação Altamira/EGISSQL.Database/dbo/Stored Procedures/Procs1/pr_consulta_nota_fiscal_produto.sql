
--sp_helptext 

CREATE PROCEDURE pr_consulta_nota_fiscal_produto
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
-- 06.05.2010 - Nota Fiscal de Devolução tem que entrar na Consulta - Carlos Fernandes
-- 24.06.2010 - Nota de Entrada/Item da Nota de Entrada - Carlos / Márcio Martins
-- 05.07.2010 - Flag para Análise / bater com o resumo do faturamento - Carlos Fernandes
-- 18.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------------------------------
@dt_inicial       datetime    = '',
@dt_final         datetime    = '',
@nm_produto       varchar(40) = '',
@ic_tipo_pesquisa char(1)     = 'F'

--select * from produto where ic_garantia_produto = 'N'
--select * from parametro_formacao_preco

AS

 declare @ic_tipo_preco_custo char(1)
 
 set @ic_tipo_preco_custo = 'R'

 select
   @ic_tipo_preco_custo = isnull(ic_tipo_preco_custo,@ic_tipo_preco_custo)
 from
   parametro_formacao_preco with (nolock) 
 where
   cd_empresa = dbo.fn_empresa()

 select 
    distinct
    identity(int,1,1)                   as cd_controle,
    nsi.cd_produto,
    nsi.cd_mascara_produto,
    IsNull(p.qt_dia_garantia_produto,0) as 'DiasGarantia',
    case when IsNull(p.ic_garantia_produto, 'N') = 'S' and ( GetDate() - ns.dt_nota_saida) < IsNull(p.qt_dia_garantia_produto,0) then 1
    else 0 end as 'Garantia',
    nsi.nm_fantasia_produto,
    ns.nm_fantasia_destinatario as nm_fantasia_nota_saida,	
    td.nm_tipo_destinatario,
    v.nm_fantasia_vendedor,
    nsi.cd_nota_saida,
    ns.cd_identificacao_nota_saida,
    ns.dt_nota_saida,
    ns.dt_saida_nota_saida,
    nsi.nm_produto_item_nota    as 'nm_produto',
    nsi.cd_item_nota_saida,
    --Quantidade de faturamento do Produto
    nsi.qt_item_nota_saida,
    nsi.cd_lote_item_nota_saida as cd_lote_produto,
    nsi.cd_numero_serie_produto,
    --ns.cd_mascara_operacao,
    case when isnull(opf.cd_mascara_operacao,'') <> '' then
      opf.cd_mascara_operacao
    else
      ns.cd_mascara_operacao
    end                         as cd_mascara_operacao,
    case IsNull(cd_servico,0)
      when 0 then nsi.vl_unitario_item_nota
      else nsi.vl_servico
    end as vl_unitario_item_nota,
    nsi.vl_total_item,
    e.sg_estado,
    c.nm_cidade,
    cp.nm_categoria_produto,
    pc.vl_net_outra_moeda,
    case when isnull(ns.vl_cambio_nota_saida,0)=0 
    then
      dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida)
    else
      ns.vl_cambio_nota_saida
    end                                                                          as vl_cambio_nota_saida,
    case when ns.dt_cambio_nota_saida = '12/30/1899' or ns.dt_cambio_nota_saida is null
    then
       ns.dt_nota_saida
    else
       isnull(ns.dt_cambio_nota_saida,ns.dt_nota_saida)
    end                                                                          as dt_cambio_nota_saida,
    isnull(ns.cd_moeda,1)                as cd_moeda,
    d.nm_fantasia                       as nm_fantasia_cliente,
--    cl.nm_fantasia_cliente,
    IsNull(nsi.vl_desp_acess_item,0)     as vl_desp_acess_item,    
    IsNull(nsi.vl_icms_item,0)           as vl_icms_item,    
    IsNull(nsi.vl_desp_aduaneira_item,0) as vl_desp_aduaneira_item,    
    IsNull(nsi.vl_ii,0)                  as vl_ii,  
    IsNull(nsi.vl_pis,0)                 as vl_pis,
    IsNull(nsi.vl_ipi,0)                 as vl_ipi,
    IsNull(nsi.vl_cofins,0)              as vl_confis,
    cast( (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
     IsNull(nsi.vl_ipi,0) -     
     IsNull(nsi.vl_desp_acess_item,0) -    
     IsNull(nsi.vl_icms_item,0) -    
     IsNull(nsi.vl_desp_aduaneira_item,0) -    
     IsNull(nsi.vl_ii,0) -    
     IsNull(nsi.vl_pis,0) -    
    IsNull(nsi.vl_cofins,0) as money )  as TotalLiquido,
    nsi.cd_pedido_venda,
    nsi.cd_item_pedido_venda,
    cf.cd_mascara_classificacao,
    vei.nm_veiculo,
    m.nm_motorista,
    um.sg_unidade_medida,

    --Valor de Custo do Produto
    --select * from produto_custo

    case when isnull(pc.vl_custo_produto,0)>0 and @ic_tipo_preco_custo = 'R' then
      pc.vl_custo_produto
    else
       case when isnull(pc.vl_custo_contabil_produto,0)>0 and @ic_tipo_preco_custo = 'C' then
          isnull(pc.vl_custo_contabil_produto,0)
       else
         case when isnull(pc.vl_custo_previsto_produto,0)>0 and @ic_tipo_preco_custo = 'M' then
             isnull(pc.vl_custo_previsto_produto,0)
         else
           case when isnull(pc.vl_custo_producao_produto,0)>0 then
             isnull(pc.vl_custo_producao_produto,0)
           else
             0.00
           end
        end
      end
    end                                  as vl_custo_produto,

    --Custo Total

    nsi.qt_item_nota_saida

    *

    case when isnull(pc.vl_custo_produto,0)>0 and @ic_tipo_preco_custo = 'R' then
      pc.vl_custo_produto
    else
       case when isnull(pc.vl_custo_contabil_produto,0)>0 and @ic_tipo_preco_custo = 'C' then
          isnull(pc.vl_custo_contabil_produto,0)
       else
         case when isnull(pc.vl_custo_previsto_produto,0)>0 and @ic_tipo_preco_custo = 'M' then
             isnull(pc.vl_custo_previsto_produto,0)
         else
           case when isnull(pc.vl_custo_producao_produto,0)>0 then
             isnull(pc.vl_custo_producao_produto,0)
           else
             0.00
           end
        end
      end
    end
                                           as vl_custo_total,

    dp.nm_destinacao_produto,
    isnull(opf.ic_comercial_operacao,'N') as ic_comercial_operacao,
    tof.nm_tipo_operacao_fiscal,
    cg.nm_cliente_grupo,
    sn.nm_status_nota,
    nsi.cd_nota_entrada,
    nsi.cd_item_nota_entrada,
    isnull(opf.ic_analise_op_fiscal,'N')  as ic_analise_op_fiscal,
    gp.nm_grupo_produto,
    case when isnull(p.cd_marca_produto,0)>0 then
       mp.nm_marca_produto
    else
       p.nm_marca_produto
    end                                   as nm_marca_produto

    

--select * from nota_saida_item

  into
    #ConsultaNotaProduto

  from
    Nota_Saida ns             with (nolock)                           
    inner join  
    Nota_Saida_Item nsi       with (nolock) on nsi.cd_nota_saida            = ns.cd_nota_saida       left outer join
    Produto p                 with (nolock) on p.cd_produto                 = nsi.cd_produto         left outer join
    Unidade_Medida um         with (nolock) on um.cd_unidade_medida         = nsi.cd_unidade_medida  left outer join
    Produto_Custo pc          with (nolock) on pc.cd_produto                = nsi.cd_produto         left outer join
    Produto_Fiscal pf         with (nolock) on pf.cd_produto                = nsi.cd_produto         left outer join 
    Classificacao_Fiscal cf   with (nolock) on cf.cd_classificacao_fiscal   = pf.cd_classificacao_fiscal left outer join
    Vendedor v                with (nolock) on v.cd_vendedor                = ns.cd_vendedor            left outer join 
    Tipo_Destinatario td      with (nolock) on td.cd_tipo_destinatario      = ns.cd_tipo_destinatario   left outer join
    vw_Destinatario d         with (nolock) on d.cd_tipo_Destinatario       = ns.cd_tipo_destinatario and	
  	                                       d.cd_destinatario            = ns.cd_cliente             left outer join
    Estado e                  with (nolock) on e.cd_estado                  = d.cd_estado               left outer join
    Cidade c                  with (nolock) on c.cd_cidade                  = d.cd_cidade               left outer join
    categoria_produto cp      with (nolock) on cp.cd_categoria_produto      = nsi.cd_categoria_produto  left outer join
    cliente cl                with (nolock) on cl.cd_cliente                = ns.cd_cliente             left outer join
    Veiculo vei               with (nolock) on vei.cd_veiculo               = ns.cd_veiculo             left outer join
    Motorista m               with (nolock) on m.cd_motorista               = ns.cd_motorista           left outer join
    Destinacao_Produto dp     with (nolock) on dp.cd_destinacao_produto     = ns.cd_destinacao_produto left outer join
    Operacao_Fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = nsi.cd_operacao_fiscal   left outer join
    Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal left outer join
    Tipo_Operacao_Fiscal  tof with (nolock) on tof.cd_tipo_operacao_fiscal  = gof.cd_tipo_operacao_fiscal
    left outer join cliente cli       with (nolock) on cli.cd_cliente      = ns.cd_cliente 
    left outer join cliente_grupo cg  with (nolock) on cg.cd_cliente_grupo = cli.cd_cliente_grupo 
    left outer join status_nota   sn  with (nolock) on sn.cd_status_nota   = ns.cd_status_nota
    left outer join Grupo_Produto gp  with (nolock) on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join Marca_Produto mp  with (nolock) on mp.cd_marca_produto = p.cd_marca_produto
--select * from nota_saida
--select * from cliente 
--select * from operacao_fiscal
--select * from tipo_operacao_fiscal
     
  where
    --ns.dt_cancel_nota_saida is null and

    ns.dt_nota_saida        between @dt_inicial and @dt_final 
    --and nsi.nm_fantasia_produto like IsNull(@nm_produto,'') + '%'
    and isnull(ns.cd_status_nota,0) <> 7 --Nota Fiscal Cancelada

  --select * from status_nota
  --select * from nota

order by
   nsi.cd_produto,
   ns.dt_nota_saida desc, nsi.nm_fantasia_produto



if @nm_produto = ''
begin
  select
    *
  from
    #ConsultaNotaProduto
  order by
   cd_produto,
   dt_nota_saida desc, nm_fantasia_produto

end
else
begin
 if @ic_tipo_pesquisa = 'F' 
 begin
   select
     *
   from
     #ConsultaNotaProduto
   where
     nm_fantasia_produto like IsNull(@nm_produto,'') + '%'

   order by
     cd_produto,
     dt_nota_saida desc, nm_fantasia_produto
  end
 else
 if @ic_tipo_pesquisa = 'C' 
 begin
   select
     *
   from
     #ConsultaNotaProduto
   where
     cd_mascara_produto like IsNull(@nm_produto,'') + '%'

   order by
     cd_produto,
     dt_nota_saida desc, cd_mascara_produto
  end

end

-- else
-- begin
--  select distinct
--     nsi.cd_produto,
--     nsi.cd_mascara_produto,
--     IsNull(p.qt_dia_garantia_produto,0) as 'DiasGarantia',
--     case when IsNull(p.ic_garantia_produto, 'N') = 'S' and ( GetDate() - ns.dt_nota_saida) < IsNull(p.qt_dia_garantia_produto,0) then 1
--     else 0 end as 'Garantia',
--     nsi.nm_fantasia_produto,
--     ns.nm_fantasia_destinatario as nm_fantasia_nota_saida,	
--     td.nm_tipo_destinatario,
--     v.nm_fantasia_vendedor,
--     nsi.cd_nota_saida,
--     ns.dt_nota_saida,
--     ns.dt_saida_nota_saida,
--     nsi.nm_produto_item_nota    as 'nm_produto',
--     nsi.cd_item_nota_saida,
--     nsi.qt_item_nota_saida,
--     nsi.cd_lote_item_nota_saida as cd_lote_produto,
--     nsi.cd_numero_serie_produto,
--     ns.cd_mascara_operacao,
--     case IsNull(cd_servico,0)
--       when 0 then nsi.vl_unitario_item_nota
--       else nsi.vl_servico
--     end as vl_unitario_item_nota,
--     nsi.vl_total_item,
--     e.sg_estado,
--     c.nm_cidade,
--     cp.nm_categoria_produto,
--     pc.vl_net_outra_moeda,
--     case when isnull(ns.vl_cambio_nota_saida,0)=0 
--     then
--       dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida)
--     else
--       ns.vl_cambio_nota_saida
--     end                                                                          as vl_cambio_nota_saida,
--     case when ns.dt_cambio_nota_saida = '12/30/1899' or ns.dt_cambio_nota_saida is null
--     then
--        ns.dt_nota_saida
--     else
--        isnull(ns.dt_cambio_nota_saida,ns.dt_nota_saida)
--     end                                                                          as dt_cambio_nota_saida,
--     isnull(ns.cd_moeda,1)                as cd_moeda,
--     cl.nm_fantasia_cliente,
--     IsNull(nsi.vl_desp_acess_item,0)     as vl_desp_acess_item,    
--     IsNull(nsi.vl_icms_item,0)           as vl_icms_item,    
--     IsNull(nsi.vl_desp_aduaneira_item,0) as vl_desp_aduaneira_item,    
--     IsNull(nsi.vl_ii,0)                  as vl_ii,  
--     IsNull(nsi.vl_pis,0)                 as vl_pis,
--     IsNull(nsi.vl_ipi,0)                 as vl_ipi,
--     IsNull(nsi.vl_cofins,0)              as vl_confis,
--     cast( (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
--      IsNull(nsi.vl_ipi,0) -     
--      IsNull(nsi.vl_desp_acess_item,0) -    
--      IsNull(nsi.vl_icms_item,0) -    
--      IsNull(nsi.vl_desp_aduaneira_item,0) -    
--      IsNull(nsi.vl_ii,0) -    
--      IsNull(nsi.vl_pis,0) -    
--     IsNull(nsi.vl_cofins,0) as money ) as TotalLiquido,
--     nsi.cd_pedido_venda,
--     nsi.cd_item_pedido_venda,
--     cf.cd_mascara_classificacao,
--     vei.nm_veiculo,
--     m.nm_motorista,
--     um.sg_unidade_medida,
-- 
--     --Valor de Custo do Produto
-- 
--     case when isnull(pc.vl_custo_produto,0)>0 then
--       pc.vl_custo_produto
--     else
--       case when isnull(pc.vl_custo_producao_produto,0)>0 then
--         isnull(pc.vl_custo_producao_produto,0)
--       else
--         case when isnull(pc.vl_custo_contabil_produto,0)>0 then
--            isnull(pc.vl_custo_contabil_produto,0)
--         else
--           0.00
--         end
--       end
--     end                                  as vl_custo_produto,
-- 
--     -----------------------------------------------------------------------------
--     --Custo Total
--     -----------------------------------------------------------------------------
--   
--     nsi.qt_item_nota_saida
-- 
--     *
-- 
--     case when isnull(pc.vl_custo_produto,0)>0 then
--       pc.vl_custo_produto
--     else
--       case when isnull(pc.vl_custo_producao_produto,0)>0 then
--         isnull(pc.vl_custo_producao_produto,0)
--       else
--         case when isnull(pc.vl_custo_contabil_produto,0)>0 then
--            isnull(pc.vl_custo_contabil_produto,0)
--         else
--           0.00
--         end
--       end
--     end                                  as vl_custo_total
-- 
-- 
--   from
--     Nota_Saida ns      with (nolock)                           
--     inner join  
--     Nota_Saida_Item nsi     with (nolock) on nsi.cd_nota_saida          = ns.cd_nota_saida left outer join
--     Produto p               with (nolock) on p.cd_produto               = nsi.cd_produto        left outer join
--     Unidade_Medida um       with (nolock) on um.cd_unidade_medida       = nsi.cd_unidade_medida left outer join
--     Produto_Custo pc        with (nolock) on pc.cd_produto              = nsi.cd_produto       left outer join
--     Produto_Fiscal pf       with (nolock) on pf.cd_produto              = nsi.cd_produto      left outer join 
--     Classificacao_Fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal left outer join
--     Vendedor v              with (nolock) on v.cd_vendedor           = ns.cd_vendedor       left outer join 
--     Tipo_Destinatario td    with (nolock) on td.cd_tipo_destinatario = ns.cd_tipo_destinatario left outer join
--     vw_Destinatario d       with (nolock) on d.cd_tipo_Destinatario  = ns.cd_tipo_destinatario and	
-- 	                                     d.cd_destinatario       = ns.cd_cliente left outer join
--     Estado e                with (nolock) on e.cd_estado             = d.cd_estado               left outer join
--     Cidade c                with (nolock) on c.cd_cidade             = d.cd_cidade               left outer join
--     categoria_produto cp    with (nolock) on cp.cd_categoria_produto = nsi.cd_categoria_produto left outer join
--     cliente cl              with (nolock) on cl.cd_cliente           = ns.cd_cliente  left outer join
--     Veiculo vei             with (nolock) on vei.cd_veiculo          = ns.cd_veiculo  left outer join 
--     Motorista m             with (nolock) on m.cd_motorista          = ns.cd_motorista         
--      
--   where
--     ns.dt_cancel_nota_saida is null and
--     ns.dt_nota_saida        between @dt_inicial and @dt_final and
--     nsi.nm_fantasia_produto like IsNull(@nm_produto,'') + '%'
-- 
-- order by
--    nsi.cd_produto,
--    ns.dt_nota_saida desc, nsi.nm_fantasia_produto
-- 
-- end
-- 

