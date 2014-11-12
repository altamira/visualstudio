
----------------------------------------------------------------------------------------------------------
-- pr_calcula_custo_medio
----------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                      2004
----------------------------------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Elias Pereira da Silva
--Banco de Dados        : EgisSQL
--Objetivo              : Efetua Cálculo do Custo Médio e Lista a Consulta
--Data                  : 26/07/2004
--Atualizado            : 19/08/2004 - Passa a preencher com o custo da última entrada quando
--                                      o Lançamento de Entrada, não conter custo - ELIAS
--                                      Atualiza o vl_custo_prod_fechamento na Produto_Fechamento - ELIAS
--                      : 30/12/2004 - Acerto do Cabeçãlho - Sérgio Cardoso
--                      : 26.10.2005 - Verificação/Acertos - Carlos Fernandes
--                      : 12.11.2005 - Acertos - Carlos Fernandes
--                      : 31.07.2006 - Chamada da Rotina de Ajuste de PIS/COFINS - Carlos Fernandes
--                      : 18.12.2006 - Atualiza o Método de Valoração - Carlos Fernandes
--                      : 10.03.2007 - Unidade de Medida do Produto - Carlos Fernandes
--                      : 24.04.2007 - Analítico Mostrar apenas Entrada/Saídas do Mês - Carlos Fernandes
-- 22.12.2008 - Ajustes Diversos - Carlos Fernandes
-- 16.05.2009 - Nota Fiscal Complementar de Importação - Carlos Fernandes
-- 02.06.2009 - Ajuste da Procedure Tipo de Pedido - Carlos Fernandes
-- 03.06.2009 - Verificação do Preço Unitário Sintético - Carlos Fernandes
-- 16.06.2009 - Busca da Entrada de Importação da Nota de Saída - Carlos Fernandes
-- 18.06.2009 - Ajuste de Cálculo da Nota Fiscal Cancelada - Carlos Fernandes
-- 06.11.2009 - Nota Cancelada não pode Valorar Estoque - Carlos Fernandes
-- 03.12.2009 - Verificação da Data de Entrada da Nota - Carlos Fernandes
-- 02.02.2010 - Verificação do Número do Documento/Movimento - Carlos Fernandes
-- 04.03.2010 - Verificação de Preço Zerado - Carlos Fernandes
-- 04.06.2010 - Checagem de Atualização do Preço no Movimento de Estoque - Carlos Fernandes
-- 
----------------------------------------------------------------------------------------------------------
create procedure pr_calcula_custo_medio
@ic_parametro       int,    -- (1) - Por Produto, (2) - Por Grupo
@ic_tipo            int,    -- (1) Sintético (2) Análitico -- (3) Consistência de Saldos
@ic_atualizar_custo int,    -- (1) Sim (2) Não
@dt_inicial         datetime,
@dt_final           datetime,
@cd_produto         int,
@cd_grupo_inicial   int,
@cd_grupo_final     int,
@cd_fase_produto    int
as

  --ajuste de Pis/Cofins da Nota Fiscal de Entrada
  --Carlos 31.07.2006
  exec pr_ajuste_nota_entrada_pis_cofins_inventario 1,@dt_inicial,@dt_final,'N'

  ----------------------------------------------------------------------------------------------------------

  declare @cd_produto_processado  int
  declare @cd_movimento           int
  declare @qt_entrada             float

-- Carlos - 16.05.2009
--   declare @vl_preco_saida         decimal(25,2)
--   declare @vl_preco_entrada       decimal(25,2)

  declare @vl_preco_saida         float
  declare @vl_preco_entrada       float
  declare @vl_total_entrada       float
  declare @qt_saida               float
  declare @qt_saldo               float
  declare @vl_total_saldo         float
  declare @vl_total_saida         float
  declare @dt_movimento           datetime
  declare @vl_custo_mes           float
  declare @qt_saldo_anterior      float
  declare @vl_saldo_anterior      float
  declare @cd_produto_anterior    int
  declare @dt_fechamento_anterior datetime  
  declare @ic_ipi_custo_produto   char(1)
  declare @cd_metodo_valoracao    int 
  declare @ic_analitico_mes_custo char(1) 
  declare @ic_nf_complemento      char(1)
  declare @ic_gera_nf_complemento char(1)

  -- Busca o Código do Método de Valoração

  select
    @cd_metodo_valoracao = isnull(cd_metodo_valoracao,0)
  from
    Metodo_Valoracao with (nolock) 
  where
    isnull(ic_custo_medio_metodo,'N') = 'S'

  -- VERIFICA SE O IPI ENTRA NO CUSTO DO PRODUTO

  select 
    top 1 @ic_ipi_custo_produto   = IsNull(ic_ipi_custo_produto,'N') ,
          @ic_analitico_mes_custo = isnull(ic_analitico_mes_custo,'N'),
          @ic_gera_nf_complemento = isnull(ic_gera_nf_complemento,'N')
  from 
    Parametro_Custo with (nolock) 
  where   
    cd_empresa = dbo.fn_empresa()


  --Gera as notas de Custos/Despesas de Importação no Movimento de Estoque

  if @ic_gera_nf_complemento = 'S' 
     exec pr_gera_movimento_estoque_nota_custo_importacao @dt_inicial,@dt_final,0

  ----------------------------------------------------------------------------------------------------------



  --select @ic_analitico_mes_custo

  -- CASO TENHA ESCOLHIDO POR GRUPO E NÃO INFORMADO GRUPO INICIAL E FINAL

  if ((@ic_parametro = 2) and (@cd_grupo_inicial = 0) and (@cd_grupo_final = 0))
  begin
    set @cd_grupo_inicial = 1
    set @cd_grupo_final   = 999
  end

  -- PREENCHE O CUSTO DAS ENTRADAS DE AJUSTE QUE NÃO FORAM PREENCHIDOS
  -- ELIAS 19/08/2004

