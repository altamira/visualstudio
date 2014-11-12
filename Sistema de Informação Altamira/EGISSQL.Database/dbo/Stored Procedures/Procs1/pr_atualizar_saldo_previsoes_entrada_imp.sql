
create procedure pr_atualizar_saldo_previsoes_entrada_imp

--------------------------------------------------------------------
--pr_atualizar_saldo_previsoes_entrada_imp
--------------------------------------------------------------------
--GBS - Global Business Solution Ltda                         2004
--------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Igor
--Banco de Dados	: EGISSQL
--Objetivo		: Atualizar o Saldo das Previsões de Entrada dos Produtos do Pedido de importação
--Data			: 19.03.2004
--Atualização           : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 02.09.2005 - Atualizar a Tabela Produto Saldo com a qtd. pedido de importação
--                                     Cancelamento / Ativação do Pedido de Importação   
--                                   - Carlos Fernandes         
-------------------------------------------------------------------------------------------------------
@cd_fase_produto int,
@cd_produto      int, 
@qt_item_ped_imp float   = 0,
@ic_ativar       char(1) = ''
as

--Carlos 02.09.2005
if @ic_ativar = 'S' --Ativação do Pedido de Importação
begin

  update produto_saldo
  set 
    qt_importacao_produto = qt_importacao_produto + isnull(@qt_item_ped_imp,0)
  where
    @cd_produto      = cd_produto and
    @cd_fase_produto = cd_fase_produto

end

if @ic_ativar='N' --Cancelamento do Pedido de Importação
begin

  update produto_saldo
  set 
    qt_importacao_produto = qt_importacao_produto - isnull(@qt_item_ped_imp,0)
  where
    @cd_produto      = cd_produto and
    @cd_fase_produto = cd_fase_produto

end

--declarar variáveis

declare @produto   int
declare @dataitem  datetime
declare @saldoitem float
declare @pedido    float

declare @dtprev1 datetime
declare @dtprev2 datetime
declare @dtprev3 datetime

declare @qtprev1 float
declare @qtprev2 float
declare @qtprev3 float

declare @pedido1 float
declare @pedido2 float
declare @pedido3 float

-- limpar as variáveis de previsão
set @dtprev1 = null
set @dtprev2 = null
set @dtprev3 = null

set @qtprev1 = null
set @qtprev2 = null
set @qtprev2 = null

set @pedido1 = null
set @pedido2 = null
set @pedido3 = null

  --Pedido de Importação
  select
     it.cd_produto,
     pim.dt_pedido_importacao data,
     pim.cd_pedido_importacao pedido,
     sum(it.qt_saldo_item_ped_imp) as qt_saldo_item
  Into
    #Saldo
  from
    pedido_importacao_item it
      inner join 
    pedido_importacao pim
      on pim.cd_pedido_importacao = it.cd_pedido_importacao
  where
    ISNULL(pim.cd_status_pedido,0) in (0,15)
    and
    pim.dt_canc_pedido_importacao is null
    and
     it.qt_saldo_item_ped_imp > 0
     and
    it.dt_cancel_item_ped_imp  is null
    and
    it.cd_produto = @cd_produto
  group by
     it.cd_produto,
     pim.dt_pedido_importacao,
     pim.cd_pedido_importacao
  order by
     it.cd_produto,
     pim.dt_pedido_importacao,
     pim.cd_pedido_importacao

-- Buscar as previsões
declare cr cursor for
  Select cd_produto, pedido, data, qt_saldo_item
  From #Saldo
  Order by data desc
-- abrir o cursor
open cr

fetch next from cr into @produto, @pedido, @dataitem, @saldoitem

while @@FETCH_STATUS = 0
begin

  if @dtprev1 is null
  begin
    set @dtprev1 = @dataitem 
    set @qtprev1 = @saldoitem 
    set @pedido1 = @pedido
  end  
  else if @dtprev2 is null
  begin
    set @dtprev2 = @dataitem 
    set @qtprev2 = @saldoitem 
    set @pedido2 = @pedido
  end  
  else if @dtprev3 is null
  begin
    set @dtprev3 = @dataitem 
    set @qtprev3 = @saldoitem 
    set @pedido3 = @pedido
  end
  else
  begin
    break
  end  

  fetch next from cr into @produto, @pedido, @dataitem, @saldoitem

end

-- Atualizar o Saldo das Previsões
Update produto_saldo
  set cd_ped_comp_imp1 = @pedido1,
      dt_ped_comp_imp1 = @dtprev1,
      qt_ped_comp_imp1 = @qtprev1,
      cd_ped_comp_imp2 = @pedido2,
      dt_ped_comp_imp2 = @dtprev2,
      qt_ped_comp_imp2 = @qtprev2,
      cd_ped_comp_imp3 = @pedido3,
      dt_ped_comp_imp3 = @dtprev3,
      qt_ped_comp_imp3 = @qtprev3

Where
  cd_produto      = @cd_produto and
  cd_fase_produto = @cd_fase_produto


close cr
deallocate cr
  
