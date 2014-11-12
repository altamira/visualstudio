create procedure pr_consulta_nota_importacao_sem_nf_complemetar
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Consulta das Notas de importacao sem invoice ou DI
--Data: 01.04.2004
---------------------------------------------------
@dt_inicial as datetime,
@dt_final as datetime
as

  select
    ns.cd_nota_saida,
    nsi.cd_item_nota_saida,
    nsi.nm_fantasia_produto,
    dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
    p.nm_produto,
    ns.dt_nota_saida,
    td.nm_tipo_destinatario,
    vwd.nm_fantasia
  from
    Nota_Saida 		ns,
    Nota_Saida_Item 	nsi,
    Tipo_Destinatario	td,
    VW_Destinatario	vwd,
    Operacao_fiscal       ofi,
    Produto		p
  where
    ns.cd_nota_saida	  = nsi.cd_nota_saida       	and
    ns.cd_tipo_destinatario = td.cd_tipo_destinatario 	and
    ns.cd_tipo_destinatario = vwd.cd_tipo_destinatario 	and
    ns.cd_cliente		  = vwd.cd_destinatario		and
    ns.cd_operacao_fiscal   = ofi.cd_operacao_fiscal      and
    nsi.cd_produto 	  = p.cd_produto		and
    ns.cd_mascara_operacao like '3%'			and
    isnull(ofi.ic_complemento_op_fiscal,'N') = 'N'	and
    isnull(ofi.ic_imp_operacao_fiscal, 'N')  = 'S'        and
    (isnull(nsi.nm_invoice,'') = '' 			or
     isnull(nsi.nm_di,'') = '')                        	and
    nsi.cd_produto > 0 					and
    ns.dt_cancel_nota_saida is null                       and
    ns.dt_nota_saida 	   between @dt_inicial and @dt_final
