
CREATE PROCEDURE pr_consulta_composicao_material_projeto_engenharia
-----------------------------------------------------------------    
--pr_consulta_composicao_material_projeto_engenharia    
-----------------------------------------------------------------    
--GBS - Global Business Solution Ltda                        2004    
-----------------------------------------------------------------    
--Stored Procedure     : Microsoft SQL Server 2000    
--Autor(es)            : Carlos Cardoso Fernandes    
--Banco de Dados       : EgisSQL    
--Objetivo             : Consulta da Composio de Materiais de Projetos     
--Data                 : 25/1/2003    
--Atualizado           : 05/02/2003 - Rafael M. Santiago    
--                 Colocao correta da passagem de parametro    
--                     : 27/08/2003 - Rafael M. Santiago    
--                                    Colocao do atributo ic_reposicao_material    
--                     : 04/01/2005 - Acerto do Cabealho - Srgio Cardoso    
--                     : 16.04.2006 - Colocado a Requisio Interna - Carlos Fernandes    
--                     : 24.04.2006 - Fantasia do Produto - Carlos Fernandes    
-- 26.01.2009 - Carlos Fernandes
--------------------------------------------------------------------------------------    
@cd_parametro    int = 0,     
                   --1 Consulta da Lista de Material    
                   --2 Consulta das Listas Liberadas para Compra / Gerao     
@cd_projeto      int = 0,    
@dt_inicial      datetime = '',    
@dt_final        datetime = '',    
@cd_item_projeto int      = 0
   
as    
    
declare @nm_materia_prima       varchar(30)    
declare @nm_fantasia_fornecedor varchar(15)           
    
    
if @cd_parametro = 1 --Consulta da Lista de Material    
begin    
    
  select    
    p.cd_interno_projeto        as 'Projeto',      
    tp.nm_tipo_projeto          as 'TipoProjeto',    
    pm.cd_item_projeto          as 'ItemProjeto',    
    pm.cd_projeto_material      as 'ItemLista',    
    pm.qt_projeto_material      as 'Quantidade',    
    pc.nm_projeto_composicao    as 'Composicao',    
    case when isnull(pm.cd_produto,0) > 0 then     
          (select nm_produto from Produto where pm.cd_produto = cd_produto)    
         else pm.nm_esp_projeto_material     
    end as 'Produto',       
    case when isnull(pm.cd_materia_prima,0)>0 then    
          ( select mpp.nm_mat_prima from Materia_Prima mpp where pm.cd_materia_prima = mpp.cd_mat_prima )    
         else    
           @nm_materia_prima     
    end  as 'MateriaPrima',    
    tpp.nm_tipo_produto_projeto   as 'TipoProduto',    
    pm.nm_marca_material          as 'Marca',    
    case when isnull(pm.cd_fornecedor,0)>0 then    
          ( select nm_fantasia_fornecedor from Fornecedor where pm.cd_fornecedor = cd_fornecedor )    
         else    
           @nm_fantasia_fornecedor     
    end as 'Fornecedor',     
    pm.nm_obs_projeto_material         as 'Observacao',    
    pm.dt_liberacao_material           as 'DataLiberacao',    
    pm.cd_requisicao_compra            as 'RequisicaoCompra',    
    pm.cd_item_requisicao_compra       as 'ItemRC',    
    pm.cd_requisicao_interna           as 'RequisicaoInterna',    
    pm.cd_item_req_interna             as 'ItemRI',    
    
    case when isnull(pm.cd_processo,0)>0     
         then pm.cd_processo    
         else    
         ( select top 1 isnull(pf.cd_processo,0) from processo_producao pf    
                                       where pf.cd_projeto          = p.cd_projeto and    
                                             pf.cd_item_projeto     = pc.cd_item_projeto and    
                                             pf.cd_projeto_material = pm.cd_projeto_material order by pf.cd_processo desc )    
     
                                end    as 'Processo',    
    
    pm.nm_desenho_material             as 'Desenho',    
    pm.ic_reposicao_material,    
    pjlib.nm_fantasia_projetista       as 'ProjetistaLib',    
    pro.nm_fantasia_produto            as 'FantasiaProduto'    
  from    
   Projeto_Composicao_Material pm      with (nolock) 
     LEFT OUTER JOIN    
   Projeto_Composicao pc    
     on pm.cd_projeto = pc.cd_projeto and pm.cd_item_projeto = pc.cd_item_projeto    
     left outer join    
 Projeto p     
     on pm.cd_projeto = p.cd_projeto    
     left outer join    
   Tipo_Produto_Projeto tpp    
     on pm.cd_tipo_produto_projeto = tpp.cd_tipo_produto_projeto    
     left outer join    
   Tipo_Projeto tp    
     on pc.cd_tipo_projeto = tp.cd_tipo_projeto    
     left outer join    
   Projetista pjlib    
     on pm.cd_projetista_liberacao = pjlib.cd_projetista    
   left outer join Produto pro on pro.cd_produto = pm.cd_produto    
    
