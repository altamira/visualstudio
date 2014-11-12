
CREATE PROCEDURE pr_consulta_projeto_processo
@cd_projeto 		int,
@cd_item_projeto 	int

AS

  select     
    p.cd_projeto, 
    p.cd_interno_projeto, 
    pc.cd_item_projeto, 
    pc.nm_projeto_composicao, 
    pjc.nm_fantasia_projetista as nm_fantasia_projetista_composicao,
    pc.nm_item_desenho_projeto, 
    pc.qt_item_projeto, 
    pcm.cd_projeto_material, 
    pjm.nm_fantasia_projetista as nm_fantasia_projetista_material, 
    pcm.nm_desenho_material, 
    pcm.nm_esp_projeto_material, 
    pcm.qt_projeto_material, 
--    pcm.cd_processo, 
    pc.dt_liberacao_item_projeto, 
    pjl.nm_fantasia_projetista as nm_fantasia_projetista_liberacao,
    pp.cd_processo,
    pp.dt_processo,
    pp.nm_processista
  from         
    projeto p      right outer join
    projetista pjc right outer join
    projetista pjl right outer join
    projeto_composicao pc on pjl.cd_projetista = pc.cd_projetista_liberacao 
                          on pjc.cd_projetista = pc.cd_projetista 
                          on p.cd_projeto = pc.cd_projeto right outer join
    tipo_produto_projeto tpp right outer join
    projetista pjm right outer join
    projeto_composicao_material pcm on pjm.cd_projetista = pcm.cd_projetista 
                                    on tpp.cd_tipo_produto_projeto = pcm.cd_tipo_produto_projeto 
                                    on pc.cd_projeto = pcm.cd_projeto and pc.cd_item_projeto = pcm.cd_item_projeto
    right outer join processo_producao pp on pp.cd_projeto      = pc.cd_projeto     and
                                            pp.cd_item_projeto = pc.cd_item_projeto and
                                            pp.cd_projeto_material = pcm.cd_projeto_material
                                            
  where     
    (isnull(tpp.ic_procfab_projeto, 'N') = 'S') and
    pc.dt_liberacao_item_projeto is not null and
    p.cd_projeto       = case when @cd_projeto=0      then p.cd_projeto       else @cd_projeto end and
    pc.cd_item_projeto = case when @cd_item_projeto=0 then pc.cd_item_projeto else @cd_item_projeto end 

