
-------------------------------------------------------------------------------
--pr_limpeza_movimento_caixa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--                 : 04.03.2006
--                 : 20.03.2006 - Acerto na Limpeza da Tabela de Abertura/Fechamento - Carlos Fernandes
-------------------------------------------------------------------------------------------------------
create procedure pr_limpeza_movimento_caixa

as

 declare @dt_inicial datetime
 declare @dt_final   datetime

 select @dt_inicial = min(dt_movimento_caixa) from Movimento_Caixa
 set    @dt_final   = getdate()
  
 --Montagem de uma tabela temporária para deleção do movimento de caixa
 --

 select
   distinct mc.cd_movimento_caixa
 into #MovimentoCaixa
 from 
   Movimento_Caixa mc
   left outer join movimento_caixa_item mci on mci.cd_movimento_caixa   = mc.cd_movimento_caixa
   left outer join Nota_Saida_Item nsi on nsi.cd_pedido_venda      = mci.cd_pedido_venda and
                                          nsi.cd_item_pedido_venda = mci.cd_item_pedido_venda
 where
    mc.dt_movimento_caixa between @dt_inicial and @dt_final and
    isnull(mc.cd_cupom_fiscal,0)=0  and
    isnull(mci.cd_pedido_venda,0)=0 and
    isnull(mci.cd_cupom_fiscal,0)=0 and
    nsi.dt_restricao_item_nota is null 
    
--Teste    mc.cd_movimento_caixa = 228
 --select * from #MovimentoCaixa
   
 declare @cd_movimento_caixa int
 set @cd_movimento_caixa = 0

 while exists ( select top 1 cd_movimento_caixa from #MovimentoCaixa )
 begin
   select top 1 @cd_movimento_caixa = cd_movimento_caixa 
   from 
     #MovimentoCaixa

   delete from Movimento_Caixa_Parcela
   where cd_movimento_caixa = @cd_movimento_caixa
      
   delete from Movimento_Caixa_Item 
   where cd_movimento_caixa = @cd_movimento_caixa

   delete from Movimento_Caixa      
   where cd_movimento_caixa = @cd_movimento_caixa

   delete from #MovimentoCaixa      
   where 
     cd_movimento_caixa = @cd_movimento_caixa

 end

 --Abertura de Caixa
 --select * from abertura_caixa_composicao 
 --select * from abertura_caixa

   select @dt_inicial = min(dt_abertura_caixa) from Abertura_Caixa

   delete abertura_caixa_composicao
   from 
     abertura_caixa_composicao
   inner join abertura_caixa on abertura_caixa.cd_abertura_caixa = abertura_caixa_composicao.cd_abertura_caixa
   where
     abertura_caixa.dt_abertura_caixa between @dt_inicial and @dt_final

  delete from abertura_caixa where dt_abertura_caixa between @dt_inicial and @dt_final
  
  --Fechamento de Caixa
  --select * from fechamento_caixa_composicao
  --select * from fechamento_caixa

   select @dt_inicial = min(dt_fechamento_caixa) from Fechamento_Caixa

   delete fechamento_caixa_composicao
   from 
     fechamento_caixa_composicao
   inner join fechamento_caixa on fechamento_caixa.cd_fechamento_caixa = fechamento_caixa_composicao.cd_fechamento_caixa
   where
     fechamento_caixa.dt_fechamento_caixa between @dt_inicial and @dt_final

  delete from fechamento_caixa where dt_fechamento_caixa between @dt_inicial and @dt_final


