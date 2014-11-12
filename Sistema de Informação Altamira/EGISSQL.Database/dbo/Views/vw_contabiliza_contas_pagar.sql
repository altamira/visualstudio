
CREATE VIEW vw_contabiliza_contas_pagar
------------------------------------------------------------------------------------
--vw_contabiliza_contas_pagar
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Contabilização do Contas a Pagar 
--                        para a TMBEVO - Customização
--Data                  : 29.04.2004
--Atualização           : 18.12.2006 - Modificações conforme Cida - Carlos Fernandes
--                      : 06.04.2007 - Verificação - Carlos Fernandes
------------------------------------------------------------------------------------
as

select
  dpc.cd_item_contab_documento                    as Item,
  convert(datetime, dpc.dt_contab_documento, 103) as Data,
  replace(pd.cd_mascara_conta,'.','')             as Debito,
  replace(pc.cd_mascara_conta,'.','')             as Credito,
  dpc.vl_contab_documento                         as Valor,
  'PAGTO '+cast(f.cd_cnpj_fornecedor as varchar(8))+' '+      
  tpd.nm_tipo_pagamento+' '+isnull(dpg.cd_identifica_documento,'')+rtrim(ltrim(dp.cd_nota_fiscal_entrada))+' '+
  cast(f.nm_fantasia_fornecedor as varchar(15))
                                                  as Historico      
from
  documento_pagar_contabil dpc
inner join documento_pagar dp on dp.cd_documento_pagar = dpc.cd_documento_pagar
left outer join documento_pagar_pagamento dpg on dpg.cd_documento_pagar = dpc.cd_documento_pagar and
                                                 dpg.cd_item_pagamento = dpc.cd_item_pagamento
left outer join plano_conta pd on pd.cd_conta = dpc.cd_conta_debito 
left outer join plano_conta pc on pc.cd_conta = dpc.cd_conta_credito 
left outer join fornecedor f   on dp.cd_fornecedor = f.cd_fornecedor
left outer join tipo_pagamento_documento tpd on tpd.cd_tipo_pagamento = dpg.cd_tipo_pagamento
 
--select * from plano_conta 
