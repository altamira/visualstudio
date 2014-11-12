
CREATE PROCEDURE pr_consulta_lista_material  
-------------------------------------------------------------------  
--pr_consulta_lista_material  
-------------------------------------------------------------------  
--GBS - Global Business Solution Ltda                          2004  
-------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Johnny Mendes de Souza  
--Banco de Dados   : SGE -> EGISSQL  
--Objetivo         : Consulta da Lista de Material
--Data             : 29/11/2002  
--Alteração        : Daniel C. Neto.  
--Desc. Alteração  : Colocado mais um filtro para Requisição Interna.  
--                 : 22/07/2004 - Acerto do filtro que não trazia nada quando 0 - ELIAS  
--                 : 18/10/2004 - Acerto para trazer todos os registros quando parametro = - 1 - Daniel C. Neto.  
--                 : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso  
--                 : 29/01/2005 - Colocado flag para identificar que o Produto não será comprado  
--                 : 24/03/2006 - Incluido PV + Item na seleção : Lucio
--                 : 27/03/2006 - Alterado nome fantasia produto para nm_esp, se o produto for especial : Lucio
--                 : 16.04.2006 - Revisão - Carlos Fernandes
--                                Caso já foi gerado as requisições não mostra os dados na consulta
--                 : 16.12.2006 - Centro de Custo
-- 12.02.2008 - Verificação da Requisição Interna - Carlos Fernandes
-- 03.03.2008 - Acerto do flag de não compra quando estiver Nulo - Carlos Fernandes
-- 10.11.2010 - Status da RI - Carlos Fernandes
----------------------------------------------------------------------------------------------------------------------  
@cd_interno_projeto char(15) = '',  
@cd_item_projeto    int      = 0  ,
@dt_inicial         Datetime,
@dt_final           Datetime,
@ic_selecao         char(1)

