----------------------------------------------------------------
--pr_documento_receber_pago_vencimento
----------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
----------------------------------------------------------------
--Stored Procedure   : Microsoft SQL Server 2000
--Autor(es)          : Elias Pereira da Silva
--Banco de Dados     : EgisSQL
--Objetivo           : Consulta Duplicatas Pagas por Vencimento
--Data               : 07/08/2002
--Atualização        : 31/03/2003 - Inclusão dos campos de Juros, Desconto e Abatimento que
--                                  apesar de estarem no form não estava aqui - ELIAS
--                   : 15/07/2004 - Inclusão dos campos de despesa bancária e crédito pendente
--                                  ao cálculo do Valor Principal
--                   : 28/07/2004 - Sempre deverá existir um cabeçalho para o pagamento, 
--                                  modificado de left outer join para inner join o relacinamento
--                                  entre Documento_receber_pagamento e documento_receber - ELIAS
--                   : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                   : 15/12/2005 - Utilizar a data da devolução com sendo a data da baixa do título, 
--																	para os casos de duplicatas devolvidas - Fabio Cesar
--                   : 26/01/2006 - Re-Inclusao da Coluna "Grupo de Cliente", que já havia sido incluida
--                                  pelo CARLOS no dia 27/11/2005 a qual não foi atualizado pela equipe
--                                  externa, sendo então modificada sobre a versão do dia 05/01/2005,
--                                  detalhes no VSS Diferenças entre a versão 6 e 7 - Dirceu
--		       01/11/2006 - Incluído customização de rateio da cydak - Daniel C. Neto.
--                     22.03.2007 - Carlos Fernandes
-- 17.06.2010 - Verificação do Tipo de Liquidação - Carlos Fernandes
-- 22.12.2010 - Conta / Caixa / Tipo Liquidação - Carlos Fernandes
------------------------------------------------------------------------------------------------------
CREATE PROCEDURE pr_documento_receber_pago_vencimento
@ic_parametro          int,
@dt_inicial            datetime,
@dt_final              datetime ,
@cd_plano_financeiro   int = 0,
@cd_centro_custo       int = 0


AS

  declare @ic_rateio int

  set @ic_rateio = dbo.fn_ver_uso_custom('RATEIO')


  select
    d.cd_identificacao		as 'Documento',
    d.dt_emissao_documento	as 'Emissao',
    d.dt_vencimento_documento	as 'Vencimento',

	--Caso trata-se de um documento devolvido
	( case 
		when ( d.dt_devolucao_documento is not null ) then
			d.dt_devolucao_documento
		else
    		drp.dt_pagamento_documento  
	 end ) as 'Pagamento',

	--Caso trata-se de um documento devolvido

	( case 
		when ( d.dt_devolucao_documento is not null ) then
                   d.vl_documento_receber
		else
                   drp.vl_pagamento_documento  
	 end ) as 'Valor',

	--Caso trata-se de um documento devolvido

	( case 
		when ( d.dt_devolucao_documento is not null ) then
			d.vl_documento_receber
		else
			d.vl_documento_receber

--Carlos 22.03.2007
--     		drp.vl_pagamento_documento 
--                     - isnull(drp.vl_juros_pagamento,0)
--                     - isnull(drp.vl_despesa_bancaria,0) 
--                     - isnull(drp.vl_credito_pendente,0)
--                     - isnull(drp.vl_reembolso_documento,0)
--                     + isnull(drp.vl_desconto_documento,0) 
--                     + isnull(drp.vl_abatimento_documento,0)

	 end )                            as 'Valor_Principal',

    d.vl_saldo_documento                  as 'Saldo',

    IsNull(drp.vl_juros_pagamento,0)	  as 'Juros',
    IsNull(drp.vl_desconto_documento,0)	  as 'Desconto',
    IsNull(drp.vl_abatimento_documento,0) as 'Abatimento',
    c.nm_fantasia_cliente	          as 'Fantasia',
    v.nm_fantasia_vendedor                as 'Vendedor',
    p.nm_portador                         as 'Portador',
    drp.nm_obs_documento	          as 'Historico',
    tl.nm_tipo_liquidacao	          as 'Liquidacao',
    b.nm_banco                            as 'Banco',
    cab.nm_conta_banco                    as 'Conta',
    cg.nm_cliente_grupo                   as 'GrupoCliente',
    dcc.pc_centro_custo,
    dcc.vl_centro_custo, 
    dpf.pc_plano_financeiro, 
    dpf.vl_plano_financeiro,
    cc.nm_centro_custo,
    pf.nm_conta_plano_financeiro,
    tc.nm_tipo_caixa


  from
    Documento_Receber d             with (nolock) left join 
    Documento_Receber_Pagamento drp on drp.cd_documento_receber=d.cd_documento_receber inner join -- Exige ter o cliente cadastrado
    Cliente c   on   d.cd_cliente = c.cd_cliente left outer join 
    Vendedor v  on   v.cd_vendedor=d.cd_vendedor left outer join 
    Portador p  on   p.cd_portador=d.cd_portador left outer join 
    Tipo_Liquidacao	tl  on   drp.cd_tipo_liquidacao = tl.cd_tipo_liquidacao left outer join 
    Banco b   	on   drp.cd_banco = b.cd_banco left outer join 
    Conta_Agencia_Banco	cab on   drp.cd_banco = cab.cd_banco and 
                                 drp.cd_conta_banco = cab.cd_conta_banco left outer join 
    Cliente_Grupo cg on   cg.cd_cliente_grupo = c.cd_cliente_grupo left outer join
    Documento_receber_centro_custo dcc on case when @ic_rateio = 0 then 0 else dcc.cd_documento_receber end = d.cd_documento_receber left outer join
    Documento_receber_plano_financ dpf on case when @ic_rateio = 0 then 0 else dpf.cd_documento_receber end = d.cd_documento_receber left outer join
    centro_custo cc on cc.cd_centro_custo = IsNull(dcc.cd_centro_custo,d.cd_centro_custo) left outer join
    Plano_Financeiro pf on pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro )

    left outer join Tipo_Caixa      tc             with (nolock) on tc.cd_tipo_caixa      = drp.cd_tipo_caixa

  where
    drp.dt_pagamento_documento  between @dt_inicial and @dt_final     and	  
    ( IsNull(d.dt_cancelamento_documento,@dt_final + 1) > @dt_final ) and
    ( IsNull(d.dt_devolucao_documento,@dt_final + 1) > @dt_final )    and

    IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) = ( case when IsNull(@cd_plano_financeiro,0) = 0 then
								IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) else
 								    @cd_plano_financeiro end ) and
   IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) = ( case when IsNull(@cd_centro_custo,0) = 0 then
	  					  IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) else
							  @cd_centro_custo end )
    and
    isnull(tl.ic_rel_doc_tipo_liquidacao,'S')='S'

  order by
    drp.dt_pagamento_documento,
    d.cd_identificacao

