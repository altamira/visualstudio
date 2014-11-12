CREATE  PROCEDURE pr_consulta_declaracao_importacao
-------------------------------------------------------------------------------
--pr_consulta_declaracao_importacao
-------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                      2004
-------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Fabio Cesar
--Banco de Dados        : EgisSql
--Objetivo              : Consulta de DI
--Data                  : 07.10.2003
--Atualização           : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--18.02.2009 - Ajustes Diversos - Carlos Fernandes
--10.03.2009 - Verificação - Carlos Fernandes
-------------------------------------------------------------------------------
@cd_fornecedor    int = 0,
@nm_di            varchar(20) = '',
@dt_inicial       datetime,
@dt_final         datetime,
@ic_parametro     int = 1 --1-Apresenta somente as DI que não tem nota fiscal 
                          --2-Apresenta Todas as DI's
As

begin

declare  
	@cd_estado_empresa int

  --Define a data inicial
  if ( @dt_inicial is null )
     set @dt_inicial = getdate()

  --Define a data final  
  if ( @dt_final is null )
     set @dt_final = getdate()

  --Define o estado da empresa
  Select @cd_estado_empresa = cd_estado 
  from EgisAdmin.dbo.Empresa with (nolock)
  where cd_empresa = dbo.fn_empresa()  

--DI que não estão em nenhuma nota fiscal
if @ic_parametro = 1 
begin
	
  Select 
    0 ic_selecionado, --Informa se o item da DI foi selecionado
    dp.cd_destinacao_produto,
    dp.nm_destinacao_produto,
    cf.cd_mascara_classificacao,
    p.nm_fantasia_produto,
		idi.qt_efetiva_chegada,
		idi.vl_produto_moeda_destino,
--	  IsNull(idi.qt_efetiva_chegada,0) *  IsNull(idi.vl_produto_moeda_destino,0) as vl_total_produto_moeda_destino,    
	idi.vl_total_moeda_destino as vl_total_produto_moeda_destino,
	  idi.vl_total_moeda_destino as vl_total_produto_moeda_destino,    
		cast(di.cd_di as varchar) + '-' + cast(idi.cd_di_item as varchar) as cd_identificador,
		di.cd_di,
	  di.nm_di,
	  di.nm_fatcomercial,
	  di.cd_fornecedor,
		f.nm_fantasia_fornecedor,
		di.nm_bl_awb,
	  di.nm_h_bl_awb,
		di.dt_desembaraco,
		di.dt_fatura_comercial,
		idi.cd_di_item,
	  idi.cd_produto,
	  p.cd_mascara_produto,
	  p.cd_grupo_produto,
    p.cd_unidade_medida,
	  p.nm_produto,
	  pf.cd_procedencia_produto,
	  pf.cd_classificacao_fiscal,
    p.cd_categoria_produto,
    cast(p.ds_produto as varchar(2000)) as ds_produto,
    idi.qt_embarque,
    idi.vl_produto_moeda_origem,
		idi.pc_di_item_ii,
	  idi.cd_pedido_importacao,
		idi.cd_item_ped_imp,
    idi.vl_ii_item_di, 
	  di.cd_tipo_frete,
	  tf.nm_tipo_frete,
    tf.sg_tipo_frete,
    tf.ic_courier_importacao,
    tf.pc_importacao_tipo_frete,
    tf.ic_ipi_tipo_frete,
    tf.ic_pis_tipo_frete,
    tf.ic_cofins_tipo_frete,
    tf.ic_siscomex_tipo_frete,
    tf.ic_reducao_icms_tipo_frete,
--    cf.pc_ipi_classificacao,    
    idi.pc_di_item_ipi as pc_ipi_classificacao,
		p.qt_peso_liquido,
		p.qt_peso_bruto,
    (Select top 1 sg_moeda from moeda where cd_moeda = pimp.cd_moeda) as sg_moeda,
--    cfe.pc_icms_classif_fiscal,
--    cfe.pc_redu_icms_class_fiscal,
    idi.pc_di_item_icms as pc_icms_classif_fiscal,
    idi.vl_cfr_item_di as cfr,
    inv.nm_invoice,
    di.cd_moeda_di,
    di.dt_moeda_di,
    di.vl_moeda_di,
    di.qt_total_volume,
    di.vl_siscomex_di,
    di.cd_condicao_pagamento,
    di.dt_chegada,
    por.cd_pais,
    idi.pc_red_icms_item_di as pc_redu_icms_class_fiscal,
