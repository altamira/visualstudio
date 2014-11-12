
CREATE PROCEDURE pr_liberacao_credito_pedido
@ic_parametro              int,
@cd_pedido_venda           int,
@dt_credito_pedido_venda   datetime,
@cd_usuario_credito_pedido int,
@dt_inicial                datetime,
@dt_final                  datetime,
@cd_motivo_liberacao       int = null,
@vl_credito_liberado       Decimal(18,2)

AS
Begin

	declare @cd_vendedor int

	--Define o vendedor para o cliente

	Select
		@cd_vendedor = dbo.fn_vendedor_internet(@cd_usuario_credito_pedido)

  ------------------------------------------------------------------------------
  if @ic_parametro = 1  -- Retorno de todos os pedidos do periodo em analise
  ------------------------------------------------------------------------------
    begin
  
      --select * from pedido_venda

      select 
        1					as 'Liberar',  -- não liberado
        p.cd_pedido_venda			as 'Pedido', 
        p.dt_pedido_venda			as 'Emissao',
        p.cd_cliente			        as 'CodCliente', 
        c.nm_fantasia_cliente                   as 'Cliente',
        isnull(p.ic_fechado_pedido,'N')         as 'Fechado',
        p.vl_total_pedido_venda,
        p.vl_total_ipi,
        p.vl_frete_pedido_venda,
        

--        p.vl_total_pedido_venda 		as 'VlrPedido',

        --Mostra o Valor Total do Pedido com IPI

        case when isnull(p.vl_total_pedido_ipi,0)>0 then
          p.vl_total_pedido_ipi
        else
          p.vl_total_pedido_venda
        end                                     as 'VlrPedido',

        b.sg_condicao_pagamento                 as 'CondPagto',
        mlc.nm_motivo_liberacao                 as 'MotivoLiberacao', 
        isnull(b.cd_condicao_pagamento,0)       cd_condicao_pagamento,		
        v.nm_fantasia_vendedor                  as 'Vendedor',
        i.ic_credito_suspenso                   as 'CreditoSuspenso',
        i.nm_credito_suspenso                   as 'MotivoSuspenso',
        isnull(cc.nm_conceito_cliente,'Não Informado') as 'ConceitoCliente',
        isnull(i.cd_motivo_liberacao, (select top 1 cd_motivo_liberacao
                                       from motivo_liberacao_credito
                                       where ic_pad_motivo_liberacao = 'S')) as 'CodMotivoLiberacao',
        Entrega = 
        ( select
            case when
              min( ip.dt_entrega_vendas_pedido ) = min(ip.dt_item_pedido_venda)
              then 'Imediato'
              else convert( varchar(10),min(ip.dt_entrega_vendas_pedido),103 ) end 
          from
            Pedido_Venda_item ip with (nolock) 
          where
            p.cd_pedido_venda  = ip.cd_pedido_venda ),
        Lib = 
        ( select top 1
            isnull(ic_libpcp_item_pedido,'N')
          from
            Pedido_Venda_item ip with (nolock)
          where
            p.cd_pedido_venda  = ip.cd_pedido_venda and
            isnull(ic_libpcp_item_pedido,'N')='S' ),

        IsNull(p.vl_credito_liberado,0) as vl_credito_liberado,

        p.cd_cliente,

        ( select top 1 tpf.nm_tipo_pendencia
          from
            tipo_pendencia_financeira tpf with (nolock) 
            inner join Pedido_Venda_Pendencia pvp on pvp.cd_tipo_pendencia = tpf.cd_tipo_pendencia
          where
            pvp.cd_pedido_venda = p.cd_pedido_venda ) as nm_tipo_pendencia,

       fp.nm_forma_pagamento

--Select * from tipo_pendencia_financeira


      from
        Pedido_Venda p                             with (nolock)
      left outer join Cliente c                    with (nolock) on p.cd_cliente            = c.cd_cliente
      left outer join Condicao_Pagamento  b        with (nolock) on b.cd_condicao_pagamento = p.cd_condicao_pagamento
      left outer join Vendedor v                   with (nolock) on p.cd_vendedor           = v.cd_vendedor
      left outer join Cliente_Informacao_Credito i with (nolock) on i.cd_cliente            = c.cd_cliente
      left outer join motivo_liberacao_credito mlc with (nolock) on mlc.cd_motivo_liberacao = i.cd_motivo_liberacao
      left outer join Cliente_Conceito cc          with (nolock) on cc.cd_conceito_cliente  = c.cd_conceito_cliente
      left outer join Forma_Pagamento fp           with (nolock) on fp.cd_forma_pagamento   = i.cd_forma_pagamento
      
      where 
        p.dt_pedido_venda between @dt_inicial and @dt_final and
        p.dt_credito_pedido_venda is null   and 
        p.dt_cancelamento_pedido  is null   and
        isnull(p.vl_total_pedido_venda,0)>0 
        --12.01.2006 Realiza a filtragem pelo vendedor para os casos de acesso por um usuário remoto/internet (representante) - Fabio Cesar
        and IsNull(p.cd_vendedor,0) = ( case @cd_vendedor
                                          when 0 then IsNull(p.cd_vendedor,0)
                                          else @cd_vendedor
                                        end )
      order by
        p.cd_pedido_venda
  
    end

  -------------------------------------------------------------------------------
  else if @ic_parametro = 2   -- Liberação do Pedido
  -------------------------------------------------------------------------------
    begin
  
      begin tran
  
        update
          Pedido_Venda
        set
          dt_credito_pedido_venda   = @dt_credito_pedido_venda,
          cd_usuario_credito_pedido = @cd_usuario_credito_pedido,
          cd_usuario                = @cd_usuario_credito_pedido,
          dt_usuario                = getDate(),
          vl_credito_liberado       = @vl_credito_liberado
        where
          cd_pedido_venda           = @cd_pedido_venda
  
        -- Atualização do Motivo da Liberação de Crédito na Informação
        -- Comercial do Cliente
        update Cliente_Informacao_Credito
        set cd_motivo_liberacao = @cd_motivo_liberacao
        where cd_cliente = (select cd_cliente from pedido_venda
                            where cd_pedido_venda = @cd_pedido_venda)
  
  
      if @@error = 0
        commit tran
      else
        rollback tran
     
    end
  -------------------------------------------------------------------------------
  else if @ic_parametro = 3  -- listagem de um único pedido
  -------------------------------------------------------------------------------
    begin
  
      select 
        1					as 'Liberar',  -- não liberado
        p.cd_pedido_venda			as 'Pedido', 
        p.dt_pedido_venda			as 'Emissao',
        p.cd_cliente			        as 'CodCliente', 
        c.nm_fantasia_cliente	        	as 'Cliente',
