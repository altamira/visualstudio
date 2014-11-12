
CREATE PROCEDURE pr_cancela_liberacao_pedido_compra

--pr_cancela_liberacao_pedido_compra
---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EgisSql
--Objetivo: Fazer o Cancelamento de uma Liberação do Pedido de Compra.
--Data: 15/09/2003
-- 28/11/2003 - Daniel C. Neto - Acerto, inclusão de novo parâmetro
-- 24/08/2006 - Ajuste para listar todos os PCs Liberados corretamente - ELIAS
---------------------------------------------------

@cd_pedido_compra as int,
@dt_inicial datetime,
@dt_final datetime,
@ic_tipo_filtro char(1),
@cd_usuario int

AS

begin

  select distinct
    pc.cd_pedido_compra, 
    pc.dt_pedido_compra, 
    f.nm_fantasia_fornecedor, 
    pc.vl_total_pedido_compra, 
    pc.dt_nec_pedido_compra, 
    cp.nm_condicao_pagamento, 
    pc.cd_requisicao_compra, 
    'N' as 'ic_aprov_comprador_pedido',
    '' as 'Requisitante' 
  from 
    Pedido_Compra pc 
    Left outer join Fornecedor f ON pc.cd_fornecedor = f.cd_fornecedor 
    left outer join Condicao_Pagamento cp ON pc.cd_condicao_pagamento = cp.cd_condicao_pagamento 
    left outer join Pedido_Compra_Aprovacao pca on pca.cd_pedido_compra = pc.cd_pedido_compra
  where      
    ((IsNull(pc.ic_aprov_pedido_compra,'N') = 'S') or (IsNull(pc.ic_aprov_comprador_pedido,'N') = 'S')) and         
     ((pc.cd_pedido_compra = @cd_pedido_compra) or (@cd_pedido_compra = 0)) and

    (((@ic_tipo_filtro = 'P') and (pc.dt_pedido_compra between cast(cast(@dt_inicial as int) as datetime) and cast(cast(@dt_final as int) as datetime))) or

    ((@ic_tipo_filtro = 'A') and (pca.dt_usuario_aprovacao between cast(cast(@dt_inicial as int) as datetime) and cast(cast(@dt_final as int) as datetime)))) and 

    pc.cd_status_pedido in (8, 10) and
    pca.cd_usuario_aprovacao = @cd_usuario 
  

end

