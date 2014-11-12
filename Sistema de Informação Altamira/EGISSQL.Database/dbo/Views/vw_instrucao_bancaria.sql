
CREATE VIEW vw_instrucao_bancaria
AS 

  select
    dr.cd_portador,
    dr.cd_identificacao			as 'Documento',
    isnull(dib.cd_banco_documento_recebe,dr.cd_banco_documento_recebe)
					as 'NumBancario',
    dr.cd_cliente			as 'CodCliente',
    dr.dt_vencimento_documento		as 'DtVencto',
    dr.dt_emissao_documento		as 'DtEmissao',
    dr.vl_documento_receber		as 'VlDocumento',
    dr.cd_tipo_destinatario             as 'TipoDestinatario',
    dib.cd_doc_instrucao_banco		as 'Codigo',
    ibco.cd_instrucao_banco             as 'Instrucao1',
    cast(null as int)			as 'Instrucao2',
    dib.cd_banco			as 'Banco',
    dib.dt_cancelamento_instrucao 	as 'DtCancel',
    dib.nm_cancelamento_instrucao 	as 'MotCancel',
    dib.ds_instrucao_banco		as 'Descricao',
    dibc.vl_instrucao_banco_compos      as 'VlInstrucao1',
    cast(null as float)			as 'VlInstrucao2',
    dibc.dt_instrucao_banco_comp        as 'DtInstrucao1',
    cast(null as datetime)		as 'DtInstrucao2',
    dibc.nm_instrucao_banco_compos      as 'ComplInstrucao1',
    cast(null as varchar)               as 'ComplInstrucao2',
    'INSTRUCAO'+' '+cast(dibc.cd_instrucao as char(2))+
    ' '+cast(replace(dr.cd_identificacao,'-','') as char(13))
                                        as 'InstrArqMag1',
    cast(null as varchar)		as 'InstrArqMag2'
  from
    Documento_Instrucao_Bancaria dib,
    Documento_Receber dr,
    Doc_Instrucao_Banco_Composicao dibc,
    Instrucao_Banco ibco
  where
    ibco.cd_instrucao            = dibc.cd_instrucao and
    dib.cd_doc_instrucao_banco   = dibc.cd_doc_instrucao_banco and
    ibco.cd_banco                = dib.cd_banco and
    dib.cd_documento_receber     = dr.cd_documento_receber and
    dib.ic_envio_instrucao_banco = 'N'  
--  order by
--    Codigo,
--    Item

--  order by
--    Codigo,
--    Item

