
--sp_helptext pr_consulta_ultimo_custo_produto_nota_entrada

CREATE PROCEDURE pr_consulta_ultimo_custo_produto_nota_entrada
--------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Notas de Entrada por Produto.
--Data          : 17/06/2003
--              : 21/06/2004 - Buscando o Valor de Custo da Tabela de Movimento de Estoque - ELIAS
-- 08/06/2004 - Incluído coluna de recebimento, tirada mascara do grupo de produto - Daniel C. neto.
-- 20.07.2006 - Incluídos novas colunas com os valores dos impostos - carlos Fernandes
-- 14.04.2007 - Data de Entrada - Carlos Fernandes
-- 05.09.2007 - Custo da Comissão - Carlos Fernandes
-- 18.10.2007 - CFOP de Entrada - Carlos Fernandes
-- 27.12.2007 - Unidade de Medida - Carlos Fernandes
-- 06.02.2008 - Acerto do Preço de Custo do produto - Carlos Fernandes
-- 02.05.2008 - Acerto do Preço de Unitário do Produto - Carlos Fernandes
-- 21.05.2008 - Ajuste do Cálculo de PIS/COFINS conforme a CFOP - Carlos Fernandes
-- 16.06.2008 - Peso/Ajuste de Cálculo  - Carlos Fernandes
-- 08.08.2008 - Ajuste por Código - Carlos Fernandes
-- 31.03.2010 - Plano Financeiro - Carlos Fernandes
--------------------------------------------------------------------------------------------------------

@ic_parametro        int         = 0,
@dt_inicial          datetime    = '',
@dt_final            datetime    = '',
@nm_fantasia_produto varchar(30) = '',
@ic_custo_estoque    char(1)     = 'N'

AS

--select cd_plano_financeiro,* from nota_entrada

--Ajusta o Valor de PIS COFINS das Notas Fiscais


declare @pc_pis    decimal(25,4)
declare @pc_cofins decimal(25,4)

set @pc_pis    = (1.65/100)
set @pc_cofins = (7.6/100)

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Produto por Nome Fantasia
-------------------------------------------------------------------------------
  begin

    --select * from nota_entrada_item where cd_nota_entrada = 981203

    
    SELECT     
      top 1
               ne.dt_receb_nota_entrada,
               ne.dt_nota_entrada,
               nei.cd_nota_entrada, 
               nei.nm_produto_nota_entrada, 
               nei.cd_item_nota_entrada,
               nei.vl_item_nota_entrada, 
               nei.qt_item_nota_entrada,
               nei.qt_pesliq_nota_entrada,
               nei.qt_pesbru_nota_entrada,
               nei.vl_total_nota_entr_item,
               td.nm_tipo_destinatario,
               vw.nm_fantasia                                               as nm_fantasia_fornecedor, 
               snf.sg_serie_nota_fiscal, 
               dbo.fn_mascara_produto(nei.cd_produto)                       as cd_mascara_produto, 
               p.nm_fantasia_produto,
               nei.cd_lote_item_nota_entrada                                as 'Lote', 
               --isnull(nei.vl_custo_nota_entrada,0)                          as vl_custo_nota_entrada,

               round((nei.vl_item_nota_entrada
               -

               case when isnull(ic_ipi_base_icm_dest_prod,'N')='S' then
               (nei.vl_ipi_nota_entrada/nei.qt_item_nota_entrada)
               else 
                0.00
               end

               -

               (nei.vl_icms_nota_entrada/nei.qt_item_nota_entrada)

               -

               --Cofins
               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_cofins_item_nota,0)>0
                 then
                    nei.vl_cofins_item_nota/nei.qt_item_nota_entrada  
                 else
                    nei.vl_item_nota_entrada*@pc_cofins
                 end
               else
                 0.00
               end                                      

               -

               --PIS
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_pis_item_nota,0)>0 
                 then
                    nei.vl_pis_item_nota/nei.qt_item_nota_entrada  
                 else
                    nei.vl_item_nota_entrada*@pc_pis
                 end
               else
                 0.00
               end),2)                                                        as 'vl_custo_nota_entrada',

                                        
               round((nei.vl_item_nota_entrada

               -

               case when isnull(ic_ipi_base_icm_dest_prod,'N')='S' then
               (nei.vl_ipi_nota_entrada/nei.qt_item_nota_entrada)
               else 
                0.00
               end

               -

               (nei.vl_icms_nota_entrada/nei.qt_item_nota_entrada)

               -

               --Cofins
               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_cofins_item_nota,0)>0
                 then
                    nei.vl_cofins_item_nota/nei.qt_item_nota_entrada  
                 else
                    nei.vl_item_nota_entrada*@pc_cofins
                 end
               else
                 0.00
               end                                      

               -

               --PIS
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_pis_item_nota,0)>0 
                 then
                    nei.vl_pis_item_nota/nei.qt_item_nota_entrada  
                 else
                    nei.vl_item_nota_entrada*@pc_pis
                 end
               else
                 0.00
               end
               )

               *                        
               nei.qt_item_nota_entrada,2) 
                                  as 'VlrCusto',
                              

