
create  VIEW vw_in86_plano_contas
--vw_in86_plano_contas
----------------------------------------------------------------
--GBS - Global Business Solution	                          2004
--Stored Procedure	: Microsoft SQL Server                  2004
--Autor(es)		      : André Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Selecionar os registros do Plano de Contas
--Data			        : 24/03/2004
----------------------------------------------------------------
as

select
  dt_usuario                                       as 'DATAATUALIZACAO',
  cd_mascara_conta                                 as 'CODIGO',
  case when (upper(ic_conta_analitica))= 'A' then
          'A'
       else
          'S'
       end                                         as 'TIPOCONTA',
  cd_conta_sintetica                               as 'CODIGO_TOTAL',
  nm_conta                                         as 'DESCRICAO'
from
  plano_conta
where
  cd_empresa = dbo.fn_empresa()
