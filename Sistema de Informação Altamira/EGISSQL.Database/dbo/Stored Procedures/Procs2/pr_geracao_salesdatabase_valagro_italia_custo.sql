
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_salesdatabase_valagro_italia_custo
-------------------------------------------------------------------------------
--pr_geracao_salesdatabase_valagro_italia
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração do Banco de Dados da empresa Valagro-Itália
--
--Data             : 29.06.2009
--Alteração        : 05.08.2009
-- 02.10.2009 - Ajustes Diversos - Carlos Fernandes
-- 20.10.2009 - 
-- 31.10.2009 - Ajustes conforme as tabelas que foram ajustadas - Carlos Fernandes
-- 06.11.2009 - (%) Desconto e Preço de Lista / 
-- 05.02.2010 - Ajuste de Produtos somente com código - Carlos Fernandes
-- 02.03.2010 - Euro de Fevereiro - Carlos fernandes
--            - Buscar o preço de Custo da Tabela de Preço de Produto Importado
--              e, fazer a conversão pelo E$
-- 03.03.2010 - Ajuste do Desconto da Tabela de Preço Custo - Carlos Fernandes
-- 04.04.2010 - Novos campos conforme solicitação Ricardo - Carlos Fernandes
-- 02.06.2010 - Busca do Euro da Tabela - Carlos Fernandes - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_geracao_salesdatabase_valagro_italia_custo
@dt_inicial datetime,
@dt_final   datetime,
@vl_moeda   float = 0

as

--select * from moeda

declare @cd_moeda int

set @cd_moeda = 8         --Euro

--set @vl_moeda = 2.236500  --Euro de Maio de 2010
set @vl_moeda = 0           --Euro de Maio de 2010

select
  @vl_moeda =  case when isnull(dbo.fn_vl_moeda_periodo(8,@dt_final),0)=0 then
                  @vl_moeda
               else
                  dbo.fn_vl_moeda_periodo(8,@dt_final)
               end 

--set @vl_moeda = 2.30390  --Euro de Abril de 2010

--set @vl_moeda = 2.4076 --Euro de Março de 2010

--set @vl_moeda = 2.5653 --Euro de Fevereiro de 2010

--set @vl_moeda = 2.5545 --Euro de Janeiro de 2010

--set @vl_moeda = 2.5964 Dezembro / 2009

--set @vl_moeda = 2.5557 
--set @vl_moeda =  2.67460

--set @vl_moeda =  2.67460
--set @vl_moeda = 2.7720
--set @vl_moeda = 2.7279

