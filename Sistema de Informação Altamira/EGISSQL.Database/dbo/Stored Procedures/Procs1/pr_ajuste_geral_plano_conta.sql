
create procedure pr_ajuste_geral_plano_conta
as
--------------------------------------------------------------------------------
--pr_ajuste_geral_plano_conta
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda             	            2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Acertos diversos no Plano de Contas do Cliente
--Data			: 14.02.2006
--Alteração             : 03.03.2006
----------------------------------------------------------------------------------

select qt_grau_conta,* from plano_conta order by cd_mascara_conta

--grau da conta

update
  plano_conta
set
  qt_grau_conta = dbo.fn_grau_conta_contabil(cd_mascara_conta)


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


--select qt_grau_conta,cd_conta_reduzido,* from plano_conta order by cd_mascara_conta  

--grupo conta
--select * from grupo_conta

update
 plano_conta
set
  cd_grupo_conta = cast ( substring(cd_mascara_conta,1,1) as int )

--tipo da conta
-- select * from grupo_conta
-- select * from plano_conta

--Custo

update
  plano_conta
set
  ic_conta_custo     = 'S'
from
  plano_conta pc 
  inner join grupo_conta gc on gc.cd_grupo_conta = pc.cd_grupo_conta
where
  pc.cd_grupo_conta = 6


update
  plano_conta
set
  ic_situacao_conta  = 'L', --Liberada
  ic_conta_custo     = 'N',
  ic_tipo_conta      = gc.ic_tipo_grupo_conta,
  ic_conta_balanco   = gc.ic_balanco_grupo_conta,
  ic_conta_resultado = gc.ic_resultado_grupo_conta,
                     --= gc.ic_demo_grupo_conta,
  ic_conta_analise   = gc.ic_analise_grupo_conta
from
  plano_conta pc 
  inner join grupo_conta gc on gc.cd_grupo_conta = pc.cd_grupo_conta


update
  plano_conta
set
  ic_conta_analitica = 'T'

--Conta Analítica apenas grau 6 
update
  plano_conta
set
  ic_conta_analitica = 'a'
where
  qt_grau_conta = 6

--Conta de Lançamento apenas grau 6
update
  plano_conta
set
  ic_lancamento_conta = 'S'
where
  qt_grau_conta = 6


--Geração e Acerto do Final da Conta

select substring(cd_mascara_conta,1,12),* from plano_conta

--Todas as Contas

update
  plano_conta
set
  cd_mascara_conta = substring(cd_mascara_conta,1,12)+'00000'
where
  qt_grau_conta<>6

select substring(cd_mascara_conta,13,5),
       cast( cd_conta_reduzido as varchar(5) ),
       case when cd_conta_reduzido<10 
       then
         '0000'+cast( cd_conta_reduzido as varchar(1) )
       else
         case when cd_conta_reduzido>9 and cd_conta_reduzido<100 then
           '000'+cast( cd_conta_reduzido as varchar(2) )
         else
           case when cd_conta_reduzido>99 and cd_conta_reduzido<1000 then
             '00'+cast( cd_conta_reduzido as varchar(3) )
           else
             case when cd_conta_reduzido>999 and cd_conta_reduzido<10000 then
               '0'+cast( cd_conta_reduzido as varchar(4) )
             else
               cast( cd_conta_reduzido as varchar(5) )
             end
           end
         end
       end as reduzido,     
                                     
      * 
from 
  plano_conta

--Conta de Grau 6

update
  plano_conta
set
  cd_mascara_conta = substring(cd_mascara_conta,1,12) + 
       case when cd_conta_reduzido<10 
       then
         '0000'+cast( cd_conta_reduzido as varchar(1) )
       else
         case when cd_conta_reduzido>9 and cd_conta_reduzido<100 then
           '000'+cast( cd_conta_reduzido as varchar(2) )
         else
           case when cd_conta_reduzido>99 and cd_conta_reduzido<1000 then
             '00'+cast( cd_conta_reduzido as varchar(3) )
           else
             case when cd_conta_reduzido>999 and cd_conta_reduzido<10000 then
               '0'+cast( cd_conta_reduzido as varchar(4) )
             else
               cast( cd_conta_reduzido as varchar(5) )
             end
           end
         end
       end
where
  qt_grau_conta=6


