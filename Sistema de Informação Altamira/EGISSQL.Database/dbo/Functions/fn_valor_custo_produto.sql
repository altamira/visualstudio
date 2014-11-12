create function fn_valor_custo_produto
( @cd_documento int,
  @cd_documento_item int,
  @cd_produto int,
  @cd_fase_produto int,
  @dt_nota_fiscal DateTime,
  @dt_inicial DateTime,
  @dt_final DateTime,
  @ic_tipo_movimento char(1)) returns float
-----------------------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server     2000
--Autor(es)		: Igor Gama
--Banco de Dados	: EGISSQL
--Objetivo		: Retorna o valor de custo de acordo com o parametro BI
--Data			  : 04.05.2004
--Alteração : 
-----------------------------------------------------------------------
as
Begin
  declare 
    @dt_nota DateTime,
    @vl_custo float,
    @ic_origem_custo char(1),
    @cd_tipo_movimento_estoque int,
    @cont int

  --Verifica o tipo de movimento para retorno de dados caso a origem for 
  -- movimentação de estoque
  Set @ic_tipo_movimento = IsNull(@ic_tipo_movimento,'')

  Set @cd_tipo_movimento_estoque = 
    Case @ic_tipo_movimento
      when 'C' then 12 -- 12 - Cancelamento NF
      when 'D' then 10 -- 10 - Devolução NF
      Else 0
    End

  --Seta a data da NF na variável para cálculo do ME
  Set @dt_nota = @dt_nota_fiscal

  --Verifica a origem do custo para realizar o cálculo
  Select @ic_origem_custo = IsNull(ic_origem_custo,'M')
  From Parametro_bi where cd_empresa = dbo.fn_empresa()

  --Realizar o cálculo através da movimentação de estoque
  -- verificando se traz apenas notas canceladas ou devolvidas ou todas
  If @ic_origem_custo = 'M'
  Begin
--     select @vl_custo = sum(qt_movimento_estoque * vl_custo_contabil_produto)
--     from movimento_estoque
--     where cd_documento_movimento = @cd_documento
--       and cd_item_documento = @cd_documento_item
--       and cd_produto = @cd_produto
--       and cd_fase_produto = @cd_fase_produto
-- --      and cd_tipo_documento_estoque = 4
--       and cd_tipo_movimento_estoque <> 13 --Notas diferentes de NF de Ativação
--       and (cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque or
--            @cd_tipo_movimento_estoque = 0)
    select @vl_custo = IsNull(sum(qt_movimento_estoque * vl_custo_contabil_produto),0)
    from movimento_estoque
    where cd_documento_movimento = @cd_documento
      and cd_item_documento = @cd_documento_item
      and cd_produto = @cd_produto
      and cd_fase_produto = @cd_fase_produto
      and cd_tipo_movimento_estoque <> 13 --Notas diferentes de NF de Ativação
      and (cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque or
           @cd_tipo_movimento_estoque = 0)  
 
    --Procedimento para pegar o valor de custo mais próximo do produto selecionado
    If IsNull(@vl_custo, 0) <= 0
    Begin
      select top 1
        @vl_custo = vl_custo_contabil_produto * qt_movimento_estoque
      from
        Movimento_Estoque 
      where 
        cd_produto = @cd_produto
        and cd_fase_produto = @cd_fase_produto
        and dt_movimento_estoque 	    <= @dt_nota_fiscal
        and cd_tipo_movimento_estoque in (1,5) --Entradas
        and cd_tipo_documento_estoque in (3,8,9)--Nota de Entrada, Tranferência e OM
      order by
        dt_movimento_estoque desc
    end

    --Procedimento para pegar o valor de 70% do valor de venda
    If IsNull(@vl_custo, 0) <= 0
    Begin
      select @vl_custo = IsNull(sum(qt_item_nota_saida * vl_unitario_item_nota),0)
      from nota_saida_item
      where cd_produto = @cd_produto
        and cd_nota_saida = @cd_documento
        and cd_item_nota_saida = @cd_documento_item
    End

  End Else
  --Realiza o cálculo através do fechamento do produto
  --Verificando a fase e o período passado
  If @ic_origem_custo = 'F'
  Begin

    select @vl_custo = sum(qt_atual_prod_fechamento * vl_custo_prod_fechamento) 
    from produto_fechamento
    where 
      dt_produto_fechamento between @dt_inicial and @dt_final
      and cd_fase_produto = @cd_fase_produto
      and cd_produto = @cd_produto

  End Else
  --Realiza o cálculo através da tabela produto custo
  --Verificando a fase e o período passado
  If @ic_origem_custo = 'R'
  Begin

    select @vl_custo = vl_custo_produto 
    from produto_custo
    where cd_produto = @cd_produto

  End Else
  --Realiza o cálculo através da tabela produto custo com o campo contábil
  --Verificando a fase e o período passado
  If @ic_origem_custo = 'C'
  Begin

    select @vl_custo = vl_custo_contabil_produto
    from produto_custo
    where cd_produto = @cd_produto

  End

  return cast(IsNull(@vl_custo,0) as decimal (15,2))
end