--select * from migracao.dbo.['SalesDatabase]

--select * from vw_faturamento


select
  distinct
  dbo.fn_strzero(month(vw.dt_nota_saida),2)       as 'MONTH',
  vw.dt_nota_saida                                as 'DATE',
  year(vw.dt_nota_saida)                          as 'YEAR',
  vw.cd_identificacao_nota_saida                  as 'DOC',

  dbo.fn_strzero(case when isnull(c.cd_interface,0)=0 then
     c.cd_cliente
  else
     c.cd_interface
  end,6)                                          as 'CUSTCODE',

  --dbo.fn_strzero(c.cd_interface,6) as 'CUSTCODE',
  c.nm_razao_social_cliente                       as 'CUSTNAME',
  ---select * from cliente_grupo
  vw.nm_cliente_grupo                             as 'CUSTYPE',
  vw.nm_pais                                      as 'COUNTRY',
  vw.nm_cliente_regiao                            as 'AREA',
  aps.nm_aplicacao_segmento                       as 'ZONE',
  'RICARDO LUIS CASIUCH '                         as 'MAGDIREC',
  --Vendedor Interno / Gerente da Área
  --isnull(vi.nm_vendedor,vivw.nm_vendedor)         as 'AREAMAN',
  vw.nm_vendedor_interno                          as 'AREAMAN',

  --Vendedor Externo
  vw.nm_vendedor_externo                          as 'ASSISTAN',

  mp.nm_marca_produto                             as 'BRAND',
  cp.sg_categoria_produto                         as 'LOCALFAM',
  cp.sg_categoria_produto                         as 'VALAGFAM',
  cast(pimp.ds_produto_importacao as varchar(40)) as 'ROOT',
  p.cd_mascara_produto                            as 'LOCALIT',
  pimp.cd_part_number_produto                     as 'VALAGIT',
  vw.nm_produto_item_nota                         as 'DESCRIT',
  'Real (R$)'                                     as 'CURR',

  case when isnull(ina.qt_item_nota_saida,0)>0 then
     ina.qt_item_nota_saida
  else
     vw.qt_item_nota_saida                 
  end                                                     as 'QTY',

  case when isnull(ina.vl_unitario_item_nota,0)>0 then
    ina.vl_unitario_item_nota
  else
    vw.vl_unitario_item_nota                    
  end                                                     as 'PRICE',
  
  vw.vl_unitario_item_total                               as 'AMOUNT',

  @vl_moeda                                               as 'EXCH_BDG',

  
  vw.vl_unitario_item_total/@vl_moeda                     as 'AMOUNTEU',

  --Custos
  --pf.vl_unitario_custo,
  --pfe.vl_unitario_custo,
  --me.vl_custo_contabil_produto,
  --select * from tabela_preco_importacao

--   case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --tpi.vl_produto_importacao
-- 
--      ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--      
--      * 
-- 
--      case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo
          else
            --me.vl_custo_contabil_produto
            0
          end
     end
 -- end 
                                                      as 'UNITCOST',


--  vw.qt_item_nota_saida  *

  case when isnull(ina.qt_item_nota_saida,0)>0 then
     ina.qt_item_nota_saida
  else
     vw.qt_item_nota_saida                 
  end 

  *

--   case when isnull(pf.vl_unitario_custo,0)>0 then
--      pf.vl_unitario_custo
--   else case when isnull(pfe.vl_unitario_custo,0)>0 then
--      pfe.vl_unitario_custo
--      else
--        me.vl_custo_contabil_produto
--      end
--   end

--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
-- --     isnull(tpi.vl_produto_importacao,0) * 
--      ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--     *
--      case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo
          else
            --me.vl_custo_contabil_produto
            0
          end
--     end
  end
                                                           as 'TOTCOST',
--  (vw.qt_item_nota_saida 

  (case when isnull(ina.qt_item_nota_saida,0)>0 then
     ina.qt_item_nota_saida
  else
     vw.qt_item_nota_saida                 
  end

  * 

--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --isnull(tpi.vl_produto_importacao,0)
--      ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
-- 
--      --* 
--      --case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo/@vl_moeda 
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo/@vl_moeda 
          else
            --me.vl_custo_contabil_produto/@vl_moeda 
           0.00
          end
     end
  --end
   )
                                             as 'TOTCOSTE',

--   case when isnull(pf.vl_unitario_custo,0)>0 then
--      pf.vl_unitario_custo
--   else case when isnull(pfe.vl_unitario_custo,0)>0 then
--      pfe.vl_unitario_custo
--      else
--        me.vl_custo_contabil_produto
--      end
--   end )/@vl_moeda 


--  vw.vl_unitario_item_nota

  case when isnull(ina.vl_unitario_item_nota,0)>0 then
    ina.vl_unitario_item_nota
  else
    vw.vl_unitario_item_nota                    
  end

  - 

--   case when isnull(pf.vl_unitario_custo,0)>0 then
--      pf.vl_unitario_custo
--   else case when isnull(pfe.vl_unitario_custo,0)>0 then
--      pfe.vl_unitario_custo
--      else
--        me.vl_custo_contabil_produto
--      end
--   end

--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --isnull(tpi.vl_produto_importacao,0) * 
--     ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--     * 
--     case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo
          else
            --me.vl_custo_contabil_produto
            0.00
          end
     end
  --end
                                                as 'UNITMARG',

  --Margem Net R$-----------------------------------------------------------------------------------
  -- (-) Impostos

  case when isnull(ina.vl_unitario_item_nota,0)>0 then
    ina.vl_unitario_item_nota
  else
    vw.vl_unitario_item_nota                    
  end

  - 

--   case when isnull(pf.vl_unitario_custo,0)>0 then
--      pf.vl_unitario_custo
--   else case when isnull(pfe.vl_unitario_custo,0)>0 then
--      pfe.vl_unitario_custo
--      else
--        me.vl_custo_contabil_produto
--      end
--   end

--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --isnull(tpi.vl_produto_importacao,0) * 
--     ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--     * 
--     case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo
          else
            --me.vl_custo_contabil_produto
           0.00
          end
     end
  --end)                                        

  -
  --PIS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_pis/vw.qt_item_nota_saida,2)
  end
  -
  --COFINS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_cofins/vw.qt_item_nota_saida,2)
  end
  -
  --IPI
  case when isnull(vw.vl_ipi,0)>0 then
    round(vw.vl_ipi/vw.qt_item_nota_saida,2)
  else
    0.00
  end
  -
  --select * from vw_faturamento
  --ICMS
  case when isnull(vw.vl_icms_item,0)>0 then
    round(vw.vl_icms_item/vw.qt_item_nota_saida,2)
  else
    0.00
  end 
 
  as 'UNITMARGNET',


  --Total da Margem NET

 case when isnull(ina.qt_item_nota_saida,0)>0 then
     ina.qt_item_nota_saida
  else
     vw.qt_item_nota_saida                 
  end

  * (


  case when isnull(ina.vl_unitario_item_nota,0)>0 then
    ina.vl_unitario_item_nota
  else
    vw.vl_unitario_item_nota                    
  end

  - 

--   case when isnull(pf.vl_unitario_custo,0)>0 then
--      pf.vl_unitario_custo
--   else case when isnull(pfe.vl_unitario_custo,0)>0 then
--      pfe.vl_unitario_custo
--      else
--        me.vl_custo_contabil_produto
--      end
--   end

--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --isnull(tpi.vl_produto_importacao,0) * 
--     ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--     * 
--     case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo
          else
            --me.vl_custo_contabil_produto
            0.00
          end
     end
--  end)                                        

  -
  --PIS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_pis/vw.qt_item_nota_saida,2)
  end
  -
  --COFINS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_cofins/vw.qt_item_nota_saida,2)
  end
  -
  --IPI
  case when isnull(vw.vl_ipi,0)>0 then
    round(vw.vl_ipi/vw.qt_item_nota_saida,2)
  else
    0.00
  end
  -
  --select * from vw_faturamento
  --ICMS
  case when isnull(vw.vl_icms_item,0)>0 then
    round(vw.vl_icms_item/vw.qt_item_nota_saida,2)
  else
    0.00
  end )
 
  as 'TOTMARGNET',

  --Total da Margem NET em E$

  --Total da Margem NET

 case when isnull(ina.qt_item_nota_saida,0)>0 then
     ina.qt_item_nota_saida
  else
     vw.qt_item_nota_saida                 
  end

  * (


  case when isnull(ina.vl_unitario_item_nota,0)>0 then
    ina.vl_unitario_item_nota
  else
    vw.vl_unitario_item_nota                    
  end

  - 

--   case when isnull(pf.vl_unitario_custo,0)>0 then
--      pf.vl_unitario_custo
--   else case when isnull(pfe.vl_unitario_custo,0)>0 then
--      pfe.vl_unitario_custo
--      else
--        me.vl_custo_contabil_produto
--      end
--   end

--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --isnull(tpi.vl_produto_importacao,0) * 
--     ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--     * 
--     case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo
          else
            --me.vl_custo_contabil_produto
            0.00
          end
     end
--  end)                                        

  -
  --PIS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_pis/vw.qt_item_nota_saida,2)
  end
  -
  --COFINS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_cofins/vw.qt_item_nota_saida,2)
  end
  -
  --IPI
  case when isnull(vw.vl_ipi,0)>0 then
    round(vw.vl_ipi/vw.qt_item_nota_saida,2)
  else
    0.00
  end
  -
  --select * from vw_faturamento
  --ICMS
  case when isnull(vw.vl_icms_item,0)>0 then
    round(vw.vl_icms_item/vw.qt_item_nota_saida,2)
  else
    0.00
  end )

  /

  case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
 
  as 'TOTMARGNETE',


