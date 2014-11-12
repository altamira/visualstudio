
create  procedure pr_ordem_separacao_nota_saida

@cd_nota_saida_i int,
@cd_nota_saida_f int

as

  declare @Nota table 
  ( Cliente		varchar(50),
    CNPJ		varchar(20),
    Nota 		int,
    Item		int,
    ItemEspecial	int,
    Endereco 		varchar(30),
    Fantasia		varchar(35),
    QuantidadeTotal  	decimal(15,4),
    Codigo		varchar(30),
    Descricao		varchar(50),
    QuantidadeEspecial  decimal(15,4),
    Fase 		varchar(15),
    EstoqueAtual	decimal(15,4),
    Kardex              varchar(50),
    Identificacao       int  )

  insert into
    @Nota
  select
    ns.nm_razao_social_nota,
    ns.cd_cnpj_nota_saida,
    ns.cd_nota_saida,
    nsi.cd_item_nota_saida,
    0,
    dbo.fn_getlocalizacao_produto_fase(nsi.cd_produto,nsi.cd_fase_produto),
    nsi.nm_fantasia_produto,
    nsi.qt_item_nota_saida,
    nsi.cd_mascara_produto,
    nsi.nm_produto_item_nota,
    0,
    fp.sg_fase_produto,
    ps.qt_saldo_atual_produto,
    nsi.nm_kardex_item_nota_saida,
    ns.cd_identificacao_nota_saida
  from
    Nota_Saida			ns	with (nolock)  left outer join
    Nota_Saida_Item		nsi	on ns.cd_nota_saida 		= nsi.cd_nota_saida 		left outer join
    Produto_Saldo		ps	on nsi.cd_produto		= ps.cd_produto 		and
					   nsi.cd_fase_produto		= ps.cd_fase_produto		left outer join
    Fase_Produto		fp	on nsi.cd_fase_produto 		= fp.cd_fase_produto
  where
    ns.cd_identificacao_nota_saida between @cd_nota_saida_i and @cd_nota_saida_f and
    ns.dt_cancel_nota_saida is null

  insert into
    @Nota
  select
    ns.nm_razao_social_nota,
    ns.cd_cnpj_nota_saida,
    ns.cd_nota_saida,
    nsi.cd_item_nota_saida,
    pvc.cd_id_item_pedido_venda,
    dbo.fn_getlocalizacao_produto_fase(pvc.cd_produto,pvc.cd_fase_produto),
--    nsi.nm_fantasia_produto + ' - '+ p.nm_fantasia_produto,
    '     ' + p.nm_fantasia_produto,
    nsi.qt_item_nota_saida * pvc.qt_item_produto_comp,
    p.cd_mascara_produto,
    p.nm_produto,
    pvc.qt_item_produto_comp,
    fp.sg_fase_produto,
    ps.qt_saldo_atual_produto,
    '' as nm_kardex_item_nota_saida,
    ns.cd_identificacao_nota_saida
  from
    Nota_Saida			ns	with (nolock)  left outer join
    Nota_Saida_Item		nsi	on ns.cd_nota_saida 		= nsi.cd_nota_saida 		inner join
    Pedido_Venda_Composicao	pvc	on nsi.cd_pedido_venda		= pvc.cd_pedido_venda		and
					   nsi.cd_item_pedido_venda	= pvc.cd_item_pedido_venda	left outer join
    Fase_Produto		fp	on pvc.cd_fase_produto 		= fp.cd_fase_produto		left outer join
    Produto_Saldo		ps	on pvc.cd_produto		= ps.cd_produto 		and
					   pvc.cd_fase_produto		= ps.cd_fase_produto		left outer join
    Produto			p	on pvc.cd_produto		= p.cd_produto
  where
    ns.cd_identificacao_nota_saida between @cd_nota_saida_i and @cd_nota_saida_f and
    ns.dt_cancel_nota_saida is null

  select
    *
  from
    @Nota
  order by
    3,4,5