--		((IsNull(idi.qt_efetiva_chegada,0) *  IsNull(idi.vl_produto_moeda_destino,0) * cf.pc_ipi_classificacao) / 100) as vl_ipi,
    idi.vl_total_ipi_item_di as vl_ipi,
		IsNull(ic_ipi_base_icm_dest_prod,'N') as ic_ipi_base_icm_dest_prod,
		di.cd_transportadora,
		--0 cd_nota_saida,
    di.vl_desp_aduaneira,
    idi.vl_total_sis_item_di,
    deco.nm_destino_compra as 'DestinoCompra',
    idi.vl_total_icms_item_di,
    idi.vl_total_cof_item_di,
    idi.vl_total_pis_item_di,
  	idi.vl_total_ii_item_di,
    idi.pc_di_item_cof, 
    idi.pc_di_item_pis,
    --Nota Fiscal de Saída
    isnull((Select top 1 cd_nota_saida
     from nota_saida_item nsi with (nolock)
     where idi.cd_di = nsi.cd_di
           and idi.cd_di_item = nsi.cd_di_item and dt_cancel_item_nota_saida is null),0) as cd_nota_saida
   From DI                with (nolock) 
       inner join Fornecedor f with (nolock) on di.cd_fornecedor = f.cd_fornecedor
       inner join DI_Item idi  with (nolock) on di.cd_di = idi.cd_di
       left outer join Pedido_Importacao pimp on idi.cd_pedido_importacao = pimp.cd_pedido_importacao
--       inner join Pedido_Importacao pimp on idi.cd_pedido_importacao = pimp.cd_pedido_importacao
--       inner join Destino_Compra deco on deco.cd_destino_compra = pimp.cd_destino_compra
       left outer join Destino_Compra deco on deco.cd_destino_compra = pimp.cd_destino_compra
       inner join Produto p on idi.cd_produto = p.cd_produto
       left outer join Produto_Fiscal pf on p.cd_produto = pf.cd_produto
       left outer join Classificacao_Fiscal cf on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
       left outer join Classificacao_Fiscal_Estado cfe on pf.cd_classificacao_fiscal = cfe.cd_classificacao_fiscal and
                                                          cfe.cd_estado = @cd_estado_empresa
--       inner join Tipo_Frete tf on di.cd_tipo_frete = tf.cd_tipo_frete
       left outer join Tipo_Frete tf on di.cd_tipo_frete = tf.cd_tipo_frete
       left outer join Destinacao_Produto dp on pf.cd_destinacao_produto = dp.cd_destinacao_produto
       left outer join Invoice inv on idi.cd_invoice = inv.cd_invoice
       left outer join Porto por on inv.cd_porto_origem = por.cd_porto
	where
    --Filtra somente as DI's do período
    di.dt_desembaraco between @dt_inicial and @dt_final and
    --Filtra somente as DI's que não foram faturadas
		(not exists(Select 'x' from nota_saida_item nsi with (nolock)
		            where 
                              idi.cd_di = nsi.cd_di
                              and isnull(cd_nota_saida,0)>0
                              and idi.cd_di_item = nsi.cd_di_item and dt_cancel_item_nota_saida is null)) and
    --Filtra por fornecedor
		IsNull(di.cd_fornecedor,0) = (case 
																		when IsNull(@cd_fornecedor,0) = 0 then 
																			IsNull(di.cd_fornecedor,0) 
																		else
																			@cd_fornecedor
																	end) and
/*		IsNull(di.nm_di,'') = (case 
														when IsNull(@nm_di,'') = '' then 
															IsNull(di.nm_di,'') 
														else
															@nm_di
														end)*/
		IsNull(di.nm_di,'') like (case 
						                    when IsNull(@nm_di,'') = ''
                                  then di.nm_di + '%'
								                else @nm_di + '%'
							                end)

	order by 
		di.cd_fornecedor, 
		di.cd_di, 
                deco.nm_destino_compra,
		cf.cd_mascara_classificacao, 
		p.nm_fantasia_produto, 
		idi.cd_di_item	
end
else
begin
  Select 
    0 ic_selecionado, --Informa se o item da DI foi selecionado
    dp.cd_destinacao_produto,
    dp.nm_destinacao_produto,
    cf.cd_mascara_classificacao,
    p.nm_fantasia_produto,
		idi.qt_efetiva_chegada,
		idi.vl_produto_moeda_destino,
--	  IsNull(idi.qt_efetiva_chegada,0) *  IsNull(idi.vl_produto_moeda_destino,0) as vl_total_produto_moeda_destino,    
	idi.vl_total_moeda_destino as vl_total_produto_moeda_destino,
		cast(di.cd_di as varchar) + '-' + cast(idi.cd_di_item as varchar) as cd_identificador,
		di.cd_di,
	  di.nm_di,
	  di.nm_fatcomercial,
	  di.cd_fornecedor,
		f.nm_fantasia_fornecedor,
		di.nm_bl_awb,
	  di.nm_h_bl_awb,
		di.dt_desembaraco,
		di.dt_fatura_comercial,
		idi.cd_di_item,
	  idi.cd_produto,
	  p.cd_mascara_produto,
	  p.cd_grupo_produto,
    p.cd_unidade_medida,
	  p.nm_produto,
	  pf.cd_procedencia_produto,
	  pf.cd_classificacao_fiscal,
    p.cd_categoria_produto,
    cast(p.ds_produto as varchar(2000)) as ds_produto,
    idi.qt_embarque,
    idi.vl_cfr_item_di as cfr,
    inv.nm_invoice,
    di.cd_moeda_di,
    di.dt_moeda_di,
    di.vl_moeda_di,
    di.qt_total_volume,
    di.vl_siscomex_di,
    di.cd_condicao_pagamento,
    di.dt_chegada,
    idi.vl_produto_moeda_origem,
    por.cd_pais,
	  idi.pc_di_item_ii,
	  idi.cd_pedido_importacao,
		idi.cd_item_ped_imp,
	  di.cd_tipo_frete,
	  tf.nm_tipo_frete,
    tf.sg_tipo_frete,
    tf.ic_courier_importacao,
    tf.pc_importacao_tipo_frete,
    tf.ic_ipi_tipo_frete,
    tf.ic_pis_tipo_frete,
    tf.ic_cofins_tipo_frete,
    tf.ic_siscomex_tipo_frete,
    tf.ic_reducao_icms_tipo_frete,