--                (case when isnull(me.vl_custo_contabil_produto,0)>0 and @ic_custo_estoque = 'S' then
--                    me.vl_custo_contabil_produto
--                else
--                   case when isnull(nei.vl_custo_nota_entrada,0)>0 then
--                    nei.vl_custo_nota_entrada/nei.qt_item_nota_entrada
--                   else
--                     nei.vl_total_nota_entr_item/nei.qt_item_nota_entrada
--                   end    
--                end * nei.qt_item_nota_entrada)                              as 'VlrCusto',

               nei.pc_icms_nota_entrada                                     as 'pc_icms',
               nei.vl_icms_nota_entrada                                     as 'Icms',         
               nei.pc_ipi_nota_entrada                                      as 'pc_ipi',
               nei.vl_ipi_nota_entrada                                      as 'Ipi', 
               
               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.pc_cofins_item_nota,0)>0
                 then
                    nei.pc_cofins_item_nota
                 else
                    @pc_cofins*100
                 end
               else
                 0.00
               end                                                          as 'pc_cofins',
            
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.pc_pis_item_nota,0)>0
                 then
                    nei.pc_pis_item_nota
                 else
                    @pc_pis*100
                 end
               else
                 0.00
               end                                                          as 'pc_pis',

               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_cofins_item_nota,0)>0
                 then
                    nei.vl_cofins_item_nota  
                 else
                    nei.vl_total_nota_entr_item*@pc_cofins
                 end
               else
                 0.00
               end                                                          as 'Cofins',

               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_pis_item_nota,0)>0 
                 then
                   nei.vl_pis_item_nota  
                 else
                   nei.vl_total_nota_entr_item*@pc_pis
                 end
               else
                 0.00
               end                                                          as 'Pis',
               
               case when 
                    isnull(nei.vl_item_nota_entrada,0) + 
                                      ( nei.vl_item_nota_entrada * (isnull(nei.pc_ipi_nota_entrada,0)/100)) = 0 
               then
                 isnull(pc.vl_custo_comissao,0)
               else
                 isnull(nei.vl_item_nota_entrada,0) + 
                                     ( nei.vl_item_nota_entrada * (isnull(nei.pc_ipi_nota_entrada,0)/100))

               end                                                          as vl_custo_comissao,

               opf.cd_mascara_operacao,
               opf.nm_operacao_fiscal,
               um.sg_unidade_medida,
               dp.nm_destinacao_produto,
               nei.cd_pedido_compra,
               nei.cd_item_pedido_compra,
               nei.cd_nota_saida,
               nei.cd_item_nota_saida,
               pf.cd_mascara_plano_financeiro, 
               pf.nm_conta_plano_financeiro,
               fp.nm_fase_produto            

