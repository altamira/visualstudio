
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_posicao_estoque
-------------------------------------------------------------------------------
--pr_consulta_posicao_estoque
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Carlos Cardoso Fernandes
--Data             : 25.06.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_posicao_estoque
@cd_produto         int     = 0,
@ic_tipo_consulta   char(1) = 'A',  --(A) Atual --(F) Fechamento
@vl_taxa_financeira float   = 1,
@cd_fase_produto    int     = 0
as


--declare @cd_fase_produto int

if @cd_fase_produto = 0
begin
  select 
    @cd_fase_produto = isnull(cd_fase_produto,0)
  from
    parametro_comercial with (nolock)
  where
   cd_empresa = dbo.fn_empresa()
end

select
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  gp.nm_grupo_produto,
  cp.nm_categoria_produto,
  p.vl_produto,
  @vl_taxa_financeira              as vl_taxa_financeira,
  p.vl_produto*
  case when @vl_taxa_financeira>0 then @vl_taxa_financeira else 1 end
                                   as vl_produto_taxa_financeira,
  cf.cd_mascara_classificacao,
  pimp.cd_part_number_produto,
  pimp.vl_produto_importacao,

  --select * from produto_saldo
  --Atual
 
  ps.qt_saldo_reserva_produto,

  --Atual
  ps.qt_saldo_atual_produto,

  ps.qt_saldo_atual_produto 
  * p.vl_produto *
  case when @vl_taxa_financeira>0 then @vl_taxa_financeira else 1 end
                                                     as vl_total_estoque,

  --Reservado
--   isnull( (select sum(vw.qt_movimento_estoque)
--           from vw_reserva_produto_estoque vw
--           where
--              vw.cd_produto = p.cd_produto 
--              and
--              vw.dt_cancelamento_item is null  and
--              vw.cd_documento_movimento not in
--              ( select cd_pedido_venda from
--                Atendimento_Pedido_Venda with (nolock) 
--                where
--                   cd_pedido_venda      = vw.cd_documento_movimento and
--                   cd_item_pedido_venda = vw.cd_item_documento )
--               ),0)            

  isnull( (select sum(vw.qt_estoque)
          from estoque_pedido_venda vw
          where
             vw.cd_produto = p.cd_produto 
              ),0)

                                                                          as qtd_reservado_estoque, 

  --Total Reservado

  p.vl_produto
  *
  case when @vl_taxa_financeira>0 then @vl_taxa_financeira else 1 end
  *    

  --select * from estoque_pedido_venda

  isnull( (select sum(vw.qt_estoque)
          from estoque_pedido_venda vw
          where
             vw.cd_produto = p.cd_produto 
              ),0)
                                                                                         as vl_reservado_estoque,
  --Disponível Físico 

   isnull(ps.qt_saldo_atual_produto,0) -
   isnull( (select sum(vw.qt_estoque)
            from estoque_pedido_venda vw
            where
              vw.cd_produto = p.cd_produto ),0)    as qt_total_disponivel,

--    isnull( (select sum(vw.qt_movimento_estoque)
--           from vw_reserva_produto_estoque vw
--           where
--              vw.cd_produto = p.cd_produto     and
--              vw.dt_cancelamento_item is null  and
--              vw.cd_documento_movimento not in
--              ( select cd_pedido_venda from
--                Atendimento_Pedido_Venda with (nolock) 
--                where
--                   cd_pedido_venda      = vw.cd_documento_movimento and
--                   cd_item_pedido_venda = vw.cd_item_documento )
--               ),0)                                                 
                              


  --Valor Total Disponível

  p.vl_produto
  *
  case when @vl_taxa_financeira>0 then @vl_taxa_financeira else 1 end
  *    
  ( isnull(ps.qt_saldo_atual_produto,0) -
   isnull( (select sum(vw.qt_estoque)
            from estoque_pedido_venda vw
            where
              vw.cd_produto = p.cd_produto ),0))                                          as vl_total_disponivel,

  --Comprada
--  IsNull(qt_prev_ent1_produto,0) + 
--  IsNull(qt_prev_ent2_produto,0) + 
--  IsNull(qt_prev_ent3_produto,0) +
  isnull(qt_prev_entrada_produto,0)                                                      as qtd_comprada,
  
  --Alocado
  isnull(qt_alocado_produto,0)                                                           as qt_alocado_produto,

  --Compra Disponível
  (
--  IsNull(qt_prev_ent1_produto,0) + 
--  IsNull(qt_prev_ent2_produto,0) + 
--  IsNull(qt_prev_ent3_produto,0) +
  isnull(qt_prev_entrada_produto,0) )
  -
  isnull(qt_alocado_produto,0)                                                           as qtd_comprada_disponivel,

  --Total Fob

  isnull(ps.qt_saldo_atual_produto,0) * isnull(pimp.vl_produto_importacao,0)             as vl_total_fob,
  cp.cd_mascara_categoria
  
--select * from categoria_produto

from
  Produto p                               with (nolock) 
  left outer join Unidade_Medida     um   with (nolock) on um.cd_unidade_medida       = p.cd_unidade_medida
  left outer join Categoria_produto  cp   with (nolock) on cp.cd_categoria_produto    = p.cd_categoria_produto
  left outer join Grupo_Produto      gp   with (nolock) on gp.cd_grupo_produto        = p.cd_grupo_produto
  left outer join Produto_Custo      pc   with (nolock) on pc.cd_produto              = p.cd_produto
  left outer join Produto_Fiscal     pf   with (nolock) on pf.cd_produto              = p.cd_produto
  left outer join Produto_Importacao pimp with (nolock) on pimp.cd_produto            = p.cd_produto
  left outer join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  left outer join Produto_Saldo      ps   with (nolock) on ps.cd_produto              = p.cd_produto and
                                                           ps.cd_fase_produto         = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                                        then @cd_fase_produto 
                                                                                        else p.cd_fase_produto_baixa end

  left outer join status_produto    sp   with (nolock) on sp.cd_status_produto = p.cd_status_produto

where
  p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end and
  isnull(sp.ic_bloqueia_uso_produto,'N')='N'

order by
  p.cd_mascara_produto

--select * from status_produto
--select * from produto_importacao
--select * from produto_saldo

