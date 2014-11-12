
---------------------------------------------------------------
-- pr_calcula_custo_medio_fracionado
---------------------------------------------------------------
--GBS - Global Business Solution Ltda                      2004
---------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Daniel C. Neto.
--Banco de Dados        : EgisSQL
--Objetivo              : Efetua Cálculo do Custo Médio Fracionado e Lista a Consulta
--Data                  : 13/11/2006
--Atualizado            : 31.07.2006 - Chamada da Rotina de Ajuste de PIS/COFINS - Carlos Fernandes
--                        14/11/2006 - Incluído rotina para separação de produtos orignais e fracionados,
-- incluído rotina para cálculo, ao final da consulta para exibir o valor dos produtos originais de acordo
-- com a fórmula passada pelo Salvatore:
-- custo medio fracionado = custo medio do produto original * fator de conversao do produto fracionado
--                        - Daniel C. Neto.
--                      : 18.12.2006 - Atualização na Tabela Produto Fechamento
--                      : 06.12.2007 - Verificação do Cálculo - Carlos Fernandes
-- 08.09.2008 - Valoração do Custo de Entrada direto do Movimento de Estoque - Carlos Fernandes
----------------------------------------------------------------------------------------------------------
-- PARA FAZER QUANDO TIVER TEMPO:
-- Eliminar o processo de cálculo de custo médio para produtos fracionados pois não há notas de entrada
-- para eles. Deixar os cálculos iniciais somente com os originais e, ao final, fazer o proporcional
-- do valor para os fracionados.
-- 21.06.2010 - Parâmetro para Valor de Arredondamento - Carlos Fernandes
----------------------------------------------------------------------------------------------------------

create procedure pr_calcula_custo_medio_fracionado
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

-- update produto_fechamento
-- set
--  vl_custo_medio_fechamento = 0,
--  vl_custo_prod_fechamento  = 0

  --ajuste de Pis/Cofins da Nota Fiscal de Entrada
  --Carlos 31.07.2006
  exec pr_ajuste_nota_entrada_pis_cofins_inventario 1,@dt_inicial,@dt_final,'N'

  ----------------------------------------------------------------------------------------------------------

  declare @cd_produto_processado  int
  declare @cd_movimento           int
  declare @qt_entrada             decimal(25,4) 
  declare @vl_preco_entrada       decimal(25,2)
  declare @vl_total_entrada       decimal(25,2)
  declare @qt_saida               decimal(25,4)
  declare @vl_preco_saida         decimal(25,2)
  declare @qt_saldo               decimal(25,4)
  declare @vl_total_saldo         decimal(25,2)
  declare @vl_total_saida         decimal(25,2)
  declare @dt_movimento           datetime
  declare @vl_custo_mes           decimal(25,2)
  declare @qt_saldo_anterior      decimal(25,4)
  declare @vl_saldo_anterior      decimal(25,2)
  declare @cd_produto_anterior    int
  declare @dt_fechamento_anterior datetime  
  declare @ic_ipi_custo_produto   char(1)
  declare @qt_produto_embalagem   decimal(25,2)
  declare @CustoEmbalagem         decimal(25,2)
  declare @cd_metodo_valoracao    int 

  -- Busca o Código do Método de Valoração

  select
    @cd_metodo_valoracao = isnull(cd_metodo_valoracao,0)
  from
    Metodo_Valoracao with (nolock) 
  where
    isnull(ic_custo_medio_metodo,'N') = 'S'

  -- VERIFICA SE O IPI ENTRA NO CUSTO DO PRODUTO

  select 
    top 1 @ic_ipi_custo_produto = IsNull(ic_ipi_custo_produto,'N') 
  from 
    Parametro_Custo with (nolock) 
  where   
    cd_empresa = dbo.fn_empresa()

  -- CASO TENHA ESCOLHIDO POR GRUPO E NÃO INFORMADO GRUPO INICIAL E FINAL

  if ((@ic_parametro = 2) and (@cd_grupo_inicial = 0) and (@cd_grupo_final = 0))
  begin
    set @cd_grupo_inicial = 1
    set @cd_grupo_final   = 999
  end

--Apenas Cria a Tabela Vazia

--Print 'Lista os Produtos EO'

select
	p.cd_produto             as Codigo,
	p.nm_fantasia_produto    as Fantasia,
	cast(0   as int )        as cd_produto_fracionado,
	cast(' ' as varchar(30)) as fantasiafracionado,
	cast(0   as int )        as cd_produto_embalagem,
	cast(1.0000 as float )   as qt_produto_embalagem
into #AuxProduto
from 
   Produto p with (nolock) 
   LEFT join Produto_Fracionamento pf  with (nolock) on pf.cd_produto_fracionado = p.cd_produto
                                                        and pf.cd_produto       <> p.cd_produto

where
	p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end 
	-- retira os Fracionado Caso seja @ic_tipo_produto 1 ou 2
   and isnull(pf.cd_produto_fracionado, 0) = 0

--select * from #AuxProduto order by Fantasia

---------------------------------------------------------------------------------------------------------------------
--Produtos Fracionados
---------------------------------------------------------------------------------------------------------------------