-- vw.qt_item_nota_saida  * (vw.vl_unitario_item_nota - 

 case when isnull(ina.qt_item_nota_saida,0)>0 then
     ina.qt_item_nota_saida
  else
     vw.qt_item_nota_saida                 
  end

  * (

  case when isnull(ina.vl_unitario_item_nota,0)>0 then
    ina.vl_unitario_item_nota
  else
    vw.vl_unitario_item_nota                    
  end

  -

--   case when isnull(pf.vl_unitario_custo,0)>0 then
--      pf.vl_unitario_custo
--   else case when isnull(pfe.vl_unitario_custo,0)>0 then
--      pfe.vl_unitario_custo
--      else
--        me.vl_custo_contabil_produto
--      end
--   end )                                          

--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --isnull(tpi.vl_produto_importacao,0) * 
--      ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--      *
--      case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo
          else
            --me.vl_custo_contabil_produto
            0.00
          end
     end
--  end)
)

  as 'TOTMARG',

--  vw.qt_item_nota_saida  * (vw.vl_unitario_item_nota - 

  case when isnull(ina.qt_item_nota_saida,0)>0 then
     ina.qt_item_nota_saida
  else
     vw.qt_item_nota_saida                 
  end

  * (

  case when isnull(ina.vl_unitario_item_nota,0)>0 then
    ina.vl_unitario_item_nota
  else
    vw.vl_unitario_item_nota                    
  end

  -

--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      --isnull(tpi.vl_produto_importacao,0) * 
--     ( isnull(tpi.vl_produto_importacao,0) - (isnull(tpi.vl_produto_importacao,0) * (isnull(tpi.pc_desconto_importacao,0)/100) ))
--     *
--      case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
     case when isnull(pf.vl_unitario_custo,0)>0 then
       pf.vl_unitario_custo
     else case when isnull(pfe.vl_unitario_custo,0)>0 then
            pfe.vl_unitario_custo
          else
            --me.vl_custo_contabil_produto
            0.00
          end
     end
  --end)
 )

  /

  case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 

  as 'TOTMARGE',

