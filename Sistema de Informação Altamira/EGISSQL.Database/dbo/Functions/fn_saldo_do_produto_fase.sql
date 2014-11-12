



CREATE FUNCTION fn_saldo_do_produto_fase
( @cd_produto int, 
  @cd_fase int )
RETURNS float
 

AS
BEGIN
 
  declare @nSaldoAtual as float
 
if (@cd_fase=null) or (@cd_fase=0)
  set @cd_fase=(SELECT cd_fase_produto
            FROM Parametro_Comercial
            WHERE cd_empresa = dbo.fn_empresa())
 
  select top 1 
    @nSaldoAtual = qt_saldo_reserva_produto
  From 
    Produto_Saldo
  where 
    cd_produto = @cd_produto and
    cd_fase_produto = @cd_fase
 
  return Isnull(@nSaldoAtual,0)
end
 
