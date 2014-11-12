
---------------------------------------------------------------------
CREATE PROCEDURE pr_atualiza_saldo_item_pedido_venda
---------------------------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Carlos Cardoso Fernandes
--Banco de Dados  : EGISSQL
--Objetivo        : Atualizar o Saldo do item do Pedido de Venda
--@ic_parametro   : 1-Cancelamento da Nota Fiscal
--                  2-Ativação do Cancelamento da Nota Fiscal
--Data            : 28/07/2002
--Atualizado      : 14/04/2003 - Atualização dos campos de data de 
--                  atualização e usuário - ELIAS
--                  Atualização do flag ic_fat_total_pedido_venda - ELIAS
--                  Verificação na atualização do saldo que não pode ser jamais superior a
--                  quantidade original e nunca inferior a 0 - ELIAS
--                : 25/08/2003 - Inclusão de Filtro de NF, devido a Op. Triangular,
--                  onde duas NFs contém o mesmo número de PV - ELIAS
-- 23.06.2005 aCERTO PARA NÃO DESMARCAR O ITEM DA PREVIA DE FATURAMENTO - Rafael Santiago
-- 02.06.2008 - Acerto do Saldo da Ordem de Produção - Carlos Fernandes
-- 13.02.2009 - Ajuste da Quantidade do Item do Pedido de Venda quando Múltiplo de Embalagem
---------------------------------------------------------------------------------------------
@ic_parametro                int   = 0, 
@cd_pedido_venda             int   = 0,
@cd_item_pedido_venda        int   = 0,
@qt_item_nota_fiscal         float = 0,
@cd_usuario		     int   = 0

AS

declare @qt_saldo_pedido_venda float
declare @qt_item_pedido_venda  float

--declare @cd_processo_producao  int 
--select cd_pedido_venda,cd_item_pedido_venda,* from processo_producao

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- Faturar o Pedido de Venda
-------------------------------------------------------------------------------
  begin

    -- verificando se o saldo será inferior a 0 - ELIAS 14/04/2003

    select
      @qt_saldo_pedido_venda = isnull(qt_saldo_pedido_venda,0)
    from
      Pedido_Venda_Item with (nolock)
    where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda
       
    if ((@qt_saldo_pedido_venda - @qt_item_nota_fiscal) < 0)
      set @qt_saldo_pedido_venda = 0
    else
      set @qt_saldo_pedido_venda = @qt_saldo_pedido_venda - @qt_item_nota_fiscal

    -- Atualizando o Saldo Corretamente e outros dados no Item do PV

    update
      Pedido_Venda_Item
    set
      qt_saldo_pedido_venda =  @qt_saldo_pedido_venda,
-- Rafael 23.06.2005
--      ic_fatura_item_pedido = 'N',
      cd_usuario = @cd_usuario,
      dt_usuario = getDate()
    where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda

  end

-------------------------------------------------------------------------------
else if @ic_parametro = 2 --Voltar Saldo para o pedido de Venda
-------------------------------------------------------------------------------
  begin

    -- verificando se o saldo será superior a quantidade inicial - ELIAS 14/04/2003
    select
      @qt_saldo_pedido_venda = isnull(qt_saldo_pedido_venda,0),
      @qt_item_pedido_venda  = isnull(qt_item_pedido_venda,0)
    from
      Pedido_Venda_Item with (nolock)
    where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda
       
    if ((@qt_saldo_pedido_venda + @qt_item_nota_fiscal) > @qt_item_pedido_venda)
      set @qt_saldo_pedido_venda = @qt_item_pedido_venda
    else
      set @qt_saldo_pedido_venda = @qt_saldo_pedido_venda + @qt_item_nota_fiscal


    if @qt_saldo_pedido_venda<0 
       set @qt_saldo_pedido_venda = @qt_item_pedido_venda

    -- Atualizando o Saldo Corretamente e outros dados no Item do PV

    update
      Pedido_Venda_Item
    set
      qt_saldo_pedido_venda = @qt_saldo_pedido_venda,

-- Rafael 23.06.2005
--      ic_fatura_item_pedido = 'N',
      cd_usuario = @cd_usuario,
      dt_usuario = getDate()

    where
      cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda

  end