--   (vw.qt_item_nota_saida  * (vw.vl_unitario_item_nota - 
-- 
-- 
--   (case when isnull(tpi.vl_produto_importacao,0)>0 
--   then
--      isnull(tpi.vl_produto_importacao,0) 
--      --*
--      --case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
--   else
--      case when isnull(pf.vl_unitario_custo,0)>0 then
--        pf.vl_unitario_custo
--      else case when isnull(pfe.vl_unitario_custo,0)>0 then
--             pfe.vl_unitario_custo
--           else
--             me.vl_custo_contabil_produto
--           end
--      end
--   end)))
-- 
--   /
-- 
--   case when isnull(tpi.vl_moeda_periodo,0)>0 then tpi.vl_moeda_periodo else @vl_moeda end 
-- 
-- --   case when isnull(pf.vl_unitario_custo,0)>0 then
-- --      pf.vl_unitario_custo
-- --   else case when isnull(pfe.vl_unitario_custo,0)>0 then
-- --      pfe.vl_unitario_custo
-- --      else
-- --        me.vl_custo_contabil_produto
-- --      end
-- --   end
--   as 'TOTMARGE',

  --Vendedor Interno

--   vc.B1_COMIS2                                                                                 as 'AREMAPOR',
-- 
--   ( vw.vl_unitario_item_total  * vc.B1_COMIS2 ) / 100                                          as 'AREMACOM',
--   (( vw.vl_unitario_item_total * vc.B1_COMIS2 ) / 100 ) / @vl_moeda                            as 'AREMACEU',

  isnull(vpc.pc_comissao_prod_vendedor,0)                                                       as 'AREMAPOR',

  ( vw.vl_unitario_item_total  * isnull(vpc.pc_comissao_prod_vendedor,0) ) / 100                as 'AREMACOM',
  (( vw.vl_unitario_item_total * isnull(vpc.pc_comissao_prod_vendedor,0) ) / 100 ) / @vl_moeda  as 'AREMACEU',


  --Dirigente Interno ( não tem comissão )
   
