-------------------------------------------------------------------------- 
CREATE PROCEDURE pr_atualiza_status_pedido_venda
--------------------------------------------------------------------------
--pr_atualiza_status_pedido_venda
--------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                               2004 
--------------------------------------------------------------------------
-- Stored Procedure     : SQL Server 2000
-- Autor(es)            : Fabio Cesar
-- Banco de Dados       : EGISSQL
-- Objetivo             : Atualiza o status do pedido de venda
-- Data                 : 27.04.2003	
-- Atualização          : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--		        : cd_pedido_venda - Código do Pedido de Venda
--                       : 08.08.2005 - Incluido para gravar a data de cancelamento do pedido 
--                                      quando muda o estado para cancelado. - Rafael Santiago.
-- 18.11.2009 - Verificar se ficou item de nota de saida sem Cabeçalho de Nota - Carlos Fernandes
-- 18.04.2010 - Quando o Pedido for Cancelado, zerar o Pedido na Ordem de Serviço - Carlos Fernandes              
-----------------------------------------------------------------------------------------------------
@cd_pedido_venda int = 0,
@cd_usuario      int = 0
as

  declare @qt_item_pedido  int,
       	  @qt_item_cancelado int,
      	  @qt_item_faturado  int

  --Atualiza o status do pedido de venda
  --7 - Cancelado
  --1 - Aberto
  --2 - Liquidado

  --Contagem de itens do pedido

  select
  	@qt_item_pedido = count('x') 
  from
	  Pedido_Venda_Item
  where
	  cd_pedido_venda = @cd_pedido_venda

  --Contagem de itens do pedido cancelados
  select
	  @qt_item_cancelado = count('x') 
  from
	  Pedido_Venda_Item with (nolock) 
  where
        cd_pedido_venda = @cd_pedido_venda and 
  	dt_cancelamento_item is not null
	
  --Contagem de itens do pedido cancelados

  select
	  @qt_item_faturado = count('x') 
  from
	  Pedido_Venda_Item with (nolock) 
  where
	  cd_pedido_venda = @cd_pedido_venda and 
  	dt_cancelamento_item is null and
  	IsNull(qt_saldo_pedido_venda,0) <= 0

  --Atualiza o status do pedido	cancelado

  if (@qt_item_pedido = @qt_item_cancelado)
  begin
    update Pedido_Venda 
      set cd_status_pedido = 7, 
          dt_cancelamento_pedido = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
         --cast((CONVERT(VARCHAR(10), GETDATE(), 105)) as datetime) 
    where
      cd_pedido_venda = @cd_pedido_venda

    --select cd_pedido_venda,* from ordem_servico_grafica

    --Volta a Ordem de Serviço em aberto

    update
      ordem_servico_grafica
    set
      cd_pedido_venda        = 0,
       ic_fechamento_servico = 'N'
    where
      cd_pedido_venda = @cd_pedido_venda

  end

  -- Liquidado -----------------------------------------------------------------------------------

  else if (@qt_item_pedido  = @qt_item_faturado) or 
          ((@qt_item_pedido = @qt_item_faturado + @qt_item_cancelado) and 
           (@qt_item_faturado > 0))
  begin
    update Pedido_Venda set cd_status_pedido = 2 
    where cd_pedido_venda = @cd_pedido_venda
  end
  --Aberto
	else
  begin
	  update Pedido_Venda
          set cd_status_pedido          = 1,
              ic_fat_total_pedido_venda = 'N', 
              ic_fat_pedido_venda       = 'N',
              dt_cancelamento_pedido    = NULL   
    where cd_pedido_venda = @cd_pedido_venda

  end

  --Verificar se existe a Nota do Item p/ o pedido de venda e não existe o Pai
  --Carlos - 10.12.2009
  --Comentei estava dando problema grave

--   select
--     i.cd_pedido_venda,
--     i.cd_nota_saida,
--     i.cd_item_nota_saida,
--     case when isnull(n.cd_nota_saida,0)=0 then
--       'S'
--     else
--       'N'
--     end               as ic_deletar     
--   into
--     #nota
--   from
--     nota_saida_item i
--     left outer join nota_saida n on n.cd_nota_saida = i.cd_nota_saida
--   where
--     i.cd_pedido_venda = @cd_pedido_venda
-- 
-- 
--   --select * from #nota
-- 
--   if exists( select cd_nota_saida from #nota where ic_deletar = 'S' )
--   begin
--     delete from nota_saida_item 
--     where 
--       cd_pedido_venda = @cd_pedido_venda
--   end
-- 
--  drop table #nota 
-- 
--  --Atualiza o Status do Pedido e o Saldo do Pedido de Venda
-- 
--    update
--     pedido_venda_item
--   set
--     qt_saldo_pedido_venda = 0
--   from
--     pedido_venda_item ip
--     inner join nota_saida_item i on i.cd_pedido_venda      = ip.cd_pedido_venda and
--                                     i.cd_item_pedido_venda = ip.cd_item_pedido_venda
-- 
--   where
--     ip.qt_saldo_pedido_venda = qt_item_pedido_venda and
--     ip.cd_pedido_venda       = @cd_pedido_venda
-- 
--   update
--     pedido_venda
--   set
--     cd_status_pedido = 2
--   from
--     pedido_venda pv 
--     inner join pedido_venda_item ip on ip.cd_pedido_venda = pv.cd_pedido_venda
--     inner join nota_saida_item i on i.cd_pedido_venda      = ip.cd_pedido_venda and
--                                   i.cd_item_pedido_venda = ip.cd_item_pedido_venda
--   where
--     qt_saldo_pedido_venda = 0 and
--     pv.cd_status_Pedido   = 1 and
--     i.cd_pedido_venda     = @cd_pedido_venda

