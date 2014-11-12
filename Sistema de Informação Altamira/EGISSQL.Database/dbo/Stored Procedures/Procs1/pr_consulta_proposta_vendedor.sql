
CREATE PROCEDURE pr_consulta_proposta_vendedor

@nm_fantasia_vendedor  varchar(40),
@dt_inicial            dateTime,
@dt_final              dateTime,
@ic_somente_abertas    char(1) = 'S'

as

--select * from cliente_contato
--select * from cliente

SELECT     
	   v.nm_fantasia_vendedor,
	   ci.cd_consulta, 
           ci.cd_item_consulta, 
           c.dt_consulta                                      as dt_item_consulta, 
           cli.nm_fantasia_cliente, 
           rtrim(ltrim(cli.nm_endereco_cliente)) +', '+cli.cd_numero_endereco+' '+
           rtrim(ltrim(cli.nm_complemento_endereco)) +'-'+
           rtrim(ltrim(cli.nm_bairro))+' Cep: '+cli.cd_cep   as 'Endereco_Cliente',
           cid.nm_cidade,
           e.sg_estado,
           p.nm_pais,
           ci.qt_item_consulta, 
           ci.nm_fantasia_produto, 
           ci.nm_produto_consulta, 
           ci.vl_unitario_item_consulta, 
           ci.pc_desconto_item_consulta, 
           ci.qt_item_consulta * ci.vl_unitario_item_consulta as vl_total_item,
           cc.nm_fantasia_contato,
           dbo.fn_mascara_produto(ci.cd_produto) as 'cd_mascara_produto',
           cp.nm_categoria_produto,
           cp.sg_categoria_produto,
           ci.vl_lista_item_consulta,
           vi.nm_fantasia_vendedor as VI,
           case 
            when ((IsNull(ci.cd_pedido_venda,0) > 0) and (dt_perda_consulta_itens is null)) then 'Fechada'
            when (dt_perda_consulta_itens is not null) then 'Perda'
            else 'Aberta'
           end as nm_status_proposta,
           --sp.nm_status_proposta, Comentado e colocado fixo por meio de regra
           ci.cd_consulta_representante,
           ci.cd_item_consulta_represe,
           cpg.sg_condicao_pagamento,
           '('+cc.cd_ddd_contato_cliente+')-'+cc.cd_telefone_contato as TelefoneContato,
           ci.pc_ipi,
           (ci.qt_item_consulta*ci.vl_unitario_item_consulta)*(ci.pc_ipi/100) as ValorIPI,
				ci.dt_entrega_consulta ,
				'(' + Rtrim(Isnull(cli.cd_ddd, '')) + ') ' + cli.cd_telefone  as Telefone,
       		nm_fantasia_usuario as nm_atendente,
           cc.cd_email_contato_cliente

FROM       Consulta_Itens ci  with (nolock) 
           left outer join
           Consulta c         with (nolock) ON c.cd_consulta = ci.cd_consulta inner join
           Vendedor v         with (nolock) on v.cd_vendedor = c.cd_vendedor left outer join
           Cliente cli        with (nolock) ON c.cd_cliente = cli.cd_cliente left outer join
           Cliente_Contato cc with (nolock) ON c.cd_contato = cc.cd_contato AND 
                                               c.cd_cliente = cc.cd_cliente 
           left outer join Categoria_Produto cp    with (nolock) on cp.cd_categoria_produto = ci.cd_categoria_produto 
           left outer join Vendedor vi             with (nolock) on vi.cd_vendedor = c.cd_vendedor_interno 
           left outer join Condicao_Pagamento cpg  with (nolock) on cpg.cd_condicao_pagamento = c.cd_condicao_pagamento 
           left outer join EGISADMIN.dbo.Usuario u with (nolock) on (u.cd_usuario = c.cd_usuario_atendente)	
           left outer join Pais p                  with (nolock) on p.cd_pais     = cli.cd_pais
           left outer join Estado e                with (nolock) on e.cd_estado   = cli.cd_estado and
                                                                    e.cd_pais     = cli.cd_pais   
           left outer join Cidade cid              with (nolock) on cid.cd_cidade = cli.cd_cidade and
                                                                    cid.cd_estado = cli.cd_estado and
                                                                    cid.cd_pais   = cli.cd_pais
  
           --left outer join
           --Status_Proposta sp on sp.cd_status_proposta = c.cd_status_proposta
where
          c.dt_consulta between @dt_inicial and @dt_final and
          (v.nm_fantasia_vendedor like @nm_fantasia_vendedor + '%') and          
          ( 
            (@ic_somente_abertas = 'N') or
            ( ( @ic_somente_abertas = 'S') and ci.dt_perda_consulta_itens is null 
               and ( IsNull(ci.cd_pedido_venda,0) = 0 ) )
          )
order by ci.cd_consulta, ci.cd_item_consulta
