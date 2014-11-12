
CREATE PROCEDURE pr_consulta_ordem_producao_requisicao
-------------------------------------------------------------------  
--pr_consulta_ordem_producao_requisicao
-------------------------------------------------------------------  
--sp_helptext pr_consulta_ordem_producao_requisicao
-------------------------------------------------------------------  
--GBS - Global Business Solution Ltda                          2008
-------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EGISSQL  
--Objetivo         : Consulta das Ordens de Produção/Processo
--                   para geração de requisição interna
--
--Data             : 09.12.2008
--
-- Atualização : 31.08.2010 - Desenho e Tipo de Produto - Carlos Fernandes 
----------------------------------------------------------------------------------------------------------------------  
@cd_processo        int      = 0,
@dt_inicial         datetime = '',
@dt_final           datetime = '',
@ic_selecao         char(1)  = ''

AS  

 declare @cd_fase_produto int

 select
   @cd_fase_produto = isnull(cd_fase_produto,0)
 from 
   parametro_comercial   with (nolock) 
 where 
   cd_empresa = dbo.fn_empresa()
  
 select       
   0                                            as ic_selecionado, --0 (Zero) não selecionado 1 selecionado  
   identity(int,1,1)                            as 'Index',
   pp.cd_processo,
   ppc.cd_componente_processo,
   ppc.cd_seq_comp_processo,

   case when isnull(ppr.qt_comp_processo,0)<>0 then
      ppr.qt_comp_processo                        
   else
      ppc.qt_comp_processo                        
   end                                          as qt_requisicao,   

   pc.qt_item_projeto,  


