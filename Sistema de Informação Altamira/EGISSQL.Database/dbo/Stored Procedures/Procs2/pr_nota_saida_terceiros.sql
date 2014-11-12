---------------------------------------------------------------------
--pr_nota_saida_terceiros
---------------------------------------------------------------------
--GBS - Global Business Sollution Ltda                           2004
---------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Francisco Leite Neto
--Banco de Dados        : EGISSQL
--Objetivo              : Trazer Todos as Notas Fiscas que 
--                        Possuam Controle de Terceiros ='S'  
--                        orçamentos : Bases, Moldes e Placas
--Data                  : 20/01/2004
--Atualizados           : 03/02/2004 Adiconado Novos Campos iden á NF da Operação Fiscal
--                      : 13.09.2004 - Inclusão de campo de prazo para cálculo de entrega da mercadoria. Igor Gama
--                      : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_nota_saida_terceiros
@ic_parametro       int,
@dt_inicial         datetime,
@dt_final           datetime,
@cd_nota_saida      int,
@cd_tipo_destinatario varchar(30)
as
------------------------------------------------------------------------------------
if @ic_parametro = 1
begin
------------------------------------------------------------------------------------
	select 
	  sn.nm_status_nota,
	  dp.nm_destinacao_produto,
	  ns.cd_tipo_destinatario,
	  ns.ic_status_nota_saida,
