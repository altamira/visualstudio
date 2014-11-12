
CREATE PROCEDURE pr_documento_receber_aberto_cliente

@nm_fantasia_cliente   varchar(50),
@dt_inicial            datetime,
@dt_final              datetime,
@ic_parametro          int = 0,
@cd_plano_financeiro   int = 0,
@cd_centro_custo       int = 0

as

declare @ic_rateio int

set @ic_rateio = dbo.fn_ver_uso_custom('RATEIO')

--------------------------------------------------------------------------------------------
--  ic_parametro = 1 - Consulta de Movimento de Duplicata por Cliente
--------------------------------------------------------------------------------------------  
--select * from documento_receber_pagamento

If @ic_parametro = 1
  Begin
    select
      distinct
      dr.cd_identificacao		as 'Documento',
      td.sg_tipo_documento      	as 'Tipo',
      dr.dt_emissao_documento   	as 'Emissao',
      dr.dt_vencimento_documento	as 'Vencimento',

      cast(dr.dt_vencimento_documento - dr.dt_emissao_documento as int ) as 'Prazo',
      -- Arredondamento - ELIAS 30/07/2003 
      cast(round(dr.vl_documento_receber,2) as decimal(25,2))            as 'Valor',
--      cast(round(dr.vl_saldo_documento,2)   as decimal(25,2))        	as 'Saldo',

      case when isnull(drp.vl_pagamento_documento,0)>0 
      then
        cast(round(
                  cast(round(dr.vl_documento_receber,2) as decimal(25,2))
                  - 
                    (isnull(drp.vl_pagamento_documento,0) -
                    isnull(drp.vl_juros_pagamento,0)     +
                    isnull(drp.vl_desconto_documento,0) )
 
                                        ,2)   as decimal(25,2))      
      else
                  isnull(dr.vl_saldo_documento,0)
      end  	                        as 'Saldo',

      por.sg_portador		   	as 'Portador',
      ven.nm_fantasia_vendedor     	as 'Vendedor',
      cob.sg_tipo_cobranca	   	as 'Cobranca',
      dr.ic_emissao_documento	   	as 'Emitido',
      cg.nm_cliente_grupo               as 'GrupoCliente',
--select * from vw_destinatario

--      cl.nm_fantasia_cliente            as 'Cliente',
      vw.nm_fantasia                    as 'Cliente',

      dcc.pc_centro_custo,
      dcc.vl_centro_custo, 
      dpf.pc_plano_financeiro, 
      dpf.vl_plano_financeiro,
      cc.nm_centro_custo,
      pf.nm_conta_plano_financeiro,
      cr.nm_cheque_receber                as 'NumeroCheque',
      cr.dt_deposito_cheque_recebe        as 'Deposito',
      drp.vl_pagamento_documento,
      drp.vl_juros_pagamento,
      drp.vl_desconto_documento,
      vwc.conta
      
          
    into 
      #DocumentoAberto

    from
      Documento_Receber dr              with (nolock) 
      left outer join Portador por      with (nolock) on por.cd_portador      = dr.cd_portador 
      left outer join Tipo_Documento td with (nolock) on td.cd_tipo_documento = dr.cd_tipo_documento 
      left outer join Tipo_Cobranca cob with (nolock) on dr.cd_tipo_cobranca  = cob.cd_tipo_cobranca   
      left outer join Vendedor ven      with (nolock) on dr.cd_vendedor       = ven.cd_vendedor 
      left outer join Cliente cl        with (nolock) on dr.cd_cliente        = cl.cd_cliente 
      left outer join Cliente_Grupo cg  with (nolock) on cl.cd_cliente_grupo  = cg.cd_cliente_grupo 
      left outer join Documento_receber_centro_custo dcc on case when @ic_rateio = 0 then 0 else dcc.cd_documento_receber end = dr.cd_documento_receber 
      left outer join Documento_receber_plano_financ dpf on case when @ic_rateio = 0 then 0 else dpf.cd_documento_receber end = dr.cd_documento_receber 
      left outer join centro_custo cc                 with (nolock) on cc.cd_centro_custo = IsNull(dcc.cd_centro_custo,dr.cd_centro_custo) 
      left outer join Plano_Financeiro pf             with (nolock) on pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro , dr.cd_plano_financeiro )
      left outer join Cheque_Receber_Composicao chq   with (nolock) on chq.cd_documento_receber = dr.cd_documento_receber
      left outer join Cheque_Receber            cr    with (nolock) on cr.cd_cheque_receber     = chq.cd_cheque_receber     
--      left outer join documento_receber_pagamento drp with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber
      left outer join vw_baixa_documento_receber drp  with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber
      left outer join vw_destinatario vw              with (nolock) on vw.cd_destinatario       = dr.cd_cliente and
                                                                       vw.cd_tipo_destinatario  = dr.cd_tipo_destinatario
      left outer join vw_conta_corrente vwc           with (nolock) on vwc.cd_conta_banco       = dr.cd_conta_banco_remessa
    WHERE     
     --cl.nm_fantasia_cliente like @nm_fantasia_cliente + '%'       and
     vw.nm_fantasia like @nm_fantasia_cliente + '%'       and
     dr.dt_vencimento_documento between @dt_inicial and @dt_final and
     (cast(round(dr.vl_saldo_documento,2) as decimal(25,2)) > 0   
      or 
      drp.dt_pagamento_documento > dr.dt_vencimento_documento and drp.dt_pagamento_documento > @dt_final )
     and
     dr.dt_cancelamento_documento is null and
     IsNull(IsNull(dpf.cd_plano_financeiro , dr.cd_plano_financeiro ),0) = ( case when IsNull(@cd_plano_financeiro,0) = 0 then
								IsNull(IsNull(dpf.cd_plano_financeiro , dr.cd_plano_financeiro ),0) else
 								    @cd_plano_financeiro end ) and
     IsNull(IsNull(dcc.cd_centro_custo,dr.cd_centro_custo),0) = ( case when IsNull(@cd_centro_custo,0) = 0 then
	    					  IsNull(IsNull(dcc.cd_centro_custo,dr.cd_centro_custo),0) else
							  @cd_centro_custo end ) and
     dr.dt_devolucao_documento is null

    ORDER BY
      dr.dt_vencimento_documento,
      dr.cd_identificacao


    --Mostra a Tabela Final
    select
      *
    from
      #DocumentoAberto     
    order by
      vencimento,
      documento

  End 


--select * from cheque_receber_composicao
--select * from cheque_receber

--------------------------------------------------------------------------------------------
--  ic_parametro = 2
--------------------------------------------------------------------------------------------  
--  If @ic_parametro = 2
--  Begin
--    print('Atenção, não existe consulta para esse parâmetro!')
--  End

