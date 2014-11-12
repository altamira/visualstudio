
-------------------------------------------------------------------------------    
--sp_helptext pr_registro_inventario_custo    
-------------------------------------------------------------------------------    
--pr_registro_inventario_custo    
-------------------------------------------------------------------------------    
--GBS Global Business Solution Ltda                                        2008    
-------------------------------------------------------------------------------    
--Stored Procedure : Microsoft SQL Server 2000    
--Autor(es)        : Carlos Cardoso Fernandes    
--Banco de Dados   : Egissql    
--Objetivo         : Registro de Inventário Custo    
--Data             : 15.09.2008    
--Alteração        : 11.11.2008 - Ajustes Diversos - Carlos Fernandes    
--02.12.2008 - Verificação da duplicidade de Produtos - Carlos Fernandes
------------------------------------------------------------------------------    
CREATE procedure pr_registro_inventario_custo    
@cd_moeda int      = 0,    
@dt_base  datetime = ''     
    
as    
    
declare @vl_moeda        float      
declare @cd_fase_produto int      

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0     
                       then 1      
                       else dbo.fn_vl_moeda(@cd_moeda) end )      


select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()

    
SELECT     
  p.cd_produto,    
  p.cd_mascara_produto,    
  p.nm_fantasia_produto,    
  p.nm_produto,    
  um.nm_unidade_medida,   
        
  --Saldo Atual do Estoque
  isnull(ps.qt_saldo_atual_produto,0) as qt_saldo_atual_produto ,    

  isnull(p.vl_produto, 0)             as PrecoVenda,    

  (isnull(p.vl_produto,0) * ps.qt_saldo_atual_produto)     
   /    
      case when p.cd_moeda<>1 then    
         isnull((select top 1 isnull(vl_moeda,1) from Valor_Moeda with (nolock) 
         where cd_moeda = @cd_moeda and dt_moeda <=@dt_base
         order by dt_moeda desc),1)    
       else    
         1    
       end as PrecoVendaTotal,    
    
  case when     
         p.cd_moeda <> 1    
       then    
         (isnull(p.vl_produto,0) * ps.qt_saldo_atual_produto) /     
         isnull((select top 1 isnull(vl_moeda,1) from Valor_Moeda with (nolock) 
                 where cd_moeda = @cd_moeda and dt_moeda <=@dt_base
                 order by dt_moeda desc),1)    
       else    
         (isnull(p.vl_produto,0) * ps.qt_saldo_atual_produto)    
       end                                                                  as total_real,    

---------------------------------------------------------------------------------------------------    
---tem que ser ajustado melhor        

--        isnull((select top 1 isnull(vm.vl_moeda,1)
--                from Valor_Moeda vm with (nolock) 
--                where vm.cd_moeda = case when vm.cd_moeda = @cd_moeda 
--                then vm.cd_moeda else @cd_moeda end 
--                                    and vm.dt_moeda <= @dt_base
--                order by vm.dt_moeda desc),1)                                as cotacao ,    

--Ajustado 29.12.2008

       isnull((select top 1 isnull(vm.vl_moeda,1)
               from Valor_Moeda vm with (nolock) 
               where 
                  vm.cd_moeda = ( case when @cd_moeda = 1 then ph.cd_moeda else @cd_moeda end ) 
                  and vm.dt_moeda <= @dt_base
               order by vm.dt_moeda desc),1)                                as cotacao ,    

---------------------------------------------------------------------------------------------------    
       cast(0.00 as float )                                                as vl_custo_previsto_produto,

--        case when @cd_moeda = 1 and ph.cd_moeda <> 1 then     
--          round(isnull(ph.vl_historico_produto, pc.vl_custo_previsto_produto)     
--          *    
--          case when isnull(ph.cd_moeda,pc.cd_moeda) = @cd_moeda   then ---    
--           1    
--         else    
-- --    
--           (select top 1 isnull(vl_moeda,1) from Valor_Moeda with (nolock) 
--            where 
--               cd_moeda = @cd_moeda and dt_moeda <= @dt_base
--            order by dt_moeda desc)    
--       
--           * case when (select top 1 isnull(vl_moeda,1) 
--                        from valor_moeda with (nolock) 
--                        where cd_moeda = ph.cd_moeda and dt_moeda <= @dt_base
--                        order by dt_moeda desc) is null then    
--             (select top 1 isnull(vl_moeda,1) from valor_moeda 
--              where cd_moeda = pc.cd_moeda and dt_moeda <= @dt_base
--              order by dt_moeda desc)    
--           else    
--             (select top 1 isnull(vl_moeda,1) from valor_moeda 
--              where cd_moeda = ph.cd_moeda and dt_moeda <= @dt_base
--              order by dt_moeda desc)    
--           end    
-- --    
--         end,4)    
--       else
--         (case when isnull(ph.vl_historico_produto,0)>0
--         then
--            --Moeda em R$ e moeda do Produto for R$
--            case when ph.cd_moeda = 1 and @cd_moeda = 1 then
--                ph.vl_historico_produto 
--            else
--                --Moeda <> R$ e moeda do Produto for diferente de R$
--                 case when @cd_moeda<>1 and ph.cd_moeda<>1   then
--                      ph.vl_historico_produto 
--                 else
--                      ph.vl_historico_produto / 
--                     (select top 1 isnull(vl_moeda,1) from valor_moeda 
--                     where cd_moeda = pc.cd_moeda and dt_moeda <= @dt_base
--                     order by dt_moeda desc)    
-- 
--                  end
--             end
--                else
--                  -- case when 
--                  case when ph.cd_moeda = 1 then
--                       isnull(pc.vl_custo_previsto_produto,0) / 
--                      (select top 1 isnull(vl_moeda,1) from valor_moeda 
--                         where cd_moeda = pc.cd_moeda and dt_moeda <= @dt_base
--                        order by dt_moeda desc)    
-- 
--                   else
--                       isnull(pc.vl_custo_previsto_produto,0) --* dbo.fn_vl_moeda_periodo(2,@dt_base)
--                   end
--             end ) 
--         
--       end                                         as vl_custo_previsto_produto,    
  
