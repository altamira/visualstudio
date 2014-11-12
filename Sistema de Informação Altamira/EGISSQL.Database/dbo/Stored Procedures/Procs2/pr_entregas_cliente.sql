
create procedure pr_entregas_cliente
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Luciano
--Banco de Dados: Egissql
--Objetivo: Listar NF por cliente com entrega
--Data: 15/04/2002
--Atualizado: 
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
---------------------------------------------------
@dt_inicial           datetime,
@dt_final             datetime,
@nm_destinatario      varchar(40),
@cd_tipo_destinatario int
as 

  select 
    distinct
    n.nm_fantasia_nota_saida,	 --Fantasia
    n.nm_razao_social_nota,      --Razao Social
    n.nm_endereco_nota_saida,
--    c.dt_cadastro_cliente,       --Cadastro
    n.cd_telefone_nota_saida,    --Telefone
    n.dt_saida_nota_saida,	 --Saida
    n.dt_entrega_nota_saida,	 --Entrega
--    n.cd_nota_saida, 		 --Nota

    case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
      n.cd_identificacao_nota_saida
    else
        n.cd_nota_saida                              
    end                           as cd_nota_saida,

    n.dt_nota_saida, 	 	 --Emissao
    n.vl_frete,
    n.vl_total, 		 --Valor
    p.cd_pedido_venda, 		 --Pedido
    v.nm_vendedor,		 --Vendedor
    v.nm_fantasia_vendedor,
    v.sg_vendedor,		 --Sigla Vendedor
    n.ic_entrega_nota_saida,	 --Entregue
    e.nm_entregador, 		 --Entregador
    n.nm_obs_entrega_nota_saida, --Observacao
    t.nm_transportadora 	 --Transportadora
  from
    nota_saida n 
      left outer join
    pedido_venda p 
      on n.cd_pedido_venda = p.cd_pedido_venda 
      left outer join
    transportadora t 
      on n.cd_transportadora = t.cd_transportadora 
      left outer join
    vendedor v 
      on n.cd_vendedor = v.cd_vendedor 
      left outer join 
    Entregador e 
      on n.cd_entregador = e.cd_entregador

  where
    n.dt_saida_nota_saida between @dt_inicial and @dt_final and 
    ((n.nm_fantasia_nota_saida like @nm_destinatario+'%')or(@nm_destinatario = '')) and
   n.cd_tipo_destinatario=@cd_tipo_destinatario
  order by
    n.nm_fantasia_nota_saida 

