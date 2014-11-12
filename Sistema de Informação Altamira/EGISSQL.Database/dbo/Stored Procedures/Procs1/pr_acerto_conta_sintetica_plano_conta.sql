
create procedure pr_acerto_conta_sintetica_plano_conta
as
--------------------------------------------------------------------------------
--pr_acerto_conta_sintetica_plano_conta
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	            2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Geração de Conta Sintética do Plano de contas 6 níveis 
--Data			: 31.01.2006
--Alteração             : 
----------------------------------------------------------------------------------


--drop table #AuxConta

--Ajustando a Conta Sintética do Plano de Contas

update
 plano_conta
set
  cd_conta_sintetica = null
where 
  qt_grau_conta = 1

-----------------------------------------------------------------------------------------------------------

--select * from plano_conta

select pc.cd_conta,
       pc.cd_conta_sintetica,
       cd_conta_sintetica_1 = ( select top 1 x.cd_conta from plano_conta x where 
                                             x.qt_grau_conta = pc.qt_grau_conta-1 and
                                             x.cd_grupo_conta=pc.cd_grupo_conta and
                                             substring(x.cd_mascara_conta,1,dbo.fn_soma_digito_grau_conta(x.cd_grupo_conta,pc.qt_grau_conta-1))=
                                             substring(pc.cd_mascara_conta,1,dbo.fn_soma_digito_grau_conta(x.cd_grupo_conta,pc.qt_grau_conta-1)) )

into #AuxConta
from plano_conta pc 

update
  plano_conta
set
  cd_conta_sintetica = ( select cd_conta_sintetica_1 from #AuxConta a where a.cd_conta = pc.cd_conta )
from
  Plano_Conta pc