--   vc.B1_COMIS                                                                                  as 'MANDIRCP',
-- 
--   ( vw.vl_unitario_item_total  * vc.B1_COMIS ) / 100                                           as 'MANDIRCO',
--   (( vw.vl_unitario_item_total * vc.B1_COMIS ) / 100 ) / @vl_moeda                             as 'MANDIRCE',

  0.00                                                                                        as 'MANDIRCP',

  ( vw.vl_unitario_item_total  * 0.00 ) / 100                                                 as 'MANDIRCO',
  (( vw.vl_unitario_item_total * 0.00 ) / 100 ) / @vl_moeda                                   as 'MANDIRCE',

--  '' as MANDIRCP,
--  '' as MANDIRCO,
--  '' as MANDIRCE,

--Vendedor Externo------------------------------------------------------------------------------------------

  isnull(cp.pc_comissao_cat_produto,0)                                                         as 'ASSISCOP',
  ( vw.vl_unitario_item_total  * isnull(cp.pc_comissao_cat_produto,0) ) / 100                  as 'ASSISCOM',
  (( vw.vl_unitario_item_total * isnull(cp.pc_comissao_cat_produto,0) ) / 100 ) / @vl_moeda    as 'ASSISCOE',

--   vc.B1_COMIS3                                                                             as 'ASSISCOP',
--   ( vw.qt_item_nota_saida  * vc.B1_COMIS3 ) / 100                                          as 'ASSISCOM',
--   (( vw.qt_item_nota_saida * vc.B1_COMIS3 ) / 100 ) / @vl_moeda                            as 'ASSISCOE',

-- ASSISCOP,
-- ASSISCOM,
-- ASSISCOE,

  '' as ACT_EXCH,

  dbo.fn_strzero(isnull(c.cd_filial_empresa,0),2)                                          as 'LOJA',

--   '' as VENC_1,
--   '' as VENC_2,
--   '' as VENC_3,
--   '' as VENC_4,
--   '' as VENC_5,
--   '' as VENC_6

   --select * from nota_saida_parcela

   ( select top 1 nsp.dt_parcela_nota_saida
   from
     nota_saida_parcela nsp with (nolock) 
   where
     nsp.cd_nota_saida = vw.cd_nota_saida and
     nsp.cd_parcela_nota_saida = 1 )                                                                as 'VENC_1',

   ( select top 1 nsp.dt_parcela_nota_saida
   from
     nota_saida_parcela nsp with (nolock) 
   where
     nsp.cd_nota_saida = vw.cd_nota_saida and
     nsp.cd_parcela_nota_saida = 2 )                                                                as 'VENC_2',

   ( select top 1 nsp.dt_parcela_nota_saida
   from
     nota_saida_parcela nsp with (nolock) 
   where
     nsp.cd_nota_saida = vw.cd_nota_saida and
     nsp.cd_parcela_nota_saida = 3 )                                                                as 'VENC_3',

   ( select top 1 nsp.dt_parcela_nota_saida
   from
     nota_saida_parcela nsp with (nolock) 
   where
     nsp.cd_nota_saida = vw.cd_nota_saida and
     nsp.cd_parcela_nota_saida = 4 )                                                                as 'VENC_4',

   ( select top 1 nsp.dt_parcela_nota_saida
   from
     nota_saida_parcela nsp with (nolock) 
   where
     nsp.cd_nota_saida = vw.cd_nota_saida and
     nsp.cd_parcela_nota_saida = 5 )                                                                as 'VENC_5',

   ( select top 1 nsp.dt_parcela_nota_saida
   from
     nota_saida_parcela nsp with (nolock) 
   where
     nsp.cd_nota_saida = vw.cd_nota_saida and
     nsp.cd_parcela_nota_saida = 6 )                                                                as 'VENC_6',

