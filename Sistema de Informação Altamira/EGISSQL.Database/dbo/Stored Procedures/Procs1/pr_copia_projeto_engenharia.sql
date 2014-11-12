
-------------------------------------------------------------------------------
--pr_copia_projeto_engenharia
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Cópia de Projeto de Engenharia
--Data             : 24.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_projeto_engenharia
@cd_projeto_origem      int = 0,
@cd_item_projeto_origem int = 0,
@cd_projeto_destino     int = 0

as

declare

  @cd_item_projeto_temp int,
  @cd_item_projeto      int,
  @cd_projeto_material  int

-----
--Último item de Composição
-----
select 

  @cd_item_projeto=isnull(max(cd_item_projeto),0)
from
  Projeto_Composicao
where
  cd_projeto=@cd_projeto_destino 

-----
--Varre tabela de Composição
-----
select 
  *
into 
  #Temp_Projeto_Composicao
from
  Projeto_Composicao
where
  cd_projeto      = @cd_projeto_origem       and
  cd_item_projeto = @cd_item_projeto_origem
order by
  cd_item_projeto

select
 @cd_projeto_destino  as cd_projeto,
 @cd_item_projeto + 1 as cd_item_projeto,
 dt_item_projeto,
 qt_item_projeto,
 cd_desenho_projeto,
 cd_tipo_projeto,
 cd_projetista,
 dt_conf_projeto,
 dt_aprov_projeto,
 nm_item_obs_projeto,
 nm_item_desenho_projeto,
 nm_item_caminho_projeto,
 ic_lista_material_projeto,
 cd_cod_projeto,
 cd_status_projeto,
 cd_usuario,
 dt_usuario,
 nm_projeto_composicao,
 cd_tipo_produto_projeto,
 dt_inicio_projeto,
 dt_fim_projeto,
 cd_ref_item_projeto
into  #Projeto_Composicao
from
  #Temp_Projeto_Composicao
order by
  cd_item_projeto

  insert into Projeto_Composicao
  ( cd_projeto,
    cd_item_projeto,
    dt_item_projeto,
    qt_item_projeto,
    cd_desenho_projeto,
    cd_tipo_projeto,
    cd_projetista,
    dt_conf_projeto,
    dt_aprov_projeto,
    nm_item_obs_projeto,
    nm_item_desenho_projeto,
    nm_item_caminho_projeto,
    ic_lista_material_projeto,
    cd_cod_projeto,
    cd_status_projeto,
    cd_usuario,
    dt_usuario,
    nm_projeto_composicao,
    cd_tipo_produto_projeto,
    dt_inicio_projeto,
    dt_fim_projeto,
    cd_ref_item_projeto)
  select top 1 
    cd_projeto,
    cd_item_projeto,
    dt_item_projeto,
    qt_item_projeto,
    cd_desenho_projeto,
    cd_tipo_projeto,
    cd_projetista,
    dt_conf_projeto,
    dt_aprov_projeto,
    nm_item_obs_projeto,
    nm_item_desenho_projeto,
    nm_item_caminho_projeto,
    ic_lista_material_projeto,
    cd_cod_projeto,
    cd_status_projeto,
    cd_usuario,
    dt_usuario,
    nm_projeto_composicao,
    cd_tipo_produto_projeto,
    dt_inicio_projeto,
    dt_fim_projeto,
   cd_item_projeto
  from #Projeto_Composicao
  order by cd_item_projeto

-----
--Último item de Materiais
-----
  set @cd_item_projeto_temp = (select top 1 cd_item_projeto from #Projeto_Composicao order by cd_item_projeto)
  select 
    @cd_projeto_material=isnull(max(cd_projeto_material),0)
  from
    Projeto_Composicao_Material
  where
    cd_projeto      = @cd_projeto_destino and
    cd_item_projeto = @cd_item_projeto_temp

-----
--Varre tabela de Materiais
-----
  select 
    *
  into 
    #Temp_Projeto_Composicao_Material
  from
    Projeto_Composicao_Material
  where
    cd_projeto      = @cd_projeto_origem and
    cd_item_projeto = @cd_item_projeto_origem
  order by 
    cd_item_projeto

  select
    @cd_projeto_destino   as cd_projeto,
    @cd_item_projeto_temp as cd_item_projeto,
    cd_projeto_material,
    cd_desenho_projeto,
    cd_produto,
    qt_projeto_material,
    nm_esp_projeto_material,
    nm_obs_projeto_material,
    ds_projeto_material,
    ic_fabricado_projeto,
    cd_fornecedor,
    cd_materia_prima,
    cd_usuario,
    dt_usuario,
    nm_marca_material,
    cd_unidade_medida,
    cd_tipo_produto_projeto,
    nm_fornec_prod_projeto,
    nm_desenho_material,
    nm_caminho_desenho,
    cd_projetista,
    ic_reposicao_material,
    ic_desgaste_material,
    qt_dia_desgaste_material,
    ic_compra_prod_material,
    qt_hora_desgaste_material,
    cd_ref_item_material,
    ic_ativo_material
  into 
    #Projeto_Composicao_Material
  from
    #Temp_Projeto_Composicao_Material
  order by cd_item_projeto

  insert into Projeto_Composicao_Material
  ( cd_projeto,
    cd_item_projeto,
    cd_projeto_material,
    cd_desenho_projeto,
    cd_produto,
    qt_projeto_material,
    nm_esp_projeto_material,
    nm_obs_projeto_material,
    ds_projeto_material,
    ic_fabricado_projeto,
    cd_fornecedor,
    cd_materia_prima,
    cd_usuario,
    dt_usuario,
    nm_marca_material,
    cd_unidade_medida,
    cd_tipo_produto_projeto,
    nm_fornec_prod_projeto,
    nm_desenho_material,
    nm_caminho_desenho,
    cd_projetista,
    ic_reposicao_material,
    ic_desgaste_material,
    qt_dia_desgaste_material,
    ic_compra_prod_material,
    qt_hora_desgaste_material,
    cd_ref_item_material,
    ic_ativo_material)
  select  
    cd_projeto,
    cd_item_projeto,
    cd_projeto_material,
    cd_desenho_projeto,
    cd_produto,
    qt_projeto_material,
    nm_esp_projeto_material,
    nm_obs_projeto_material,
    ds_projeto_material,
    ic_fabricado_projeto,
    cd_fornecedor,
    cd_materia_prima,
    cd_usuario,
    dt_usuario,
    nm_marca_material,
    cd_unidade_medida,
    cd_tipo_produto_projeto,
    nm_fornec_prod_projeto,
    nm_desenho_material,
    nm_caminho_desenho,
    cd_projetista,
    ic_reposicao_material,
    ic_desgaste_material,
    qt_dia_desgaste_material,
    ic_compra_prod_material,
    qt_hora_desgaste_material,
    cd_ref_item_material,
    ic_ativo_material
  from 
    #Projeto_Composicao_Material


drop table #Temp_Projeto_Composicao
drop table #Temp_Projeto_Composicao_Material
drop table #Projeto_Composicao
drop table #Projeto_Composicao_Material

