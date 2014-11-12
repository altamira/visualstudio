
CREATE PROCEDURE pr_consulta_produto_ordem_producao
---------------------------------------------------------------
--pr_consulta_produto_ordem_producao
---------------------------------------------------------------
--GBS - Global Business Solution Ltda                      2004
---------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Daniel Carrasco
--Banco de Dados       : EgisSQL
--Objetivo             : Consulta de Ordem de Produção por Produto.
--Data                 : 28/04/2004
--Atualização          : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 30.08.2007 - Complemento das Informações 
---------------------------------------------------------------------------

@ic_parametro        int,
@nm_fantasia_produto varchar(30),
@dt_inicial          datetime,
@dt_final            datetime

AS

--select * from processo_producao
--select * from projeto
--select * from projeto_composicao
--select * from projeto_composicao_material

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Produto por Nome Fantasia
-------------------------------------------------------------------------------
  begin
    select 
      pp.cd_processo, 
      pp.dt_processo, 
      pp.ic_libprog_processo,
      pp.cd_identifica_processo, 
      pp.dt_inicio_processo, 
      pp.dt_fimprod_processo, 
      pp.qt_planejada_processo,
      cast(pp.ds_processo as varchar(2000)) as ds_processo, 
      sp.nm_status_processo, 
      dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto, 
      p.nm_fantasia_produto, 
      p.nm_produto,
      cast(GetDate() as integer) - cast(pp.dt_inicio_processo as integer) as 'Dias',
      us.nm_fantasia_usuario,
      pj.cd_interno_projeto,
      pjc.nm_projeto_composicao,
      pjm.nm_esp_projeto_material,
      pp.cd_pedido_venda,
      pp.cd_item_pedido_venda,
      fp.nm_fase_produto
    FROM         
      Processo_Producao pp with (nolock)
      left outer join Produto p                with (nolock)        ON pp.cd_produto           = p.cd_produto 
      left outer join Status_Processo sp       with (nolock)        ON pp.cd_status_processo   = sp.cd_status_processo 
      left outer join EgisAdmin.dbo.Usuario us with (nolock)        on us.cd_usuario           = pp.cd_usuario
      left outer join Projeto         pj       with (nolock)        on pj.cd_projeto           = pp.cd_projeto
      left outer join Projeto_Composicao pjc   with (nolock)        on pjc.cd_projeto          = pp.cd_projeto and
                                                                       pjc.cd_item_projeto     = pp.cd_item_projeto    
      left outer join Projeto_Composicao_Material pjm with (nolock) on pjm.cd_projeto          = pp.cd_projeto and
                                                                       pjm.cd_item_projeto     = pp.cd_item_projeto and
                                                                       pjm.cd_projeto_material = pp.cd_projeto_material
      left outer join Fase_Produto fp          with (nolock)        on fp.cd_fase_produto      = pp.cd_fase_produto
    where 
      (IsNUll(p.nm_fantasia_produto,'') like @nm_fantasia_produto + '%') and
      pp.dt_processo between @dt_inicial and @dt_final and
      pp.dt_canc_processo is null
    order by 
      pp.dt_processo desc

  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Produto por Máscara
-------------------------------------------------------------------------------
  begin

   declare @Mascara_Limpa varchar(30)

    set @Mascara_Limpa = Replace(@nm_fantasia_produto,'.','')
    set @Mascara_Limpa = Replace(@Mascara_Limpa,'-','')

    print(@Mascara_Limpa)


    select 
      pp.cd_processo, 
      pp.dt_processo, 
      pp.ic_libprog_processo,
      pp.cd_identifica_processo, 
      pp.dt_inicio_processo, 
      pp.dt_fimprod_processo, 
      pp.qt_planejada_processo,
      cast(pp.ds_processo as varchar(2000)) as ds_processo, 
      sp.nm_status_processo, 
      dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto, 
      p.nm_fantasia_produto, 
      p.nm_produto,
      cast(GetDate() as integer) - cast(pp.dt_inicio_processo as integer) as 'Dias',
      us.nm_fantasia_usuario,
      pj.cd_interno_projeto,
      pjc.nm_projeto_composicao,
      pjm.nm_esp_projeto_material,
      pp.cd_pedido_venda,
      pp.cd_item_pedido_venda,
      fp.nm_fase_produto

    FROM         
      Processo_Producao pp                     with (nolock)
      left outer join Produto p                with (nolock) ON pp.cd_produto = p.cd_produto
      left outer join Status_Processo sp       with (nolock) ON pp.cd_status_processo = sp.cd_status_processo 
      left outer join EgisAdmin.dbo.Usuario us with (nolock) on us.cd_usuario = pp.cd_usuario
      left outer join Projeto         pj       with (nolock)        on pj.cd_projeto           = pp.cd_projeto
      left outer join Projeto_Composicao pjc   with (nolock)        on pjc.cd_projeto          = pp.cd_projeto and
                                                                       pjc.cd_item_projeto     = pp.cd_item_projeto    
      left outer join Projeto_Composicao_Material pjm with (nolock) on pjm.cd_projeto          = pp.cd_projeto and
                                                                       pjm.cd_item_projeto     = pp.cd_item_projeto and
                                                                       pjm.cd_projeto_material = pp.cd_projeto_material
      left outer join Fase_Produto fp          with (nolock)        on fp.cd_fase_produto      = pp.cd_fase_produto

    where 
      (IsNull(p.cd_mascara_produto,'') like @Mascara_Limpa + '%') and
      pp.dt_processo between @dt_inicial and @dt_final and
      pp.dt_canc_processo is null

    order by 
      pp.dt_processo desc

  end

  
