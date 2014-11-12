
CREATE VIEW vw_trailer_lote_itau_sispag
------------------------------------------------------------------------------------
--vw_trailer_lote_itau_sispag
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)       :Márcio Rodrigues 
--Banco de Dados	: EGISSQL 
--Objetivo	      : Seleciona dados da empresa para o SAM
--Data            : 10.04.2006
--Atualização     : 
------------------------------------------------------------------------------------
as

Select
	PP.cd_lote,
	Count(D.cd_documento_pagar) as Qtd,
   Replace(Cast(Sum(vl_saldo_documento_pagar) as varchar(15)),'.','') as Valor,
	PP.sg_banco
from
	documento_pagar D inner join 
  	conta_agencia_banco c on (c.cd_conta_banco = d.cd_conta_banco) inner join 
	Parametro_Pagamento_Eletronico_Sispag  PP ON (pp.cd_banco = c.cd_banco AND pp.cd_conta_banco = d.cd_conta_banco) left join
	documento_pagar_cod_barra B on (D.cd_documento_pagar = B.cd_documento_pagar)  
where 
	ic_envio_documento = 'S' and
	dt_envio_banco is null
group by
	PP.cd_lote,
	PP.sg_banco
