
CREATE VIEW vw_in86_Plano_de_Contas
--vw_in86_Plano_de_Contas
-------------------------------------------------------------
--GBS - Global Business Solution	                       2004
--Stored Procedure	: Microsoft SQL Server               2004
--Autor(es)		      : André de Oliveira Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Arquivo de Plano completo com todas Contas Analiticas e Sintéticas.
--Data			        : 24/03/2004
-------------------------------------------------------------
as

select
  dt_usuario as 'DATAATUALIZACAO',
  cd_mascara_conta as 'CODIGO',
  case when (upper(ic_conta_analitica))= 'A' then
          'A'
       else
          'S'
       end   as 'TIPOCONTA',
  cd_conta_sintetica as 'CODIGO_TOTAL',
  nm_conta as 'DESCRICAO'
from
  plano_conta
where
  cd_empresa = dbo.fn_empresa()

