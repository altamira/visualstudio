

CREATE    FUNCTION fn_consumo_produto_mes
(@cd_produto int,
 @cd_fase_produto int,
 @ic_mov_tipo_movimento char(1),
 @cd_mes     int,
 @cd_ano     int)
RETURNS float


AS
BEGIN
  declare @consumo float

  set @consumo= (select  
                   IsNull(sum(x.qt_movimento_estoque),0)
                 from Movimento_Estoque x 
                 left outer join Tipo_Movimento_Estoque tm on 
                   tm.cd_tipo_movimento_estoque = x.cd_tipo_movimento_estoque 
                 where 
                   x.cd_produto= @cd_produto and                      
                   x.cd_fase_produto = @cd_fase_produto and
                   month(x.dt_movimento_estoque) = @cd_mes and
                   year(x.dt_movimento_estoque)  = @cd_ano and
                   tm.ic_mov_tipo_movimento      = @ic_mov_tipo_movimento  and
                   tm.ic_operacao_movto_estoque in ('R','A'))

  return (@consumo)

end