--    case when isnull(pvi.vl_lista_item_pedido,0)>0 then
--       isnull(pvi.vl_lista_item_pedido,0)                                                        
--    else
--       tpp.vl_tabela_produto
--    end                                                                                            

   (tpp.vl_tabela_produto
   -
--    ( 
--    case when isnull(pvi.vl_lista_item_pedido,0)>0 then
--       isnull(pvi.vl_lista_item_pedido,0)                                                        
--    else
--       tpp.vl_tabela_produto
--    end                                                                       
--    *

   tpp.vl_tabela_produto
   *
   (isnull(tp.pc_tabela_preco,0)
   /100))                                             as 'PRICE_LIST',


--    case when isnull(pvi.vl_lista_item_pedido,0)>0 and
--                 isnull(pvi.pc_desconto_item_pedido,0)>0 then
--      isnull(pvi.pc_desconto_item_pedido,0)                                                            
--    else
--      case when tpp.vl_tabela_produto>0 then
--        100-( round((pvi.vl_unitario_item_pedido/tpp.vl_tabela_produto)*100,4))
--      else
--        0
--      end
--    end  

--    100-( round((pvi.vl_unitario_item_pedido/tpp.vl_tabela_produto)*100,4))            

    100 -

        (
        round(
--        (vw.vl_unitario_item_nota

          (case when isnull(ina.vl_unitario_item_nota,0)>0 then
              ina.vl_unitario_item_nota
           else
              vw.vl_unitario_item_nota                    
           end

        /
        ( tpp.vl_tabela_produto - ( tpp.vl_tabela_produto * ( isnull(tp.pc_tabela_preco,0)/100)
                                  )
        ) * 100
        )
        ,4)
        )
                                                                          as 'PER_DISCOUNT',

   isnull(tpi.vl_produto_importacao,0)                                    as 'TRANSFER_PRICE',
   isnull(tpi.vl_produto_importacao,0)                                    as 'vl_produto_importacao',
   isnull(tpi.vl_moeda_periodo,@vl_moeda)                                 as 'vl_moeda_periodo',

--   j.VENC_1  as VENC_1,
--   j.VENC_2  as VENC_2,
--   j.VENC_3  as VENC_3,
--   cast(j.VENC_4 as datetime) as VENC_4,
--   cast(j.VENC_5 as datetime) as VENC_5,
--   cast(j.VENC_6 as datetime) as VENC_6
   isnull(vw.pc_icms,0)                                                  as 'pc_icms',
   isnull(vw.pc_ipi,0)                                                   as 'pc_ipi',
   isnull(vw.vl_icms_item,0)                                             as 'vl_icms',
   isnull(vw.vl_ipi,0)                                                   as 'vl_ipi',
   isnull(vw.vl_pis,0)                                                   as 'vl_pis',
   isnull(vw.vl_cofins,0)                                                as 'vl_cofins',

   case when isnull(ina.vl_unitario_item_nota,0)>0 then
     ina.vl_unitario_item_nota
   else
     vw.vl_unitario_item_nota                    
   end

  -

  --PIS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_pis/vw.qt_item_nota_saida,2)
  end
  -
  --COFINS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_cofins/vw.qt_item_nota_saida,2)
  end
  -
  --IPI
  case when isnull(vw.vl_ipi,0)>0 then
    round(vw.vl_ipi/vw.qt_item_nota_saida,2)
  else
    0.00
  end

  -

  --select * from vw_faturamento
  --ICMS
  case when isnull(vw.vl_icms_item,0)>0 then
    round(vw.vl_icms_item/vw.qt_item_nota_saida,2)
  else
    0.00
  end 

   as 'NET_PRICE',


   --Total Net

   vw.qt_item_nota_saida  

   *
   
   (case when isnull(ina.vl_unitario_item_nota,0)>0 then
     ina.vl_unitario_item_nota
   else
     vw.vl_unitario_item_nota                    
   end

  -

  --PIS

  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_pis/vw.qt_item_nota_saida,2)
  end

  -
  --COFINS
  case when isnull(cf.ic_base_pis_clas_fiscal,'N')='S'
  then 
    0.00
  else
    round(vw.vl_cofins/vw.qt_item_nota_saida,2)
  end

  -
  --IPI
  case when isnull(vw.vl_ipi,0)>0 then
    round(vw.vl_ipi/vw.qt_item_nota_saida,2)
  else
    0.00
  end

  -

  --select * from vw_faturamento
  --ICMS
  case when isnull(vw.vl_icms_item,0)>0 then
    round(vw.vl_icms_item/vw.qt_item_nota_saida,2)
  else
    0.00
  end )

   as 'NET_AMOUNT',

  tp.nm_tabela_preco