--Print 'Lista os Produtos Fracionados'

--Lista Apenas os Fracionados Caso @ic_tipo_produto = 1 ou 2

select 
  p.cd_produto                           as Codigo,
  p.nm_fantasia_produto                  as Fantasia,
  pf.cd_produto_fracionado,
  cast(case when px.nm_fantasia_produto is null 
       then isnull(p.nm_fantasia_produto,'') 
       else isnull(px.nm_fantasia_produto,'') 
  end as varchar(30) )                   as fantasiafracionado,
  isnull(te.cd_produto,0)                as cd_produto_embalagem,
  isnull(pf.qt_produto_fracionado,0)     as qt_produto_embalagem

into 
  #ProdutoFracionado

from 
  Produto p                            with (nolock) 
  inner join Produto_Fracionamento pf  with (nolock) on pf.cd_produto           = p.cd_produto
  left outer join Produto px           with (nolock) on px.cd_produto           = pf.cd_produto_fracionado
  left outer join Tipo_Embalagem    te with (nolock) on te.cd_tipo_embalagem    = pf.cd_tipo_embalagem
where
  isnull(p.cd_produto,0) = (CASE WHEN @cd_produto = 0 THEN    
                       					p.cd_produto       
                     				ELSE       
                       					@cd_produto       
                     				END)
  and
        IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
                                   else IsNull(p.cd_grupo_produto,0) end 
                               and case when @ic_parametro = 2 then @cd_grupo_final
                                   else IsNull(p.cd_grupo_produto,0) end   
  --and 1 <> 1

order by
  p.cd_produto 


--select * from  #ProdutoFracionado


--Print 'Junção das Tabelas Produto'

insert into #AuxProduto 
  select * from #Produtofracionado


select 
  a.Codigo,
  a.Fantasia,
  a.cd_produto_fracionado,
  a.FantasiaFracionado,
  cd_produto           = case when isnull(a.cd_produto_fracionado,0) = 0 then a.Codigo               else a.cd_produto_fracionado  end,
  cd_produto_embalagem = case when isnull(a.cd_produto_embalagem,0) <> 0 then a.cd_produto_embalagem else te.cd_produto            end,
  qt_produto_embalagem = case when isnull(a.qt_produto_embalagem,0) <> 0 then a.qt_produto_embalagem else pf.qt_produto_fracionado end

into 
  #Produto  

from 
  #AuxProduto a
  left outer join Produto_Fracionamento pf on pf.cd_produto_fracionado = case when a.cd_produto_fracionado = 0 then a.codigo else a.cd_produto_fracionado end
                                              and pf.cd_produto           <> a.codigo

  left outer join Tipo_Embalagem        te on te.cd_tipo_embalagem     = pf.cd_tipo_embalagem

order by 
   a.Codigo

--select * from #Produto

----------------------------------------------------------------------------------------
--Cálculo de Faturamento / Entrada do Produto
----------------------------------------------------------------------------------------
  
SELECT     
  p.cd_grupo_produto,
  p.cd_produto,    
  dbo.fn_mascara_produto(p.cd_produto)    as   cd_mascara_produto,     
  p.nm_fantasia_produto,    
  p.nm_produto,    
  um.sg_unidade_medida,    
  case when isnull(pf.cd_produto_fracionado,0)<> 0 then 'S'
                                                   else 'N' end as Fracionado,

  (Select pp.cd_produto from Produto pp with (nolock) 
   where pp.cd_produto = case when isnull(pf.cd_produto_fracionado,0)<> 0 then isnull(pf.cd_produto,0) else isnull(p.cd_produto,0) end) as Principal
	
Into    
 #TmpCpvEspecial    

FROM     
  Produto p                                 with (nolock)   
  LEFT OUTER JOIN  Unidade_Medida um        with (nolock) on p.cd_unidade_medida      = um.cd_unidade_medida    
  LEFT OUTER JOIN  Produto_Custo pc         with (nolock) on p.cd_produto             = pc.cd_produto    
  LEFT OUTER JOIN  Produto_Fracionamento pf with (nolock) on pf.cd_produto_fracionado = p.cd_produto
                                                             and pf.cd_produto           <> p.cd_produto
  
