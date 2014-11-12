
create  VIEW vw_in86_lancamento_contabeis
--vw_in86_lancamento_contabeis
---------------------------------------------------------
--GBS - Global Business Solution	                   2004
--Stored Procedure	: Microsoft SQL Server           2004
--Autor(es)		      : André Godoi
--Banco de Dados	  : EGISSQL
--Objetivo	       	: Selecionar os lançamentos Contábeis
--Data			        : 19/03/2004
---------------------------------------------------------
as

select
  dt_lancamento_contabil as 'DATALANCAMENTO',
  cd_reduzido_debito as 'CODCONTA',
  cd_centro_custo as 'CODCCUSTO',  
  cd_reduzido_credito as 'CODCONTRA',
  vl_lancamento_contabil as 'VALOR',
  'D' as 'DEBCRED', 
  cast(cd_lote as char(4))+ '- ' + cast(cd_lancamento_contabil as char(4))  as 'NUMARQ',
  cd_lancamento_contabil as 'NUMLANC',
  ds_historico_contabil as 'HISTORICO' 
from
  Movimento_Contabil
where
  cd_reduzido_debito is not null and
  cd_reduzido_credito is not null
union all
select
  dt_lancamento_contabil as 'DATALANCAMENTO',
  cd_reduzido_credito as 'CODCONTA',  
  cd_centro_custo as 'CODCCUSTO',  
  cd_reduzido_debito as 'CODCONTRA',  
  vl_lancamento_contabil as 'VALOR',
  'C' as 'DEBCRED',
  cast(cd_lote as char(4))+ '- ' + cast(cd_lancamento_contabil as char(4)) as 'NUMARQ',
  cd_lancamento_contabil as 'NUMLANC',
  ds_historico_contabil as 'HISTORICO'
from
  Movimento_Contabil
where
  cd_reduzido_debito is not null and
  cd_reduzido_credito is not null
union all
select
  dt_lancamento_contabil as 'DATALANCAMENTO',
  case when (isnull(cd_reduzido_credito,0)=0) then
      cd_reduzido_debito
  else
      cd_reduzido_credito
  end as 'CODCONTA',  
  cd_centro_custo as 'CODCCUSTO',  
  NULL as 'CODCONTRA', 
  vl_lancamento_contabil as 'VALOR',
  case when (isnull(cd_reduzido_credito,0)=0) then
    'D'
  else
    'C'
  end as 'DEBCRED',
  cast(cd_lote as char(4))+ '- ' + cast(cd_lancamento_contabil as char(4)) as 'NUMARQ',  
  cd_lancamento_contabil as 'NUMLANC',
  ds_historico_contabil as 'HISTORICO'
from
  Movimento_Contabil
where
  cd_reduzido_debito is null or
  cd_reduzido_credito is null


