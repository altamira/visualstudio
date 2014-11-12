
create procedure pr_movimento_de_produtos_de_terceiros
@ic_parametro int,
@tipo_destinatario int, 
@destinatario int, 
@produto int,
@data_inicial datetime,
@data_final datetime
as

  -- Declara as variáveis de saldo
  declare @saldo_inicial int 
  declare @saldo_entrada int 
  declare @saldo_saida int

  -- Inicializa as variáveis
  set @saldo_inicial = 0 
  set @saldo_entrada = 0 
  set @saldo_saida = 0


if @ic_parametro = 1   -- CONSULTA DA MOVIMENTAÇÃO
begin
 
  -- Monta Saldo Entrada
  select @saldo_entrada = isnull(sum(qt_movimento_terceiro),0) 
  from movimento_produto_terceiro
  where isnull(cd_nota_entrada,0)<> 0
    and dt_movimento_terceiro < @data_inicial 

  -- Saldo Saldo Saída
  select @saldo_saida = isnull(sum(qt_movimento_terceiro),0) 
  from movimento_produto_terceiro
  where isnull(cd_nota_saida,0)<> 0
    and dt_movimento_terceiro < @data_inicial 
  
  -- Saldo Inicial
  set @saldo_inicial = @saldo_entrada - @saldo_saida
  
  -- Lista o relatório de Movimento de Produtos de Terceiros

  select @saldo_inicial as SaldoInicial,
         cd_nota_entrada as NotaEntrada,
         case when (isnull(cd_nota_entrada,0)=0) then 0 
              else dt_movimento_terceiro end as DataEntrada,
         cd_produto as Produto,
         case when (isnull(cd_nota_entrada,0)=0) then 0 
              else qt_movimento_terceiro end as QtdeEntrada,
         cd_nota_saida as NotaSaida,
         case when (isnull(cd_nota_saida,0)=0) then 0 
              else dt_movimento_terceiro end as DataSaida,
         case when (isnull(cd_nota_saida,0)=0) then 0 
              else qt_movimento_terceiro end as QtdeSaida
  
  from movimento_produto_terceiro
  
  where cd_tipo_destinatario = @tipo_destinatario 
    and cd_destinatario = @destinatario 
    and cd_produto = @produto
    and dt_movimento_terceiro between @data_inicial and @data_final

end
else if @ic_parametro = 2   -- SALDO EM ABERTO
begin

  -- Monta Saldo Entrada
  select @saldo_entrada = isnull(sum(qt_movimento_terceiro),0) 
  from movimento_produto_terceiro
  where isnull(cd_nota_entrada,0)<> 0
    and dt_movimento_terceiro < @data_inicial 

  -- Saldo Saldo Saída
  select @saldo_saida = isnull(sum(qt_movimento_terceiro),0) 
  from movimento_produto_terceiro
  where isnull(cd_nota_saida,0)<> 0
    and dt_movimento_terceiro < @data_inicial 
  
  -- Saldo Inicial
  select SaldoAtual = (@saldo_entrada - @saldo_saida)


end
