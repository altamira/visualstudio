
CREATE PROCEDURE pr_consulta_projeto_engenharia
-------------------------------------------------------------    
--pr_consulta_projeto_engenharia    
-------------------------------------------------------------    
--GBS - Global Business Solution Ltda                    2004    
-------------------------------------------------------------    
--Stored Procedure     : Microsoft SQL Server  2000    
--Autor(es)            : Carlos Cardoso Fernandes    
--Banco de Dados       : EgisSQL    
--Objetivo             : Consulta de Projetos     
--Data                 : 25/1/2003    
--Atualizado           : 09/12/2003 - Daniel C. Neto    
--                     : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso    
--                     : 30/01/2005 - Acertado a Ordem dos Projetos - Carlos    
--                     : 03.12.2005 - Filtro de Período - Carlos Fernandes    
--                     : 16.12.2006 - Centro de Custo - Carlos Fernandes
----------------------------------------------------------------------------    
@cd_interno_projeto varchar(40) = '',    
@dt_inicial         datetime,    
@dt_final           datetime    
as    
    
declare @ic_filtro_periodo_projeto char(1)     
    
select    
  @ic_filtro_periodo_projeto = isnull(ic_filtro_periodo_projeto,'N')    
from    
  Parametro_Projeto    
where    
  cd_empresa = dbo.fn_empresa()    
    
----------------------------------------------------------------------------    

if @ic_filtro_periodo_projeto='N'    
begin    
    
  select    
    
    --Status para Definicao da Legenda    
    
    case when dt_entrega_cliente < getdate()    then 'S' else 'N' end as 'Atraso',    
    case when dt_liberacao_item_projeto is null then 'N' else 'S' end as 'Liberado',    
    case when dt_fim_projeto is null            then 'N' else 'S' end as 'Finalizado',    
    
    c.nm_fantasia_cliente       as 'Cliente',    
    p.cd_interno_projeto        as 'Projeto',    
    p.cd_projeto,     
    p.dt_entrada_projeto        as 'Entrada',    
    p.dt_inicio_projeto         as 'Inicio',    
    p.dt_fim_projeto            as 'Fim',    
    p.dt_liberacao_item_projeto as 'Liberacao',    
    p.dt_entrega_cliente        as 'Entrega',    
    p.nm_projeto                as 'Descricao',    
    p.cd_pedido_venda           as 'Pedido',    
    p.cd_item_pedido_venda      as 'ItemPedido',    
    p.cd_consulta               as 'Proposta',    
    p.cd_item_consulta          as 'ItemProposta',   
    pj.nm_projetista            as 'ProjetistaLib',
    -- Lucio
    p.qt_peso_produto_projeto   as 'PesoProduto',
    sp.nm_status_projeto        as 'StatusProjeto',
    c.cd_vendedor               as 'Setor',
    m.sg_material_plastico      as 'SiglaMaterial',
    m.nm_material_plastico      as 'Material',
    p.nm_comp_material_plastico as 'Complemento',
    p.nm_produto_cliente        as 'ProdutoCliente',
    tp.nm_tipo_projeto          as 'TipoProjeto',
    DescricaoComponente =  
   (select top 1 substring(ds_projeto_material,1,200) as ds_projeto_material
    from projeto_composicao_material pcm
    where p.cd_projeto = pcm.cd_projeto and
          pcm.nm_esp_projeto_material like 'manif%'),
    cc.nm_centro_custo          as 'CentroCusto' 

  from Projeto p     

    inner join Cliente c                 on p.cd_cliente = c.cd_cliente    
    left outer join Projetista pj        on isnull(p.cd_projetista_liberacao,p.cd_projetista) = pj.cd_projetista
    left outer join Status_Projeto sp    on p.cd_status_projeto = sp.cd_status_projeto
    left outer join Material_Plastico m  on p.cd_material_plastico = m.cd_material_plastico
    left outer join Tipo_Projeto tp      on p.cd_tipo_projeto = tp.cd_tipo_projeto
    left outer join Centro_Custo cc      on cc.cd_centro_custo = p.cd_centro_custo
  where    
    p.cd_interno_projeto like '%' + @cd_interno_projeto or    
    (p.dt_entrada_projeto between @dt_inicial and @dt_final    
    and @cd_interno_projeto = '' )    
  order by    
   p.dt_entrada_projeto desc, p.cd_projeto desc    
    
end    
else    
begin    
    
  select    
    
    --Status para Definicao da Legenda    
    
    case when dt_entrega_cliente < getdate()    then 'S' else 'N' end as 'Atraso',    
    case when dt_liberacao_item_projeto is null then 'N' else 'S' end as 'Liberado',    
    case when dt_fim_projeto is null            then 'N' else 'S' end as 'Finalizado',    
    
    c.nm_fantasia_cliente       as 'Cliente',    
    p.cd_interno_projeto        as 'Projeto',    
    p.cd_projeto,     
    p.dt_entrada_projeto        as 'Entrada',    
    p.dt_inicio_projeto         as 'Inicio',    
    p.dt_fim_projeto            as 'Fim',    
    p.dt_liberacao_item_projeto as 'Liberacao',    
    p.dt_entrega_cliente        as 'Entrega',    
    p.nm_projeto                as 'Descricao',    
    p.cd_pedido_venda           as 'Pedido',    
    p.cd_item_pedido_venda      as 'ItemPedido',    
    p.cd_consulta               as 'Proposta',    
    p.cd_item_consulta          as 'ItemProposta',    
    pj.nm_projetista            as 'ProjetistaLib',
    -- Lucio
    p.qt_peso_produto_projeto   as 'PesoProduto',
    sp.nm_status_projeto        as 'StatusProjeto',
    c.cd_vendedor               as 'Setor',
    m.sg_material_plastico      as 'SiglaMaterial',
    m.nm_material_plastico      as 'Material',
    p.nm_comp_material_plastico as 'Complemento',
    p.nm_produto_cliente        as 'ProdutoCliente',
    tp.nm_tipo_projeto          as 'TipoProjeto',
    DescricaoComponente =  
   (select top 1 substring(ds_projeto_material,1,200) as ds_projeto_material
    from projeto_composicao_material pcm
    where p.cd_projeto = pcm.cd_projeto and
          pcm.nm_esp_projeto_material like 'manif%'),
    cc.nm_centro_custo          as 'CentroCusto' 
    
  from Projeto p     
    inner join Cliente c                  on p.cd_cliente = c.cd_cliente    
    left outer join Projetista pj         on isnull(p.cd_projetista_liberacao,p.cd_projetista) = pj.cd_projetista
    left outer join Status_Projeto sp     on p.cd_status_projeto = sp.cd_status_projeto
    left outer join Material_Plastico m   on p.cd_material_plastico = m.cd_material_plastico
    left outer join Tipo_Projeto tp       on p.cd_tipo_projeto = tp.cd_tipo_projeto
    left outer join Centro_Custo cc       on cc.cd_centro_custo = p.cd_centro_custo
  where    
--    p.cd_interno_projeto = case when @cd_interno_projeto = '' then p.cd_interno_projeto else @cd_interno_projeto end and    
--    p.dt_entrada_projeto between @dt_inicial and @dt_final  
-- Carlos/Wilder 11.04.2005  
    p.cd_interno_projeto like '%' + @cd_interno_projeto or    
    (p.dt_entrada_projeto between @dt_inicial and @dt_final    
    and @cd_interno_projeto = '' )    

  order by    
   p.dt_entrada_projeto desc, p.cd_projeto desc    
   
end    

