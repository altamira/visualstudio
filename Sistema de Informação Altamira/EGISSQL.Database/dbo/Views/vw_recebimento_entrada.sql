
CREATE VIEW vw_recebimento_entrada
------------------------------------------------------------------------------------
--sp_helptext vw_recebimento_entrada
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernadnes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Notas Fiscais de Entrada
--Data                  : 22.10.2008
--Atualização           : 
------------------------------------------------------------------------------------
as


    SELECT     
               ne.dt_receb_nota_entrada,
               ne.dt_nota_entrada,
               nei.cd_nota_entrada, 
               nei.cd_produto,
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
                 nei.vl_cofins_item_nota/nei.qt_item_nota_entrada  
               else
                 0.00
               end                                      

               -

               --PIS
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 nei.vl_pis_item_nota/nei.qt_item_nota_entrada  
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
                 nei.vl_cofins_item_nota/nei.qt_item_nota_entrada  
               else
                 0.00
               end                                      

               -

               --PIS
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 nei.vl_pis_item_nota/nei.qt_item_nota_entrada  
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
                 nei.pc_cofins_item_nota
               else
                 0.00
               end                                                          as 'pc_cofins',
            
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 nei.pc_pis_item_nota
               else
                 0.00
               end                                                          as 'pc_pis',

               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                  nei.vl_cofins_item_nota  
               else
                 0.00
               end                                                          as 'Cofins',

               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 nei.vl_pis_item_nota  
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
               nei.cd_item_nota_saida            

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


 
