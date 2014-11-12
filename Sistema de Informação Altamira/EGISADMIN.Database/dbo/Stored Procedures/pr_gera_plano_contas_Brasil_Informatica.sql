
--------------------------------------------------------------------------------------------------------------------
--pr_gera_plano_contas_Brasil_Informatica
--------------------------------------------------------------------------------------------------------------------
--Global Business Solution Ltda                2006
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Diego Santiago
--Banco de Dados  : EgisSql
--Objetivo: Atualiza o Plano de contas da Brasil Informatica
--Data: 18/01/2006
--Atualizado: 18/01/2006 - Criação
--          : 25.01.2006 - Carlos Fernandes
----------------------------------------------------------------------------------------------------------------------

create procedure pr_gera_plano_contas_Brasil_Informatica
as

--drop table #PlanoConta
--go 

delete from plano_conta

select
  22					 as cd_empresa,
  identity (int,1,1) 			 as cd_conta,
  substring(pc.Col001,1,14)		 as cd_mascara_conta,
  pc.col003           	 		 as nm_conta,
  'D'					 as ic_tipo_conta,
  case when pc.Col002 <> 5 then 'T' else 'a' end  as ic_conta_analitica,
  'N'					 as ic_conta_balanco,
  'N'					 as ic_conta_resultado,
  'N'					 as ic_conta_custo,
  'N'					 as ic_conta_analise,
  'N'					 as ic_situacao_conta,
  'N'					 as ic_lancamento_conta,
  0					 as vl_saldo_inicial_conta,
  'N'					 as ic_saldo_inicial_conta,
  0					 as vl_debito_conta,
  0					 as vl_credito_conta,
  0					 as qt_lancamento_conta,
  0					 as vl_saldo_atual_conta,
  'N'					 as ic_saldo_atual_conta,
  cast( substring(pc.Col001,1,1) as int) as cd_grupo_conta,
  substring(pc.Col001,10,5)		 as cd_conta_reduzido,
  1					 as cd_usuario,
  getdate()				 as dt_usuario,
  pc.Col002				 as qt_grau_conta,
  0					 as cd_conta_sintetica,
  'N'					 as ic_conta_demonstrativo,
  0					 as cd_centro_custo,
  0					 as cd_centro_receita

into
  #PlanoConta

from 
  PlanoTrm pc

-------------------
--Segundo Trecho---
-------------------

insert into
  Plano_Conta
select
  *
from
  #PlanoConta