--	  ns.cd_nota_saida,
          case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
            ns.cd_identificacao_nota_saida
          else
            ns.cd_nota_saida                              
          end                   as 'cd_nota_saida',

	  ns.cd_num_formulario_nota,
	  ns.dt_nota_saida,
	  vw.nm_fantasia as nm_fantasia_nota_saida,
	  ns.cd_destinacao_produto,
	  ns.ic_emitida_nota_saida,
	  ns.nm_mot_cancel_nota_saida,
	  ns.dt_cancel_nota_saida,
	  ns.dt_saida_nota_saida,
	  ns.cd_num_formulario,
	  ns.nm_razao_social_nota,
	  ns.nm_razao_social_c,
	  ns.cd_mascara_operacao,
	  ns.nm_operacao_fiscal,
	  ns.nm_fantasia_destinatario,
	  ns.nm_razao_social_cliente,
	  ns.nm_razao_socila_cliente_c,
	  ns.ic_forma_nota_saida,
	  td.cd_tipo_destinatario,
	  td.nm_tipo_destinatario,
	  vw.nm_fantasia,
	  vw.cd_cnpj,
    isnull(o.qt_prazo_operacao_fiscal,0) as 'qt_prazo',
    case when isnull(o.qt_prazo_operacao_fiscal,0) > 0
      then datediff(dd, getdate(), (ns.dt_nota_saida + isnull(o.qt_prazo_operacao_fiscal,0))) 
      else 0
    end as 'qt_faltam_prazo',
	  sum(nsi.qt_devolucao_item_nota * nsi.vl_unitario_item_nota) as Total,
	  sum(nsi.qt_devolucao_item_nota  - nsi.qt_item_nota_saida ) as Saldodevolvido,
	  cast(o.cd_mascara_operacao as varchar(20) ) + '- ' + o.nm_operacao_fiscal as CFOP,
	  cast(round(ns.vl_bc_icms,2) as decimal(25,2)) as vl_bc_icms,
	  cast(round(ns.vl_icms,2) as decimal(25,2)) as vl_icms,
	  cast(round(ns.vl_bc_subst_icms,2) as decimal(25,2)) as vl_bc_subst_icms,
	  cast(round(ns.vl_produto,2) as decimal(25,2)) as vl_produto,
	  cast(round(ns.vl_frete,2) as decimal(25,2)) as vl_frete,
	  cast(round(ns.vl_seguro,2) as decimal(25,2)) as vl_seguro,
	  cast(round(ns.vl_desp_acess,2) as decimal(25,2)) as vl_desp_acess,
	  cast(round(ns.vl_total,2) as decimal(25,2)) as vl_total,
	  cast(round(ns.vl_icms_subst,2) as decimal(25,2)) as vl_icms_subst,
	  cast(round(ns.vl_ipi,2) as decimal(25,2)) as vl_ipi,	
	  cast(round(ns.vl_iss,2) as decimal(25,2)) as vl_iss,
	  cast(round(ns.vl_servico,2) as decimal(25,2)) as vl_servico,
	  cast(round(ns.vl_irrf_nota_saida,2) as decimal(25,2)) as vl_irrf_nota_saida,
	  cast(round(ns.vl_bc_ipi,2) as decimal(25,2)) as vl_bc_ipi          
	from
	  Nota_Saida ns with (nolock) 
      left outer join
	  Nota_Saida_Item nsi 
      on ns.cd_nota_saida = nsi.cd_nota_saida 
      left outer join
	  Tipo_destinatario td
      on ns.cd_tipo_destinatario = td.cd_tipo_destinatario 
      left outer join
	  Vw_Destinatario vw 
      on ns.cd_tipo_destinatario = vw.cd_tipo_destinatario 
         and ns.cd_cliente = vw.cd_destinatario left outer join 
	  Operacao_Fiscal o 
      on o.cd_operacao_fiscal = ns.cd_operacao_fiscal 
      left outer join		
	  Destinacao_Produto dp 
      on dp.cd_destinacao_produto = ns.cd_destinacao_produto 
      left outer join		
	  Status_Nota sn 
      on sn.cd_status_nota = ns.cd_status_nota
	where
	  ns.dt_nota_saida between  @dt_inicial and @dt_final and
	  ns.cd_tipo_destinatario = @cd_tipo_destinatario and
	  ns.ic_status_nota_saida <> 'C' and
	  o.ic_terceiro_op_fiscal = 'S'    
	group by
	  sn.nm_status_nota,
	  dp.nm_destinacao_produto,
	  ns.cd_tipo_destinatario,
	  ns.ic_status_nota_saida,
	  ns.cd_nota_saida,
          ns.cd_identificacao_nota_saida,
	  ns.cd_num_formulario_nota,
	  ns.dt_nota_saida,
	  ns.nm_fantasia_nota_saida,
	  ns.cd_destinacao_produto,
	  ns.ic_emitida_nota_saida,
	  ns.nm_mot_cancel_nota_saida,
	  ns.dt_cancel_nota_saida,
	  ns.dt_saida_nota_saida,
	  ns.cd_num_formulario,
	  ns.nm_razao_social_nota,
	  ns.nm_razao_social_c,
	  ns.cd_mascara_operacao,
	  ns.nm_operacao_fiscal,
	  ns.nm_fantasia_destinatario,
	  ns.nm_razao_social_cliente,
	  ns.nm_razao_socila_cliente_c,
	  ns.ic_forma_nota_saida,
	  td.cd_tipo_destinatario,
	  td.nm_tipo_destinatario,
	  vw.nm_fantasia,
	  vw.cd_cnpj,
	  ns.vl_bc_icms,
		ns.vl_bc_subst_icms,
		ns.vl_icms,
		ns.vl_produto,
		ns.vl_frete,
		ns.vl_seguro,
		ns.vl_desp_acess,
		ns.vl_total,
		ns.vl_icms_subst,
		ns.vl_ipi,
		ns.vl_iss,
		ns.vl_servico,
		ns.vl_irrf_nota_saida,
		ns.vl_bc_ipi,
		o.cd_mascara_operacao,
		o.nm_operacao_fiscal,
    o.qt_prazo_operacao_fiscal
	
	order by
	  ns.dt_nota_saida 

------------------------------------------------------------------------------------
end
else if @ic_parametro = 2
------------------------------------------------------------------------------------
begin
  select
    n.dt_restricao_item_nota as 'DataDevolucao',
    n.cd_nota_dev_nota_saida as 'NFDevolucao',
    n.qt_saldo_atual_produto as 'QtdSaldo',
    n.qt_devolucao_item_nota as 'QtdDevolvida',
    n.cd_item_nota_saida as 'CdItem',
    n.cd_mascara_produto as 'CdMascaraCodigo', 
    n.nm_fantasia_produto as  'FantasiaProduto',
    n.nm_produto_item_nota as 'DescricaoItem',
    n.qt_item_nota_saida as 'QTDEItem',
    n.vl_unitario_item_nota	as 'PrecoUnitario',
    n.vl_total_item as 'Total',
    um.sg_unidade_medida as 'Unidade',
    n.cd_nota_saida as 'CdNF'          
  from 
    Nota_Saida_Item n
      left outer join
    Unidade_Medida um 
      on (n.cd_unidade_medida = um.cd_unidade_medida) 
  where
    n.cd_nota_saida = @cd_nota_saida
end
 else
  return