--        p.vl_total_pedido_venda		as 'VlrPedido',

        isnull(p.ic_fechado_pedido,'N')         as 'Fechado',
        p.vl_total_pedido_venda,
        p.vl_total_ipi,
        p.vl_frete_pedido_venda,

        case when isnull(p.vl_total_pedido_ipi,0)>0 then
          p.vl_total_pedido_ipi
        else
          p.vl_total_pedido_venda
        end                                     as 'VlrPedido',

        b.sg_condicao_pagamento 		as 'CondPagto',
        mlc.nm_motivo_liberacao           as 'MotivoLiberacao',
        isnull(b.cd_condicao_pagamento,0) cd_condicao_pagamento,
        v.nm_fantasia_vendedor		as 'Vendedor',
        i.ic_credito_suspenso		as 'CreditoSuspenso',
        i.nm_credito_suspenso		as 'MotivoSuspenso',
        isnull(cc.nm_conceito_cliente,'Não Informado') as 'ConceitoCliente',
        isnull(i.cd_motivo_liberacao, (select top 1 cd_motivo_liberacao
                                       from motivo_liberacao_credito
                                       where ic_pad_motivo_liberacao = 'S')) as 'CodMotivoLiberacao',
        Entrega = 
        ( select
            case when
              min( ip.dt_entrega_vendas_pedido ) = min(ip.dt_item_pedido_venda)
              then 'Imediato'
              else convert( varchar(10),min(ip.dt_entrega_vendas_pedido),103 ) end 
          from
            Pedido_Venda_item ip
          where
            p.cd_pedido_venda  = ip.cd_pedido_venda ),
        Lib = 
        ( select
            case when
              min( ip.dt_entrega_fabrica_pedido ) = ''
              then 'N'
            else 'S' end 
          from
            Pedido_Venda_item ip with (nolock) 
          where
            p.cd_pedido_venda  = ip.cd_pedido_venda ),
        IsNull(p.vl_credito_liberado,0) as vl_credito_liberado,
        p.cd_cliente,
        ( select top 1 tpf.nm_tipo_pendencia
          from
            tipo_pendencia_financeira tpf with (nolock) 
            inner join Pedido_Venda_Pendencia pvp on pvp.cd_tipo_pendencia = tpf.cd_tipo_pendencia
          where
            pvp.cd_pedido_venda = p.cd_pedido_venda ) as nm_tipo_pendencia,

       fp.nm_forma_pagamento


      from
        Pedido_Venda p                      with (nolock)
      left outer join Cliente c             with (nolock) on p.cd_cliente = c.cd_cliente
      left outer join Condicao_Pagamento  b with (nolock) on b.cd_condicao_pagamento = p.cd_condicao_pagamento
      left outer join Vendedor v            with (nolock) on p.cd_vendedor = v.cd_vendedor
      left outer join Cliente_Informacao_Credito i 
                                            with (nolock) on i.cd_cliente = c.cd_cliente
      left outer join motivo_liberacao_credito mlc
                                            with (nolock) on mlc.cd_motivo_liberacao = i.cd_motivo_liberacao
      left outer join Cliente_Conceito cc   with (nolock) on cc.cd_conceito_cliente = c.cd_conceito_cliente

      left outer join Forma_Pagamento fp           with (nolock) on fp.cd_forma_pagamento   = i.cd_forma_pagamento

      where 
        p.cd_pedido_venda = @cd_pedido_venda and
        p.dt_credito_pedido_venda is null and 
        p.dt_cancelamento_pedido  is null
        --12.01.2006 Realiza a filtragem pelo vendedor para os casos de acesso por um usuário remoto/internet (representante) - Fabio Cesar
        and IsNull(p.cd_vendedor,0) = ( case @cd_vendedor
                                          when 0 then IsNull(p.cd_vendedor,0)
                                          else @cd_vendedor
                                        end )
     order by
        p.cd_pedido_venda
  
    end
  else
    return

end

