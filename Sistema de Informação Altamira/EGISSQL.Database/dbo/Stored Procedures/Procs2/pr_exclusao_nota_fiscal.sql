
CREATE PROCEDURE pr_exclusao_nota_fiscal

@ic_parametro  int,
@cd_nota_saida int

AS

declare @cd_doc_rec as integer

------------------------------------------------------
if @ic_parametro = 1 -- Exclusão das tabelas do SCR
------------------------------------------------------
begin
  
  select 
    cd_documento_receber 
  into #Documento_Receber 
  from Documento_Receber
  where cd_nota_Saida = @cd_nota_saida

  while exists ( select top 1 * from #Documento_Receber)
    begin

      set @cd_doc_rec = ( select top 1 * from #Documento_Receber )

      delete from Documento_Receber where cd_documento_receber =
        @cd_doc_rec

      delete from Documento_Receber_Pagamento where cd_documento_receber =
        @cd_doc_rec


      delete from Documento_Receber_Contabil where cd_documento_Receber =
        @cd_doc_rec

      delete from #Documento_Receber where cd_documento_receber = @cd_doc_rec

    end


--where cd_nota_saida = @cd_nota_saida
 


end

--------------------------------------------------------
else if @ic_parametro = 2 -- Excluir SLF
--------------------------------------------------------
begin

  delete from Nota_Saida_Item_Registro where cd_nota_Saida = @cd_nota_saida

  delete from Nota_Saida_Registro where cd_nota_saida = @cd_nota_saida  

-- delete from Nota_Saida_Contabil where cd_nota_saida = @cd_nota_saida

end

--------------------------------------------------------
else if @ic_parametro = 3 -- Excluir SFT
--------------------------------------------------------
begin

	--Atualiza a composição da prévia de faturamento com o item faturado
	update Previa_Faturamento_Composicao
	set 
		ic_fatura_previa_faturam = 'N'
	from
		Previa_Faturamento_Composicao, Nota_Saida_Item
	where 
		Previa_Faturamento_Composicao.cd_pedido_venda = Nota_Saida_Item.cd_pedido_venda and
		Previa_Faturamento_Composicao.cd_item_pedido_venda = Nota_Saida_Item.cd_item_pedido_venda and
		Nota_Saida_Item.cd_nota_saida = @cd_nota_saida
	
	--Atuliza a Prévia de faturamento após a atualização da composição
	update Previa_Faturamento
	set
		ic_fatura_previa_faturam = 'N'
	from 
		Previa_Faturamento 
	where
	  --Filtra somente as Prévias de faturamento que ainda não foram baixadas
		ic_fatura_previa_faturam <> 'N'
		and 
		--Filtra somente as prévias de faturamento que não possui composição
		exists(Select 'x' from Previa_Faturamento_Composicao 
					 where Previa_Faturamento_Composicao.cd_previa_faturamento = Previa_Faturamento.cd_previa_faturamento)
		and
		--Filtra somente as composições que não tem mais nada a ser faturado
		not exists(select 'x' from previa_faturamento_composicao 
		where previa_faturamento_composicao.cd_previa_faturamento = previa_faturamento.cd_previa_faturamento
		and ic_fatura_previa_faturam <> 'N')


--  delete from Nota_Saida         where cd_nota_saida = @cd_nota_saida
  
  delete from Nota_saida_Credito    where cd_nota_saida = @cd_nota_saida

  delete from NOta_Saida_Cond_Pagto where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Endereco_Entrega where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Parcela          where cd_nota_saida = @cd_nota_saida
  
  delete from Nota_Saida_Complemento      where cd_nota_saida = @cd_nota_saida

  --select * from nota_saida_entrega
  --select * from nota_saida_complemento
  --select * from nota_saida_item_lote
  --select * from nota_saida_item_devolucao
  --select * from nota_saida_item_registro
  --select * from nota_saida_devolucao
  --select * from nota_saida_entrada
  --select * from nota_saida_contabil
  --select * from nota_saida_imposto

  delete from nota_saida_item_devolucao where cd_nota_saida = @cd_nota_saida

  delete from nota_saida_item_lote      where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Acumulada      where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Entrega        where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Item_Registro  where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Registro       where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Devolucao      where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Contabil       where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Imposto        where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Recibo         where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida_Item           where cd_nota_saida = @cd_nota_saida

  delete from Nota_Saida                where cd_nota_saida = @cd_nota_saida
 
  
  delete from Movimento_Estoque
     where cd_documento_movimento = @cd_nota_saida -- Nota de Saída
           and 
           (( cd_tipo_documento_estoque = 4 ) -- NF Saída
            or
            (( cd_tipo_documento_estoque = 3 ) and -- NF Entrada
             ( cd_tipo_movimento_estoque in ( 2, 3, 10, 12, 13 ) )))
            -- Reserva, Cancelamento Reserva, Devolução, Cancelamento NF, Ativação NF

  --Movimento de Terceiro

  delete from Movimento_Produto_Terceiro where cd_nota_saida = @cd_nota_saida
                        
  --select * from movimento_produto_terceiro
                                            
  --select * from tipo_documento_estoque
  --select * from tipo_movimento_estoque           

end

------------------------------------------------------
if @ic_parametro = 4 -- Consultar Dados.
------------------------------------------------------
begin

SELECT     
  ns.cd_nota_saida, 
  isnull(ns.cd_mascara_operacao,0) as 'cd_operacao_fiscal', 
  ( select tt.nm_tipo_transporte from Tipo_Transporte tt where tt.cd_tipo_transporte = t.cd_tipo_transporte) as 'ViaTransporte',
  t.nm_transportadora,
  tpf.sg_tipo_pagamento_frete,
  op.nm_operacao_fiscal,
  v.nm_fantasia_vendedor,
  v.cd_telefone_vendedor, 
  sn.nm_status_nota,
  ns.dt_nota_saida, 
  ns.cd_pedido_venda,
  ( select ve.nm_fantasia_vendedor from Vendedor ve where ve.cd_vendedor = ns.cd_vendedor) as 'VendExt', 
  ( select ' (' + IsNull(ve.cd_ddd_vendedor,'') + ') ' + IsNull(ve.cd_telefone_vendedor,'') from Vendedor ve where ve.cd_vendedor = ns.cd_vendedor) as 'TelVendExt', 
  case when ns.cd_tipo_destinatario <> 1 then '' 
  else ( select ve.nm_fantasia_vendedor from Vendedor ve where ve.cd_vendedor = c.cd_vendedor_interno) 
  end as 'VendInt', 
    case when ns.cd_tipo_destinatario <> 1 then '' 
  else ( select ' (' + IsNull(ve.cd_ddd_vendedor,'') + ') ' + IsNull(ve.cd_telefone_vendedor,'') from Vendedor ve where ve.cd_vendedor = c.cd_vendedor_interno) 
  end as 'TelVendInt', 
  ( select count(d.cd_nota_saida) from Documento_Receber d where d.cd_nota_saida = ns.cd_nota_saida) as 'QtdeDuplicatas',
  ns.ic_emitida_nota_saida,
  ns.qt_item_nota_saida,
  ns.sg_estado_nota_saida,
  ns.sg_estado_entrega,
  ns.vl_produto,
  ns.vl_total,
  ns.vl_desp_acess,
  ns.qt_peso_bruto_nota_saida,
  ns.vl_bc_subst_icms,
  ns.vl_bc_icms,
  ns.vl_ipi,
  ns.nm_fantasia_nota_saida, 
  ns.nm_razao_social_nota,
  ns.cd_telefone_nota_saida, 
  ns.vl_icms,
  ns.ds_obs_compl_nota_saida,
  cp.nm_condicao_pagamento,
  td.nm_tipo_destinatario,
  ns.nm_mot_cancel_nota_saida,
  IsNull(dt_nota_dev_nota_saida,ns.dt_cancel_nota_saida) as 'dt_cancel_nota_saida'
FROM         
  Nota_Saida ns with (nolock) LEFT OUTER JOIN
  Transportadora t on t.cd_transportadora = ns.cd_transportadora left outer join
  Tipo_Pagamento_Frete tpf on tpf.cd_tipo_pagamento_frete = ns.cd_tipo_pagamento_frete left outer join
  Operacao_Fiscal op on op.cd_operacao_fiscal = ns.cd_operacao_fiscal left outer join
  Status_Nota sn ON sn.cd_status_nota = ns.cd_status_nota LEFT OUTER JOIN
  Vendedor v ON v.cd_vendedor = ns.cd_vendedor left outer join
  Cliente c ON c.cd_cliente = ns.cd_cliente left outer join
  Condicao_Pagamento cp on ns.cd_condicao_pagamento = cp.cd_condicao_pagamento left outer join
  Tipo_Destinatario td on td.cd_tipo_destinatario = ns.cd_tipo_destinatario

WHERE
  ns.cd_nota_saida = @cd_nota_saida
end

--------------------------------------------------------
else -- Consultar Itens
--------------------------------------------------------

begin

SELECT     
  nsi.cd_item_nota_saida, 
  nsi.qt_item_nota_saida, 
  nsi.vl_unitario_item_nota, 
  nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota AS vl_total_item, 
  nsi.nm_fantasia_produto, 
  nsi.nm_produto_item_nota as 'nm_produto', 
  nsi.cd_pedido_venda, 
  nsi.cd_item_pedido_venda, 
  nsi.ic_status_item_nota_saida,
  nsi.dt_cancel_item_nota_saida
FROM
  Nota_Saida_Item nsi       with (nolock) 
  LEFT OUTER JOIN Produto p with (nolock) ON nsi.cd_produto = p.cd_produto
WHERE
   nsi.cd_nota_saida = @cd_nota_saida
ORDER BY 
  nsi.cd_item_nota_saida

end