--select * from vw_faturamento where cd_nota_saida = 15449

from

  vw_faturamento vw                       with (nolock) 
  left outer join cliente c               with (nolock) on c.cd_cliente              = vw.cd_cliente
  --left outer join cliente_grupo cg on cg.cd_cliente_grupo = c.cd_cliente_grupo
  left outer join aplicacao_segmento aps  with (nolock) on aps.cd_aplicacao_segmento = c.cd_aplicacao_segmento
  left outer join vendedor vi             with (nolock) on vi.cd_vendedor            = c.cd_vendedor_interno
  left outer join vendedor vivw           with (nolock) on vivw.cd_vendedor          = vw.cd_vendedor_interno

  left outer join produto p               with (nolock) on p.cd_produto              = vw.cd_produto
  left outer join marca_produto mp        with (nolock) on mp.cd_marca_produto       = p.cd_marca_produto
  left outer join categoria_produto cp    with (nolock) on cp.cd_categoria_produto   = p.cd_categoria_produto
  left outer join produto_importacao pimp with (nolock) on pimp.cd_produto           = vw.cd_produto

  left outer join produto_fechamento pf   with (nolock) on pf.cd_produto             = vw.cd_produto and
                                                           pf.dt_produto_fechamento  = @dt_final and
                                                           pf.cd_fase_produto        = p.cd_fase_produto_baixa
      
  left outer join produto_fechamento pfe   with (nolock) on pfe.cd_produto             = vw.cd_produto and
                                                            pfe.dt_produto_fechamento  = @dt_final and
                                                            pfe.cd_fase_produto        = 3 --( Armazem EBA-50 )


--   left outer join movimento_estoque me    with (nolock) on cast(me.cd_documento_movimento as int ) = vw.cd_nota_saida and
--                                                            cast(me.cd_item_documento as int )      = vw.cd_item_nota_saida 
-- 

  --Vendedor Interno
  left outer join vendedor_produto_comissao vpc with (nolock) on vpc.cd_vendedor          = vw.cd_vendedor_interno and
                                                                 vpc.cd_categoria_produto = p.cd_categoria_produto


  left outer join pedido_venda_item         pvi with (nolock) on  pvi.cd_pedido_venda      = vw.cd_pedido_venda and
                                                                  pvi.cd_item_pedido_venda = vw.cd_item_pedido_venda