WHERE    
	--Produ ou FRacionados depende do parametro @ic_tipo_produto
   (isnull(p.cd_produto,0) = (CASE WHEN @cd_produto = 0 THEN    
                       					p.cd_produto       
                     				ELSE       
                       					@cd_produto       
                     				END)
	or isnull(p.cd_produto,0) in (select cd_produto from #produto)
 )
and   
        IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
                                   else IsNull(p.cd_grupo_produto,0) end 
                               and case when @ic_parametro = 2 then @cd_grupo_final
                                   else IsNull(p.cd_grupo_produto,0) end    
-- AND isnull(p.cd_categoria_produto, 0) <> 6     
  
  
 AND isnull(p.cd_STATUS_produto, 0) <> 2  

--select * from  #TmpCpvEspecial    


Select 

  c.*,

  --Custo Direto da Nota Fiscal de Entrada - ( Temos que tirar o ICMS )  

  dbo.fn_vl_liquido_custo('F',IsNull((select top 1(IsNull(nei.vl_item_nota_entrada,0))     
          from nota_entrada_item nei    with (nolock)    
          inner join nota_entrada ne    with (nolock) on ne.cd_nota_entrada      = nei.cd_nota_entrada      and
                                                         ne.cd_fornecedor        = nei.cd_fornecedor        and
                                                         ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                                         ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal    
          inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          where 
              nei.cd_produto = p.cd_produto_embalagem and 
              isnull(opf.ic_comercial_operacao,'N')='S'
              and nei.dt_item_receb_nota_entrad <= @dt_final

          order by 
              nei.dt_item_receb_nota_entrad desc),0),

          IsNull((select top 1 (IsNull(nei.pc_icms_nota_entrada,18))     
          from nota_entrada_item nei     with (nolock) 
          inner join nota_entrada ne     with (nolock) on ne.cd_nota_entrada         = nei.cd_nota_entrada and
                                                      ne.cd_fornecedor           = nei.cd_fornecedor      and
                                                      ne.cd_serie_nota_fiscal    = nei.cd_serie_nota_fiscal and
                                                      ne.cd_operacao_fiscal      = nei.cd_operacao_fiscal    
          inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          where nei.cd_produto = p.cd_produto_embalagem 
                and isnull(opf.ic_comercial_operacao,'N')='S' 
                and nei.dt_item_receb_nota_entrad <= @dt_final

          order by 
                nei.dt_item_receb_nota_entrad desc),18),0,0,@dt_inicial,'S','N') as 'CustoEmbalagem',



  --isnull( (select vl_custo_produto from Produto_Custo where cd_produto = p.cd_produto_embalagem),0) as 'CustoEmbalagem',
                       
  p.qt_produto_embalagem,
  p.cd_produto_embalagem,

  --Custo Direto da Nota Fiscal de Entrada - ( Temos que tirar o ICMS )  

  dbo.fn_vl_liquido_custo('F',IsNull((select top 1(IsNull(nei.vl_item_nota_entrada,0))     
          from nota_entrada_item nei    with (nolock)    
          inner join nota_entrada ne    with (nolock) on ne.cd_nota_entrada      = nei.cd_nota_entrada      and
                                                         ne.cd_fornecedor        = nei.cd_fornecedor        and
                                                         ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                                         ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal    
          inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          where 
              nei.cd_produto = p.cd_produto and 
              isnull(opf.ic_comercial_operacao,'N')='S'
              and nei.dt_item_receb_nota_entrad <= @dt_final 

          order by 
              nei.dt_item_receb_nota_entrad desc),0),
          IsNull((select top 1 (IsNull(nei.pc_icms_nota_entrada,18))     
          from nota_entrada_item nei     with (nolock) 
          inner join nota_entrada ne     with (nolock) on ne.cd_nota_entrada     = nei.cd_nota_entrada and
                                                      ne.cd_fornecedor           = nei.cd_fornecedor      and
                                                      ne.cd_serie_nota_fiscal    = nei.cd_serie_nota_fiscal and
                                                      ne.cd_operacao_fiscal      = nei.cd_operacao_fiscal    
          inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          where nei.cd_produto = p.cd_produto
                and isnull(opf.ic_comercial_operacao,'N')='S' 
                and nei.dt_item_receb_nota_entrad <= @dt_final
          order by 
                nei.dt_item_receb_nota_entrad desc),18),0,0,@dt_inicial,'S','N') as 'CustoOriginal'



into #ProdutoOriginal 
from 
  #Produto p 
  inner join #TmpCpvEspecial c on p.cd_produto = c.cd_produto
--where Fracionado = 'N'

order by 
  p.codigo


--select * from #ProdutoOriginal

  -- PREENCHE O CUSTO DAS ENTRADAS DE AJUSTE QUE NÃO FORAM PREENCHIDOS
  -- ELIAS 19/08/2004

  update 
    movimento_estoque
  set 
    vl_custo_contabil_produto = 

  case when  isnull((select top 1 isnull(mec.vl_custo_contabil_produto,0)
            from movimento_estoque mec with (nolock) 
                 join tipo_movimento_estoque tme on tme.cd_tipo_movimento_estoque = mec.cd_tipo_movimento_estoque
                 and tme.ic_mov_tipo_movimento = 'E'
                 and tme.ic_operacao_movto_estoque in ('A','R')
            where mec.dt_movimento_estoque <= me.dt_movimento_estoque and
                  mec.cd_movimento_estoque <> me.cd_movimento_estoque
                  and mec.cd_fase_produto = me.cd_fase_produto
                  and mec.cd_produto = me.cd_produto
            order by mec.dt_movimento_estoque desc, 
                     mec.cd_movimento_estoque),0) < 0 then 0 else 
           isnull((select top 1 mec.vl_custo_contabil_produto
            from movimento_estoque mec
                 join tipo_movimento_estoque tme on tme.cd_tipo_movimento_estoque = mec.cd_tipo_movimento_estoque
                 and tme.ic_mov_tipo_movimento = 'E'
                 and tme.ic_operacao_movto_estoque in ('A','R')
            where mec.dt_movimento_estoque <= me.dt_movimento_estoque and
                  mec.cd_movimento_estoque <> me.cd_movimento_estoque
                  and mec.cd_fase_produto = me.cd_fase_produto
                  and mec.cd_produto = me.cd_produto
            order by mec.dt_movimento_estoque desc, 
                     mec.cd_movimento_estoque),0)
  end
  from movimento_estoque me with (nolock) 
       join tipo_movimento_estoque tme
       on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
          and tme.ic_mov_tipo_movimento = 'E'
          and tme.ic_operacao_movto_estoque in ('A','R')
       join #ProdutoOriginal p on p.cd_produto = me.cd_produto   
  where me.dt_movimento_estoque between @dt_inicial and @dt_final and 
        isnull(me.vl_custo_contabil_produto,0) = 0 and
        IsNull(me.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
                        else IsNull(me.cd_produto,0) end and
        IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
                                   else IsNull(p.cd_grupo_produto,0) end 
                               and case when @ic_parametro = 2 then @cd_grupo_final
                                   else IsNull(p.cd_grupo_produto,0) end and
        me.cd_fase_produto = @cd_fase_produto
  

--   select
-- 
--     vl_custo_contabil_produto = 
-- 
--   case when  isnull((select top 1 isnull(mec.vl_custo_contabil_produto,0)
--             from movimento_estoque mec with (nolock) 
--                  join tipo_movimento_estoque tme on tme.cd_tipo_movimento_estoque = mec.cd_tipo_movimento_estoque
--                  and tme.ic_mov_tipo_movimento = 'E'
--                  and tme.ic_operacao_movto_estoque in ('A','R')
--             where mec.dt_movimento_estoque <= me.dt_movimento_estoque and
--                   mec.cd_movimento_estoque <> me.cd_movimento_estoque
--                   and mec.cd_fase_produto = me.cd_fase_produto
--                   and mec.cd_produto = me.cd_produto
--             order by mec.dt_movimento_estoque desc, 
--                      mec.cd_movimento_estoque),0) < 0 then 0 else 
--            isnull((select top 1 mec.vl_custo_contabil_produto
--             from movimento_estoque mec
--                  join tipo_movimento_estoque tme on tme.cd_tipo_movimento_estoque = mec.cd_tipo_movimento_estoque
--                  and tme.ic_mov_tipo_movimento = 'E'
--                  and tme.ic_operacao_movto_estoque in ('A','R')
--             where mec.dt_movimento_estoque <= me.dt_movimento_estoque and
--                   mec.cd_movimento_estoque <> me.cd_movimento_estoque
--                   and mec.cd_fase_produto = me.cd_fase_produto
--                   and mec.cd_produto = me.cd_produto
--             order by mec.dt_movimento_estoque desc, 
--                      mec.cd_movimento_estoque),0)
--   end
--   from movimento_estoque me with (nolock) 
--        join tipo_movimento_estoque tme
--        on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
--           and tme.ic_mov_tipo_movimento = 'E'
--           and tme.ic_operacao_movto_estoque in ('A','R')
--        join #ProdutoOriginal p on p.cd_produto = me.cd_produto   
--   where me.dt_movimento_estoque between @dt_inicial and @dt_final and 
--         isnull(me.vl_custo_contabil_produto,0) = 0 and
--         IsNull(me.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
--                         else IsNull(me.cd_produto,0) end and
--         IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
--                                    else IsNull(p.cd_grupo_produto,0) end 
--                                and case when @ic_parametro = 2 then @cd_grupo_final
--                                    else IsNull(p.cd_grupo_produto,0) end and
--         me.cd_fase_produto = @cd_fase_produto
--   

  -- BUSCA O CUSTO ANTERIOR DA TABELA DE PRODUTO FECHAMENTO

  select 
    g.nm_grupo_produto,
    p.nm_fantasia_produto    as nm_produto,
    p.nm_produto             as ds_produto,
    p.cd_produto,
    998                      as cd_tipo_movimento,
    'X'                      as cd_entrada_saida,
    9999999                  as cd_movimento,
    pf.dt_produto_fechamento as dt_movimento,
    'Saldo '+cast(month(pf.dt_produto_fechamento) as varchar)+'/'+
             cast(year(pf.dt_produto_fechamento) as varchar) as nm_historico,
    cast(0 as decimal(25,4)) as qt_entrada,
    cast(0 as decimal(25,2)) as vl_preco_entrada,
    cast(0 as decimal(25,2)) as vl_total_entrada,
    cast(0 as decimal(25,4)) as qt_saida,
    cast(0 as decimal(25,2)) as vl_preco_saida,
    cast(0 as decimal(25,2)) as vl_total_saida,
    cast(pf.qt_atual_prod_fechamento as decimal(25,4)) as qt_saldo,
    cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) / 
         case when (isnull(pf.qt_atual_prod_fechamento,0) = 0) then 1 
              else pf.qt_atual_prod_fechamento end as decimal(25,2)) as vl_preco_saldo,
    cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) as decimal(25,2)) as vl_total_saldo
  into #SI
  from produto_fechamento pf, #ProdutoOriginal p, produto_custo pc, grupo_produto g
  where
        p.cd_produto       = pf.cd_produto and 
        pc.cd_produto      = pf.cd_produto and
        g.cd_grupo_produto = p.cd_grupo_produto and      
        isnull(pc.ic_peps_produto,'S') = 'S' and
        IsNull(pf.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
                        else IsNull(pf.cd_produto,0) end and
        IsNull(p.cd_grupo_produto,0) between case when @ic_parametro = 2 then @cd_grupo_inicial
                                   else IsNull(p.cd_grupo_produto,0) end 
                               and case when @ic_parametro = 2 then @cd_grupo_final
                                   else IsNull(p.cd_grupo_produto,0) end and
        pf.cd_fase_produto = @cd_fase_produto and
        pf.dt_produto_fechamento between (@dt_inicial -1) and @dt_final   and
        isnull(pf.qt_atual_prod_fechamento,0)>0


  -- BUSCA A MOVIMENTAÇÃO DO PERÍODO  
--  select * from #SI

  select
    g.nm_grupo_produto,
    p.nm_fantasia_produto         as nm_produto,
    p.nm_produto                  as ds_produto,
    p.cd_produto,
    tme.cd_tipo_movimento_estoque as cd_tipo_movimento,
    tme.ic_mov_tipo_movimento     as cd_entrada_saida,
    me.cd_movimento_estoque       as cd_movimento,
    me.dt_movimento_estoque       as dt_movimento,

    isnull(me.nm_historico_movimento,tme.nm_tipo_movimento_estoque) as nm_historico_movimento,

    case when tme.ic_mov_tipo_movimento = 'E' then 
      case when (nei.cd_nota_entrada is null) then cast(isnull(me.qt_movimento_estoque,0) as decimal(25,4))
      else cast(isnull(nei.qt_item_nota_entrada,0) as decimal(25,4)) 
      end 
    else 0.00 
    end                                        as qt_entrada,

    
    --Valor Total de Entrada

    case when tme.ic_mov_tipo_movimento = 'E' then 
      --case when (nei.cd_nota_entrada is null) then cast(isnull(me.vl_custo_contabil_produto,0) as decimal(25,2))
      case when (isnull(nei.cd_nota_entrada,0)=0) and
      isnull(pc.vl_custo_fracionado_produto,0)>0 and Fracionado = 'S'
      then cast(isnull(pc.vl_custo_fracionado_produto,0) as decimal(25,2))
      else
        case when (isnull(nei.cd_nota_entrada,0)>0) then
          cast(((case @ic_ipi_custo_produto when 'S' then
                    isnull(nei.vl_total_nota_entr_item,0)
                    + IsNull(nei.vl_ipi_nota_entrada,0)
                    - IsNull(nei.vl_icms_nota_entrada,0)
                    - IsNull(nei.vl_pis_item_nota,0)
                    - Isnull(nei.vl_cofins_item_nota,0)     
                  else
                    isnull(nei.vl_total_nota_entr_item,0)
                    - isnull(nei.vl_icms_nota_entrada,0)
                    - IsNull(nei.vl_pis_item_nota,0)
                    - Isnull(nei.vl_cofins_item_nota,0)     
                  end) / isnull(nei.qt_item_nota_entrada,1)) as decimal(25,2)) 
        else
          --Verificar se possui custo de entrada manuual
          case when isnull(vl_unitario_movimento,0)>0 then
            isnull(vl_unitario_movimento,0)
          else
            case when isnull(p.CustoOriginal,0)>0 then p.CustoOriginal else 0.00 end
        
            --0.00
          end
        end
      end
    else 
         0.00 
    end as vl_preco_entrada, 

    case when tme.ic_mov_tipo_movimento = 'E' then 
    case when (isnull(nei.cd_nota_entrada,0)=0) and
      isnull(pc.vl_custo_fracionado_produto,0)>0 and Fracionado = 'S'
       then cast(isnull((pc.vl_custo_fracionado_produto * me.qt_movimento_estoque),0) as decimal(25,2))
      else cast((case @ic_ipi_custo_produto 
             when 'S' then
               isnull(nei.vl_total_nota_entr_item,0)
               + IsNull(nei.vl_ipi_nota_entrada,0)
               - IsNull(nei.vl_icms_nota_entrada,0)
               - IsNull(nei.vl_pis_item_nota,0)
               - Isnull(nei.vl_cofins_item_nota,0)     

             else
               isnull(nei.vl_total_nota_entr_item,0)
               - isnull(nei.vl_icms_nota_entrada,0)
               - IsNull(nei.vl_pis_item_nota,0)
               - Isnull(nei.vl_cofins_item_nota,0)     

             end) as decimal(25,2)) 
      end
    else 0.00 
    end 
as vl_total_entrada,

    case when tme.ic_mov_tipo_movimento = 'S' then 
      cast(isnull(me.qt_movimento_estoque,0) as decimal(25,4)) else 0 end as qt_saida,
    cast(0 as decimal(25,2)) as vl_preco_saida,
    cast(0 as decimal(25,2)) as vl_total_saida,
    cast(0 as decimal(25,4)) as qt_saldo,
    cast(0 as decimal(25,2)) as vl_preco_saldo,
    cast(0 as decimal(25,2)) as vl_total_saldo
 
  into #M
  from movimento_estoque me                with (nolock) 
  left outer join nota_entrada_item nei
  on nei.cd_nota_entrada      = me.cd_documento_movimento and
     nei.cd_item_nota_entrada = me.cd_item_documento and
     nei.cd_fornecedor        = me.cd_fornecedor and
     nei.cd_operacao_fiscal   = isnull(me.cd_operacao_fiscal, 
                                       nei.cd_operacao_fiscal)
  left outer join nota_entrada ne
  on ne.cd_nota_entrada      = nei.cd_nota_entrada and
     ne.cd_fornecedor        = nei.cd_fornecedor and
     ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal and
     ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
  inner join tipo_movimento_estoque tme with (nolock) 
  on me.cd_tipo_movimento_estoque = tme.cd_tipo_movimento_estoque and
     tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto'
  inner join #ProdutoOriginal p on me.cd_produto = p.cd_produto
  inner join produto_custo pc   on pc.cd_produto = p.cd_produto and      
                                   isnull(pc.ic_peps_produto,'S') = 'S'
  inner join grupo_produto g    on g.cd_grupo_produto = p.cd_grupo_produto
  inner join produto_fechamento pf
  on pf.cd_produto = me.cd_produto and
     pf.cd_fase_produto = @cd_fase_produto and
     pf.dt_produto_fechamento between @dt_inicial and @dt_final
  where IsNull(me.cd_produto,0) = case when @ic_parametro = 1 then @cd_produto 
                        else IsNull(me.cd_produto,0) end and
        IsNull(p.cd_grupo_produto,0) >= case when @ic_parametro = 2 then @cd_grupo_inicial
                              else IsNull(p.cd_grupo_produto,0) end and
        IsNull(p.cd_grupo_produto,0) <= case when @ic_parametro = 2 then @cd_grupo_final
                              else IsNull(p.cd_grupo_produto,0) end and
        me.cd_fase_produto = @cd_fase_produto and
        me.dt_movimento_estoque between @dt_inicial and @dt_final

--select * from movimento_estoque where cd_movimento_estoque = 1024053
 
  -- CARREGA O CUSTO ANTERIOR E A MOVIMENTAÇÃO EM UMA SÓ TABELA TEMPORÁRIA 
  insert into #M select * from #SI 
 
  --select * from #m
  --select * from #m where cd_produto=2744
 
  -- CURSOR ORDENADO COM TODA A MOVIMENTAÇÃO PARA A VALORAÇÃO

  declare cCursor cursor for
  select 
    cd_produto,    
    cd_movimento,
    dt_movimento,
    qt_entrada,
    vl_preco_entrada,
    vl_total_entrada,
    qt_saida,
    qt_saldo,
    vl_total_saldo
  from #M 
  order by nm_produto, dt_movimento, cd_entrada_saida, cd_movimento
  
  open cCursor
  
  fetch next from cCursor into @cd_produto_processado, @cd_movimento, @dt_movimento, @qt_entrada, @vl_preco_entrada,
                               @vl_total_entrada, @qt_saida, @qt_saldo, @vl_total_saldo

  -- PRIMEIRAS VARIÁVEIS, ANTES DO LOOP  

  set @qt_saldo_anterior      = @qt_saldo
  set @vl_saldo_anterior      = @vl_total_saldo
  set @cd_produto_anterior    = @cd_produto_processado
  set @dt_fechamento_anterior = null  
  
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
      set @qt_saldo_anterior      = @qt_saldo
      set @vl_saldo_anterior      = @vl_total_saldo

    end
  
    -- LIMPA VARIÁVEL DE SAÍDAS
    set @vl_preco_saida = 0
    set @vl_total_saida = 0
  
    -- VERIFICA SE HOUVE ENTRADA, E CALCULA NOVO SALDO
    if (@qt_entrada <> 0)
    begin

      if (@vl_total_entrada = 0) 
      begin
        --Carlos 30.10.2005
        set @vl_total_entrada = @qt_entrada * ( case when @vl_preco_entrada=0 then 1 else @vl_preco_entrada end )
      end
  
      set @vl_total_saldo = @vl_saldo_anterior + @vl_total_entrada 
      set @qt_saldo       = @qt_saldo_anterior + @qt_entrada 
  
    end
    else
    -- VERIFICA SE HOUVE SAIDA, CALCULA CUSTO DA SAIDA E NOVO SALDO
    if (@qt_saida <> 0)
    begin      
      set @vl_preco_saida = @vl_saldo_anterior / case when @qt_saldo_anterior = 0 then 1 else @qt_saldo_anterior end
      set @vl_total_saida = @qt_saida * @vl_preco_saida
  
      --Analisar aqui--
      set @vl_total_saldo = @vl_saldo_anterior - @vl_total_saida
      set @qt_saldo       = @qt_saldo_anterior - @qt_saida    
    end
    else
    begin
      -- SE NÃO HOUVE ENTRADA E NEM SAÍDAS, ATUALIZA O SALDO 
      set @vl_total_saldo = @vl_saldo_anterior
      set @qt_saldo       = @qt_saldo_anterior
    end


--         if @cd_produto_processado = 2744
--         begin
-- 	  print 'Oi! Estou aqui'
--           print @qt_entrada
-- 	  print @vl_total_entrada
--           print @qt_produto_embalagem
--           print @CustoEmbalagem
--         end

  
    --print @vl_total_entrada
    --select @vl_total_entrada

    -- ATUALIZANDO A TABELA COM A NOVA VALORAÇÃO
    update #M 
    set vl_preco_saida   = @vl_preco_saida,
        vl_total_saida   = @vl_total_saida,
        vl_total_entrada = @vl_total_entrada,
        qt_saldo         = @qt_saldo,
        vl_preco_saldo   = case when @qt_saldo <> 0 
                           then @vl_total_saldo / @qt_saldo
                           else 0 end,
        vl_total_saldo   = case when @qt_saldo <> 0 
                           then @vl_total_saldo 
                           else 0 end
    where
      cd_produto   = @cd_produto_processado and
      cd_movimento = @cd_movimento and
      @cd_movimento <> 9999999

    -- ATUALIZANDO SOMENTE OS REGISTROS DE SALDO DA TABELA
    update #M 
    set qt_saldo       = @qt_saldo_anterior,
        vl_preco_saldo = case when @qt_saldo <> 0 
                         then @vl_total_saldo / @qt_saldo
                         else 0 end,
        vl_total_saldo = case when @qt_saldo <> 0 
                         then @vl_total_saldo
                         else 0 end

    where
      cd_produto    = @cd_produto_processado and
      cd_movimento  = @cd_movimento and
      dt_movimento  = @dt_movimento and
      @cd_movimento = 9999999  

    -- ATUALIZANDO O SALDO ANTERIOR
    set @vl_saldo_anterior      = @vl_total_saldo
    set @qt_saldo_anterior      = @qt_saldo
    set @dt_fechamento_anterior = @dt_movimento
                   
    fetch next from cCursor into @cd_produto_processado, @cd_movimento, @dt_movimento, @qt_entrada, @vl_preco_entrada,
                                 @vl_total_entrada, @qt_saida, @qt_saldo, @vl_total_saldo

  
  end
  
  close      cCursor
  deallocate cCursor

--  select * from #m

  if (@ic_atualizar_custo = 1)
  begin

--  Mostrar a Tabela de Cálculo
--   select
--    m.vl_total_entrada,m.vl_total_saida,m.*
--   from produto_fechamento pf, #M m
--     where pf.cd_produto      = m.cd_produto and
--           pf.cd_fase_produto = @cd_fase_produto and
--           pf.dt_produto_fechamento = m.dt_movimento 

--   SELECT * FROM #M

    -- ATUALIZA O PRODUTO FECHAMENTO
    update produto_fechamento set vl_custo_medio_fechamento = m.vl_total_saldo,
                                  vl_custo_prod_fechamento  = m.vl_total_saldo,
                                  qt_medio_prod_fechamento  = m.qt_saldo,
                                  vl_custo_entrada          = m.vl_total_entrada,
                                  vl_custo_saida            = m.vl_total_saida,
                                  cd_metodo_valoracao       = @cd_metodo_valoracao
    from produto_fechamento pf, #M m
    where pf.cd_produto            = m.cd_produto and
          pf.cd_fase_produto       = @cd_fase_produto and
          pf.dt_produto_fechamento = m.dt_movimento and
          m.cd_entrada_saida = 'X'
  
    -- ATUALIZA O PRODUTO CUSTO
    update produto_custo
    set
         vl_custo_contabil_produto = m.vl_preco_saldo
    from produto_custo pc, #M m
    where pc.cd_produto      = m.cd_produto and
          m.dt_movimento     = @dt_final and
          m.cd_entrada_saida = 'X'
  
    -- ATUALIZA O MOVIMENTO DE ESTOQUE
    update movimento_estoque set vl_custo_contabil_produto = case when m.cd_entrada_saida = 'E' then
                                                               m.vl_preco_entrada
                                                             else 
                                                               m.vl_preco_saida end
    from movimento_estoque me, #M m
    where m.cd_movimento = me.cd_movimento_estoque and
          m.cd_entrada_saida in ('E','S')

  end

  -- LISTA O SINTÉTICO OU ANALÍTICO

  if (@ic_tipo = 1)      
  begin

    select
      m.nm_grupo_produto,
      m.nm_produto,
      m.ds_produto,
      m.cd_produto,
      sum(m.qt_entrada)       as qt_entrada,      
      sum(m.vl_total_entrada) as vl_total_entrada,
      sum(m.qt_saida)         as qt_saida,
      sum(m.vl_total_saida)   as vl_total_saida,
      cast(max(pf.qt_atual_prod_fechamento) as decimal(25,4)) as qt_saldo,
      cast(isnull(max(pf.vl_custo_medio_fechamento),0) / 
           case when (isnull(max(pf.qt_atual_prod_fechamento),0) = 0) then 1 
                else max(pf.qt_atual_prod_fechamento) end as decimal(25,2)) as vl_preco_saldo,
      cast(isnull(max(pf.vl_custo_medio_fechamento),0) as decimal(25,2)) as vl_total_saldo
    into #Mov
    from #M m, Produto_Fechamento pf
    where m.cd_produto             = pf.cd_produto and
          pf.cd_fase_produto       = @cd_fase_produto and
          pf.dt_produto_fechamento = @dt_final and
          m.cd_entrada_saida in ('S','E')      and
          isnull(pf.qt_atual_prod_fechamento,0)>0

    group by m.nm_grupo_produto, m.nm_produto, m.ds_produto, m.cd_produto

    -- BUSCA O CUSTO ATUAL
    select 
     g.nm_grupo_produto,
     p.nm_fantasia_produto as nm_produto,
     p.nm_produto as ds_produto,
     p.cd_produto,
     0 as qt_entrada,
     0 as vl_total_entrada,
     0 as qt_saida,
     0 as vl_total_saida, 
     cast(pf.qt_atual_prod_fechamento as decimal(25,4)) as qt_saldo,
     cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) / 
       case when (isnull(pf.qt_atual_prod_fechamento,0) = 0) then 1 
	    else pf.qt_atual_prod_fechamento end as decimal(25,2)) as vl_preco_saldo,
