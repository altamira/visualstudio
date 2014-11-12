
create procedure pr_situacao_pedido_compra
@cd_pedido_compra int
as

select 
  pedmov as 'Pedido',
  datmov as 'Data',
  hormov as 'Hora',
  setmov as 'Setor',
  hismov as 'Historico',
  obsmov as 'Observacao',
  cobmov as 'Fornecedor',
  usumov as 'Usuario'
from
  sap.dbo.CADHPCO 
Where
  pedmov = @cd_pedido_compra
order by
  datmov, hormov, hismov
