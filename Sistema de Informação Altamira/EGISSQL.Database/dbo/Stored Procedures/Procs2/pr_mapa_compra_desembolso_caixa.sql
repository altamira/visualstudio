
-------------------------------------------------------------------------------
--pr_mapa_compra_desembolso_caixa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Mapa de Compras por Desembolso de Caixa conforme a Condição de Pagamento
--
--Parâmetros       : Plano de Compras
--                   
--
--Data             : 02.02.2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_mapa_compra_desembolso_caixa
@ic_parametro    int,
@cd_plano_compra int,
@dt_inicial      datetime,
@dt_final        datetime
as

--select * from plano_compra
--select * from pedido_compra
--select * from condicao_pagamento  
--select * from condicao_pagamento_parcela
--pc_codicao_parcela_pagto7
--qt_dia_cond_parcela_pgto

select
  pc.cd_plano_compra,
  p.cd_mascara_plano_compra   as Codigo,
  p.nm_plano_compra           as PlanoCompra,
  f.nm_fantasia_fornecedor    as Fornecedor,
  pc.cd_pedido_compra         as PedidoCompra,
  pc.dt_pedido_compra         as Emissao,
  pc.vl_total_pedido_compra   as TotalPedido,
  cp.cd_condicao_pagamento    as cd_condicao_pagamento,
  cp.nm_condicao_pagamento    as CondicaoPagamento,
  d.nm_departamento           as Departamento,
  c.nm_comprador              as Comprador,
  cp.qt_parcela_condicao_pgto as QtdParcela
into
  #MapaCompra
from
  Pedido_Compra pc
  left outer join Plano_Compra       p  on p.cd_plano_compra        = pc.cd_plano_compra
  left outer join Condicao_Pagamento cp on cp.cd_condicao_pagamento = pc.cd_condicao_pagamento 
  left outer join Fornecedor         f  on f.cd_fornecedor          = pc.cd_fornecedor
  left outer join Departamento       d  on d.cd_departamento        = pc.cd_departamento
  left outer join Comprador          c  on c.cd_comprador           = pc.cd_comprador
where
  pc.dt_pedido_compra between @dt_inicial and @dt_final and
  IsNull(pc.cd_plano_compra,0) = case when @cd_plano_compra = 0 then IsNull(pc.cd_plano_compra,0) else @cd_plano_compra end and
  pc.dt_cancel_ped_compra is null and
  exists ( select 'x' from Pedido_Compra_Item x 
           where x.cd_pedido_compra = pc.cd_pedido_compra and
                 x.qt_saldo_item_ped_compra > 0 )
           

--Mapa de Compras Auxiliar

select
  *
into
  #MapaCompraAux
from
  #MapaCompra
where
  isnull(cd_condicao_pagamento,0)>0 and isnull(qtdParcela,0)>0

--select * from #MapaCompra

--Montagem da Tabela Auxiliar com o Desdobramento

create table #Parcela_Compra 
( cd_pedido_compra int null,
  vl_parcela        float null,
  dt_parcela        datetime null)

declare @cd_pedido_compra      int
declare @qt_parcela            int
declare @qt_parcela_aux        int
declare @vl_parcela            int
declare @dt_parcela            datetime
declare @cd_condicao_pagamento int
declare @dt_emissao_pedido     datetime
declare @vl_total_compra       float

while exists ( select top 1 pedidocompra from #MapaCompraAux )
begin

  select top 1
    @cd_pedido_compra      = PedidoCompra,
    @qt_parcela            = QtdParcela,
    @cd_condicao_pagamento = cd_condicao_pagamento,
    @dt_emissao_pedido     = Emissao,
    @vl_total_compra       = TotalPedido,
    @vl_parcela            = 0,
    @dt_parcela            = null
  from
    #MapaCompraAux

  set @qt_parcela_aux = 1

  while @qt_parcela_aux <= @qt_parcela
  begin

    --select * from condicao_pagamento_parcela    

    --Busca dados da Parcela / Cálculo
    select @dt_parcela = @dt_emissao_pedido + qt_dia_cond_parcela_pgto,
           @vl_parcela = ( @vl_total_compra * (pc_condicao_parcela_pgto/100))      
    from
      Condicao_Pagamento_parcela 
    where
       cd_condicao_pagamento    = @cd_condicao_pagamento and
       cd_condicao_parcela_pgto = @qt_parcela_aux

    --Gera Tabela de Parcelas
    Insert 
      #Parcela_Compra
    ( cd_pedido_compra, 
      vl_parcela,    
      dt_parcela  )
    Select
      @cd_pedido_compra,
      @vl_parcela,
      @dt_parcela

    set @qt_parcela_aux = @qt_parcela_aux + 1

  end

  delete from #MapaCompraAux where @cd_pedido_compra = PedidoCompra

end

--Mostra as Parcelas

--select * from #Parcela_Compra

--Valor Total de Compras

set @vl_total_compra = 0

select 
  @vl_total_compra = isnull( sum(TotalPedido),0) 
from
  #MapaCompra


--Finalizacao da Tabela para Apresentação

select
  mc.*,
  ( mc.TotalPedido / @vl_total_compra ) * 100 as Percentual,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=1 )  as Janeiro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=2 )  as Fevereiro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=3 )  as Marco,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=4 )  as Abril,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=5 )  as Maio,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=6 )  as Junho,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=7 )  as Julho,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=8 )  as Agosto,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=9 )  as Setembro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=10 ) as Outubro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=11 ) as Novembro,
  ( select isnull(sum(vl_parcela),0) from #Parcela_Compra where cd_pedido_compra = mc.PedidoCompra  and month(dt_parcela)=12 ) as Dezembro
  
from
  #MapaCompra mc
order by
  mc.PlanoCompra,
  mc.TotalPedido desc