--     as vl_preco_saldo,
     cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) as decimal(25,2)) --* IsNull(qt_produto_embalagem,1) + CustoEmbalagem 
    as vl_total_saldo
    into #SF
    from
      Produto_Fechamento pf with (nolock) inner join
      #ProdutoOriginal p on  pf.cd_produto = p.cd_produto left outer join 
      Grupo_Produto g on g.cd_grupo_produto = p.cd_grupo_produto left outer join 
      produto_custo pc on pc.cd_produto = pf.cd_produto   
    where g.cd_grupo_produto = p.cd_grupo_produto and      
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

 
    select 
      distinct
      m.nm_grupo_produto,
      m.nm_produto,
      m.ds_produto,
      m.cd_produto,
      m.qt_entrada,
      (case when p.Fracionado = 'N' 
	 then m.vl_total_entrada else ( ( ( select x.vl_total_entrada / (case when IsNull(x.qt_entrada,1) = 0 then 1 else IsNull(x.qt_entrada,1) end )
	 			            from #Mov x
   				            where x.cd_produto = p.Principal ) * p.qt_produto_embalagem ) + p.CustoEmbalagem ) * m.qt_entrada
       end 
      ) as vl_total_entrada,
      m.qt_saida,
      m.vl_total_saida, 
      m.qt_saldo,
      (case when p.Fracionado = 'N' 
	 then m.vl_preco_saldo else ( ( ( select x.vl_total_entrada / (case when IsNull(x.qt_entrada,1) = 0 then 1 else IsNull(x.qt_entrada,1) end )
	 			            from #Mov x
   				            where x.cd_produto = p.Principal ) * p.qt_produto_embalagem ) + p.CustoEmbalagem ) 
       end 
      )            as vl_preco_saldo,
      m.vl_total_saldo,
      p.Fracionado,
      p.Principal,
      p.CustoEmbalagem,
      p.qt_produto_embalagem

    from 
      #Mov m left outer join
      #ProdutoOriginal p on p.cd_produto = m.cd_produto
    where
      isnull(m.vl_preco_saldo,0)>0