--select * from projeto_composicao_material    
    
  where    
    p.cd_projeto       = pm.cd_projeto and       
    pm.cd_projeto      = case when @cd_projeto = 0 then pm.cd_projeto else @cd_projeto end and    
    pm.cd_item_projeto = case when @cd_item_projeto = 0 then pm.cd_item_projeto else @cd_item_projeto end   
  order by    
    pm.cd_projeto_material    
end    
    
if @cd_parametro = 2 --Consulta das Listas de Materiais Liberadas    
begin    
    
  select    
    pm.dt_liberacao_material        as 'DataLiberacao',    
    pjlib.nm_fantasia_projetista    as 'ProjetistaLib',    
    p.cd_interno_projeto            as 'Projeto',      
    tp.nm_tipo_projeto              as 'TipoProjeto',    
    pm.cd_item_projeto              as 'ItemProjeto',    
    pm.cd_projeto_material          as 'ItemLista',    
    pm.qt_projeto_material          as 'Quantidade',    
    case when isnull(pm.cd_produto,0)>0 then     
          ( select nm_produto from Produto where pm.cd_produto = cd_produto )    
         else    
            pm.nm_esp_projeto_material     
    end as 'Produto',    
    case when isnull(pm.cd_materia_prima,0)>0 then    
          ( select nm_mat_prima from Materia_Prima where pm.cd_materia_prima = cd_materia_prima )    
         else    
           @nm_materia_prima     
    end  as 'MateriaPrima',    
    tpp.nm_tipo_produto_projeto   as 'TipoProduto',    
    pm.nm_marca_material          as 'Marca',    
    case when isnull(pm.cd_fornecedor,0)>0 then    
          ( select nm_fantasia_fornecedor from Fornecedor where pm.cd_fornecedor = cd_fornecedor )    
         else    
           @nm_fantasia_fornecedor     
    end                                as 'Fornecedor',     
    
    pm.nm_obs_projeto_material         as 'Observacao',    
    pm.cd_requisicao_compra            as 'RequisicaoCompra',    
    pm.cd_item_requisicao_compra       as 'ItemRC',    
    pm.cd_requisicao_interna           as 'RequisicaoInterna',    
    pm.cd_item_req_interna             as 'ItemRI',    
    
    --Processo de Fabricao    
    
    case when isnull(pm.cd_processo,0)>0     
         then pm.cd_processo    
         else    
         ( select top 1 isnull(pf.cd_processo,0) from processo_producao pf    
                                       where pf.cd_projeto          = p.cd_projeto and    
                                             pf.cd_item_projeto     = pc.cd_item_projeto and    
                                             pf.cd_projeto_material = pm.cd_projeto_material order by pf.cd_processo desc )    
     
                                end    as 'Processo',    
    
    pm.ic_reposicao_material    
    
    
  from    
    Projeto p,      
    Projeto_Composicao pc,    
    Projeto_Composicao_Material pm,    
    Tipo_Produto_Projeto tpp,    
    Tipo_Projeto tp,    
    Projetista pjlib    
  where    
    p.cd_projeto               = pc.cd_projeto       and    
    pc.cd_tipo_projeto         = tp.cd_tipo_projeto  and    
    pc.dt_liberacao_item_projeto between @dt_inicial and @dt_final and    
    pc.cd_item_projeto         = pm.cd_item_projeto  and    
    pm.cd_tipo_produto_projeto = tpp.cd_tipo_produto_projeto and    
    pm.cd_projetista_liberacao = pjlib.cd_projetista    
  order by    
    pc.dt_liberacao_item_projeto desc,    
    pm.cd_projeto_material    
end    