--select * from plano_financeiro

    FROM       Nota_Entrada_Item nei with (nolock) 
               left outer join
               Nota_Entrada ne  with (nolock)  
                               on ne.cd_fornecedor = nei.cd_fornecedor and
                                  ne.cd_nota_entrada = nei.cd_nota_entrada and
                                  ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
                                  ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
               left outer join
               Movimento_Estoque me with (nolock) 
                                    on me.cd_fornecedor = nei.cd_fornecedor and
                                       me.cd_documento_movimento = cast(nei.cd_nota_entrada as varchar) and
                                       me.cd_operacao_fiscal = nei.cd_operacao_fiscal and
                                       me.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                       me.cd_item_documento = nei.cd_item_nota_entrada and                                       
                                       me.cd_tipo_documento_estoque = 3
               left outer join
               vw_destinatario vw                    with (nolock) ON ne.cd_tipo_destinatario  = vw.cd_tipo_destinatario and ne.cd_fornecedor = vw.cd_destinatario  
               left outer join Serie_Nota_Fiscal snf with (nolock) ON nei.cd_serie_nota_fiscal = snf.cd_serie_nota_fiscal 
               left outer join Produto p             with (nolock) ON nei.cd_produto           = p.cd_produto 
               left outer join Produto_Custo pc      with (nolock) on pc.cd_produto            = p.cd_produto 
               left outer join Grupo_Produto gp      with (nolock) on gp.cd_grupo_produto      = p.cd_grupo_produto 
               left outer join Tipo_Destinatario td  with (nolock) ON td.cd_tipo_destinatario  = ne.cd_tipo_destinatario        
               left outer join Operacao_Fiscal opf   with (nolock) on opf.cd_operacao_fiscal   = ne.cd_operacao_fiscal
               left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida     = nei.cd_unidade_medida
               left outer join Destinacao_Produto dp with (nolock) on dp.cd_destinacao_produto = ne.cd_destinacao_produto
               left outer join Plano_Financeiro   pf with (nolock) on pf.cd_plano_financeiro   = ne.cd_plano_financeiro
               left outer join Fase_Produto       fp with (nolock) on fp.cd_fase_produto       = nei.cd_fase_produto
  where 
    ne.dt_receb_nota_entrada < @dt_final and
    (p.nm_fantasia_produto like @nm_fantasia_produto + '%')
  order by 
    ne.dt_receb_nota_entrada desc
   
end


-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Saldo do Estoque do Produto por Máscara
-------------------------------------------------------------------------------
  begin
 
    declare @Mascara_Limpa varchar(30)

    set @Mascara_Limpa = Replace(@nm_fantasia_produto,'.','')
    set @Mascara_Limpa = Replace(@Mascara_Limpa,'-','')

    print(@Mascara_Limpa)

