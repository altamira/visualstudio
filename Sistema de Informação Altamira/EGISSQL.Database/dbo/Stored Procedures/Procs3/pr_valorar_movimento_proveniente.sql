

create procedure pr_valorar_movimento_proveniente
  @Data_ini DateTime,
  @Data_fim DateTime,
  @cd_produto_peps int,
  @cd_fase_produto int --Fase 
as


declare @cd_movimento_estoque int,
        @cd_documento_entrada_peps int,
        @cd_item_documento_entrada int,
        @qt_entrada_peps float,
        @cd_produto int,
        @vl_custo_contabil numeric(18,4),
        @dt_movimento_estoque datetime,
        @cd_tipo_documento_estoque int



if @Data_ini is null
  set @Data_ini = '01/01/1900'

if @Data_fim is null
  set @Data_fim = getdate()

set nocount on
/******************************************************************
CODIGO IMPLEMENTADO APENAS PARA REALIZAR A VALORAÇÃO DE UM PRODUTO
*******************************************************************/
--Atualiza na tabela de Nota_Entrada_PEPS
Select 
  cd_movimento_estoque,
  cd_produto,
  cd_documento_entrada_peps,
  cd_item_documento_entrada,
  qt_entrada_peps,
  cd_fase_produto
  dt_controle_nota_entrada
into
  #Entrada_PEPS
From 
  Nota_Entrada_PEPS
where 
  cd_produto = @cd_produto_peps and
  cd_fase_produto <> @cd_fase_produto and
  IsNull(ic_tipo_lancamento,'A') = 'A'

while exists(Select 'x' from #Entrada_PEPS )
begin

  Select 
    top 1
    @cd_movimento_estoque = e.cd_movimento_estoque,
    @cd_documento_entrada_peps = e.cd_documento_entrada_peps,
    @cd_item_documento_entrada = e.cd_item_documento_entrada,
    @qt_entrada_peps = e.qt_entrada_peps,
    @cd_produto = e.cd_produto,
    @dt_movimento_estoque = me.dt_movimento_estoque,
    @cd_tipo_documento_estoque = cd_tipo_documento_estoque
  from
    #Entrada_PEPS e
  inner join
    Movimento_Estoque me
  on e.cd_movimento_estoque = me.cd_movimento_estoque
  

  --Verifica se houve um movimento de saída do documento/item em outra fase e que esteja com um valor > 0
  Set @vl_custo_contabil = 0

  Select 
    top 1
      @vl_custo_contabil = IsNull(vl_custo_contabil_produto,0)
  from
    Movimento_Estoque
  where
    cd_produto = @cd_produto
    and cd_tipo_documento_estoque = @cd_tipo_documento_estoque
    and cd_documento_movimento = @cd_documento_entrada_peps
    and cd_item_documento = @cd_item_documento_entrada
    and cd_movimento_estoque <> @cd_movimento_estoque
    and IsNull(vl_custo_contabil_produto,0) > 0
  order by
    cd_movimento_estoque desc

  if IsNull(@vl_custo_contabil,0) > 0
    update 
      nota_entrada_peps
    set 
      vl_custo_valorizacao_peps = @vl_custo_contabil
    where  
      cd_movimento_estoque = @cd_movimento_estoque
  
  delete from #Entrada_PEPS where cd_movimento_estoque = @cd_movimento_estoque
end

set nocount off

