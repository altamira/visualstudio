
CREATE FUNCTION fn_montar_produto_pela_composicao
  (@cd_produto int, @ic_tipo_saldo varchar(1)) --@ic_tipo_saldo = 'D - Disponível' / @ic_tipo_saldo = 'R - Real'
RETURNS float
AS
BEGIN
  DECLARE @qt_possivel_montagem FLOAT
  

  SET @qt_possivel_montagem = 0

  --Cria tabela temporária para tratamento
  DECLARE @tbProduto TABLE 
  (cd_produto_pai int, 
   cd_produto int, 
   qt_produto_composicao float, 
   cd_fase_produto int, 
   nm_fantasia_produto varchar(30))
  
  --Insere na tabela temporária a composição
  Insert into @tbProduto
  SELECT 
    comp.cd_produto_pai, 
    comp.cd_produto,
    comp.qt_produto_composicao,
    comp.cd_fase_produto,
    comp.nm_fantasia_produto
  FROM 
    [EgisSQL].[dbo].[fn_composicao_produto](@cd_produto) comp
  
  --Desconsidera os itens que dependem de subitens
  delete @tbProduto 
  from @tbProduto a
  where exists(select 'x' from @tbProduto b where b.cd_produto_pai = a.cd_produto)
  
  --Define o mínimo que poderá ser montado em função do Saldo
  if ( @ic_tipo_saldo = 'D' )
    Select 
      @qt_possivel_montagem = min (FLOOR(ps.qt_saldo_reserva_produto / p.qt_produto_composicao))
    from 
      @tbProduto p 
      inner join Produto prod with (nolock, index(pk_produto))
        on prod.cd_produto = p.cd_produto
      inner join produto_saldo ps with (nolock, index(pk_produto_saldo))
        on ps.cd_produto = IsNull(prod.cd_produto_baixa_estoque, p.cd_produto)
           and ps.cd_fase_produto = p.cd_fase_produto
  else
    Select 
      @qt_possivel_montagem = min (FLOOR(ps.qt_saldo_atual_produto / p.qt_produto_composicao))
    from 
      @tbProduto p 
      inner join Produto prod with (nolock, index(pk_produto))
        on prod.cd_produto = p.cd_produto
      inner join produto_saldo ps with (nolock, index(pk_produto_saldo))
        on ps.cd_produto = IsNull(prod.cd_produto_baixa_estoque, p.cd_produto)
           and ps.cd_fase_produto = p.cd_fase_produto    
  
  RETURN @qt_possivel_montagem
END
