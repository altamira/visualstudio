
-------------------------------------------------------------------------------
--pr_migracao_kgm_ferramenta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabelas de Ferramentas
--Data             : 26.09.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_kgm_ferramenta
as

-- drop table ferramenta
-- drop table grupo_ferramenta

delete from ferramenta
delete from grupo_ferramenta

--select * from kgm.dbo.ferramental$

select
  identity(int,1,1)                    as cd_ferramenta,
  cast(isnull([CADASTRO GERAL - FERRAMENTAL (DISPOSITIVOS/CALIBRADORES/INSTRUME],'') as varchar(60) ) as nm_ferramenta,
  cast(f.F1 as varchar(30))            as  nm_fantasia_ferramenta,
  null                                 as cd_oleo_refrigerante,
  null                                 as cd_forma_ferramenta,
  null                                 as cd_mat_prima,
  null                                 as cd_tipo_iso_maquina,
  1                                    as cd_grupo_ferramenta,
  null                                 as nm_caminho_ferramenta,
  null                                 as cd_produto,
  null                                 as vl_diametro,
  null                                 as qt_facas,
  null                                 as cd_num_ferramenta,
  null                                 as vl_comp_corte,
  null                                 as vl_prof_corte,
  null                                 as vl_larg_corte,
  null                                 as cd_fornecedor,
  null                                 as vl_raio_canto,
  null                                 as vl_angulo_ponta,
  null                                 as vl_passo_macho,
  null                                 as vl_avanco_retracao,
  null                                 as vl_diametro_piloto,
  null                                 as vl_diametro_mandril,
  null                                 as vl_comp_mandril,
  null                                 as vl_diametro_haste,
  null                                 as vl_comp_total,
  cast(null as varchar)                as ds_ferramenta,
  null                                 as vl_avanco_faca,
  null                                 as vl_rotacao,
  null                                 as vl_avanco_trabalho,
  null                                 as vl_vida_util,
  null                                 as vl_avanco_mergulho,
  99                                   as cd_usuario,
  getdate()                            as dt_usuario,
  null                                 as vl_comprimento_total_ferrament,
  f.F1                                 as cd_identificacao_ferramenta,
  null                                 as cd_desenho_ferramenta,
  null                                 as cd_rev_desenho_ferramenta,
  ( select top 1 cd_tipo_ferramenta
    from
      Tipo_Ferramenta
    where
      sg_tipo_ferramenta = f.F3 )      as cd_tipo_ferramenta,

  ( select top 1 cd_local_ferramenta 
    from
      Local_Ferramenta 
    where
      sg_local_ferramenta = f.F5 )     as cd_local_ferramenta,

  null                                 as nm_obs_ferramenta
  
into
  #Ferramenta
from
  kgm.dbo.ferramental$ f
where
  [CADASTRO GERAL - FERRAMENTAL (DISPOSITIVOS/CALIBRADORES/INSTRUME] is not null

--select * from #Ferramenta

insert into
  Ferramenta
select
  *
from
  #Ferramenta

drop table #Ferramenta

Select * from Ferramenta

