
-------------------------------------------------------------------------------
--pr_geracao_adicional_pedido_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure  Microsoft SQL Server 2000
--Autor(es)         Márcio Rodrigues
--Banco de Dados    Egissql
--Objetivo          
--Data              19.12.2006
--Alteração         
------------------------------------------------------------------------------
create procedure pr_geracao_adicional_pedido_venda
	@ic_parametro     int,
	@cd_consulta      int = 0,
	@cd_item_consulta int = 0,
   @cd_pedido_venda  int = 0,
	@cd_cliente       int = 0
as

-- Cria a tabela para cópia do registro
if @ic_parametro = 1 
begin
    declare @cd_item_pedido_venda int
    Select 
       dt_item_pedido_venda    	=	c.dt_fechamento_consulta,
       qt_item_pedido_venda     	=	c.qt_item_consulta,
       qt_saldo_pedido_venda    	=	c.qt_item_consulta,
       cd_usuario_lib_desconto  	=	c.cd_usuario_lib_desconto,
       dt_desconto_item_pedido 	=	c.dt_desconto_item_consulta,
       vl_custo_financ_item      =	c.vl_custo_financ_item,
       vl_indice_item_pedido     =	c.vl_indice_item_consulta,
       cd_moeda_cotacao				=	c.cd_moeda_cotacao,
       dt_moeda_cotacao				=	c.dt_moeda_cotacao,
       vl_moeda_cotacao				=	c.vl_moeda_cotacao,
       vl_unitario_item_pedido  	=	c.vl_unitario_item_consulta,
       vl_lista_item_pedido     	=	c.vl_lista_item_consulta,
       pc_desconto_item_pedido  	=	c.pc_desconto_item_consulta,
       cd_pdcompra_item_pedido 	=	c.cd_pedido_compra_consulta,
       qt_liquido_item_pedido   	=	c.qt_peso_liquido,
       qt_bruto_item_pedido     	=	c.qt_peso_bruto,
       ic_montagem_g_item_pedido =	c.ic_montagem_g_consulta,
       cd_tipo_montagem       	=	c.cd_tipo_montagem,
       cd_montagem           	 	=	c.cd_montagem,
       ic_subs_tributaria_item 	=	c.ic_subs_tributaria_cons,
       cd_posicao_item_pedido  	=	c.cd_posicao_consulta,
       cd_os_tipo_pedido_venda 	=	c.cd_os_consulta,
       cd_consulta            	=	c.cd_consulta,
       cd_item_consulta        	=	c.cd_item_consulta,
       dt_fechamento_pedido  		=	Null,
       ic_desconto_item_pedido 	=	c.ic_desconto_consulta_item,
       ic_fatura_item_pedido   	=  'N',
       ic_pedido_venda_item    	=	c.ic_consulta_item, 
       ic_progfat_item_pedido  	=  'N',
       qt_progfat_item_pedido 		=  0,
       nm_kardex_item_ped_venda 	=	c.nm_kardex_item_consulta,
       ic_orcamento_pedido_venda	=	c.ic_orcamento_consulta,
       ic_mp66_item_pedido      	=	c.ic_mp66_item_consulta,
       ic_montagem_item_pedido  	=	c.ic_montagem_item_consulta,
       cd_unidade_medida       	=	c.cd_unidade_medida,
       vl_frete_item_pedido      	=	c.vl_frete_item_consulta ,
            cd_produto 						=	c.cd_produto,
       nm_produto_pedido   			=	c.nm_produto_consulta,
       pc_ipi               		=	c.pc_ipi,
       pc_icms              		=	c.pc_icms,
       pc_reducao_icms      		=	c.pc_reducao_icms,
       nm_fantasia_produto 			=	c.nm_fantasia_produto,
       cd_serie_produto   			=	c.cd_serie_produto,
       cd_grupo_produto   			=	c.cd_grupo_produto,
       cd_grupo_categoria     		=	c.cd_grupo_categoria,
       qt_dia_entrega_pedido    	=	c.qt_dia_entrega_consulta,
       ic_reserva_item_pedido  	=  'N',
       ic_kit_grupo_produto    	=	c.ic_kit_grupo_produto,
       cd_lote_item_pedido			=	c.cd_lote_item_consulta,
       cd_produto_concorrente		=	c.cd_produto_concorrente,
            ic_controle_pcp_pedido 		= case isnull(c.cd_produto,0) when 0 then gp.ic_controle_pcp_grupo else IsNull(p.ic_controle_pcp_produto, gp.ic_controle_pcp_grupo) end,
            ic_controle_mapa_pedido		= case isnull(c.cd_produto,0) 
                                                                                            when 0 then  
                                                                                                    (case isnull(c.cd_produto,0) 
                                                                                                            when 0 then 
                                                                                                                    gp.ic_controle_pcp_grupo
                                                                                                            else 
                                                                                                                    IsNull(p.ic_controle_pcp_produto, gp.ic_controle_pcp_grupo) 
                                                                                                            end) 
                                                                                            else 
                                                                                                    Isnull(pp.ic_controle_mapa_produto, IsNull(p.ic_controle_pcp_produto, gp.ic_controle_pcp_grupo)) 
                                                                                            end,
       cd_categoria_produto 		=	isnull(p.cd_categoria_produto, pe.cd_categoria_produto),
       cd_servico						= 	c.cd_servico,
       ds_produto_pedido_venda	= 	c.ds_produto_consulta,
       ds_observacao_fabrica		= 	c.ds_observacao_fabrica,
       ic_sel_fechamento			= 	'N',
       cd_om 							=	isnull(c.cd_om,0),
       cd_desenho_item_pedido		= 	c.cd_desenho_item_consulta,
            cd_rev_des_item_pedido		= 	c.cd_rev_des_item_consulta,
       qt_area_produto				= 	c.qt_area_produto,
       dt_entrega_vendas_pedido	=  dt_entrega_consulta,
            ic_produto_especial 			=  ic_produto_especial

    Into #Pedido_Venda_Item
    --Drop Table Pedido_Venda_Item
    From 	Consulta_Itens c left join
                    Produto p        on (c.cd_produto = p.cd_produto) left join
                    Grupo_Produto gp on (gp.cd_grupo_produto = p.cd_grupo_produto) left join
                    Produto_PCP pp   on (pp.cd_produto = p.cd_produto) left join
               Produto_Exportacao pe on (pe.cd_produto = p.cd_produto)
    where 
          c.cd_consulta = @cd_consulta and 
          c.cd_item_consulta = @cd_item_consulta
            

    order by cd_consulta desc

    -- Select * from #Pedido_Venda_Item

   