--   pcm.nm_desenho_material                      as 'nm_item_desenho_projeto',  

   case when isnull(pcm.nm_desenho_material,'')<>'' then -- is not null then
      pcm.nm_desenho_material
   else
     --select * from produto
     rtrim(ltrim(pr.cd_desenho_produto))
     +
     case when pr.cd_rev_desenho_produto is not null and isnull(pr.cd_rev_desenho_produto,'')<> '' then
        'Rev: '+pr.cd_rev_desenho_produto
     else
       ''
     end
   end                                               as 'nm_item_desenho_projeto',  




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
   ppc.cd_mat_prima                             as cd_materia_prima,  
   pr.qt_peso_liquido,  
   pr.qt_peso_bruto,   
   pcm.nm_esp_projeto_material,   
   pcm.qt_projeto_material,   

   --Buscando saldo do produto  

   isnull((select ps.qt_saldo_atual_produto   
    from produto_saldo ps  with (nolock) 
    where ps.cd_produto      = pr.cd_produto and   
          ps.cd_fase_produto = case when isnull(pr.cd_fase_produto_baixa,0)>0 
                                    then pr.cd_fase_produto_baixa
                                    else @cd_fase_produto                                       
                                    end ),0) as qt_saldo_atual_produto,  

   isnull((select qt_saldo_reserva_produto  
    from produto_saldo with (nolock)   
    where cd_produto       = pr.cd_produto and   
           cd_fase_produto = case when isnull(pr.cd_fase_produto_baixa,0)>0 
                                    then pr.cd_fase_produto_baixa
                                    else @cd_fase_produto                                       
                                    end ),0) as qt_saldo_reserva,   
   mp.nm_mat_prima,   

   case when isnull(ppr.cd_unidade_medida,0)<>0 then
      ppr.cd_unidade_medida
   else
     ppc.cd_unidade_medida
   end                                       as cd_unidade_medida,  

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

   case when isnull(pc.nm_item_desenho_projeto,'')<>'' then -- is not null then
      pc.nm_item_desenho_projeto          
   else
     --select * from produto
     rtrim(ltrim(pr.cd_desenho_produto))
     +
     case when pr.cd_rev_desenho_produto is not null and isnull(pr.cd_rev_desenho_produto,'')<> '' then
        'Rev: '+pr.cd_rev_desenho_produto
     else
       ''
     end
   end                                               as 'nm_detalhe',  

   isnull(pcm.ic_compra_prod_material,'S')           as 'NaoCompra',

   p.cd_pedido_venda, 
   p.cd_item_pedido_venda,
   pcm.cd_requisicao_compra,
   pcm.cd_item_requisicao_compra,


   --Tipo do Produto 

   case when tpp.nm_tipo_produto_projeto is not null then
      tpp.nm_tipo_produto_projeto
   else
      tpr.nm_tipo_produto_projeto
      
   end                                                    as nm_tipo_produto_projeto,

   isnull(p.dt_entrada_projeto,pp.dt_processo)            as dt_entrada_projeto,
   cl.nm_fantasia_cliente,
   isnull(p.cd_centro_custo,0)                            as cd_centro_custo,
   cc.nm_centro_custo,

   --Fase do Produto
  
   fp.cd_fase_produto,
   fp.nm_fase_produto,
  
   ppc.cd_requisicao_interna,

   ppc.cd_item_req_interna,

   case when isnull(ppr.nm_obs_comp_processo,'')<>'' then
     ppr.nm_obs_comp_processo
   else
     ppc.nm_obs_comp_processo
   end                                                   as nm_obs_comp_processo

 Into 
   #Lista

 from 
   --select * from processo_producao_componente  
   processo_producao_componente ppc       with (nolock) 
   inner join processo_producao pp        with (nolock) on pp.cd_processo              = ppc.cd_processo 
   left outer join processo_producao_componente_real ppr
                                          with (nolock) on ppr.cd_processo             = ppc.cd_processo           and
                                                           ppr.cd_componente_processo  = ppc.cd_componente_processo

   left outer join produto pr             with (nolock) on pr.cd_produto               = 
                                                           case when isnull(ppr.cd_produto,0)<>0 then
                                                              ppr.cd_produto 
                                                           else
                                                              ppc.cd_produto 
                                                           end

   

   left outer join Produto_Processo     ppx with (nolock ) on ppx.cd_produto              = pr.cd_produto 
                                                            --and pp.cd_fase_produto         = ps.cd_fase_produto

   left outer join Tipo_Produto_Projeto tpr with (nolock ) on tpr.cd_tipo_produto_projeto = ppx.cd_tipo_produto_projeto

   left outer join unidade_medida um      with (nolock) on um.cd_unidade_medida        = ppc.cd_unidade_medida 
   left outer join materia_prima mp       with (nolock) on mp.cd_mat_prima             = ppc.cd_mat_prima
   left outer join projeto p              with (nolock) on p.cd_projeto                = pp.cd_projeto  
   left outer join projeto_composicao pc  with (nolock) on pc.cd_projeto               = pp.cd_projeto          and 
                                                           pc.cd_item_projeto          = pp.cd_item_projeto 
   left outer join projeto_composicao_material pcm
                                          with (nolock) on pcm.cd_projeto              = pp.cd_projeto          and
                                                           pcm.cd_item_projeto         = pp.cd_item_projeto     and
                                                           pcm.cd_projeto_material     = pp.cd_projeto_material

   left outer join tipo_produto_projeto tpp with (nolock) on pcm.cd_tipo_produto_projeto = tpp.cd_tipo_produto_projeto
   left outer join Grupo_Produto gp       with (nolock) on pr.cd_grupo_produto         = gp.cd_grupo_produto
   left outer join pedido_venda pv        with (nolock) on pp.cd_pedido_venda          = pv.cd_pedido_venda 
   left outer join Cliente cl             with (nolock) on isnull(pv.cd_cliente,
                                                                  pp.cd_cliente)       = cl.cd_cliente 

   left outer join Centro_Custo cc        with (nolock) on cc.cd_centro_custo          = p.cd_centro_custo
   left outer join Fase_Produto fp        with (nolock) on fp.cd_fase_produto          = 
                                                           case when isnull(ppr.cd_fase_produto,0)<>0 then
                                                             ppr.cd_fase_produto
                                                           else
                                                             case when isnull(ppc.cd_fase_produto,0)=0 then
                                                                case when isnull(pr.cd_fase_produto_baixa,0)>0 
                                                                then
                                                                  pr.cd_fase_produto_baixa else @cd_fase_produto end
                                                             else
                                                                ppc.cd_fase_produto 
                                                             end
                                                           end


 where       
    pp.cd_processo = case when @cd_processo = 0 then pp.cd_processo else @cd_processo end and
    pp.dt_processo between ( case when @cd_processo = 0 then @dt_inicial else pp.dt_processo end ) and
                           ( case when @cd_processo = 0 then @dt_final   else pp.dt_processo end ) and
    isnull(ppc.cd_requisicao_interna,0) = 0    and  
    pp.dt_canc_processo    is null and
    pp.dt_fimprod_processo is null and
    pp.cd_status_processo  <= 4

 order by  
   pp.cd_processo


  Select * from #Lista
  order by
    cd_processo,
    cd_componente_processo   


