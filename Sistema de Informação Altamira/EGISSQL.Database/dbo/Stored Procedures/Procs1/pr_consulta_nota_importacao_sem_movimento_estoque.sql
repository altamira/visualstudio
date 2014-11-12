create procedure pr_consulta_nota_importacao_sem_movimento_estoque
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

  Begin
  
  Select
    nsi.cd_nota_saida,
    nsi.cd_num_formulario_nota,
    nsi.cd_item_nota_saida,
    nsi.nm_fantasia_produto,
    nsi.qt_item_nota_saida,
    nsi.nm_produto_item_nota,
    ns.nm_fantasia_nota_saida
  from
    Nota_Saida_Item nsi 
    inner join Nota_Saida ns
      on nsi.cd_nota_saida = ns.cd_nota_saida
      and ns.dt_nota_saida between @dt_inicial and @dt_final
    inner join Operacao_Fiscal op
      on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal
      and IsNull(op.ic_estoque_op_fiscal,'N') = 'S'
      and IsNull(op.ic_imp_operacao_fiscal,'N') = 'S'
    left outer join Produto p on nsi.cd_produto = p.cd_produto
    left outer join  movimento_estoque me
      on cast(nsi.cd_nota_saida as varchar) = me.cd_documento_movimento
      and nsi.cd_item_nota_saida = me.cd_item_documento
      and (case IsNull(p.cd_produto_baixa_estoque,0)
   	  when 0 then p.cd_produto
   	  else p.cd_produto_baixa_estoque
  	 end) = me.cd_produto 
      and IsNull(nsi.ic_movimento_estoque,'N') = 'S'    
      and IsNull(me.cd_tipo_movimento_estoque,1) not in (10,12,13)--Desconsidera os movimentos de cancelamento e devolução
    where
      me.cd_movimento_estoque is null and
      IsNull(nsi.cd_produto,0) > 0
    order by
      1,3
  end