/*
	--CASO PRECISE DE UPDATE USAR NESTE TRECHO
	Update #Pedido_Venda_Item set	

*/

  
    --Pega o Código do Pedido Venda Item
    --Insere o Item
    Set @cd_item_pedido_venda = (Select Isnull(Max(cd_item_pedido_venda),0) +1 from Pedido_Venda_Item where cd_pedido_venda = @cd_pedido_venda)
    Insert into  Pedido_Venda_Item
       (cd_item_pedido_venda,
            cd_pedido_venda,
       dt_item_pedido_venda,
       qt_item_pedido_venda,
       qt_saldo_pedido_venda,
       cd_usuario_lib_desconto,
       dt_desconto_item_pedido,
       vl_custo_financ_item,
       vl_indice_item_pedido,
       cd_moeda_cotacao,
       dt_moeda_cotacao,
       vl_moeda_cotacao,
       vl_unitario_item_pedido,
       vl_lista_item_pedido,
       pc_desconto_item_pedido,
       cd_pdcompra_item_pedido,
       qt_liquido_item_pedido,
       qt_bruto_item_pedido,
       ic_montagem_g_item_pedido,
       cd_tipo_montagem,
       cd_montagem,
       ic_subs_tributaria_item,
       cd_posicao_item_pedido,
       cd_os_tipo_pedido_venda,
       cd_consulta,
       cd_item_consulta,
       dt_fechamento_pedido,
       ic_desconto_item_pedido,
       ic_fatura_item_pedido,
       ic_pedido_venda_item,
       ic_progfat_item_pedido,
       qt_progfat_item_pedido,
       nm_kardex_item_ped_venda,
       ic_orcamento_pedido_venda,
       ic_mp66_item_pedido,
       ic_montagem_item_pedido,
       cd_unidade_medida,
       vl_frete_item_pedido,
       cd_produto,
       nm_produto_pedido,
       pc_ipi,
       pc_icms,
       pc_reducao_icms,
       nm_fantasia_produto,
       cd_serie_produto,
       cd_grupo_produto,
       cd_grupo_categoria,
       qt_dia_entrega_pedido,
       ic_reserva_item_pedido,
       ic_kit_grupo_produto,
       cd_lote_item_pedido,
       cd_produto_concorrente,
       ic_controle_pcp_pedido,
       ic_controle_mapa_pedido,
       cd_categoria_produto,
       cd_servico,
       ds_produto_pedido_venda,
       ds_observacao_fabrica,
       ic_sel_fechamento,
       cd_om,
       cd_desenho_item_pedido,
       cd_rev_des_item_pedido,
       qt_area_produto,
       dt_entrega_vendas_pedido,
       ic_produto_especial)
       (Select @cd_item_pedido_venda, @cd_pedido_venda,* from #Pedido_Venda_Item)


--Atualiza o Item da Proposta

UpDate Consulta_Itens set
	cd_item_pedido_venda     = @cd_item_pedido_venda,
	cd_pedido_venda          = @cd_pedido_venda,
	ic_item_perda_consulta   = 'N',
   ic_sel_fechamento        = 'N',
   dt_fechamento_consulta   = getDate()
where 
	cd_consulta = @cd_consulta and 
   cd_item_consulta = @cd_item_consulta


end	
else if @ic_parametro = 2
begin
	--AQUI É PARA LISTAR OS PEDIDOS PARA SEREM EXIBIDOS
	Select cd_pedido_venda, dt_pedido_venda , c.nm_fantasia_cliente, c.cd_cliente
	from 	Pedido_Venda pv left join
			Cliente		 c on (pv.cd_cliente = c.cd_cliente) 
   where 
--			isNull(ic_fechamento_total, 'N') = 'N' and
--			dt_cancelamento_pedido is null and
         pv.cd_cliente = @cd_cliente
	order by dt_pedido_venda desc
end
else if @ic_parametro = 3
begin
		-- AQUI ALTERA O PEDIDO DE VENDA
		update  Pedido_venda set
		dt_fechamento_pedido = Null,
		ic_fechamento_total    = 'N',
      ic_fat_total_pedido_venda = Null,
      ic_fat_pedido_venda       = Null
		where cd_pedido_venda = @cd_pedido_venda
end

/*
	PROCEDIMENTOS A EXECUTAR
*/



