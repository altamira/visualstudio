
--pr_Consulta_pedido_Compra_geral
-------------------------------------------------------------------------------------------
-- GBS
-- Stored Procedure : SQL Server
-- Autor(es)        : Sandro Campos
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta de Pedido de Compra Geral
-- Data             : 03/06/2002	
-- Atualizado       : 08/09/2003 - Otimização do SQL
--                    - Inclusão do Relacionamento com Serviço
--                    - Daniel C. NEto.
--                    27/02/2004 - Inclusão de colunas de matéria-prima.
--                               - Daniel C. Neto.
--                    01/03/2004 - Trazer pedidos de compra individualmente
--                                 sem contar com o período - Daniel C. Neto.
--                    14.07.2006 - Foram adicionados 3 novos campos: Fase do produto,
--                                 Requisição de Compra e Item - Fabio Cesar
--                    20.07.2006 - O campo Materia Prima será preenchido com a matéria
--                                 prima do produto caso exista - Fabio Cesar
----------------------------------------------------------
CREATE PROCEDURE pr_Consulta_pedido_compra_geral
@ic_parametro     int,
@cd_status_pedido int,
@cd_pedido_compra int,
@dt_inicial       Datetime,
@dt_final         Datetime
as
    if @ic_parametro = 1
    begin 
        Select
            pc.cd_fornecedor                as 'CodFornecedor',
            f.nm_fantasia_fornecedor        as 'Fornecedor',
            pc.cd_pedido_compra             as 'Pedido',
            pc.dt_pedido_compra             as 'Emissao',
            pc.cd_comprador                 as 'CodComprador',  
            pc.cd_status_Pedido             as 'Status',  
            cp.nm_fantasia_comprador        as 'Comprador',
            pc.ds_cancel_Ped_compra         as 'MotivoCancelamento',
            pc.dt_cancel_Ped_compra         as 'DataCancelamento',
            pc.ds_Ativacao_Pedido_compra    as 'MotivoAtivacao',
            pc.dt_ativacao_Pedido_compra    as 'DataAtivacao',
            pc.cd_contato_fornecedor        as 'CodContato',
--            pv.cd_Centro_Custo            as 'CentroCusto',
            fc.nm_contato_fornecedor        as 'NomeContato',
            pc.vl_total_pedido_compra       as 'Valor',
            tp.ic_pedido_mat_prima

        from 
          Pedido_compra pc Left Join 
          Tipo_Pedido tp on tp.cd_tipo_pedido = pc.cd_tipo_pedido left join
          Comprador cp On pc.cd_comprador = cp.cd_comprador Left Join 
          Fornecedor f On pc.cd_fornecedor = f.cd_fornecedor Left Join 
          Fornecedor_Contato fc On (pc.cd_fornecedor = fc.cd_Fornecedor) and
                                   (pc.cd_Contato_Fornecedor = fc.cd_Contato_Fornecedor)
        where
             ( (pc.cd_pedido_compra = @cd_pedido_compra)  or
             ((pc.dt_pedido_Compra between @dt_inicial and 
                                         @dt_final) and
              (@cd_pedido_compra = 0) ) ) and
             (
              (IsNull(pc.cd_status_pedido,0) = @cd_status_pedido) or
              (@cd_status_pedido = 0)
             ) 
        order by pc.cd_pedido_compra
    end
    -----------------------------------------------------------------------------------------
    else 
    -----------------------------------------------------------------------------------------
    begin
        declare @cd_fase_produto int
        
        Select @cd_fase_produto = cd_fase_produto from Parametro_Suprimento where cd_empresa = dbo.fn_empresa()


        Select pci.cd_pedido_compra           as 'PedidoCompra',
               p.cd_produto                   as 'CodigoProduto',
               IsNull(pci.nm_fantasia_produto, s.nm_servico) as 'nm_fantasia_produto',
               'CodigoProdutoBaixa' =
                   case 
                       when p.cd_produto_baixa_estoque is null then
                            p.cd_produto
                       else p.cd_produto_baixa_estoque
                   end,
         
               CASE IsNull(p.ic_especial_produto,'N')
                 when 'S' then
                   ltrim(IsNull(cast(pci.ds_item_pedido_compra as varchar(40)), IsNull(pci.nm_produto, s.nm_servico)))
                 ELSE 
                   IsNull(IsNull(pci.nm_produto, s.nm_servico),cast(pci.ds_item_pedido_compra as varchar(40)))
               end as 'DescricaoProduto',
               pci.cd_item_pedido_compra       as 'Item',
               pci.qt_item_pedido_compra       as 'Qtde',
               pci.vl_item_unitario_ped_comp  as 'Unitario',
              (pci.qt_item_pedido_compra *
               pci.vl_item_unitario_ped_comp) as 'Compra',
               pci.pc_item_descto_Ped_compra   as 'PercDesconto',
               pci.qt_saldo_Item_ped_compra      as 'QtdeSaldo',
               pci.nm_item_motcanc_Ped_compr     as 'MotivoCancelamento',
               pci.dt_item_canc_ped_compra      as 'DataCancelamento',
               pci.nm_item_ativ_ped_compra     as 'MotivoAtivacao',
               pci.dt_Item_ativ_Ped_compra            as 'DataAtivacao',
               pci.dt_entrega_item_ped_compr    as 'Comercial',
               ProdCusto.ic_peps_produto       As 'Peps',   
               dbo.fn_mascara_produto(pci.cd_produto) as 'cd_mascara_produto',
               pci.nm_medbruta_mat_prima,
               pci.qt_item_pesbr_ped_compra,
               mp.sg_mat_prima,
               IsNull(pci.cd_requisicao_compra,0) as cd_requisicao_compra,
               IsNull(pci.cd_requisicao_compra_item,0) as cd_requisicao_compra_item,
               --Define a fase de estoque
               IsNull(tr.cd_fase_produto, @cd_fase_produto) as 'FaseProduto',
               0 as ic_selecionado 
        from 
          Pedido_compra_item pci with (nolock) Left Join 
          Pedido_compra pc with (nolock) On pc.cd_pedido_compra = pci.cd_pedido_compra Left Join 
          Produto P with (nolock) On P.cd_Produto = pci.cd_Produto Left Join 
          Produto_Custo ProdCusto with (nolock) On ProdCusto.cd_Produto = pci.cd_Produto left outer join 
          Servico s with (nolock) on s.cd_servico = pci.cd_servico left outer join
          Materia_Prima mp with (nolock) on mp.cd_mat_prima = (case IsNull(pci.cd_materia_prima,0)
                                                                 when 0 then p.cd_materia_prima
                                                                 else pci.cd_materia_prima end)  Left outer join
          Requisicao_Compra rc with (nolock) on rc.cd_requisicao_compra = pci.cd_requisicao_compra Left outer join
          Tipo_Requisicao tr with (nolock) on tr.cd_tipo_requisicao = rc.cd_tipo_requisicao            
        where
             (pci.cd_pedido_compra = @cd_pedido_compra and (@ic_parametro = 2) ) or
	     ( (pci.cd_pedido_compra = @cd_pedido_compra) and
               (pci.dt_item_canc_ped_compra is Null) and (@ic_parametro = 3) ) or
	     ( (pci.cd_pedido_compra = @cd_pedido_compra) and
               (pci.dt_item_canc_ped_compra is not Null) and 
               (@ic_parametro = 4) )

	order by pci.cd_item_pedido_compra
    end



