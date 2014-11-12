
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_vendas_entrada_financeira
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Mapa de Vendas por Entrada Financeira conforme a Condição de Pagamento
--
--Parâmetros       : Plano de vendas
--                   
--
--Data             : 02.02.2005
--Atualizado       : 09/11/2006 - Acerto na localização da chave da parcela da condição de 
-- pgto que estava sempre começando com o n. 1, sendo que a chave desta tabela Condicao_Pagamento_Parcela
-- é sequencial o que fazia com que os cálculos se perdessem
--                              - Daniel C. Neto.
-- 29.01.2009 - Desenvolvimento Completo 
--------------------------------------------------------------------------------------------------
create procedure pr_mapa_vendas_entrada_financeira
@ic_parametro    int,
@dt_inicial      datetime,
@dt_final        datetime
as

select
  
  c.nm_fantasia_cliente                as Cliente,
  pv.cd_pedido_venda                   as PedidoVenda,
  pv.dt_pedido_venda                   as Emissao,
  isnull(pv.vl_total_pedido_venda,0)   as TotalPedido,
  cp.cd_condicao_pagamento             as cd_condicao_pagamento,
  cp.nm_condicao_pagamento             as CondicaoPagamento,
  cp.qt_parcela_condicao_pgto          as QtdParcela

into
  #MapaVenda
from
  Pedido_Venda pv                       with (nolock) 
  left outer join Condicao_Pagamento cp with (nolock) on cp.cd_condicao_pagamento = pv.cd_condicao_pagamento 
  left outer join Cliente            c  with (nolock) on c.cd_cliente             = pv.cd_cliente
where
  pv.dt_pedido_venda between @dt_inicial and @dt_final and
  pv.dt_cancelamento_pedido is null and
  exists ( select 'x' from Pedido_Venda_Item x 
           where x.cd_pedido_venda                 = pv.cd_pedido_venda and
                 isnull(x.qt_saldo_pedido_venda,0) > 0  and
                 x.dt_cancelamento_item is null )
           
--select * from pedido_venda

--Mapa de vendas Auxiliar

select
  *
into
  #MapaVendaAux
from
  #MapaVenda
where
  isnull(cd_condicao_pagamento,0)>0 and isnull(qtdParcela,0)>0

--select * from #Mapavenda

--Montagem da Tabela Auxiliar com o Desdobramento

create table #Parcela_Venda
( cd_pedido_Venda   int null,
  vl_parcela        float null,
  dt_parcela        datetime null)

declare @cd_pedido_venda       int
declare @qt_parcela            int
declare @qt_parcela_aux        int
declare @vl_parcela            float
declare @dt_parcela            datetime
declare @cd_condicao_pagamento int
declare @dt_emissao_pedido     datetime
declare @vl_total_venda        float

while exists ( select top 1 pedidovenda from #MapaVendaAux )
begin

  select top 1
    @cd_pedido_venda       = PedidoVenda,
    @qt_parcela            = QtdParcela,
    @cd_condicao_pagamento = cd_condicao_pagamento,
    @dt_emissao_pedido     = Emissao,
    @vl_total_venda        = TotalPedido,
    @vl_parcela            = 0,
    @dt_parcela            = null
  from
    #MapaVendaAux

  set @qt_parcela_aux =  IsNull(( select min(cd_condicao_parcela_pgto)
		             from Condicao_Pagamento_parcela  with (nolock) 
			     where 
                                cd_condicao_pagamento = @cd_condicao_pagamento ),1)

  set @qt_parcela = @qt_parcela + @qt_parcela_aux

  while @qt_parcela_aux <= @qt_parcela
  begin

    --select * from condicao_pagamento_parcela    
    --Busca dados da Parcela / Cálculo

    if exists ( select 'x' from
		      Condicao_Pagamento_parcela with (nolock) 
		where
		       cd_condicao_pagamento    = @cd_condicao_pagamento and
		       cd_condicao_parcela_pgto = @qt_parcela_aux )
    begin

      select @dt_parcela = @dt_emissao_pedido + qt_dia_cond_parcela_pgto,
             @vl_parcela = ( @vl_total_venda * (pc_condicao_parcela_pgto/100))      
      from
        Condicao_Pagamento_parcela with (nolock)  
      where
         cd_condicao_pagamento    = @cd_condicao_pagamento and
         cd_condicao_parcela_pgto = @qt_parcela_aux

      --Gera Tabela de Parcelas
      Insert 
        #Parcela_Venda
      ( cd_pedido_venda, 
        vl_parcela,    
        dt_parcela  )
      Select
        @cd_pedido_venda,
        @vl_parcela,
         @dt_parcela
    end

    set @qt_parcela_aux = @qt_parcela_aux + 1

  end

  delete from #MapaVendaAux where @cd_pedido_venda = PedidoVenda

end

--Mostra as Parcelas

--select * from #Parcela_venda

--Valor Total de vendas

set @vl_total_venda = 0

select 
  @vl_total_venda = isnull( sum(TotalPedido),0) 
from
  #MapaVenda


--Finalizacao da Tabela para Apresentação

select
  mc.*,
  ( mc.TotalPedido / @vl_total_venda ) * 100 as Percentual,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=1 )  as Janeiro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=2 )  as Fevereiro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=3 )  as Marco,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=4 )  as Abril,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=5 )  as Maio,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=6 )  as Junho,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=7 )  as Julho,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=8 )  as Agosto,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=9 )  as Setembro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=10 ) as Outubro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=11 ) as Novembro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_venda where cd_pedido_venda = mc.Pedidovenda  and month(dt_parcela)=12 ) as Dezembro
  
from
  #Mapavenda mc
order by
  mc.TotalPedido desc


