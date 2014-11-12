
create procedure pr_atualizar_saldo_previsoes_entrada(
  @cd_fase_produto int,
  @cd_produto int )
---------------------------------------------------------------------------------------------------
--pr_atualizar_saldo_previsoes_entrada
---------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Eduardo
--Banco de Dados	: EGISSQL
--Objetivo		: Atualizar o Saldo das Previsões de Entrada dos Produtos do Pedido ou Nota
--Data			: 04/03/2004
--                      : 08/03/2004 - Modificada para Chamar um produto por vez
--                      : 22/11/2005 - Buscar também os PC recebidos Parcialmente - ELIAS
--                      : 15/03/2006 - Incluir também as previsões digitadas pela Importação - ELIAS
--                      : 23/03/2006 - ACERTO ESPECÍFICO POLIMOLD, NÃO PROCESSAR COMPRA ESPECIAL - ELIAS
--                      : 24/07/2006 - Ajuste na Fase Default do PC.
--                                   - Não estava limpando devidamente as datas, quando não havia mais previsão - ELIAS
--                      : 05/10/2006 - Força o índice de PK na Produto Saldo - ELIAS
---------------------------------------------------------------------------------------------------
as

  SET NOCOUNT ON

-- CÓDIGO INSERIDO, ESPECÍFICO DA POLIMOLD - VERIFICAR MELHOR CASO
-------------------------------------------------------------------------------
-- PRODUTO 8763 ESPECIAL E 53786 ROSCA, NÃO EXECUTAR PREVISÃO
if ((isnull(@cd_produto,0) <> 0) and (isnull(@cd_produto,0) <> 8763) and
  (isnull(@cd_produto,0) <> 53786))      
-------------------------------------------------------------------------------
begin

  --declarar variáveis
  declare @produto int
  declare @dataitem datetime
  declare @saldoitem float

  declare @dtprev1 datetime
  declare @dtprev2 datetime
  declare @dtprev3 datetime

  declare @qtprev1 float
  declare @qtprev2 float
  declare @qtprev3 float

  -- Indica se a previsão armazenará somente Importação, Compra ou Ambos - ELIAS
  declare @ic_previsao char(1)

  -- Fase Padrão, quando o PC não ter Fase na Requisição.
  declare @cd_fase_padrao int
  select @cd_fase_padrao = cd_fase_produto
  from Parametro_Suprimento
  where cd_empresa = dbo.fn_empresa()
  
  -- limpar as variáveis de previsão
  set @dtprev1 = null
  set @dtprev2 = null
  set @dtprev3 = null

  set @qtprev1 = null
  set @qtprev2 = null
  set @qtprev3 = null

  select @ic_previsao = ic_previsao_evolucao_consumo 
  from Parametro_Estoque
  where cd_empresa = dbo.fn_empresa()

  -- Limpando as Datas para poder reprocessá-las
  update produto_saldo
    set dt_prev_ent1_produto = null,
        qt_prev_ent1_produto = null,
        dt_prev_ent2_produto = null,
        qt_prev_ent2_produto = null,
        dt_prev_ent3_produto = null,
        qt_prev_ent3_produto = null
  from Produto_Saldo with(index(PK_Produto_Saldo))
  where
    cd_produto = @cd_produto and
    cd_fase_produto = @cd_fase_produto

  -- Buscar as previsões
  declare cr cursor for
    select
      pci.cd_produto,
      pci.dt_entrega_item_ped_compr,
      sum(pci.qt_saldo_item_ped_compra) as qt_saldo_item_ped_compra 
    from Pedido_Compra_Item pci with (nolock) inner join 
      Pedido_Compra pc with (nolock) on pc.cd_pedido_compra = pci.cd_pedido_compra left outer join
      Requisicao_Compra rc with(nolock) on pci.cd_requisicao_compra = rc.cd_requisicao_compra left outer join 
      Tipo_Requisicao tr with(nolock) on rc.cd_tipo_requisicao = tr.cd_tipo_requisicao  left outer join
      Produto_Compra pco with(nolock) on pci.cd_produto = pco.cd_produto
    where pc.dt_cancel_ped_compra is null and
      pci.qt_saldo_item_ped_compra > 0 and
      pci.dt_item_canc_ped_compra is null and
      pci.cd_produto = @cd_produto --and
--      isnull(tr.cd_fase_produto, isnull(pco.cd_fase_produto_entrada, @cd_fase_padrao)) = @cd_fase_produto
    group by pci.cd_produto,
      pci.dt_entrega_item_ped_compr
    union all
    select
      ps.cd_produto,
      ps.dt_ped_comp_imp1 as dt_entrega_item_ped_compr,
      qt_ped_comp_imp1 as qt_saldo_item_ped_compra
    from Produto_Saldo ps with (nolock, index(PK_Produto_Saldo))
    where ps.cd_produto = @cd_produto and
      ps.cd_fase_produto = @cd_fase_produto and
      isnull(ps.dt_ped_comp_imp1,0) <> 0 and
      @ic_previsao = 'A'  -- Ambas (Compras e Importação)
    union all
    select
      ps.cd_produto,
      ps.dt_ped_comp_imp2 as dt_entrega_item_ped_compr,
      qt_ped_comp_imp2 as qt_saldo_item_ped_compra
    from Produto_Saldo ps with (nolock, index(PK_Produto_Saldo))
    where ps.cd_produto = @cd_produto and
      ps.cd_fase_produto = @cd_fase_produto and
      isnull(ps.dt_ped_comp_imp2,0) <> 0 and
      @ic_previsao = 'A'  -- Ambas (Compras e Importação)
    union all
    select
      ps.cd_produto,
      ps.dt_ped_comp_imp3 as dt_entrega_item_ped_compr,
      qt_ped_comp_imp3 as qt_saldo_item_ped_compra
    from Produto_Saldo ps with (nolock, index(PK_Produto_Saldo))
    where ps.cd_produto = @cd_produto and
      ps.cd_fase_produto = @cd_fase_produto and
      isnull(ps.dt_ped_comp_imp3,0) <> 0 and
      @ic_previsao = 'A'  -- Ambas (Compras e Importação)
    order by 2, 3

  open cr

  fetch next from cr into @produto, @dataitem, @saldoitem

  while @@FETCH_STATUS = 0
  begin

    if @dtprev1 is null
    begin
      set @dtprev1 = @dataitem 
      set @qtprev1 = @saldoitem 
    end  
    else if @dtprev2 is null
    begin
      set @dtprev2 = @dataitem 
      set @qtprev2 = @saldoitem 
    end  
    else if @dtprev3 is null
    begin
      set @dtprev3 = @dataitem 
      set @qtprev3 = @saldoitem 
    end
    else
    begin
      break
    end  

    fetch next from cr into @produto, @dataitem, @saldoitem

  end

  -- Atualizar o Saldo das Previsões
  update produto_saldo
    set dt_prev_ent1_produto = @dtprev1,
        qt_prev_ent1_produto = @qtprev1,
        dt_prev_ent2_produto = @dtprev2,
        qt_prev_ent2_produto = @qtprev2,
        dt_prev_ent3_produto = @dtprev3,
        qt_prev_ent3_produto = @qtprev3
  from Produto_Saldo with(index(PK_Produto_Saldo))
  where
    cd_produto = @cd_produto and
    cd_fase_produto = 3 --@cd_fase_produto

  close cr
  deallocate cr

end
  
