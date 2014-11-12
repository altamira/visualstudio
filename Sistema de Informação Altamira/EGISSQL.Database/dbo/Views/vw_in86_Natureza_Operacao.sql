
CREATE VIEW vw_in86_Natureza_Operacao
--  vw_in86_Natureza_Operacao
-------------------------------------------------------------
--GBS - Global Business Solution	                       2004
--Stored Procedure	: Microsoft SQL Server               2004
--Autor(es)		      : André de Oliveira Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : descrição dos Códigos da Natureza da Operação
--Data			        : 24/03/2004
-------------------------------------------------------------
as

select
  op.dt_usuario as 'DATAATUALIZACAO',
  op.cd_operacao_fiscal as 'CODIGO',
  op.nm_operacao_fiscal as 'DESCRICAO'

from
  operacao_fiscal op
