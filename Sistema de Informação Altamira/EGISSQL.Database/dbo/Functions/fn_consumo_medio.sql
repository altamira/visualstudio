
CREATE  FUNCTION fn_consumo_medio
  ( @cd_fase_produto int, @cd_produto int, @dt_inicial_movimentacao datetime, @dt_final_movimentacao datetime )
RETURNS Float


--fn_consumo_medio
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Daniel C. Neto
--Banco de Dados: EgisSql
--Objetivo: Retorna o Consumo Médio do Produto no período selecionado.
--Data: 18/12/2003
-----------------------------------------------------------------------------------------

AS
BEGIN

--select * from produto where nm_fantasia_produto = 'TV1025'
return(
  select
    ( sum( QtdeProduto ) / 3 ) as 'QtdeTrim'
  from
  ( 
  select
      sum( isnull( me.qt_movimento_estoque, 0 ) ) as 'QtdeProduto'
    from
      Movimento_Estoque me with (nolock)
      inner join Tipo_Movimento_Estoque tme  with (nolock)
        on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
    where
      ( me.cd_produto = @cd_produto ) and
      ( me.cd_fase_produto = @cd_fase_produto ) and
      ( me.dt_movimento_estoque >= @dt_inicial_movimentacao ) and
      ( me.dt_movimento_estoque < @dt_final_movimentacao ) and
      ( tme.ic_mov_tipo_movimento = 'S' ) and
      ( isnull(tme.ic_consumo_tipo_movimento,'S') = 'S' ) and
      ( tme.ic_operacao_movto_estoque in ('R','A') ) -- Movimenta o Real ou Ambos    
    union all
    
    select
      sum( isnull( meCancDev.qt_movimento_estoque, 0 ) * ( case when meCancDev.cd_tipo_movimento_estoque = 13 then 1 else -1 end ) ) as 'QtdeProduto'
    from
      Movimento_Estoque me  with (nolock) inner join 
      Tipo_Movimento_Estoque tme   with (nolock) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque inner join 
      Movimento_Estoque meCancDev  with (nolock) on  ( meCancDev.cd_tipo_documento_estoque = me.cd_tipo_documento_estoque ) and
                                                     ( meCancDev.cd_documento_movimento = me.cd_documento_movimento ) and
                                                     ( meCancDev.cd_item_documento = me.cd_item_documento ) and
                                                     ( meCancDev.cd_produto = me.cd_produto ) and
                                                     ( meCancDev.cd_fase_produto = me.cd_fase_produto ) and
                                                     ( meCancDev.cd_tipo_movimento_estoque in (10,12,13)) and -- Devolução, Ativação e Cancelamento
                                                     ( meCancDev.cd_movimento_estoque > me.cd_movimento_estoque )
    where
      ( me.cd_produto = @cd_produto ) and
      ( me.cd_fase_produto = @cd_fase_produto ) and
      ( me.dt_movimento_estoque >= @dt_inicial_movimentacao ) and
      ( me.dt_movimento_estoque < @dt_final_movimentacao ) and
      ( tme.ic_mov_tipo_movimento = 'S' ) and
      ( isnull(tme.ic_consumo_tipo_movimento,'S') = 'S' ) and
      ( tme.ic_operacao_movto_estoque in ('R','A') ) -- Movimenta o Real ou Ambos    
 
  ) Consumo 
)

end
