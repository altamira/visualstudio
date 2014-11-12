


CREATE   FUNCTION fn_saldo_do_produto
  ( @cd_produto int ) RETURNS float
AS
BEGIN

  declare @nSaldoAtual as float

  select top 1 
    @nSaldoAtual = qt_saldo_reserva_produto
  From 
    Produto_Saldo
  where 
    cd_produto = @cd_produto and
    cd_fase_produto = (SELECT cd_fase_produto
                        FROM Parametro_Comercial
                        WHERE cd_empresa = dbo.fn_empresa())

  return Isnull(@nSaldoAtual,0)
end

--select dbo.fn_saldo_do_produto( 1 ) as teste


