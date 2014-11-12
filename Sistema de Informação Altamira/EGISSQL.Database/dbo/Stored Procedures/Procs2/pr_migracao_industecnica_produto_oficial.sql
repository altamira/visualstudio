
-------------------------------------------------------------------------------
--pr_migracao_industecnica_produto_oficial
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes 
--                   Wilder Mendes
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Produtos
--Data             : 01.06.06
--Alteração        : 26.07.2006
------------------------------------------------------------------------------
create procedure pr_migracao_industecnica_produto_oficial
as

--select * from  egissql_industecnica.dbo.produto
-- delete  egissql_industecnica.dbo.produto
--select * from KIN.DBO.prod
--select * from produto
--select * from origem_produto
--select * from tributacao_cupom_fiscal

delete tributacao_cupom_fiscal    --deletar o relacionamento na tabela produto
delete produto_compra
delete produto_fiscal
delete produto_custo
delete from Processo_Producao
delete produto

------------------------------Migração após passos anteriores---------------------------------------------------------

select
  identity(int,1,1)         as cd_produto,
  [CODIGO NOVO]             as cd_mascara_produto,
  NOME                      as nm_produto,
  [CODIGO NOVO]             as nm_fantasia_produto,
  cast('' as varchar)       as nm_marca_produto,
  cast(PESO as float )      as qt_peso_liquido,
  cast(PESO as float )      as qt_peso_bruto,
  DESCRIC                   as ds_produto,
  cast(0 as float )         as qt_espessura_produto,
  cast(0 as float )         as qt_largura_produto,
  cast(0 as float )         as qt_comprimento_produto,
  cast(0 as float )         as qt_altura_produto,
  grupo                     as cd_grupo_produto,
  1                         as cd_status_produto, --ativo
  6                         as cd_unidade_medida,
  cast(0 as int)            as cd_tipo_embalagem,
  cast(0 as int)            as cd_origem_produto,
  cast(0 as int)            as cd_agrupamento_produto,
  categoria                          as cd_categoria_produto,
  cast(0 as float )         as qt_dias_entrega_medio,
  VR_VAREJO                 as vl_produto,
  cast(0 as float )         as vl_fator_conversao_produt,
  cast(0 as int )           as cd_produto_baixa_estoque,
  cast(0 as float )         as pc_desconto_max_produto,
  cast(0 as float )         as pc_desconto_min_produto,
  cast(0 as float )         as pc_acrescimo_max_produto,
  cast(0 as float )         as pc_acrescimo_min_produto,
  cast('' as varchar )      as nm_observacao_produto,
  cast(0 as int )           as cd_serie_produto,
  99                        as cd_usuario,
  getdate()                 as dt_usuario,
  'N'                       as ic_kogo_produto,
  1                         as cd_tipo_valoracao,
  COMPLEM                   as nm_complemento_produto,
  cast(0 as int )           as cd_grupo_categoria,
  'N'                       as ic_bem_ind_acessorio_prod,
  cast(0 as int )           as cd_substituto_produto,
  'N'                       as ic_wapnet_produto,
  cast(0 as float )         as qt_dia_entrega_medio,
  'N'                       as ic_lote_produto,
  cast(0 as int )           as cd_termo_garantia,
  'N'                       as ic_Rasteabilidade_produto,
  cast('' as varchar )      as nm_serie_produto,
  cast(0 as int )           as qt_dia_garantia_produto,
  'N'                       as ic_garantia_produto,
  'N'                       as ic_rastreabilidade_prod,
  cast(0 as int )           as cd_substituido_produto,
  cast(0 as int )           as cd_un_compra_produto,
  cast(0 as float )         as qt_conv_compra_produto,
  cast(0 as int )           as cd_un_estoque_produto,
  cast(0 as float )         as qt_convestoque_produto,
  'S'                       as ic_controle_pcp_produto,
  cast(0 as int )           as cd_codigo_barra_produto,
  'N'                       as ic_desenvolvimento_prod,
  'N'                       as ic_descritivo_nf_produto,
  cast('' as varchar)       as nm_produto_complemento,
  cast( 0 as float )        as pc_comissao_produto,
  cast( 1 as int )          as cd_versao_produto,
  cast( 0 as int )          as qt_leadtime_produto,
  cast( 0 as int )          as qt_leadtime_compra,
  'N'                       as ic_sob_encomenda_produto,
  getdate()                 as dt_cadastro_produto,
  cast( 1 as int )          as cd_moeda,
  cast( 0 as float )        as qt_volume_produto,
  cast( 0 as int )          as cd_plano_financeiro,
  cast( 0 as int )          as cd_plano_compra,
  'N'                       as ic_baixa_composicao_prod,
  'N'                       as ic_dev_composicao_prod,
  'N'                       as ic_inspecao_produto,
  'N'                       as ic_estoque_inspecao_prod,
  cast( 0 as int )          as cd_laudo_produto,
  'S'                       as ic_comercial_produto,
  'S'                       as ic_compra_produto,
  'S'                       as ic_producao_produto,
  'S'                       as ic_importacao_produto,
  'S'                       as ic_exportacao_produto,
  'N'                       as ic_beneficiamento_produto,
  'N'                       as ic_amostra_produto,
  'N'                       as ic_consignacao_produto,
  'N'                       as ic_transferencia_produto,
  1                         as cd_tipo_mercado,
  cast(0 as float )         as qt_evolucao_produto,
  'N'                       as ic_guia_trafego_produto,
  'N'                       as ic_pol_federal_produto,
  'N'                       as ic_exercito_produto,
  cast(0 as float )         as qt_concentracao_produto,
  cast(0 as float )         as qt_densidade_produto,
  'S'                       as ic_revenda_produto,
  'S'                       as ic_tecnica_produto,
  'S'                       as ic_almox_produto,
  cast(0 as int )           as cd_cor,
  cast(0 as int )           as cd_exercito_produto,
  cast('' as varchar)       as nm_exercito_produto,
  cast(0 as int )           as cd_policia_federal,
  cast('' as varchar)       as nm_policia_federal,
  cast(0 as int )           as cd_policia_civil,
  cast('' as varchar)       as nm_policia_civil,
  'N'                       as ic_usar_valor_composicao,
  cast(0 as int   )         as cd_preco_frete,
  cast(0 as int   )         as cd_preco_montagem_produto,
  case i.promat   when 'A' then 
			  2
		when 'I' then 
			  6
		when 'M' then 
			  1
		when 'O' then 
			  4
		when 'P' then 
			  3
		when 'S' then 
			  5
		Else 	  
			  3
