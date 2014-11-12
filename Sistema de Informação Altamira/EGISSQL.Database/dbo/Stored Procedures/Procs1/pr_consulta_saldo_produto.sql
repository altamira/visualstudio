
CREATE PROCEDURE pr_consulta_saldo_produto
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Duela
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Saldo de Estoque por Produto
--Data          : 08/04/2002
--Atualizado    : 25/07/2002
--Atualizado    : 06/02/2003 - Inclusão da máscara do grupo de produto.
--Atualizado    : 07/05/2003 - Inclusão do campo Total. - Carla
--              : 17.05.2005 - Verificação do Somatória - Carlos Fernandes
--              : 02.09.2005 - Acerto para Somar o Pedido de Importação - Carlos Fernandes.
--              : 03.02.2006 - Acerto do status do Produto para bloqueio do uso de produto - Carlos Fernandes
--              : 12/04/2006 - Acrescentado ao total de requisições as requisições de importação e uma coluna
--                             para pedidos de importação - Paulo Souza
--              : 04.12.2006 - Estoque Mínimo / Máximo 
--                             Todas as Fases - Carlos Fernandes
--              : 15.02.2007 - Correção do Saldo de Requisição de Compras - Anderson
--              : 28.05.2007 - Descrição do Produto/Unidade
--              : 18.06.2007 - Verificação e acertos - Carlos Fernandes
-- 20.05.2008 - Saldo do Produto - Carlos Fernandes 
-- 20.08.2008 - Total dos Produtos em Ordem de Produção - Carlos Fernandes
-- 11.02.2009 - Categoria Produto/Grupo e LeadTime de Compras/LeadTime Produção - Carlos Fernandes
-- 02.10.2010 - Nova Coluna para mostrar o Total Reservado no Período - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------
@ic_parametro        int         = 0, 
@nm_fantasia_produto varchar(30) = '',
@cd_fase_produto     int         = 0,
@dt_inicial          datetime    = '',
@dt_final            datetime    = '' 

AS

declare @cd_produto int

--select * from movimento_estoque
--select * from tipo_movimento_estoque


if @ic_parametro = 1 or @ic_parametro = 2
begin

--select * from produto_saldo

    select 
       p.cd_produto,
       p.cd_mascara_produto,
       gp.cd_mascara_grupo_produto,
       p.nm_fantasia_produto                      as 'Produto_Fantasia', 
       p.nm_produto                               as 'Descricao',
       um.sg_unidade_medida                       as 'Unidade',
       gp.nm_grupo_produto                        as 'GrupoProduto',
       IsNull(ps.qt_saldo_atual_produto,0)        as 'Saldo_Estoque_Atual',
       IsNull(ps.qt_saldo_reserva_produto,0)      as 'Saldo_Estoque_Reserva',
       IsNull(ps.qt_pd_compra_produto,0)+
       IsNull(ps.qt_importacao_produto,0)         as 'Pedido_Compra',
       IsNull(ps.qt_saldo_reserva_produto,0) + IsNull(ps.qt_pd_compra_produto,0) +
       IsNull(ps.qt_importacao_produto,0)    + 
       isNull(ps.qt_producao_produto,0)           as 'Total',
       IsNull(ps.qt_req_compra_produto,0)         as 'Requisicao_Compra',
       IsNull(ps.qt_terceiro_produto,0)           as 'Saldo_Estoque_Terceiro',
       IsNull(ps.qt_implantacao_produto,0)        as 'Saldo_Estoque_Implantacao',
       IsNull(ps.qt_consig_produto,0)             as 'Saldo_Estoque_Consignacao',
       IsNull(ps.vl_fob_produto, 0.00)            as 'Valor_Fob',
       IsNull(ps.vl_custo_contabil_produto, 0.00) as 'Valor_Custo_Contabil',
       IsNull(ps.vl_fob_convertido, 0.00)         as  'Valor_Fob_Convertido',
       Isnull(ps.qt_producao_produto,0)           as 'Saldo_Producao',
       case 
         When cast(ps.qt_saldo_atual_produto as decimal(16,2)) < (cast(ps.qt_maximo_produto as decimal(16,2))  * 0.25)
         Then Cast(ps.qt_padrao_lote_compra as decimal(16,2))
         Else 0.00
       end as 'Sugestao_Compra',
