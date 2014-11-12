
-------------------------------------------------------------------------------
--pr_resumo_producao_maquina_diaria_quantidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes / Danilo Campoi
--Banco de Dados   : Egissql
--Objetivo         : Resumo do Processamento Diário por Máquina
--
--Data             : 24.01.2006
--Alteração        : 
--
------------------------------------------------------------------------------
create procedure pr_resumo_producao_maquina_diaria_quantidade
@cd_maquina int = 0,
@dt_inicial datetime,
@dt_final   datetime
as

--select * from processo_categoria_apontamento

------ Soma por Categoria -----------------
   select 
     pca.cd_categoria_Apontamento as Codigo,
     sum(isnull(pca.qt_peca_boa_apontamento,0) + isnull(pca.qt_peca_ruim_apontamento,0))as TotalCat
   --sum(isnull(TotalCat,0)) as Total 
   into #SomaCate
   from
     Processo_Categoria_Apontamento pca
   group by
     cd_categoria_apontamento   
---------------------------------------------
   select
     pca.cd_maquina,
     m.nm_fantasia_maquina    as Maquina,
     day (pca.dt_fim)         as Dia,
     convert(DateTime,pca.hr_inicio,108) as HoraEstimada,
     --isnull(datediff(hour,pca.hr_inicio,pca.hr_fim),0) as HoraEstimada,
     sum(isnull(pca.qt_apontamento,0) + isnull(pca.qt_peca_boa_apontamento,0)
     + isnull(pca.qt_peca_ruim_apontamento,0) + isnull(pca.qt_processo_apontamento,0)
     + isnull(pca.qt_setup_apontamento,0)) as Total,
     cast( 0 as float)        as Perc,
     ca.nm_fantasia_categoria as Categoria,  
     cast( 0 as float)        as QtdCat,
     cast( 0 as float)        as PercCat,
     cast( 0 as float)        as KghProd,
     cast( 0 as float)        as PercProd,
     isnull(sum(pca.qt_peca_boa_apontamento),0) as QtddiaAprov,
     cast( 0 as float)      as PercAprov   
   from
     Processo_Categoria_Apontamento pca
     left outer join Maquina m    on m.cd_maquina = pca.cd_maquina
     left outer join Categoria_Apontamento ca on ca.cd_categoria_apontamento = pca.cd_categoria_apontamento
   where
     pca.cd_maquina = case when @cd_maquina = 0 then pca.cd_maquina else @cd_maquina end and
     m.nm_fantasia_maquina is not null

   group by
    pca.cd_maquina,m.nm_fantasia_maquina,pca.dt_fim,pca.hr_fim,pca.hr_inicio,ca.nm_fantasia_categoria
   order by
    m.nm_fantasia_maquina
   