--     SELECT     
--                ne.dt_receb_nota_entrada,                
--                ne.dt_nota_entrada,
--                nei.cd_nota_entrada, 
--                nei.nm_produto_nota_entrada, 
-- 	       nei.cd_item_nota_entrada, 
--                nei.vl_item_nota_entrada,
--                nei.qt_item_nota_entrada, 
--                nei.vl_total_nota_entr_item,
--                td.nm_tipo_destinatario,
--                vw.nm_fantasia                                               as nm_fantasia_fornecedor, 
--                snf.sg_serie_nota_fiscal, 
--                p.cd_mascara_produto, 
--                p.nm_fantasia_produto,
--                gp.cd_mascara_grupo_produto,
--                nei.cd_lote_item_nota_entrada                                as 'Lote', 
--                (me.vl_custo_contabil_produto * nei.qt_item_nota_entrada)    as 'VlrCusto',
--                nei.pc_icms_nota_entrada                                     as 'pc_icms',
--                nei.vl_icms_nota_entrada                                     as 'Icms',
--                nei.pc_ipi_nota_entrada                                      as 'pc_ipi',
--                nei.vl_ipi_nota_entrada                                      as 'Ipi',       
--                nei.vl_cofins_item_nota                                      as 'Cofins',
--                nei.vl_pis_item_nota                                         as 'Pis' ,
-- --               pc.vl_custo_comissao,
-- 
--                case when 
--                     isnull(nei.vl_item_nota_entrada,0) + 
--                                       ( nei.vl_item_nota_entrada * (isnull(nei.pc_ipi_nota_entrada,0)/100)) = 0 
--                then
--                  isnull(pc.vl_custo_comissao,0)
--                else
--                  isnull(nei.vl_item_nota_entrada,0) + 
--                                      ( nei.vl_item_nota_entrada * (isnull(nei.pc_ipi_nota_entrada,0)/100))
-- 
--                end                                                          as vl_custo_comissao,
-- 
--                um.sg_unidade_medida             
--  
-- 
--     FROM       Nota_Entrada_Item nei with (nolock) left outer join
--                Nota_Entrada ne with (nolock) on ne.cd_fornecedor = nei.cd_fornecedor and
--                                   ne.cd_nota_entrada = nei.cd_nota_entrada and
--                                   ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
--                                   ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
--                left outer join
--                Movimento_Estoque me with (nolock) on me.cd_fornecedor = nei.cd_fornecedor and
--                                        me.cd_documento_movimento = cast(nei.cd_nota_entrada as varchar) and
--                                        me.cd_operacao_fiscal = nei.cd_operacao_fiscal and
--                                        me.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
--                                        me.cd_item_documento = nei.cd_item_nota_entrada and                                       
--                                        me.cd_tipo_documento_estoque = 3
--                left outer join
--                vw_destinatario vw with (nolock) ON ne.cd_tipo_destinatario = vw.cd_tipo_destinatario and ne.cd_fornecedor = vw.cd_destinatario  left outer join
--                Serie_Nota_Fiscal snf with (nolock) ON nei.cd_serie_nota_fiscal = snf.cd_serie_nota_fiscal left outer join
--                Produto p with (nolock) ON nei.cd_produto = p.cd_produto left outer join
--                Produto_Custo pc with (nolock) on pc.cd_produto = p.cd_produto left outer join
--                Grupo_Produto gp with (nolock) on gp.cd_grupo_produto = p.cd_grupo_produto left outer join
--                Tipo_Destinatario td with (nolock) ON td.cd_tipo_destinatario = ne.cd_tipo_destinatario        
--                left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida = nei.cd_unidade_medida
-- 
-- 
--  where

    select
               ne.dt_receb_nota_entrada,
               ne.dt_nota_entrada,
               nei.cd_nota_entrada, 
               nei.nm_produto_nota_entrada, 
               nei.cd_item_nota_entrada,
               nei.vl_item_nota_entrada, 
               nei.qt_item_nota_entrada,
               nei.qt_pesliq_nota_entrada,
               nei.qt_pesbru_nota_entrada,
               nei.vl_total_nota_entr_item,
               td.nm_tipo_destinatario,
               vw.nm_fantasia                                               as nm_fantasia_fornecedor, 
               snf.sg_serie_nota_fiscal, 
               dbo.fn_mascara_produto(nei.cd_produto)                       as cd_mascara_produto, 
               p.nm_fantasia_produto,
               nei.cd_lote_item_nota_entrada                                as 'Lote', 
               isnull(nei.vl_custo_nota_entrada,0)                          as vl_custo_nota_entrada,

               (nei.vl_item_nota_entrada
               +
               (nei.vl_ipi_nota_entrada/nei.qt_item_nota_entrada))

               -
               (nei.vl_icms_nota_entrada/nei.qt_item_nota_entrada)
               -

               --Cofins
               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_cofins_item_nota,0)>0
                 then
                    nei.vl_cofins_item_nota/nei.qt_item_nota_entrada  
                 else
                    nei.vl_item_nota_entrada/nei.qt_item_nota_entrada*@pc_cofins
                 end
               else
                 0.00
               end                                      

               -

               --PIS
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_pis_item_nota,0)>0 
                 then
                    nei.vl_pis_item_nota/nei.qt_item_nota_entrada  
                 else
                    nei.vl_item_nota_entrada/nei.qt_item_nota_entrada*@pc_pis
                 end
               else
                 0.00
               end                                                        as 'CustoUnitarioCalculado',
                                        
                               
               (case when isnull(me.vl_custo_contabil_produto,0)>0 and @ic_custo_estoque = 'S' then
                   me.vl_custo_contabil_produto
               else
                  case when isnull(nei.vl_custo_nota_entrada,0)>0 then
                   nei.vl_custo_nota_entrada/nei.qt_item_nota_entrada
                  else
                    nei.vl_total_nota_entr_item/nei.qt_item_nota_entrada
                  end    
               end * nei.qt_item_nota_entrada)                              as 'VlrCusto',

               nei.pc_icms_nota_entrada                                     as 'pc_icms',
               nei.vl_icms_nota_entrada                                     as 'Icms',         
               nei.pc_ipi_nota_entrada                                      as 'pc_ipi',
               nei.vl_ipi_nota_entrada                                      as 'Ipi', 
               
               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.pc_cofins_item_nota,0)>0
                 then
                    nei.pc_cofins_item_nota
                 else
                    @pc_cofins*100
                 end
               else
                 0.00
               end                                                          as 'pc_cofins',
            
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.pc_pis_item_nota,0)>0
                 then
                    nei.pc_pis_item_nota
                 else
                    @pc_pis*100
                 end
               else
                 0.00
               end                                                          as 'pc_pis',

               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_cofins_item_nota,0)>0
                 then
                    nei.vl_cofins_item_nota  
                 else
                    nei.vl_total_nota_entr_item*@pc_cofins
                 end
               else
                 0.00
               end                                                          as 'Cofins',

               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_pis_item_nota,0)>0 
                 then
                   nei.vl_pis_item_nota  
                 else
                   nei.vl_total_nota_entr_item*@pc_pis
                 end
               else
                 0.00
               end                                                          as 'Pis',
               
               case when 
                    isnull(nei.vl_item_nota_entrada,0) + 
                                      ( nei.vl_item_nota_entrada * (isnull(nei.pc_ipi_nota_entrada,0)/100)) = 0 
               then
                 isnull(pc.vl_custo_comissao,0)
               else
                 isnull(nei.vl_item_nota_entrada,0) + 
                                     ( nei.vl_item_nota_entrada * (isnull(nei.pc_ipi_nota_entrada,0)/100))

               end                                                          as vl_custo_comissao,

               opf.cd_mascara_operacao,
               opf.nm_operacao_fiscal,
               um.sg_unidade_medida,
               dp.nm_destinacao_produto,
               nei.cd_pedido_compra,
               nei.cd_item_pedido_compra,
               nei.cd_nota_saida,
               nei.cd_item_nota_saida,
               pf.cd_mascara_plano_financeiro,
               pf.nm_conta_plano_financeiro            
            

    FROM       Nota_Entrada_Item nei with (nolock) 
               left outer join
               Nota_Entrada ne  with (nolock)  
                               on ne.cd_fornecedor = nei.cd_fornecedor and
                                  ne.cd_nota_entrada = nei.cd_nota_entrada and
                                  ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
                                  ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
               left outer join
               Movimento_Estoque me with (nolock) 
                                    on me.cd_fornecedor = nei.cd_fornecedor and
                                       me.cd_documento_movimento = cast(nei.cd_nota_entrada as varchar) and
                                       me.cd_operacao_fiscal = nei.cd_operacao_fiscal and
                                       me.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                       me.cd_item_documento = nei.cd_item_nota_entrada and                                       
                                       me.cd_tipo_documento_estoque = 3
               left outer join
               vw_destinatario vw with (nolock) ON ne.cd_tipo_destinatario = vw.cd_tipo_destinatario and ne.cd_fornecedor = vw.cd_destinatario  
               left outer join Serie_Nota_Fiscal snf with (nolock) ON nei.cd_serie_nota_fiscal = snf.cd_serie_nota_fiscal 
               left outer join Produto p             with (nolock) ON nei.cd_produto = p.cd_produto 
               left outer join Produto_Custo pc      with (nolock) on pc.cd_produto = p.cd_produto 
               left outer join Grupo_Produto gp      with (nolock) on gp.cd_grupo_produto = p.cd_grupo_produto 
               left outer join Tipo_Destinatario td  with (nolock) ON td.cd_tipo_destinatario = ne.cd_tipo_destinatario        
               left outer join Operacao_Fiscal opf   with (nolock) on opf.cd_operacao_fiscal   = ne.cd_operacao_fiscal
               left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida = nei.cd_unidade_medida
               left outer join Destinacao_Produto dp with (nolock) on dp.cd_destinacao_produto = ne.cd_destinacao_produto
               left outer join Plano_Financeiro   pf with (nolock) on pf.cd_plano_financeiro   = ne.cd_plano_financeiro


  where 
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
   (p.cd_mascara_produto like  + @Mascara_Limpa + '%')

  order by 
    nei.cd_nota_entrada desc,
    vw.nm_fantasia
  end
  
