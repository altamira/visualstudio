
-------------------------------------------------------------------------------
--pr_pedido_credito_motivo_liberacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consulta de Pedido Liberado x Motivo de Liberação
--Data             : 13/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_pedido_credito_motivo_liberacao
@cd_motivo_liberacao int
as

select
	mlc.nm_motivo_liberacao,
	mlc.cd_motivo_liberacao,
	v.nm_vendedor,
	vi.nm_vendedor as VendedorI,
	c.nm_fantasia_cliente,
	pv.dt_pedido_venda,
	pv.cd_pedido_venda,
	pv.vl_total_pedido_venda,
	cp.nm_condicao_pagamento 
	
from
	motivo_liberacao_credito mlc left outer join
	cliente_informacao_credito cic on cic.cd_motivo_liberacao = mlc.cd_motivo_liberacao left outer join
	cliente c on c.cd_cliente = cic.cd_cliente left outer join
	vendedor v on v.cd_vendedor = c.cd_vendedor left outer join
	pedido_venda pv on pv.cd_cliente = c.cd_cliente left outer join
	condicao_pagamento cp on cp.cd_condicao_pagamento = c.cd_condicao_pagamento left outer join
	vendedor vi on vi.cd_vendedor = pv.cd_vendedor_interno

Where 
      IsNull(mlc.cd_motivo_liberacao ,0) = 
      case 
         When isnull(@cd_motivo_liberacao ,0) = 0 then 
            IsNull(mlc.cd_motivo_liberacao ,0) 
         else 
           @cd_motivo_liberacao  
         end

order By mlc.nm_motivo_liberacao

