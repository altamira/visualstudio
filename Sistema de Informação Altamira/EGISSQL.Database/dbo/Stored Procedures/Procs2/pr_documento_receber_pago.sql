
CREATE PROCEDURE pr_documento_receber_pago
@dt_inicial             char(10),
@dt_final               char(10),
@cd_cliente             int = 0,
@cd_vendedor            int = 0,
@cd_portador            int = 0,
@cd_tipo_documento      int = 0,
@cd_tipo_cobranca       int = 0,
@ic_agrupa_portador     char(1),
@cd_centro_custo        int = 0

AS

/*  select 
    d.cd_identificacao as documento,
    c.nm_fantasia_cliente as cliente,
    d.dt_emissao_documento as emissao,
    d.dt_vencimento_documento as vencimento,
    p.dt_pagamento_documento as pagamento,
    d.vl_documento_receber as valor,
    p.vl_desconto_documento + p.vl_abatimento_documento as descabat,
    p.vl_juros_pagamento as juros,
    p.vl_pagamento_documento as pago,
    d.cd_vendedor as ven,
    d.cd_portador as por,
    cast((P.DT_PAGAMENTO_DOCUMENTO - D.DT_VENCIMENTO_DOCUMENTO)AS INT) as Dias,
    CASE WHEN D.VL_SALDO_DOCUMENTO > 0.00 THEN 2 ELSE 1 END as ic_tipo_baixa   
  from
    documento_receber d
  inner join
    documento_receber_pagamento p
  on
    d.cd_documento_receber = p.cd_documento_receber
  left outer join
    cliente c
  on
    d.cd_cliente = c.cd_cliente
  where
    p.dt_pagamento_documento between @dt_inicial and @dt_final and
    d.cd_cliente = isnull(@cd_cliente, '')

*/
  declare @InstrucaoSQL varchar(5000)

  set @InstrucaoSQL = ' SELECT '+
                        ' D.CD_IDENTIFICACAO 		as Documento,'+
                        ' C.NM_FANTASIA_CLIENTE		as Cliente, '+
                        ' D.DT_EMISSAO_DOCUMENTO 	as Emissao, '+
                        ' D.DT_VENCIMENTO_DOCUMENTO 	as Vencimento, '+
                        ' P.DT_PAGAMENTO_DOCUMENTO 	as Pagamento, '+
			' D.VL_DOCUMENTO_receber 	as Valor, '+
                        ' P.VL_DESCONTO_DOCUMENTO + P.VL_ABATIMENTO_DOCUMENTO  	as DescAbat, '+
                        ' P.VL_REEMBOLSO_DOCUMENTO      as Reembolso,'+
                        ' P.VL_JUROS_PAGAMENTO 		as Juros, '+
                        ' P.VL_PAGAMENTO_DOCUMENTO      as Pago, '+
                        ' D.CD_VENDEDOR 		as Ven, '+
                        ' D.CD_PORTADOR 		as Por, '+
                        ' PT.NM_PORTADOR                as Portador,'+
                        ' CC.nm_centro_custo            as CentroCusto,'+
                        ' CAST((P.DT_PAGAMENTO_DOCUMENTO - D.DT_VENCIMENTO_DOCUMENTO)AS INT) as Dias, '+
                        ' CASE WHEN cast(str(D.VL_SALDO_DOCUMENTO,25,2) as decimal(25,2)) > 0.00 THEN 2 ELSE 1 END as ic_tipo_baixa, '+ -- 1 - Baixa total 2 - Baixa Parcial
                        ' TL.NM_TIPO_LIQUIDACAO ' +
                      ' FROM '+
                        ' DOCUMENTO_RECEBER D with (nolock) INNER JOIN DOCUMENTO_RECEBER_PAGAMENTO P '+
                      ' ON D.CD_DOCUMENTO_RECEBER = P.CD_DOCUMENTO_RECEBER ' +
                      ' INNER JOIN TIPO_LIQUIDACAO TL ON TL.CD_TIPO_LIQUIDACAO = P.CD_TIPO_LIQUIDACAO '+
                      ' LEFT OUTER JOIN CLIENTE C '+
                      ' ON D.CD_CLIENTE = C.CD_CLIENTE LEFT OUTER JOIN PORTADOR PT ON PT.CD_PORTADOR=D.CD_PORTADOR'+  
                      ' LEFT OUTER JOIN CENTRO_CUSTO  CC ON CC.CD_CENTRO_CUSTO = D.CD_CENTRO_CUSTO '+
                      ' WHERE '+
                        ' D.DT_CANCELAMENTO_DOCUMENTO IS NULL and '+
                        ' D.DT_DEVOLUCAO_DOCUMENTO IS NULL and '+
                        ' ISNULL(TL.ic_rel_doc_tipo_liquidacao,''S'') = ''S'' AND '+
                        ' P.DT_PAGAMENTO_DOCUMENTO BETWEEN '+
                        ''''+@dt_inicial +''''+' and '+''''+@dt_final+''''

  if isnull(@cd_cliente, 0) <> 0 
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_CLIENTE = '+''''+cast(@cd_cliente as varchar(6))+''''

  if isnull(@cd_vendedor, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_VENDEDOR = '+''''+cast(@cd_vendedor as varchar(6))+''''

  if isnull(@cd_portador, 0) <> 0 
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_PORTADOR = '+''''+cast(@cd_portador as varchar(6))+''''

  if isnull(@cd_tipo_documento, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_TIPO_DOCUMENTO = '+''''+cast(@cd_tipo_documento as varchar(6))+''''   

  if isnull(@cd_tipo_cobranca, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_TIPO_COBRANCA = '+''''+cast(@cd_tipo_cobranca as varchar(6))+''''   

  if isnull(@cd_centro_custo, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_CENTRO_CUSTO = '+''''+cast(@cd_centro_custo as varchar(6))+''''   


  if @ic_agrupa_portador='S'
    set @InstrucaoSQL = @InstrucaoSQL + 'Order by por, P.DT_PAGAMENTO_DOCUMENTO'
  else
    set @InstrucaoSQL = @InstrucaoSQL + 'Order by ic_tipo_baixa, P.DT_PAGAMENTO_DOCUMENTO'

  exec(@InstrucaoSQL)