--   select
--     me.cd_tipo_movimento_estoque,
--     me.vl_custo_contabil_produto,
--     pc.vl_custo_contabil_produto,
-- 
--   valor = case when  isnull( (select top 1 mec.vl_custo_contabil_produto
--             from movimento_estoque mec with (nolock)
--                  inner join tipo_movimento_estoque tme on tme.cd_tipo_movimento_estoque = mec.cd_tipo_movimento_estoque
--                  and tme.ic_mov_tipo_movimento = 'E'
--                  and tme.ic_operacao_movto_estoque in ('A','R')
--             where mec.dt_movimento_estoque <= me.dt_movimento_estoque and
--                   mec.cd_movimento_estoque <> me.cd_movimento_estoque
--                   and mec.cd_fase_produto = me.cd_fase_produto
--                   and mec.cd_produto      = me.cd_produto
--                   and isnull(mec.ic_nf_complemento,'N') = 'N' 
-- 
--             order by mec.dt_movimento_estoque desc, 
--                      mec.cd_movimento_estoque),0) < 0 
--    then 
--       0.00
--    else 
--     isnull((select top 1 mec.vl_custo_contabil_produto
--              from movimento_estoque mec with (nolock) 
--                  inner join tipo_movimento_estoque tme on tme.cd_tipo_movimento_estoque = mec.cd_tipo_movimento_estoque
--                  and tme.ic_mov_tipo_movimento = 'E'
--                  and tme.ic_operacao_movto_estoque in ('A','R')
--             where mec.dt_movimento_estoque <= me.dt_movimento_estoque and
--                   mec.cd_movimento_estoque <> me.cd_movimento_estoque
--                   and mec.cd_fase_produto = me.cd_fase_produto
--                   and mec.cd_produto = me.cd_produto
--                   and isnull(mec.ic_nf_complemento,'N') = 'N' 
-- 
--             order by mec.dt_movimento_estoque desc, 
--                      mec.cd_movimento_estoque),0)
--    end
-- 
--   from
--     movimento_estoque me with (nolock) 
--   left outer join tipo_movimento_estoque tme  on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
--           and tme.ic_mov_tipo_movimento = 'E'
--           and tme.ic_operacao_movto_estoque in ('A','R')
--   left outer join produto p on p.cd_produto = me.cd_produto   
--   left outer join produto_custo pc on pc.cd_produto = p.cd_produto
-- 
--   where me.dt_movimento_estoque between @dt_inicial and @dt_final and 
-- --        isnull(me.vl_custo_contabil_produto,0) = 0 and
--         IsNull(me.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
--                         else IsNull(me.cd_produto,0) end and
--         IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
--                                    else IsNull(p.cd_grupo_produto,0) end 
--                                and case when @ic_parametro = 2 then @cd_grupo_final
--                                    else IsNull(p.cd_grupo_produto,0) end and
--         me.cd_fase_produto = @cd_fase_produto
--         and me.cd_tipo_movimento_estoque <> 12
-- --        and me.cd_movimento_estoque = 3476
--         and me.cd_documento_movimento not in ( select top 1 cd_nota_saida 
--                                  from
--                                    nota_saida with (nolock) 
--                                  where
--                                    cd_status_nota = 7 and 
--                                    me.cd_documento_movimento = cd_nota_saida )
-- 

  update
    movimento_estoque 
  set 
    vl_custo_contabil_produto = 

  case when  isnull((select top 1 mec.vl_custo_contabil_produto
            from movimento_estoque mec with (nolock)
                 inner join tipo_movimento_estoque tme on tme.cd_tipo_movimento_estoque = mec.cd_tipo_movimento_estoque
                 and tme.ic_mov_tipo_movimento = 'E'
                 and tme.ic_operacao_movto_estoque in ('A','R')
            where mec.dt_movimento_estoque <= me.dt_movimento_estoque and
                  mec.cd_movimento_estoque <> me.cd_movimento_estoque
                  and mec.cd_fase_produto = me.cd_fase_produto
                  and mec.cd_produto      = me.cd_produto             
                  and isnull(mec.ic_nf_complemento,'N') = 'N' 
                   
            order by mec.dt_movimento_estoque desc, 
                     mec.cd_movimento_estoque),0) < 0 then 0.00
 else 
   --pc.vl_custo_contabil_produto
    isnull((select top 1 mec.vl_custo_contabil_produto
             from movimento_estoque mec with (nolock) 
                 inner join tipo_movimento_estoque tme on tme.cd_tipo_movimento_estoque = mec.cd_tipo_movimento_estoque
                 and tme.ic_mov_tipo_movimento = 'E'
                 and tme.ic_operacao_movto_estoque in ('A','R')
            where mec.dt_movimento_estoque <= me.dt_movimento_estoque and
                  mec.cd_movimento_estoque <> me.cd_movimento_estoque
                  and mec.cd_fase_produto = me.cd_fase_produto
                  and mec.cd_produto = me.cd_produto
                  and isnull(mec.ic_nf_complemento,'N') = 'N' 

            order by mec.dt_movimento_estoque desc, 
                     mec.cd_movimento_estoque),0)

end
  from movimento_estoque me with (nolock) 
  left outer join tipo_movimento_estoque tme  on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
          and tme.ic_mov_tipo_movimento = 'E'
          and tme.ic_operacao_movto_estoque in ('A','R')
  left outer join produto p        on p.cd_produto  = me.cd_produto   
  left outer join produto_custo pc on pc.cd_produto = p.cd_produto

  where me.dt_movimento_estoque between @dt_inicial and @dt_final and 
        isnull(me.vl_custo_contabil_produto,0) = 0 and
        IsNull(me.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
                        else IsNull(me.cd_produto,0) end and
        IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
                                   else IsNull(p.cd_grupo_produto,0) end 
                               and case when @ic_parametro = 2 then @cd_grupo_final
                                   else IsNull(p.cd_grupo_produto,0) end and
        me.cd_fase_produto = @cd_fase_produto
        and me.cd_tipo_movimento_estoque <> 12
        and me.cd_documento_movimento not in ( select top 1 cd_nota_saida 
                                 from
                                   nota_saida with (nolock) 
                                 where
                                   cd_status_nota in (4,7) and 
                                   me.cd_documento_movimento = cd_nota_saida )
  
--select * from status_nota

  --select vl_custo_contabil_produto,* from movimento_estoque where cd_movimento_estoque = 3469

  -- BUSCA O CUSTO ANTERIOR DA TABELA DE PRODUTO FECHAMENTO

  select 
    g.nm_grupo_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto    as nm_produto,
    p.nm_produto             as ds_produto,
    um.sg_unidade_medida,
    p.cd_produto,
    998                      as cd_tipo_movimento,
    'X'                      as cd_entrada_saida,
    9999999                  as cd_movimento,
    pf.dt_produto_fechamento as dt_movimento,
    'Saldo '+cast(month(pf.dt_produto_fechamento) as varchar)+'/'+
             cast(year(pf.dt_produto_fechamento)  as varchar) as nm_historico,
    cast(0 as float)         as vl_unitario_movimento,
    cast(0 as float)         as qt_entrada,
    cast(0 as float       )  as vl_preco_entrada,
    cast(0 as float)         as vl_total_entrada,
    cast(0 as float)         as qt_saida,
    cast(0 as float        ) as vl_preco_saida,
    cast(0 as float)         as vl_total_saida,
    cast(pf.qt_atual_prod_fechamento as float) 
                             as qt_saldo,
  
--    0.00                     as vl_preco_saldo,

    isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) / 
         case when (isnull(pf.qt_atual_prod_fechamento,0) = 0) then 1 
              else pf.qt_atual_prod_fechamento end                                                    as vl_preco_saldo,

    cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) as float)         as vl_total_saldo,

    'N'                      as ic_nf_complemento,
    cast('' as char(1))      as ic_imposto_tipo_pedido,
    0                        as cd_documento_movimento,
    cast('' as char(1))      as ic_peps_operacao_fiscal,
    cast(0 as int )          as cd_movimento_estoque


  into #SI
  from produto_fechamento pf             with (nolock) 
       inner join produto p              with (nolock) on p.cd_produto         = pf.cd_produto 
       inner join produto_custo pc       with (nolock) on pc.cd_produto        = p.cd_produto
       left outer join grupo_produto g   with (nolock) on g.cd_grupo_produto   = p.cd_produto
       left outer join unidade_medida um with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
     
  where
        isnull(pc.ic_peps_produto,'S') = 'S' and
        IsNull(pf.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
                        else IsNull(pf.cd_produto,0) end and
        IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
                                   else IsNull(p.cd_grupo_produto,0) end 
                               and case when @ic_parametro = 2 then @cd_grupo_final
                                   else IsNull(p.cd_grupo_produto,0) end and
        pf.cd_fase_produto = @cd_fase_produto and
        pf.dt_produto_fechamento between (@dt_inicial - 1) and @dt_final   and
        isnull(pf.qt_atual_prod_fechamento,0)>0 

        --Carlos 20.09.2007
        --and isnull(pf.vl_custo_medio_fechamento,0)>0 


  -- BUSCA A MOVIMENTAÇÃO DO PERÍODO  

  select
    g.nm_grupo_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto         as nm_produto,
    p.nm_produto                  as ds_produto,
    um.sg_unidade_medida,          
    p.cd_produto,
    tme.cd_tipo_movimento_estoque as cd_tipo_movimento,
    tme.ic_mov_tipo_movimento     as cd_entrada_saida,
    me.cd_movimento_estoque       as cd_movimento,
    me.dt_movimento_estoque       as dt_movimento,
    isnull(me.nm_historico_movimento,tme.nm_tipo_movimento_estoque) as nm_historico_movimento,

    --Quantidade de Entrada-------------------------------------------------------

    case when tme.ic_mov_tipo_movimento = 'E' 
    then 
      case when (nei.cd_nota_entrada is null) or isnull(nei.cd_nota_entrada,0)=0
      then cast(isnull(me.qt_movimento_estoque,0)  as float)
      else cast(isnull(nei.qt_item_nota_entrada,0) as float) 
      end 
    else 0.00 
    end                           as qt_entrada,

    --Valor de Entrada    
    me.vl_unitario_movimento,

    case when tme.ic_mov_tipo_movimento = 'E' then 
      case when (nei.cd_nota_entrada is null) or isnull(nei.cd_nota_entrada,0)=0 
      then
         case when ((nsi.cd_nota_saida is null ) or isnull(nsi.cd_nota_saida,0)=0 )
                   
         then
            case when isnull(me.vl_custo_contabil_produto,0)>0 then
               cast(isnull(me.vl_custo_contabil_produto,0) as float)
            else
              isnull(me.vl_unitario_movimento,0)     
            end
         else
            --select * from nota_saida_item
           case when isnull(me.cd_tipo_movimento_estoque,0) <> 12 and ns.dt_nota_saida between @dt_inicial and @dt_final then 
              nsi.vl_unitario_item_nota
           else
          (case when isnull(me.vl_custo_contabil_produto,0)>0 then
             cast(isnull(me.vl_custo_contabil_produto,0) as float)
          else
            isnull(me.vl_unitario_movimento,0)    
          end

          )
           end
         end
      else cast(((case @ic_ipi_custo_produto when 'S' then
                    isnull(nei.vl_total_nota_entr_item,0)
                    + IsNull(nei.vl_ipi_nota_entrada,0)
                    - IsNull(nei.vl_icms_nota_entrada,0)
                    - IsNull(nei.vl_pis_item_nota,0)
                    - Isnull(nei.vl_cofins_item_nota,0)     
                  else
                    isnull(nei.vl_total_nota_entr_item,0)
                    - isnull(nei.vl_icms_nota_entrada,0)
--                    - IsNull(nei.vl_pis_item_nota,0)
--                    - Isnull(nei.vl_cofins_item_nota,0)     
                  end) / isnull(nei.qt_item_nota_entrada,1)) as float) 
      end
    else
          (case when isnull(me.vl_custo_contabil_produto,0)>0 then
             cast(isnull(me.vl_custo_contabil_produto,0) as float)
          else
            isnull(me.vl_unitario_movimento,0)    
          end

         * isnull(me.qt_movimento_estoque,0) )

    end                           as vl_preco_entrada, 

    case when tme.ic_mov_tipo_movimento = 'E' then 
        case when (nei.cd_nota_entrada is null) or isnull(nei.cd_nota_entrada,0)=0 
        then 
          case when ((nsi.cd_nota_saida is null ) or isnull(nsi.cd_nota_saida,0)=0 ) 
          then
            (case when isnull(me.vl_custo_contabil_produto,0)>0 then
              cast(isnull(me.vl_custo_contabil_produto,0) as float)
           else
            case when isnull(pc.vl_custo_contabil_produto,0)>0 then
              cast(isnull(pc.vl_custo_contabil_produto,0) as float)
            else 
             isnull(me.vl_unitario_movimento,0)    
            end
           end
 
          * isnull(me.qt_movimento_estoque,0) )

        else
           case when isnull(me.cd_tipo_movimento_estoque,0)<>12 and ns.dt_nota_saida between @dt_inicial and @dt_final then
              nsi.vl_total_item
            else
          (case when isnull(me.vl_custo_contabil_produto,0)>0 then
             cast(isnull(me.vl_custo_contabil_produto,0) as float)
          else
            case when isnull(pc.vl_custo_contabil_produto,0)>0 then
              cast(isnull(pc.vl_custo_contabil_produto,0) as float)
            else 
              isnull(me.vl_unitario_movimento,0)    
            end
          end

         * isnull(me.qt_movimento_estoque,0) )

           end
        end
      else cast((case @ic_ipi_custo_produto when 'S' then
               isnull(nei.vl_total_nota_entr_item,0)
               + IsNull(nei.vl_ipi_nota_entrada,0)
               - IsNull(nei.vl_icms_nota_entrada,0)
               - IsNull(nei.vl_pis_item_nota,0)
               - Isnull(nei.vl_cofins_item_nota,0)     

             else
               isnull(nei.vl_total_nota_entr_item,0)
               - isnull(nei.vl_icms_nota_entrada,0)
--               - IsNull(nei.vl_pis_item_nota,0)
--               - Isnull(nei.vl_cofins_item_nota,0)     

             end) as float) 
      end
    else
          (case when isnull(me.vl_custo_contabil_produto,0)>0 then
             cast(isnull(me.vl_custo_contabil_produto,0) as float)
          else
            isnull(me.vl_unitario_movimento,0)    
          end

         * isnull(me.qt_movimento_estoque,0) )
 
    end                                                  as vl_total_entrada,

    case when tme.ic_mov_tipo_movimento = 'S' then 
      cast(isnull(me.qt_movimento_estoque,0) as float)
    else 0.00 
    end                              as qt_saida,
    cast(0.00 as float)              as vl_preco_saida,
    cast(0 as float)                 as vl_total_saida,
    cast(0 as float)                 as qt_saldo,
    cast(0 as float)                 as vl_preco_saldo,
    cast(0 as float)                 as vl_total_saldo,
    isnull(me.ic_nf_complemento,'N') as ic_nf_complemento,

    case when tme.ic_mov_tipo_movimento = 'E' then 
      'S' 
    else
      isnull(tp.ic_imposto_tipo_pedido,'N' ) 
    end                                     as ic_imposto_tipo_pedido,
    me.cd_documento_movimento,
    isnull(opfe.ic_peps_operacao_fiscal,'S') as ic_peps_operacao_fiscal,
    me.cd_movimento_estoque
 

  into #M
  from movimento_estoque me              with (nolock) 

  --select * from produto_custo

  --Entrada
  left outer join nota_entrada_item nei  with (nolock) on nei.cd_nota_entrada      = me.cd_documento_movimento    and
                                                          nei.cd_item_nota_entrada = me.cd_item_documento         and
                                                          nei.cd_fornecedor        = me.cd_fornecedor             and
                                                          nei.cd_operacao_fiscal = isnull(me.cd_operacao_fiscal, 
                                                                                          nei.cd_operacao_fiscal) and
                                                          nei.cd_produto           = me.cd_produto

  left outer join nota_entrada ne        with (nolock) on ne.cd_nota_entrada      = nei.cd_nota_entrada and
                                                          ne.cd_fornecedor        = nei.cd_fornecedor and
                                                          ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal and
                                                          ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal



  inner join tipo_movimento_estoque tme  with (nolock) on me.cd_tipo_movimento_estoque = tme.cd_tipo_movimento_estoque and
                                                          tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto'

  inner join produto p                   with (nolock) on me.cd_produto = p.cd_produto
  inner join produto_custo pc            with (nolock) on pc.cd_produto = p.cd_produto and      
                                                          isnull(pc.ic_peps_produto,'S') = 'S'
  inner join grupo_produto g             with (nolock)      on g.cd_grupo_produto   = p.cd_grupo_produto
  left outer join Unidade_Medida um      with (nolock)      on um.cd_unidade_medida = p.cd_unidade_medida
  inner join produto_fechamento pf       with (nolock)      on pf.cd_produto      = me.cd_produto     and
                                                          pf.cd_fase_produto = @cd_fase_produto  and
                                                          pf.dt_produto_fechamento between @dt_inicial and @dt_final

  left outer join nota_saida_item nsi    with (nolock) on nsi.cd_nota_saida          = me.cd_documento_movimento and
                                                       nsi.cd_item_nota_saida     = me.cd_item_documento      and
                                                       nsi.cd_produto             = me.cd_produto             
                                                       
  left outer join nota_saida ns          with (nolock) on ns.cd_nota_saida           = nsi.cd_nota_saida
  left outer join pedido_venda pv        with (nolock) on pv.cd_pedido_venda         = nsi.cd_pedido_venda
  left outer join tipo_pedido tp         with (nolock) on tp.cd_tipo_pedido          = pv.cd_tipo_pedido

  left outer join operacao_fiscal opfe   with (nolock) on opfe.cd_operacao_fiscal    = nei.cd_operacao_fiscal

  --select * from operacao_fiscal

  where 
        IsNull(me.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
                        else IsNull(me.cd_produto,0) end and
        IsNull(p.cd_grupo_produto,0) >= case when @ic_parametro = 2 then @cd_grupo_inicial
                              else IsNull(p.cd_grupo_produto,0) end and
        IsNull(p.cd_grupo_produto,0) <= case when @ic_parametro = 2 then @cd_grupo_final
                              else IsNull(p.cd_grupo_produto,0) end and
        me.cd_fase_produto = @cd_fase_produto and
        me.dt_movimento_estoque between @dt_inicial and @dt_final
        and ( me.cd_tipo_movimento_estoque not in (12,13) ) --Cancelamento NF
          

  --Atualiza os Valores de Entrada que não atualiza o Custo Unitário

  update
    #M
  set
    vl_total_entrada      = 0,
    vl_unitario_movimento = 0,
    vl_preco_entrada      = 0
  where
    ic_peps_operacao_fiscal = 'N' and vl_total_entrada>0



--select * from #M where cd_produto = 176

--select * from nota_saida ( dt_entrada_nota_saida )

--Deleta os Documentos de Entrada no Faturamento com a Data de Entrada > Data Final
--Casos de Entrada de Importação

  delete from #M
  where
     cd_entrada_saida = 'E' AND --Movimento de Entrada
     cd_documento_movimento in ( select top 1 ns.cd_nota_saida 
                                 from
                                   nota_saida ns with (nolock) 
                                 where
                                   ns.cd_status_nota <> 7 and 
                                   cd_documento_movimento =  ns.cd_nota_saida and 
                                   ns.dt_entrada_nota_saida is not null      and
                                   ns. dt_entrada_nota_saida > @dt_final )


  --Zera os Custos Contábeis do Período

  update 
    movimento_estoque
  set
    vl_custo_contabil_produto = 0
  from
    movimento_estoque me
    inner join #M m on m.cd_movimento_estoque = me.cd_movimento_estoque
  where
     me.cd_tipo_movimento_estoque in (12,13) --Cancelamento/Ativação de Nota Fiscal
     or
     me.cd_documento_movimento in ( select top 1 ns.cd_nota_saida 
                                 from
                                   nota_saida ns with (nolock) 
                                 where
                                     ns.cd_status_nota in (4,7) and 
                                     me.cd_documento_movimento = cd_nota_saida and
                                     dt_cancel_nota_saida between @dt_inicial and @dt_final )
--Deleta as Notas Canceladas no Período
--Por que elas não devem entrar no cálculo

  delete from #M
  where
    cd_tipo_movimento in (12,13) and
    dt_movimento  between @dt_inicial and @dt_final

  delete from #M
  where
     cd_documento_movimento in ( select top 1 cd_nota_saida 
                                 from
                                   nota_saida with (nolock) 
                                 where
                                     cd_status_nota in (4,7) and 
                                     cd_documento_movimento = cd_nota_saida and 
                                     dt_cancel_nota_saida between @dt_inicial and @dt_final )

--select * from nota_saida

--select * from #M where cd_produto = 176

--        and p.cd_produto = 6

--  select * from #M

--  select * from #SI

  --Verifica se O Documento é de Saída e o Tipo de Pedido/Nota Fiscal
  --02.06.2009 ( Carlos/David )

--   delete from #M
--   where 
--     ic_imposto_tipo_pedido='N'     


--   select * from #M
 
  --Deleta os Documentos Cancelando

--   delete from #M
--   where
--      cd_documento_movimento in ( select top 1 cd_nota_saida 
--                                  from
--                                    nota_saida with (nolock) 
--                                  where
--                                    cd_status_nota in (4,7) and 
--                                    cd_documento_movimento = cd_nota_saida )



--   delete from #M
--   where
--     cd_tipo_m


  -- CARREGA O CUSTO ANTERIOR E A MOVIMENTAÇÃO EM UMA SÓ TABELA TEMPORÁRIA 
  insert into #M select * from #SI 
 
  -- CURSOR ORDENADO COM TODA A MOVIMENTAÇÃO PARA A VALORAÇÃO

  declare cCursor cursor for
  select cd_produto,    
    cd_movimento,
    dt_movimento,
    qt_entrada,
    vl_preco_entrada,
    vl_total_entrada,
    qt_saida,
    qt_saldo,
    vl_total_saldo,
    ic_nf_complemento 
  from #M 
  order by nm_produto, dt_movimento, cd_entrada_saida, cd_movimento
  
  open cCursor
  
  fetch next from cCursor into @cd_produto_processado, 
                               @cd_movimento, 
                               @dt_movimento, @qt_entrada, @vl_preco_entrada,
                               @vl_total_entrada, @qt_saida, @qt_saldo, @vl_total_saldo, @ic_nf_complemento 

  -- PRIMEIRAS VARIÁVEIS, ANTES DO LOOP  

  set @qt_saldo_anterior      = isnull(@qt_saldo,0)
  set @vl_saldo_anterior      = isnull(@vl_total_saldo,0)
  set @cd_produto_anterior    = @cd_produto_processado
  set @dt_fechamento_anterior = null  

  --select @vl_saldo_anterior
  
  while @@FETCH_STATUS = 0
  begin

    -- CASO ESTEJA MUDANDO DE PRODUTO OU DE MÊS, INICIAR AS VARIÁVEIS
    if (@cd_produto_processado  <> @cd_produto_anterior) or
      ((@dt_fechamento_anterior <> null) and
      (dbo.fn_ultimo_dia_mes(@dt_fechamento_anterior) <> dbo.fn_ultimo_dia_mes(@dt_movimento)))
    begin

      -- ATUALIZA AS VARIÁVEIS
      set @cd_produto_anterior    = @cd_produto_processado
      set @dt_fechamento_anterior = @dt_movimento
      set @qt_saldo_anterior      = isnull(@qt_saldo,0)
      set @vl_saldo_anterior      = isnull(@vl_total_saldo,0)

    end
  
    -- LIMPA VARIÁVEL DE SAÍDAS
    set @vl_preco_saida = 0.00
    set @vl_total_saida = 0.00
  
    -- VERIFICA SE HOUVE ENTRADA, E CALCULA NOVO SALDO

    if (@qt_entrada <> 0) or @ic_nf_complemento = 'S'
    begin

      if (@vl_total_entrada = 0) 
      begin
        --Carlos 30.10.2005
        --  set @vl_total_entrada = @qt_entrada * case when @vl_preco_entrada=0 then 1 else @vl_preco_entrada end

        --Verifica se Existe Movimento somente de complemento de Custo
        set @vl_total_entrada = 
          case when isnull(@qt_entrada,0)>0 then
            @qt_entrada
          else
            1
          end
          *
          case when @vl_preco_entrada=0 
            then 
              case when isnull(@vl_saldo_anterior,0)<>0 and @qt_saldo_anterior>0
                   then isnull(@vl_saldo_anterior,0)/@qt_saldo_anterior 
                   else 1 end
            else @vl_preco_entrada 
          end
            
      end
 
      set @vl_total_saldo = isnull(@vl_saldo_anterior,0) + isnull(@vl_total_entrada,0) 
      set @qt_saldo       = isnull(@qt_saldo_anterior,0) + isnull(@qt_entrada,0) 
  
      --select @vl_total_saldo

    end
    else

    -- VERIFICA SE HOUVE SAIDA, CALCULA CUSTO DA SAIDA E NOVO SALDO

    if (@qt_saida <> 0)
    begin      

      --select @qt_saldo_anterior
      --select @qt_saldo_anterior,@vl_saldo_anterior

      set @vl_preco_saida = round(isnull(@vl_saldo_anterior,0) / case when @qt_saldo_anterior = 0 
                            then 1 
                            else @qt_saldo_anterior end,6)

      set @vl_total_saida = isnull(@qt_saida,0) * isnull(@vl_preco_saida,0)

      --select @qt_saida,@vl_preco_saida,@vl_saldo_anterior,@vl_total_saida

  
      --Analisar aqui--
      --04.03.2010 ** Verificar...

      set @vl_total_saldo = isnull(@vl_saldo_anterior,0) - case when @vl_total_saida>0 and isnull(@vl_saldo_anterior,0)>@vl_total_saida then @vl_total_saida else isnull(@vl_saldo_anterior,0) end
      set @qt_saldo       = isnull(@qt_saldo_anterior,0) - case when @qt_saida>0       and @qt_saldo_anterior>@qt_saida       then @qt_saida       else @qt_saldo_anterior end    

    end
    else
    begin
      -- SE NÃO HOUVE ENTRADA E NEM SAÍDAS, ATUALIZA O SALDO 
      set @vl_total_saldo = isnull(@vl_saldo_anterior,0)
      set @qt_saldo       = isnull(@qt_saldo_anterior,0)
    end
  
    -- ATUALIZANDO A TABELA COM A NOVA VALORAÇÃO

    --select @qt_saldo,@vl_total_saldo,@vl_total_saldo / @qt_saldo

    update #M 
    set vl_preco_saida   = @vl_preco_saida,
        vl_total_saida   = @vl_total_saida,
        vl_total_entrada = @vl_total_entrada,
        qt_saldo         = @qt_saldo,
        vl_preco_saldo   = round(case when @qt_saldo <> 0 
                           then @vl_total_saldo / @qt_saldo
                           else 0 end,6),
        vl_total_saldo   = case when @qt_saldo <> 0 
                           then @vl_total_saldo 
                           else 0 end,
        vl_preco_entrada = case when isnull(qt_entrada,0)>0 and isnull(vl_preco_entrada,0)=0
                           then
                             @vl_total_entrada/qt_entrada
                           else
                             vl_preco_entrada
                           end
        
    where
      cd_produto   = @cd_produto_processado and
      cd_movimento = @cd_movimento and
      @cd_movimento <> 9999999

    -- ATUALIZANDO SOMENTE OS REGISTROS DE SALDO DA TABELA

    update #M 
    set qt_saldo       = @qt_saldo_anterior,
        vl_preco_saldo = round(case when @qt_saldo <> 0 
                         then @vl_total_saldo / @qt_saldo
                         else 0 end,6),
        vl_total_saldo = case when @qt_saldo <> 0 
                         then @vl_total_saldo
                         else 0 end

    where
      cd_produto    = @cd_produto_processado and
      cd_movimento  = @cd_movimento and
      dt_movimento  = @dt_movimento and
      @cd_movimento = 9999999  

    -- ATUALIZANDO O SALDO ANTERIOR
    set @vl_saldo_anterior      = isnull(@vl_total_saldo,0)
    set @qt_saldo_anterior      = isnull(@qt_saldo,0)
    set @dt_fechamento_anterior = @dt_movimento
                   
    fetch next from cCursor into @cd_produto_processado, @cd_movimento, @dt_movimento, @qt_entrada, @vl_preco_entrada,
                                 @vl_total_entrada, @qt_saida, @qt_saldo, @vl_total_saldo, @ic_nf_complemento
  
  end
  
  close      cCursor
  deallocate cCursor

  if (@ic_atualizar_custo = 1)
  begin

--  Mostrar a Tabela de Cálculo
--   select
--    m.vl_total_entrada,m.vl_total_saida,m.*
--   from produto_fechamento pf, #M m
--     where pf.cd_produto      = m.cd_produto and
--           pf.cd_fase_produto = @cd_fase_produto and
--           pf.dt_produto_fechamento = m.dt_movimento 

    -- ATUALIZA O PRODUTO FECHAMENTO
    update produto_fechamento set vl_custo_medio_fechamento = m.vl_total_saldo,
                                  vl_custo_prod_fechamento  = m.vl_total_saldo,
                                  qt_medio_prod_fechamento  = m.qt_saldo,
                                  vl_custo_entrada          = m.vl_total_entrada,
                                  vl_custo_saida            = m.vl_total_saida,
                                  cd_metodo_valoracao       = @cd_metodo_valoracao,
                                  vl_unitario_custo         = case when m.qt_saldo>0 then
                                                                --m.vl_total_saldo/m.qt_saldo
                                                                m.vl_preco_saldo
                                                              else
                                                                0
                                                              end
    from produto_fechamento pf, #M m
    where pf.cd_produto      = m.cd_produto and
          pf.cd_fase_produto = @cd_fase_produto and
          pf.dt_produto_fechamento = m.dt_movimento and
          m.cd_entrada_saida = 'X'
  
    -- ATUALIZA O PRODUTO CUSTO

    update produto_custo 
    set vl_custo_contabil_produto = m.vl_preco_saldo
    from 
      produto_custo pc, #M m
    where pc.cd_produto      = m.cd_produto and
          m.dt_movimento     = @dt_final and
          m.cd_entrada_saida = 'X'
  

    --select * from #M where cd_produto = 176

    -- ATUALIZA O MOVIMENTO DE ESTOQUE

    update movimento_estoque
    set vl_custo_contabil_produto = case when m.cd_entrada_saida = 'E' then
                                                               m.vl_preco_entrada
                                                             else 
                                                               m.vl_preco_saida end
    from
      movimento_estoque me, #M m
    where 
      m.cd_movimento = me.cd_movimento_estoque and
      m.cd_entrada_saida in ('E','S')

  end
 

  -- LISTA O SINTÉTICO OU ANALÍTICO

  if (@ic_tipo = 1)            -- Sintético
  begin

    select
      m.nm_grupo_produto,
      m.cd_mascara_produto,
      m.nm_produto,
      m.ds_produto,
      m.sg_unidade_medida,
      m.cd_produto,
      sum(m.qt_entrada)       as qt_entrada,      
      sum(m.vl_total_entrada) as vl_total_entrada,
      sum(m.qt_saida)         as qt_saida,
      sum(m.vl_total_saida)   as vl_total_saida,
      cast(max(pf.qt_atual_prod_fechamento) as float)                       as qt_saldo,

      --Custo Total
      cast(isnull(max(pf.vl_custo_medio_fechamento),0) / 
           case when (isnull(max(pf.qt_atual_prod_fechamento),0) = 0) then 1 
                else max(pf.qt_atual_prod_fechamento) end as float)         as vl_preco_saldo,

      cast(isnull(max(pf.vl_custo_medio_fechamento),0) as float)            as vl_total_saldo
    into #Mov
    from #M m, Produto_Fechamento pf
    where m.cd_produto             = pf.cd_produto and
          pf.cd_fase_produto       = @cd_fase_produto and
          pf.dt_produto_fechamento = @dt_final and
          m.cd_entrada_saida in ('S','E')      and
          isnull(pf.qt_atual_prod_fechamento,0)>0

    group by m.nm_grupo_produto, m.cd_mascara_produto,m.nm_produto, m.ds_produto, m.sg_unidade_medida,m.cd_produto

    -- BUSCA O CUSTO ATUAL

    select 
     g.nm_grupo_produto,
     p.cd_mascara_produto,
     p.nm_fantasia_produto as nm_produto,
     p.nm_produto          as ds_produto,
     um.sg_unidade_medida,
     p.cd_produto,
     0.00 as qt_entrada,
     0.00 as vl_total_entrada,
     0.00 as qt_saida,
     0.00 as vl_total_saida, 
     cast(pf.qt_atual_prod_fechamento as float) as qt_saldo,
     cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) / 
       case when (isnull(pf.qt_atual_prod_fechamento,0) = 0) then 1 
	    else pf.qt_atual_prod_fechamento end as float) as vl_preco_saldo,
     cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) as float) as vl_total_saldo
