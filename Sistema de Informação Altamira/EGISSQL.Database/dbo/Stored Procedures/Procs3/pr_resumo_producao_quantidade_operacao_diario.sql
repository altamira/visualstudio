
-------------------------------------------------------------------------------
--pr_resumo_producao_maquina_diaria_quantidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Danilo Campoi
--Banco de Dados   : Egissql
--Objetivo         : Resumo Produção de Quantidade por Operação Diária
--
--Data             : 26.01.2006
--Alteração        : 

--------------------------------------------------------------

create procedure pr_resumo_producao_quantidade_operacao_diario
@cd_maquina  int = 0,
@cd_operacao int = 0,
@dt_inicial  datetime,
@dt_final    datetime
as

--select * from processo_categoria_apontamento


----- Tabela de Qtdade------------------------------------------------------------------------------------------


select
  pca.cd_operacao,
  pca.cd_categoria_apontamento,
  sum(isnull(case when day(pca.dt_fim) = 1  then isnull(pca.qt_apontamento,0) end,0)) as '1',
  sum(isnull(case when day(pca.dt_fim) = 2  then isnull(pca.qt_apontamento,0) end,0)) as '2',
  sum(isnull(case when day(pca.dt_fim) = 3  then isnull(pca.qt_apontamento,0) end,0)) as '3',
  sum(isnull(case when day(pca.dt_fim) = 4  then isnull(pca.qt_apontamento,0) end,0)) as '4',
  sum(isnull(case when day(pca.dt_fim) = 5  then isnull(pca.qt_apontamento,0) end,0)) as '5',
  sum(isnull(case when day(pca.dt_fim) = 6  then isnull(pca.qt_apontamento,0) end,0)) as '6',
  sum(isnull(case when day(pca.dt_fim) = 7  then isnull(pca.qt_apontamento,0) end,0)) as '7',
  sum(isnull(case when day(pca.dt_fim) = 8  then isnull(pca.qt_apontamento,0) end,0)) as '8',
  sum(isnull(case when day(pca.dt_fim) = 9  then isnull(pca.qt_apontamento,0) end,0)) as '9',
  sum(isnull(case when day(pca.dt_fim) = 10 then isnull(pca.qt_apontamento,0) end,0)) as '10',
  sum(isnull(case when day(pca.dt_fim) = 11 then isnull(pca.qt_apontamento,0) end,0)) as '11',
  sum(isnull(case when day(pca.dt_fim) = 12 then isnull(pca.qt_apontamento,0) end,0)) as '12',
  sum(isnull(case when day(pca.dt_fim) = 13 then isnull(pca.qt_apontamento,0) end,0)) as '13',
  sum(isnull(case when day(pca.dt_fim) = 14 then isnull(pca.qt_apontamento,0) end,0)) as '14',
  sum(isnull(case when day(pca.dt_fim) = 15 then isnull(pca.qt_apontamento,0) end,0)) as '15',
  sum(isnull(case when day(pca.dt_fim) = 16 then isnull(pca.qt_apontamento,0) end,0)) as '16',
  sum(isnull(case when day(pca.dt_fim) = 17 then isnull(pca.qt_apontamento,0) end,0)) as '17',
  sum(isnull(case when day(pca.dt_fim) = 18 then isnull(pca.qt_apontamento,0) end,0)) as '18',
  sum(isnull(case when day(pca.dt_fim) = 19 then isnull(pca.qt_apontamento,0) end,0)) as '19',
  sum(isnull(case when day(pca.dt_fim) = 20 then isnull(pca.qt_apontamento,0) end,0)) as '20',
  sum(isnull(case when day(pca.dt_fim) = 21 then isnull(pca.qt_apontamento,0) end,0)) as '21',
  sum(isnull(case when day(pca.dt_fim) = 22 then isnull(pca.qt_apontamento,0) end,0)) as '22',
  sum(isnull(case when day(pca.dt_fim) = 23 then isnull(pca.qt_apontamento,0) end,0)) as '23',
  sum(isnull(case when day(pca.dt_fim) = 24 then isnull(pca.qt_apontamento,0) end,0)) as '24',
  sum(isnull(case when day(pca.dt_fim) = 25 then isnull(pca.qt_apontamento,0) end,0)) as '25',
  sum(isnull(case when day(pca.dt_fim) = 26 then isnull(pca.qt_apontamento,0) end,0)) as '26',
  sum(isnull(case when day(pca.dt_fim) = 27 then isnull(pca.qt_apontamento,0) end,0)) as '27',
  sum(isnull(case when day(pca.dt_fim) = 28 then isnull(pca.qt_apontamento,0) end,0)) as '28',
  sum(isnull(case when day(pca.dt_fim) = 29 then isnull(pca.qt_apontamento,0) end,0)) as '29',
  sum(isnull(case when day(pca.dt_fim) = 30 then isnull(pca.qt_apontamento,0) end,0)) as '30',
  sum(isnull(case when day(pca.dt_fim) = 31 then isnull(pca.qt_apontamento,0) end,0)) as '31'
into 
  #Qtd 
from
  processo_categoria_apontamento pca
where
  pca.dt_fim between @dt_inicial and @dt_final
group by
  pca.cd_operacao,
  pca.cd_categoria_apontamento



   select
     pca.cd_maquina,
     m.nm_fantasia_maquina       as Maquina, 
     o.nm_operacao               as Operacao,
     ca.nm_categoria_apontamento as Categoria,
     cast( 0 as float  )  as '1',
     cast( 0 as float  )  as '2',
     cast( 0 as float  )  as '3',
     cast( 0 as float  )  as '4',
     cast( 0 as float  )  as '5',
     cast( 0 as float  )  as '6',
     cast( 0 as float  )  as '7',
     cast( 0 as float  )  as '8',
     cast( 0 as float  )  as '9',
     cast( 0 as float  )  as '10',
     cast( 0 as float  )  as '11',
     cast( 0 as float  )  as '12',
     cast( 0 as float  )  as '13',
     cast( 0 as float  )  as '14',
     cast( 0 as float  )  as '15',
     cast( 0 as float  )  as '16',
     cast( 0 as float  )  as '17',
     cast( 0 as float  )  as '18',
     cast( 0 as float  )  as '19',
     cast( 0 as float  )  as '20',
     cast( 0 as float  )  as '21',
     cast( 0 as float  )  as '22',
     cast( 0 as float  )  as '23',
     cast( 0 as float  )  as '24',
     cast( 0 as float  )  as '25',
     cast( 0 as float  )  as '26',
     cast( 0 as float  )  as '27',
     cast( 0 as float  )  as '28',
     cast( 0 as float  )  as '29',
     cast( 0 as float  )  as '30',
     cast( 0 as float  )  as '31',
     cast( 0 as float)  as Total,
     cast( 0 as float)  as Perc ,
     cast( 0 as float)  as Media
          
   from
     Processo_Categoria_Apontamento pca 
     left outer join Maquina               m   on m.cd_maquina                 = pca.cd_maquina
     left outer join Operacao              o   on o.cd_operacao                = pca.cd_operacao
     left outer join Categoria_Apontamento ca  on ca.cd_categoria_apontamento  = pca.cd_categoria_apontamento
      
   where
     pca.cd_maquina = case when @cd_maquina = 0 then pca.cd_maquina else @cd_maquina end and
     m.nm_fantasia_maquina is not null and
     o.cd_operacao = case when @cd_operacao = 0 then o.cd_operacao else @cd_operacao end and
     isnull(ca.ic_pad_categoria,'N')='S'
  
   
   order by
     m.nm_fantasia_maquina