end                         as cd_fase_produto_baixa,
  'S'                       as ic_processo_produto,
  cast(0 as float )         as vl_anterior_produto,
  cast(0 as int )           as cd_periculosidade,
  cast(null as datetime)    as dt_exportacao_registro,
  'N'                       as ic_mapa_exercito,
  'N'                       as ic_mapa_pol_civil,
  getdate()                 as dt_alteracao_produto,
  cast(0 as int   )         as cd_materia_prima,
  cast(0 as int   )         as cd_propaganda,
  cast(0 as float )         as vl_produto_mercado,
  cast(0 as float )         as qt_limite_venda_mes,
  'N'                       as ic_controlado_exportacao,
  'N'                       as ic_fmea_produto,
  'N'                       as ic_plano_controle_produto,
  'N'                       as ic_emergencia_produto,
  'N'                       as ic_promocao_produto,
  cast(0 as float )         as qt_multiplo_embalagem,
  0                         as cd_tabela_preco,
  0                         as cd_tipo_retalho,
  0                         as cd_prazo,
  cast('' as varchar)       as nm_preco_lista_produto,
  0                         as cd_local_entrega_mov_caixa,
  'N'                       as ic_dadotec_produto,
  'S'                       as ic_pcp_produto,
  'N'                       as ic_especial_produto,
  cast(0 as float )         as qt_peso_embalagem_produto,
  'S'                       as ic_analise_produto,
  'N'                       as ic_numero_serie_produto,
  [CODIGO NOVO]             as nm_fantasia_produto_novo,
  'N'                       as ic_entrada_estoque_fat,
  cast(0 as float )         as pc_icms_produto,
  null                      as cd_tributacao,
  'N'                       as ic_estoque_caixa_produto,
  'N'                       as ic_lista_preco_caixa_produto,
  'N'                       as ic_controlar_montagem_pv,
  cast(0 as int )           as qt_cubagem_produto,
  CODIGO                    as nm_fantasia_antigo,
  null                      as qt_peso_especifico_produto,
  null                      as qt_minimo_venda_produto,
  null                      as cd_marca_produto,
  null                      as cd_desenho_produto,
  null                      as cd_rev_desenho_produto,
  null                      as qt_area_produto

      
into
  #produto
from
  Produto_teste left join
  Kin.dbo.INPRO i on (i.CODIGO = pt.CODIGO)	

-- select * from #produto
-- order by cd_produto

--delete from produto

insert into
  produto
select
  *   
from
  #produto 

drop table #produto

select * from produto
order by
  cd_produto

--Atualiza o Grupo Categoria

-- update
--   Produto
-- set
--   cd_grupo_categoria = ( select top 1 cd_grupo_categoria from Categoria_Produto cp where cp.cd_categoria_produto = p.cd_categoria_produto )
-- from
--   Produto p