--    where 
--      m.nm_produto like 'AMG%'
    order by m.nm_grupo_produto, m.nm_produto

    
  end
  else 
  if (@ic_tipo = 2)
/*    select 
      m.nm_grupo_produto,
      m.nm_produto,
      m.ds_produto,
      m.cd_produto,
      m.qt_entrada,
      (case when p.Fracionado = 'N' 
	 then m.vl_total_entrada else (( select top 1 x.vl_total_entrada
	 			        from #M x
				        where x.cd_produto = p.Principal ) * p.qt_produto_embalagem ) + p.CustoEmbalagem 
end 
) as vl_total_entrada,
      m.qt_saida,
      m.vl_total_saida, 
      m.qt_saldo,
      m.vl_preco_saldo,
      m.vl_total_saldo,
      p.Fracionado,
      p.Principal,
      p.CustoEmbalagem,
      p.qt_produto_embalagem
    from 
      #M m left outer join
      #ProdutoOriginal p on p.cd_produto = m.cd_produto
    order by m.nm_grupo_produto, m.nm_produto, m.dt_movimento, m.cd_entrada_saida, m.cd_movimento
*/
    select distinct * from #M m
    where
      isnull(m.vl_preco_saldo,0)>0

    order by m.nm_grupo_produto, m.nm_produto, m.dt_movimento, m.cd_entrada_saida, m.cd_movimento
  else
  if (@ic_tipo = 3) --Consistência de Saldos
  begin
    select
      distinct
      * 
    from #M 
    where
       isnull(vl_total_saida,0)<0 or isnull(vl_total_entrada,0)<0 or isnull(vl_total_saldo,0)<0
    order by nm_grupo_produto, nm_produto, dt_movimento, cd_entrada_saida, cd_movimento
 
  end  
--  drop table #SI
--  drop table #M
--  drop table #SF
--  drop table #Mov      



