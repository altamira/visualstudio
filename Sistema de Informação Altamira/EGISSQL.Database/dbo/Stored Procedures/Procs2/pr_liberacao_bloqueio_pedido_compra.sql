
-------------------------------------------------------------------------------
--sp_helptext pr_liberacao_bloqueio_pedido_compra
-------------------------------------------------------------------------------
--pr_liberacao_bloqueio_pedido_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : EgisAdmin ou Egissql
--
--Objetivo         : Liberação do Pedido de Compra
--Data             : 29.10.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_liberacao_bloqueio_pedido_compra

@ic_parametro              int      = 0,
@cd_usuario                int      = 0,
@cd_pedido_compra          int      = 0,
@dt_inicial                datetime = '',
@dt_final                  datetime = ''

as

-------------------------------------------------------
if @ic_parametro = 1 -- Consulta os pedidos do usuário.
--------------------------------------------------------
begin

 
  select     
    distinct
      pc.cd_pedido_compra, 
      pc.dt_pedido_compra, 
      f.nm_fantasia_fornecedor, 
      plano.nm_plano_compra,
      IsNull(pc.vl_total_pedido_ipi, pc.vl_total_pedido_compra) as vl_total_pedido_compra, 
      pc.dt_nec_pedido_compra, 
      cp.nm_condicao_pagamento, 
      (select top 1 pci.cd_requisicao_compra 
       from Pedido_Compra_Item pci with (nolock) 
       where pci.cd_pedido_compra = pc.cd_pedido_compra ) 	as 'cd_requisicao_compra', 
      'N' 							as 'ic_aprov_comprador_pedido',
      u.nm_fantasia_usuario 					as 'Requisitante',
      d.nm_departamento,
      c.nm_fantasia_comprador,
      cast('' as varchar(60)) 					as 'NomeLiberador',
      pc.dt_alteracao_ped_compra,
      IsNull(tap.nm_tipo_alteracao_pedido + '-','') + IsNull(pc.ds_alteracao_ped_compra,'') as 'ds_alteracao_ped_compra',
     ( select min(dt_entrega_item_ped_compr) 
       from Pedido_Compra_Item x with (nolock) 
       where x.cd_pedido_compra = pc.cd_pedido_compra) as dt_entrega_item_ped_compr,
      cc.nm_centro_custo

    from
      Pedido_Compra pc            with (nolock)                                 left outer join 
      Fornecedor f                on pc.cd_fornecedor             = f.cd_fornecedor left outer join
      Condicao_Pagamento cp       on pc.cd_condicao_pagamento     = cp.cd_condicao_pagamento left outer join
      Departamento d              on d.cd_departamento            = pc.cd_departamento  left outer join
      Comprador c                 on  c.cd_comprador              = pc.cd_comprador inner join
      EGISADMIN.dbo.Usuario u     on u.cd_usuario                 = pc.cd_usuario            left outer join
      Tipo_Alteracao_Pedido tap   on tap.cd_tipo_alteracao_pedido = pc.cd_tipo_alteracao_pedido left outer join
      Plano_Compra plano          on plano.cd_plano_compra        = pc.cd_plano_compra                 left outer join
      Centro_Custo cc             on cc.cd_centro_custo           = pc.cd_centro_custo
    where 
       pc.dt_cancel_ped_compra is null              and
       pc.cd_pedido_compra   = case when @cd_pedido_compra = 0 then pc.cd_pedido_compra else @cd_pedido_compra end

       --Verifica se o Pedido está bloqueado
       and
       pc.cd_pedido_compra in ( select b.cd_pedido_compra from pedido_compra_bloqueio b
                                where
                                  pc.cd_pedido_compra = b.cd_pedido_compra and
                                  isnull(b.ic_bloqueio_pedido,'N')='S'     and
                                  b.dt_liberacao_bloqueio is null )


    Order by
       pc.dt_pedido_compra 

end

-------------------------------------------------------------------------
else if @ic_parametro = 2 -- Atualiza as tabelas de Pedido de Compra.
-------------------------------------------------------------------------
begin

  update
    pedido_compra_bloqueio

  set
    ic_bloqueio_pedido        = 'N',
    cd_usuario_liberacao      = @cd_usuario,
    dt_liberacao_bloqueio     = getdate(),
    nm_obs_liberacao_bloqueio = 'Liberação Pedido Acima Limite'

  where
    cd_pedido_compra = @cd_pedido_compra


  --select * from pedido_compra_bloqueio

end
-------------------------------------------------------------------------
else if @ic_parametro = 3 -- Atualiza a tabela de Pedido de Compra.
-------------------------------------------------------------------------
begin

  --Atualiza o Flag quando o pedido de compra estiver com a Aprovação Total
  
  update
     pedido_compra
  set
     ic_aprov_pedido_compra = 'S',
     cd_usuario             = @cd_usuario,
     dt_usuario             = getDate()
  where
     cd_pedido_compra = @cd_pedido_compra
   

end


