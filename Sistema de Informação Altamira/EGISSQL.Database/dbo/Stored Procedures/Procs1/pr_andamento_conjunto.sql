
CREATE PROCEDURE pr_andamento_conjunto
-------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : DANIEL DUELA
--Banco de Dados: EgisSQL
--Objetivo      : Geração/Atualização dos documentos a receber.
--Data          : 26/03/2004
-- 22/07/2004 - Incluído coluna de fornecedor e rotina de serviço especial - Daniel C. Neto.
-------------------------------------------------------------------------------
@cd_projeto 	int, --Define o código do projeto
@cd_item_projeto  int, --Define o item do projeto
@ic_procfab_projeto char(1) --Define se foi fabricado
as

declare 
  @cd_processo int,
  @cd_chave int

	-------------------
	-- Projetos
	-------------------
	select
	  identity(int,1,1) as 'cd_chave',
	  pjcm.cd_projeto,
	  pjcm.cd_item_projeto,
	  pjcm.cd_projeto_material,
	  pjcm.qt_projeto_material,
	  (pjcm.qt_projeto_material*qt_item_projeto) as qt_total,
	  pjcm.nm_esp_projeto_material,
	  pjcm.nm_desenho_material,
	  pp.cd_processo,
	  pp.dt_inicio_processo,
	  pp.dt_fimprod_processo,
	  pp.qt_hora_prevista,
	  pp.qt_hora_processo,
	  mp.nm_mat_prima,
	  u.sg_unidade_medida,
	  pjcm.nm_marca_material,
	  f.nm_fantasia_fornecedor,
	  pjcm.cd_requisicao_compra,
	  pjcm.cd_item_requisicao_compra,
	  pjcm.cd_requisicao_interna,
	  pjcm.cd_item_req_interna,
	  f1.nm_fantasia_fornecedor as nm_fantasia_fornecedor_compra,
	  pci.cd_pedido_compra,
	  pci.cd_item_pedido_compra,
	  pci.dt_item_nec_ped_compra,
	  pci.dt_entrega_item_ped_compr,
	  nei.cd_nota_entrada,
	  nei.cd_item_nota_entrada,
	  nei.qt_item_nota_entrada,
	  ne.dt_receb_nota_entrada,
	  rci.dt_item_nec_req_compra,
	  pci.cd_requisicao_compra_item as 'nm_produto_recebido',
    nep.vl_preco_entrada_peps,
    cast(null as varchar(60)) as 'nm_fantasia_fornecedor_comp',
	  cast(null as varchar(15)) as and_1,
	  cast(null as varchar(15)) as and_2,
	  cast(null as varchar(15)) as and_3,
	  cast(null as varchar(15)) as and_4,
	  cast(null as varchar(15)) as and_5,
	  cast(null as varchar(15)) as and_6,
	  cast(null as varchar(15)) as and_7,
	  cast(null as varchar(15)) as and_8,
	  cast(null as varchar(15)) as and_9,
	  cast(null as varchar(15)) as and_10,
	  cast(null as varchar(15)) as and_11,
	  cast(null as varchar(15)) as and_12,
	  cast(null as varchar(15)) as and_13,
	  cast(null as varchar(15)) as and_14,
	  cast(null as varchar(15)) as and_15,
	  cast(null as varchar(15)) as and_16
	into #Temp_1
	from 
	  Projeto_Composicao_Material pjcm
      inner join 
    Projeto_Composicao pjc 
      on pjcm.cd_projeto = pjc.cd_projeto and
         pjcm.cd_item_projeto = pjc.cd_item_projeto
      left outer join 
    Processo_Producao pp 
      on pjcm.cd_projeto = pp.cd_projeto and
         pjcm.cd_item_projeto = pp.cd_item_projeto and
         pjcm.cd_projeto_material = pp.cd_projeto_material
      left outer join 
    Requisicao_Compra_Item rci 
      on pjcm.cd_requisicao_compra = rci.cd_requisicao_compra and
         pjcm.cd_item_requisicao_compra = rci.cd_item_requisicao_compra
      left outer join 
    Pedido_Compra pc 
      on pc.cd_pedido_compra = rci.cd_pedido_compra
      left outer join 
    Pedido_Compra_Item pci 
      on rci.cd_requisicao_compra = pci.cd_requisicao_compra and
         rci.cd_item_requisicao_compra = pci.cd_requisicao_compra_item
      left outer join 
    Nota_Entrada_Item nei 
      on rci.cd_pedido_compra = nei.cd_pedido_compra and
         rci.cd_item_pedido_compra = nei.cd_item_pedido_compra
      left outer join 
    Nota_Entrada ne 
      on nei.cd_fornecedor = ne.cd_fornecedor and
         nei.cd_nota_entrada = ne.cd_nota_entrada and
         nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
         nei.cd_operacao_fiscal = ne.cd_operacao_fiscal
      left outer join 
    Nota_Entrada_Peps nep
      on nei.cd_nota_entrada = nep.cd_documento_entrada_peps and
         nei.cd_item_nota_entrada = nep.cd_item_documento_entrada
      left outer join 
    Materia_Prima mp 
      on pjcm.cd_materia_prima = mp.cd_mat_prima
      left outer join 
    Fornecedor f 
      on pjcm.cd_fornecedor = f.cd_fornecedor
      left outer join 
    Fornecedor f1 
      on pc.cd_fornecedor = f1.cd_fornecedor
      left outer join 
    Unidade_Medida u 
      on pjcm.cd_unidade_medida = u.cd_unidade_medida
      left outer join 
    Tipo_Produto_Projeto tpj 
      on pjcm.cd_tipo_produto_projeto = tpj.cd_tipo_produto_projeto
	where
    pjcm.cd_projeto = @cd_projeto and
    pjcm.cd_item_projeto = @cd_item_projeto and
    isnull(tpj.ic_procfab_projeto,'N') = @ic_procfab_projeto 
  order by
    pjcm.cd_projeto_material

	-------------------
	-- Apontamentos
	-------------------
	select 
	  cd_chave,
	  cd_processo
	into 
	  #Temp_2 
	from 
	  #Temp_1 
	order by cd_chave

	-------------------
	-- Atualização dos  Apontamentos nos Projetos
	-------------------
	while exists(select 'x' from #Temp_2)
	begin
	  select top 1
	    @cd_processo = cd_processo,
	    @cd_chave = cd_chave
	  from #Temp_2
	  order by cd_chave
	
    select top 16
      identity(int,1,1) as cd_chave,
      ppc.cd_processo,
      gm.sg_grupo_maquina,
      f.nm_fantasia_fornecedor,
      case 
        when IsNull(ppc.cd_servico_especial,0) <> 0 then '$'
	      when ppa.ic_operacao_concluida = 'S' then '#' 
	      when ppa.cd_processo_apontamento is null then '' 
	    else '@' end as ic_status
	  into #Temp_3
	  from 
	    Processo_Producao_Composicao ppc 
	  left outer join Processo_Producao_Apontamento ppa on
	    ppc.cd_processo=ppa.cd_processo and
	    ppc.cd_item_processo=ppa.cd_item_processo
	  left outer join Grupo_Maquina gm on
	    ppc.cd_grupo_maquina=gm.cd_grupo_maquina
    left outer join Fornecedor f on
      f.cd_fornecedor = ppc.cd_fornecedor
	  where
	    ppc.cd_processo=@cd_processo
	
	  update #Temp_1
	  set
      nm_fantasia_fornecedor_comp = ( select top 1 nm_fantasia_fornecedor from #Temp_3 where IsNull(nm_fantasia_fornecedor,'') <> '' ),
	    and_1 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 1),
	    and_2 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 2),
	    and_3 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 3),
	    and_4 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 4),
	    and_5 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 5),
	    and_6 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 6),
	    and_7 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 7),
	    and_8 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 8),
	    and_9 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 9),
	    and_10 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 10),
	    and_11 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 11),
	    and_12 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 12),
	    and_13 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 13),
	    and_14 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 14),
	    and_15 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 15),
	    and_16 = ( select ic_status + sg_grupo_maquina from #Temp_3 where cd_chave = 16)
	  where
	    cd_chave = @cd_chave
	
	  delete from #Temp_2 
	  where cd_chave = @cd_chave
	
	  drop table #Temp_3
	end
    
	select * 
	from #Temp_1
	
	drop table #Temp_1
	drop table #Temp_2