--  left outer join tabela_preco_produto     tpp  with (nolock) on tpp.cd_produto             = vw.cd_produto and
--                                                                 tpp.cd_tabela_preco        = c.cd_tabela_preco

   left outer join tabela_periodo_preco_produto tpp  with (nolock) on tpp.cd_produto             = vw.cd_produto     and
                                                                      tpp.cd_tabela_preco        = c.cd_tabela_preco and
                                                                      tpp.dt_inicio_tabela       = @dt_inicial       and    
                                                                      tpp.dt_final_tabela        = @dt_final

--select * from tabela_periodo_preco_produto

  left outer join tabela_preco             tp  with (nolock) on tp.cd_tabela_preco          = tpp.cd_tabela_preco
  left outer join tabela_preco_importacao  tpi with (nolock) on tpi.cd_produto              = vw.cd_produto and
                                                                tpi.dt_inicial_preco        = @dt_inicial   and
                                                                tpi.dt_final_preco          = @dt_final       

  --Itens Ajustados

  left outer join Nota_Saida_item_Ajuste ina   with (nolock) on ina.cd_nota_saida           = vw.cd_nota_saida and 
                                                                ina.cd_item_nota_saida      = vw.cd_item_nota_saida


  left outer join produto_fiscal pfis          with (nolock) on pfis.cd_produto             = p.cd_produto
  left outer join classificacao_fiscal cf      with (nolock) on cf.cd_classificacao_fiscal  = pfis.cd_classificacao_fiscal

--select * from tabela_preco_importacao
--select * from pedido_venda_item
--select * from vendedor_produto_comissao
--select * from classificacao_fiscal

--  left outer join dadosadv.dbo.sb1010 vc  on vc.b1_cod                 = p.cd_mascara_produto


--select * from categoria_produto
--select * from produto_fechamento
--select * from movimento_estoque

where
  vw.dt_nota_saida between @dt_inicial and @dt_final
  --and isnull(vw.cd_produto,0)<>0       and --somente produtos
  and isnull(vw.ic_comercial_operacao,'N')='S'
  --Status da Nota Fiscal 
  and (isnull(vw.cd_status_nota,1) = 5 or isnull(vw.cd_status_nota,1) = 1)
  and ( vw.ic_analise_op_fiscal  = 'S' )      --Verifica apenas as operações fiscais selecionadas para o BI
  and ( vw.cd_tipo_operacao_fiscal = 2 )      --and     --Desconsiderar notas de entrada

order by
  vw.dt_nota_saida

-- select 
--   sum(qt_item_nota_saida) as qtd
-- from
--   vw_faturamento vw
--   left outer join produto p               on p.cd_produto              = vw.cd_produto
--   inner join migracao.dbo.julho09  j on cast(j.DOC as int )     = vw.cd_nota_saida and
--                                                p.cd_mascara_produto    = j.LOCALIT
-- 
-- where
--   vw.dt_nota_saida between @dt_inicial and @dt_final
--   and isnull(vw.ic_comercial_operacao,'N')='S'
--   and (isnull(vw.cd_status_nota,1) = 5 or isnull(vw.cd_status_nota,1) = 1)

-- select 
--  vw.*
-- from
--   vw_faturamento vw
--   left outer join produto p               on p.cd_produto              = vw.cd_produto
--   inner join migracao.dbo.julho09  j on cast(j.DOC as int )     = vw.cd_nota_saida and
--                                                p.cd_mascara_produto    = j.LOCALIT
-- 
-- where
--   vw.dt_nota_saida between @dt_inicial and @dt_final
--   and isnull(vw.ic_comercial_operacao,'N')='S'
--   and (isnull(vw.cd_status_nota,1) = 5 or isnull(vw.cd_status_nota,1) = 1)
--   and qty <> qt_item_nota_saida

-- select 
--   j.*
-- from
--   migracao.dbo.julho09  j 
--   left outer join produto p               on p.cd_mascara_produto              = j.LOCALIT
-- where
--   cast(j.doc as int ) not in (select cd_nota_saida from   vw_faturamento vw where 
--                                                p.cd_mascara_produto    = j.LOCALIT )
-- 