-------------------------------------------------------------------------------    
--         isnull(ps.qt_saldo_atual_produto,0)      
-- 
--         * 
--         isnull(ph.vl_historico_produto,pc.vl_custo_previsto_produto)    
--         *    
--         case when ph.cd_moeda = 1 then    
--           (select top 1 isnull(vl_moeda,1) from Valor_Moeda 
--           where cd_moeda = @cd_moeda and dt_moeda <= @dt_base
--           order by dt_moeda desc)    
--         else    
--            1    
--         end                                          as CustoMoeda,    

      cast(0.00 as float )                              as CustoMoeda,

------------------------------------------------------------------------------------------------------------------------    
--         case when isnull(ph.cd_moeda,pc.cd_moeda) = @cd_moeda   then ---    
--           isnull(ps.qt_saldo_atual_produto,0)      
--           * isnull(ph.vl_historico_produto,pc.vl_custo_previsto_produto )    
--         else    
--           isnull(ps.qt_saldo_atual_produto,0)      
--           * isnull(ph.vl_historico_produto,pc.vl_custo_previsto_produto )    
--           *     
--           (select top 1 isnull(vl_moeda,1) from Valor_Moeda 
--            where cd_moeda = @cd_moeda and dt_moeda <= @dt_base
--            order by dt_moeda desc)      
--           * case when (select top 1 isnull(vl_moeda,1) from valor_moeda 
--                        where cd_moeda = ph.cd_moeda and dt_moeda <= @dt_base
--                        order by dt_moeda desc) is null then    
--               (select top 1 isnull(vl_moeda,1) from valor_moeda 
--                where cd_moeda = pc.cd_moeda and dt_moeda <= @dt_base
--                order by dt_moeda desc)    
--             else    
--               (select top 1 isnull(vl_moeda,1) from valor_moeda 
--                where cd_moeda = ph.cd_moeda and dt_moeda <= @dt_base
--                order by dt_moeda desc)    
--             end    
--          end                                         as TotalCusto,

        cast(0.00 as float)                             as TotalCusto,
        isnull(ph.cd_moeda,pc.cd_moeda)                 as cd_moeda,
        m.sg_moeda,
        case when isnull(ph.vl_historico_produto,0)<>0 
        then
           isnull(ph.vl_historico_produto,0)
        else
           isnull(pc.vl_custo_previsto_produto,0)
        end                                             as vl_historico_produto,
        isnull(pc.vl_custo_previsto_produto,0)          as vl_custo_previsto_cadastro,
        isnull(pc.vl_custo_produto,0)                   as vl_custo_produto

into
  #InventarioCusto                                      

-------------------------------------------------------------------------------------------------------------------------    

FROM     
  Produto p                               with (nolock)     
  INNER JOIN PRODUTO_SALDO ps             with (nolock) ON ps.cd_produto                = p.cd_produto    and
                                                           ps.cd_fase_produto           = 
                                                           case when isnull(p.cd_fase_produto_baixa,0)>0 then
                                                              p.cd_fase_produto_baixa else @cd_fase_produto end 

  LEFT OUTER JOIN Unidade_Medida um       with (nolock) ON um.cd_unidade_medida         = p.cd_unidade_medida    
  left outer join produto_custo pc        with (nolock) on pc.cd_produto                = p.cd_produto    
  left outer join grupo_produto_custo gpc with (nolock) on gpc.cd_grupo_produto         = p.cd_grupo_produto    
  LEFT OUTER JOIN produto_historico ph    with (nolock) on ph.cd_produto                = p.cd_produto          and     
                                                           --ph.dt_historico_produto      = @dt_base              and    
                                                           ph.dt_historico_produto = 
                                                           (select
                                                              max(phx.dt_historico_produto) 
                                                            from
                                                              produto_historico phx
                                                            where
                                                              phx.dt_historico_produto <= @dt_base    and
                                                              phx.cd_produto           = p.cd_produto and
                                                              phx.ic_tipo_historico_produto = 'C' ) and      
                                                            --order by
                                                            --  phx.dt_historico_produto desc ) and
  
                                                           ph.ic_tipo_historico_produto = 'C'    

  left outer join Moeda m                 with (nolock) on m.cd_moeda                   = ph.cd_moeda