--        case 
--          when ((ps.qt_saldo_reserva_produto-(ps.qt_req_compra_produto+ps.qt_pd_compra_produto))< 0) 
--          then 0 
--          else isnull((ps.qt_saldo_reserva_produto-(ps.qt_req_compra_produto+ps.qt_pd_compra_produto)),0) 
--        end as 'Sugestao_Compra',
       isnull(ps.qt_entrada_produto,0)       as 'Saldo_Estoque_Entrada',
       isnull(ps.qt_saida_produto,0)         as 'Saldo_Estoque_Saida',
       isnull(ps.qt_consumo_produto,0.00)    as 'Consumo',
       case 
         when ((ps.qt_saldo_reserva_produto=0) or (ps.qt_consumo_produto=0)) 
         then 0 
         else isnull(((ps.qt_saldo_reserva_produto/ps.qt_consumo_produto)*30),0.00) 
       end as 'Duracao',

      pc.vl_custo_produto                    as 'CustoReposicao',

      IsNull((select Sum(pii.qt_saldo_item_ped_imp)
              from pedido_importacao_item pii
              where pii.cd_produto = p.cd_produto and
                    pii.qt_saldo_item_ped_imp > 0 and
                    pii.dt_cancel_item_ped_imp is null
              group by pii.cd_produto),0) as 'PedidoImportacao',
      (IsNull(ps.qt_req_compra_produto,0) + IsNull((select Sum(rci.qt_item_requisicao_compra) 
                                                    from requisicao_compra_item rci
                                                    inner join pedido_importacao_item piii on rci.cd_requisicao_compra = piii.cd_requisicao_compra and
                                                                                              rci.cd_item_requisicao_compra = piii.cd_item_requisicao_compra and
                                                                                              piii.dt_cancel_item_ped_imp is null
                                                    Where rci.cd_produto = p.cd_produto
                                                    Group by rci.cd_produto),0)) as 'Requisicao_Total',
     isNull(p.qt_area_produto,0) as qt_area_produto,
     (IsNull(ps.qt_saldo_atual_produto,0) * isNull(p.qt_area_produto,0)) as qt_total_area_produto,
     ps.qt_minimo_produto                                                as Minimo,
     ps.qt_maximo_produto                                                as Maximo,
     fp.nm_fase_produto                                                  as FaseProduto,
     isnull(mp.nm_marca_produto,p.nm_marca_produto)                      as MarcaProduto,
     isnull(cp.nm_categoria_produto,'')                                  as nm_categoria_produto,
     p.qt_leadtime_produto,
     p.qt_leadtime_compra,

     --Total Reservado no Período
     isnull( (select
               sum( isnull(me.qt_movimento_estoque,0) )
             from
               movimento_estoque me with (nolock) 
             where
               me.cd_produto                = p.cd_produto and --Produto
               me.cd_tipo_movimento_estoque = 2            and --Reserva 
               me.dt_movimento_estoque between @dt_inicial and @dt_final and
               me.cd_fase_produto           = ps.cd_fase_produto
             group by
               me.cd_produto ),0)                                       as 'Total_Reservado'


--    into #Teste

    from 
      produto_saldo ps                  with (nolock)
      inner join Produto p              with (nolock) on p.cd_produto         = ps.cd_produto 
      left outer join Grupo_Produto gp     on p.cd_grupo_produto      = gp.cd_grupo_produto
      left outer join Produto_Custo pc     on pc.cd_produto           = p.cd_produto    
      left outer join Status_Produto sp    on sp.cd_status_produto    = p.cd_status_produto
      left outer join Fase_Produto   fp    on fp.cd_fase_produto      = ps.cd_fase_produto
      left outer join Unidade_Medida um    on um.cd_unidade_medida    = p.cd_unidade_medida
      left outer join Marca_Produto  mp    on mp.cd_marca_produto     = p.cd_marca_produto
      left outer join Categoria_produto cp on cp.cd_categoria_produto = p.cd_categoria_produto
  where (case when (@ic_parametro = 1) and (p.nm_fantasia_produto like @nm_fantasia_produto + '%') then 1
              when (@ic_parametro = 2) and (p.cd_mascara_produto like @nm_fantasia_produto + '%' or 
                                            dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,p.cd_mascara_produto)
                                              like @nm_fantasia_produto + '%' ) then 1
         else 0 end ) = 1 and
        ps.cd_fase_produto = case when @cd_fase_produto=0 then ps.cd_fase_produto else @cd_fase_produto end  and
        isnull(sp.ic_bloqueia_uso_produto,'N') = 'N' 

  order by 
    p.nm_fantasia_produto

--select * from produto
end

------------------------------------------------------------------------------------------
--Consulta por Lote
------------------------------------------------------------------------------------------

if @ic_parametro = 3
begin
  
  select 
    @cd_produto = isnull(cd_produto,0)
  from
    produto p with (nolock) 
  where
    nm_fantasia_produto = @nm_fantasia_produto


  --sele 
  --select * from lote_produto_item
  --select * from lote_produto,
  --select * from lote_produto_saldo

  select
    lp.nm_ref_lote_produto     as Lote,
    lp.dt_entrada_lote_produto as Entrada,
    lp.dt_inicial_lote_produto as InicioValidade,
    lp.dt_final_lote_produto   as FimValidade,
    lps.qt_saldo_reserva_lote  as Disponivel,
    lps.qt_saldo_atual_lote    as Fisico
  from 
    lote_produto_item lpi 
    inner join lote_produto lp        on lp.cd_lote_produto   = lpi.cd_lote_produto
    inner join lote_produto_saldo lps on lps.cd_lote_produto  = lpi.cd_lote_produto
  where
    lpi.cd_produto = @cd_produto and
    isnull(lps.qt_saldo_atual_lote,0)>0
  order by
    lp.nm_ref_lote_produto

end

--  select cd_mascara_produto, count(*)
--  from #Teste
--  group by cd_mascara_produto
--  having count(*) > 1


--select * from produto_saldo
  