AS  
  
 select       
   0                                            as ic_selecionado, --0 (Zero) não selecionado 1 selecionado  
   identity(int,1,1)                            as 'Index',
   pcm.qt_projeto_material * pc.qt_item_projeto as qt_requisicao,   
   pc.qt_item_projeto,  
   pcm.nm_desenho_material                      as 'nm_item_desenho_projeto',  
   pcm.cd_projeto,   
   p.cd_interno_projeto,   
   pcm.cd_item_projeto,   
   pc.nm_projeto_composicao,   
   pcm.cd_projeto_material,   
   pr.cd_produto,  
   pr.nm_fantasia_produto,   
   pr.nm_produto,  
   pr.cd_mascara_produto,  
   pr.cd_categoria_produto,  
   pcm.cd_materia_prima,  
   pr.qt_peso_liquido,  
   pr.qt_peso_bruto,   
   pcm.nm_esp_projeto_material,   
   pcm.qt_projeto_material,   

   --Buscando saldo do produto  

   (select qt_saldo_atual_produto   
    from produto_saldo   
    where cd_produto = pr.cd_produto and   
           cd_fase_produto in (select cd_fase_produto   
                               from parametro_comercial   
                               where cd_empresa = dbo.fn_empresa())) as qt_saldo_atual_produto,  
   (select qt_saldo_reserva_produto  
    from produto_saldo   
    where cd_produto = pr.cd_produto and   
           cd_fase_produto in (select cd_fase_produto   
                               from parametro_comercial   
                               where cd_empresa = dbo.fn_empresa())) as qt_saldo_reserva,   
   mp.nm_mat_prima,   
   pcm.cd_unidade_medida,  
   um.sg_unidade_medida,  
   um.nm_unidade_medida,   
   pcm.nm_fornec_prod_projeto,  
   pcm.nm_obs_projeto_material,  
   pcm.ds_projeto_material,  
   pcm.nm_marca_material,  
   pr.cd_plano_compra,  
   pr.cd_plano_financeiro,  
   gp.cd_plano_compra                                as cd_plano_compra_gp,  
   gp.cd_plano_financeiro                            as cd_plano_financeiro_gp,  
   pc.nm_item_desenho_projeto                        as 'nm_detalhe',  
   isnull(pcm.ic_compra_prod_material,'S')           as 'NaoCompra',
   p.cd_pedido_venda, 
   p.cd_item_pedido_venda,
   pcm.cd_requisicao_compra,
   pcm.cd_item_requisicao_compra,
   tpp.nm_tipo_produto_projeto,
   p.dt_entrada_projeto,
   cl.nm_fantasia_cliente,
   isnull(p.cd_centro_custo,0)                       as cd_centro_custo,
   cc.nm_centro_custo,
   pcm.cd_requisicao_interna,
   pcm.cd_item_req_interna,
   sr.nm_status_requisicao

 into 
   #Lista

 from 
      projeto_composicao_material pcm         with (nolock) 
 left outer join tipo_produto_projeto tpp     with (nolock) on pcm.cd_tipo_produto_projeto = tpp.cd_tipo_produto_projeto
 left outer join unidade_medida um            with (nolock) on pcm.cd_unidade_medida = um.cd_unidade_medida 
 left outer join materia_prima mp             with (nolock) on pcm.cd_materia_prima = mp.cd_mat_prima
 left outer join produto pr                   with (nolock) on pcm.cd_produto = pr.cd_produto 
 left outer join projeto p                    with (nolock) on pcm.cd_projeto = p.cd_projeto  
 left outer join projeto_composicao pc        with (nolock) on  pcm.cd_projeto = pc.cd_projeto and pcm.cd_item_projeto = pc.cd_item_projeto 
 left outer join Grupo_Produto gp             with (nolock) on pr.cd_grupo_produto = gp.cd_grupo_produto
 left outer join pedido_venda pv              with (nolock) on p.cd_pedido_venda = pv.cd_pedido_venda 
 left outer join Cliente cl                   with (nolock) on isnull(pv.cd_cliente,p.cd_cliente) = cl.cd_cliente 
 left outer join Centro_Custo cc              with (nolock) on cc.cd_centro_custo = p.cd_centro_custo
 left outer join Requisicao_Interna ri        with (nolock) on ri.cd_requisicao_interna = pcm.cd_requisicao_interna
 left outer join status_requisicao_interna sr with (nolock) on sr.cd_status_requisicao = ri.cd_status_requisicao

 where       
   (isnull(tpp.ic_requisicao_projeto,'N') = 'S' or
    isnull(tpp.ic_req_interna_projeto,'N') = 'S') and
    --antes 25.08.2007
--     (isnull(pcm.cd_requisicao_compra,0)  = 0 and              --Caso já foi gerado não mostra a requisição na consulta
--     isnull(pcm.cd_requisicao_interna,0) = 0 ) and  


    --25.08.2007 ( correto e nao mostrar mais apos a geracao da RI )
    isnull(pcm.cd_requisicao_interna,0) = 0  and  

    isnull(pcm.dt_liberacao_material,'') <> '' and  
    isnull(pcm.ic_ativo_material,'S') = 'S' and
    isnull(p.cd_interno_projeto, '')  = (case isnull(@cd_interno_projeto, '') when '' then isnull(p.cd_interno_projeto, '') else isnull(@cd_interno_projeto,'') end) and
    isnull(pcm.cd_item_projeto, 0)    = (case isnull(@cd_item_projeto, 0) when 0 then isnull(pc.cd_item_projeto, 0) else isnull(@cd_item_projeto, 0) end) and
    (p.dt_entrada_projeto between @dt_inicial and @dt_final) and
     pc.dt_liberacao_item_projeto is not null and

    (
     (@ic_selecao = 'A' and (select count(*) from projeto_composicao_material pcm
                             where pcm.cd_projeto = pc.cd_projeto and
                                   pcm.cd_item_projeto = pc.cd_item_projeto and
                                   isnull(cd_requisicao_interna,0) = 0) > 0) OR

     (@ic_selecao = 'T' and (select count(*) from projeto_composicao_material pcm
                             where pcm.cd_projeto = pc.cd_projeto and
                             pcm.cd_item_projeto = pc.cd_item_projeto) > 0)
     )

 order by  
   pc.nm_projeto_composicao,   
   pcm.cd_projeto_material  


  Select * from #Lista