WHERE    
  ( isnull(ps.qt_saldo_atual_produto,0) > 0 )    
  and p.CD_CATEGORIA_PRODUTO NOT IN (6,7)    
  and isnull(gpc.cd_grupo_estoque,0) > 0    

ORDER BY    
  p.nm_produto    

--Cálculo do Inventário

update
  #InventarioCusto

set

  vl_custo_previsto_produto = 

  round(   case when @cd_moeda = 1 and cd_moeda <> 1
     then     
        isnull(vl_historico_produto,0)
        *    
        case when cd_moeda = @cd_moeda 
        then ---    
          1.00    
        else    
          cotacao
        end
     else
      --Moeda Estrangeira
      (case when isnull(vl_historico_produto,0)>0
       then
         --Moeda em R$ e moeda do Produto for R$
         case when cd_moeda = 1 and @cd_moeda = 1 
         then
           isnull(vl_historico_produto,0) 
         else
           --Moeda <> R$ e moeda do Produto for diferente de R$
             case when @cd_moeda<>1 and cd_moeda<>1   then
                  vl_historico_produto 
             else
                  vl_historico_produto / cotacao
             end
         end
         else
             case when cd_moeda = 1 and @cd_moeda <> 1 
             then
                 isnull(vl_custo_previsto_cadastro,0) / cotacao
             else
                 isnull(vl_custo_previsto_cadastro,0) --* dbo.fn_vl_moeda_periodo(2,@dt_base)
             end
      end ) 
         
  end,4),
    
  CustoMoeda = 
     round(isnull(qt_saldo_atual_produto,0)
     *
     case when @cd_moeda = 1 and cd_moeda <> 1
     then     
        vl_historico_produto
        *    
        case when cd_moeda = @cd_moeda 
        then ---    
          1    
        else    
          cotacao
        end
     else
      (case when isnull(vl_historico_produto,0)>0
       then
         --Moeda em R$ e moeda do Produto for R$
         case when cd_moeda = 1 and @cd_moeda = 1 
         then
           vl_historico_produto 
         else
           --Moeda <> R$ e moeda do Produto for diferente de R$
             case when @cd_moeda<>1 and cd_moeda<>1   then
                  vl_historico_produto 
             else
                  vl_historico_produto / cotacao
             end
         end
         else
             case when cd_moeda = 1
             then
                 isnull(vl_custo_previsto_cadastro,0) / cotacao
             else
                 isnull(vl_custo_previsto_cadastro,0) --* dbo.fn_vl_moeda_periodo(2,@dt_base)
             end
      end ) 
         
  end,4),     

  TotalCusto = 
     round(isnull(qt_saldo_atual_produto,0)
     *
     case when @cd_moeda = 1 and cd_moeda <> 1
     then     
        vl_historico_produto
        *    
        case when cd_moeda = @cd_moeda 
        then ---    
          1    
        else    
          cotacao
        end
     else
      (case when isnull(vl_historico_produto,0)>0
       then
         --Moeda em R$ e moeda do Produto for R$
         case when cd_moeda = 1 and @cd_moeda = 1 
         then
           vl_historico_produto 
         else
           --Moeda <> R$ e moeda do Produto for diferente de R$
             case when @cd_moeda<>1 and cd_moeda<>1   then
                  vl_historico_produto 
             else
                  vl_historico_produto / cotacao
             end
         end
         else
             case when cd_moeda = 1
             then
                 isnull(vl_custo_previsto_cadastro,0) / cotacao
             else
                 isnull(vl_custo_previsto_cadastro,0) --* dbo.fn_vl_moeda_periodo(2,@dt_base)
             end
      end ) 
         
  end,2)     

-- 
--         * 
--         isnull(ph.vl_historico_produto,pc.vl_custo_previsto_produto)    
--         *    
--         case when ph.cd_moeda = 1 then    
--           (select top 1 isnull(vl_moeda,1) from Valor_Moeda 
--           where cd_moeda = @cd_moeda and dt_moeda <= @dt_base
--           order by dt_moeda desc)    
--         else    
--            1    
--         end                                          as CustoMoeda,    



    
from
  #InventarioCusto


--Mostra a Tabela do Inventário

select
  *
from
  #InventarioCusto
order by
  nm_produto

