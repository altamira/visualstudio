
create procedure pr_entrega_atrasada
@cd_nota_saida int,
@dt_inicial datetime,
@dt_final datetime
---------------------------------------------------
--GBS Global Business Solution Ltda            2002
---------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Luciano Ramirez
--Banco de Dados: EgisSql
--Objetivo: Consulta de Entregas Atrasadas
--Data      : 10/05/2002
--Atualizado: 13/05/2002 - Correção - ELIAS	
--            14/01/2003 - Daniel C. Neto 
--                       - Incluído campo dt_dev_nota_saida.
--Alteração        : 
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------------------------------

as 


if @cd_nota_saida = 0
begin

select 
	n.dt_entrega_nota_saida, 	-- Data Entrega	    
        n.dt_saida_nota_saida,          -- Data Saida
--        n.cd_nota_saida,		-- Nota Fiscal

  case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
        n.cd_identificacao_nota_saida
      else
        n.cd_nota_saida                              
  end                                       as cd_nota_saida,

 	n.dt_nota_saida,		-- Emissao
        n.nm_fantasia_nota_saida, 	-- Cliente
        n.vl_total,			-- Vl Total
	v.nm_vendedor,			-- Vendedor
	e.nm_entregador,                -- Entregador
        t.cd_transportadora,            -- Transportadora
        n.ic_entrega_nota_saida, 	-- Entregue (S/N)
  	o.nm_observacao_entrega,	-- Observacao
        p.cd_pedido_venda,		-- Pedido
        td.nm_tipo_destinatario,        -- Tipo de Destinatário.
        n.vl_frete,
        t.nm_transportadora,
	v.nm_fantasia_vendedor,			-- Vendedor
	n.dt_nota_dev_nota_saida,
        sn.sg_status_nota,
        op.cd_operacao_fiscal,  
        op.nm_operacao_fiscal 


from

    nota_saida n          with (nolock)                                left join

    pedido_venda p   	  on n.cd_pedido_venda = p.cd_pedido_venda     left outer join

    transportadora t      on n.cd_transportadora = t.cd_transportadora left outer join

    vendedor v         	  on n.cd_vendedor = v.cd_vendedor left outer join 

    Entregador e     	  on n.cd_entregador = e.cd_entregador left outer join
 
    Observacao_Entrega o  on n.cd_observacao_entrega = o.cd_observacao_entrega left outer join
  
    Tipo_Destinatario td  on td.cd_tipo_destinatario = n.cd_tipo_destinatario left outer join
    
    Status_Nota sn on sn.cd_status_nota = n.cd_status_nota left outer join
    
    Operacao_Fiscal op on n.cd_operacao_fiscal = op.cd_operacao_fiscal    

  
Where
   (n.dt_nota_saida between @dt_inicial and @dt_final) and
   (
    (dt_entrega_nota_saida is null) and
    (dt_saida_nota_saida   is null) and
    (dt_cancel_nota_saida is null)
   )
  
order by 
   n.dt_nota_saida desc	

end

else

begin

select 
	n.dt_entrega_nota_saida, 	-- Data Entrega	    
        n.dt_saida_nota_saida,          -- Data Saida
        n.cd_nota_saida,		-- Nota Fiscal
 	n.dt_nota_saida,		-- Emissao
        n.nm_fantasia_nota_saida, 	-- Cliente
        n.vl_total,			-- Vl Total
	v.nm_vendedor,			-- Vendedor
	e.nm_entregador,                -- Entregador
        t.cd_transportadora,            -- Transportadora
        n.ic_entrega_nota_saida, 	-- Entregue (S/N)
  	o.nm_observacao_entrega,	-- Observacao
        p.cd_pedido_venda,		-- Pedido
        td.nm_tipo_destinatario,        -- Tipo de Destinatário.
        n.vl_frete,
        t.nm_transportadora,
	v.nm_fantasia_vendedor,			-- Vendedor
	n.dt_nota_dev_nota_saida,
        sn.sg_status_nota,
        op.cd_operacao_fiscal,  
        op.nm_operacao_fiscal 

from

    nota_saida n left join

    pedido_venda p   	  on n.cd_pedido_venda = p.cd_pedido_venda left outer join

    transportadora t      on n.cd_transportadora = t.cd_transportadora left outer join

    vendedor v         	  on n.cd_vendedor = v.cd_vendedor left outer join 

    Entregador e     	  on n.cd_entregador = e.cd_entregador left outer join
 
    Observacao_Entrega o  on n.cd_observacao_entrega = o.cd_observacao_entrega left outer join
  
    Tipo_Destinatario td  on td.cd_tipo_destinatario = n.cd_tipo_destinatario  left outer join
    
    Status_Nota sn on sn.cd_status_nota = n.cd_status_nota left outer join
    
    Operacao_Fiscal op on n.cd_operacao_fiscal = op.cd_operacao_fiscal 
  
  
Where
   (n.dt_nota_saida between @dt_inicial and @dt_final) and
   (dt_entrega_nota_saida is null) and (dt_saida_nota_saida   is null) and
   (dt_cancel_nota_saida is null) and
   (n.cd_nota_saida = @cd_nota_saida )

order by 
   n.dt_nota_saida desc	

end