into #SF
from
  Produto_Fechamento pf with (nolock) inner join
  Produto p             with (nolock) on  pf.cd_produto = p.cd_produto left outer join 
  Grupo_Produto g       with (nolock) on g.cd_grupo_produto = p.cd_grupo_produto left outer join 
  produto_custo pc      with (nolock) on pc.cd_produto = pf.cd_produto   left outer join
  unidade_medida um     with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
where
      g.cd_grupo_produto             = p.cd_grupo_produto and      
      isnull(pc.ic_peps_produto,'S') = 'S' and
      IsNull(pf.cd_produto,0) not in (select IsNull(m.cd_produto,0) from #Mov m group by IsNull(cd_produto,0)) and
      IsNull(pf.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
	                 else IsNull(pf.cd_produto,0) end and
      IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
                                      else IsNull(p.cd_grupo_produto,0) end 
	                            and case when @ic_parametro = 2 then @cd_grupo_final
	                                 else IsNull(p.cd_grupo_produto,0) end and
      pf.cd_fase_produto = @cd_fase_produto and
      pf.dt_produto_fechamento = @dt_final and
      isnull(pf.qt_atual_prod_fechamento,0)>0 and
     (isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) <> 0) 

    insert into #Mov 
    select * from #SF

    select * from #Mov 
    order by nm_grupo_produto, nm_produto
    
  end

  ----------------------------------------------------------------------------------------------
  --Analítico
  ----------------------------------------------------------------------------------------------
  else 

  if (@ic_tipo = 2)
  begin

    --Delete todos os Produtos sem Movimentação no Período
    if @ic_analitico_mes_custo = 'S'
    begin
      delete from #M where isnull(qt_entrada,0)=0 and isnull(qt_saida,0)=0
    end

    select * from #M 
    order by nm_grupo_produto, nm_produto, dt_movimento, cd_entrada_saida, cd_movimento

  end

  else

  if (@ic_tipo = 3) --Consistência de Saldos
  begin
    select * from #M 
    where
       isnull(vl_total_saida,0)<0 or isnull(vl_total_entrada,0)<0 or isnull(vl_total_saldo,0)<0
    order by 
      nm_grupo_produto, 
      nm_produto, 
      dt_movimento, 
      cd_entrada_saida,
      cd_movimento
 
  end  

--  drop table #SI
--  drop table #M
--  drop table #SF
--  drop table #Mov      