--    cf.pc_ipi_classificacao,    
    idi.pc_di_item_ipi as pc_ipi_classificacao,
		p.qt_peso_liquido,
		p.qt_peso_bruto,
    (Select top 1 sg_moeda from moeda where cd_moeda = pimp.cd_moeda) as sg_moeda,
--    cfe.pc_icms_classif_fiscal,
--    cfe.pc_redu_icms_class_fiscal,
--		((IsNull(idi.qt_efetiva_chegada,0) *  IsNull(idi.vl_produto_moeda_destino,0) * cf.pc_ipi_classificacao) / 100) as vl_ipi,
    idi.pc_di_item_icms as pc_icms_classif_fiscal,
    idi.pc_red_icms_item_di as pc_redu_icms_class_fiscal,
    idi.vl_total_ipi_item_di as vl_ipi,
		IsNull(ic_ipi_base_icm_dest_prod,'N') as ic_ipi_base_icm_dest_prod,
		di.cd_transportadora,
    isnull((Select top 1 cd_nota_saida from nota_saida_item nsi
							 where nsi.cd_di = idi.cd_di
							 and nsi.cd_di_item = idi.cd_di_item and nsi.dt_cancel_item_nota_saida is null),0) as cd_nota_saida,
    di.vl_desp_aduaneira,
    idi.vl_total_sis_item_di,
  	deco.nm_destino_compra as 'DestinoCompra',
    idi.vl_total_icms_item_di,
    idi.vl_total_cof_item_di,
    idi.vl_total_pis_item_di,
   	idi.vl_total_ii_item_di,
    idi.pc_di_item_cof, 
    idi.pc_di_item_pis,
    idi.vl_ii_item_di

    from DI
       inner join Fornecedor f on di.cd_fornecedor = f.cd_fornecedor
       inner join DI_Item idi  on di.cd_di = idi.cd_di
--       inner join Pedido_Importacao pimp on idi.cd_pedido_importacao = pimp.cd_pedido_importacao
--       inner join Destino_Compra deco on deco.cd_destino_compra = pimp.cd_destino_compra
       left outer join Pedido_Importacao pimp on idi.cd_pedido_importacao = pimp.cd_pedido_importacao
       left outer join Destino_Compra deco on deco.cd_destino_compra = pimp.cd_destino_compra
       inner join Produto p on idi.cd_produto = p.cd_produto
       left outer join Produto_Fiscal pf on p.cd_produto = pf.cd_produto
       left outer join Classificacao_Fiscal cf on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
       left outer join Classificacao_Fiscal_Estado cfe on pf.cd_classificacao_fiscal = cfe.cd_classificacao_fiscal and
                                                           cfe.cd_estado = @cd_estado_empresa
--       inner join Tipo_Frete tf on di.cd_tipo_frete = tf.cd_tipo_frete
       left outer join Tipo_Frete tf on di.cd_tipo_frete = tf.cd_tipo_frete
       left outer join Destinacao_Produto dp on pf.cd_destinacao_produto = dp.cd_destinacao_produto
       left outer join Invoice inv on idi.cd_invoice = inv.cd_invoice
       left outer join Porto por on inv.cd_porto_origem = por.cd_porto
	where
	  --Filtra somente as DI's do período
    di.dt_desembaraco between @dt_inicial and @dt_final and
    --Filtra por fornecedor
		IsNull(di.cd_fornecedor,0) = (case 
																		when IsNull(@cd_fornecedor,0) = 0 then 
																			IsNull(di.cd_fornecedor,0) 
																		else
																			@cd_fornecedor
																	end)
	  and
/*		IsNull(di.nm_di,'') = (case 
														when IsNull(@nm_di,'') = '' then 
															IsNull(di.nm_di,'') 
														else
															@nm_di
														end)*/
		IsNull(di.nm_di,'') like (case 
						                    when IsNull(@nm_di,'') = ''
                                  then di.nm_di + '%'
								                else @nm_di + '%'
							                end)
	order by 
		di.cd_fornecedor, 
		di.cd_di, 
    deco.nm_destino_compra,
		cf.cd_mascara_classificacao, 
		p.nm_fantasia_produto, 
		idi.cd_di_item	
end

end

