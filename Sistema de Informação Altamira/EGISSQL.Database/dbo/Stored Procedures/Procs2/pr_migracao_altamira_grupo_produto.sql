
-------------------------------------------------------------------------------
--pr_migracao_altamira_grupo_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Robert Gaffo
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela
--Data             : 15.03.2009
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_grupo_produto
as

--Delta os Registros da Tabela Destino
delete from Grupo_Produto_Fiscal
delete from Grupo_Produto_Custo
delete from Grupo_Produto_Garantia
delete from Grupo_Produto_Tecnica_Idioma
delete from Grupo_Produto_Servico
delete from Grupo_Produto_Crescimento
delete from Grupo_Produto_Contabilizacao
delete from Grupo_Produto_Codificacao
delete from Grupo_Produto_Observacao
delete from Grupo_Produto_Valoracao
delete from Grupo_Produto_Proposta
delete from Grupo_Produto_Fiscal_Entrada
delete from Grupo_Produto_Markup
delete from Grupo_Produto_Fase
delete from Grupo_Produto_Departamento
delete from Grupo_Produto_Tecnica
delete from Grupo_Produto_Portaria_Norma
delete from Grupo_Produto

--select * from db_altamira.dbo.co_pasta

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
copt_codigo			     as cd_grupo_produto,
cast (copt_descricao as varchar(40)) as nm_grupo_produto,
cast (copt_descricao as varchar(15)) as nm_fantasia_grupo_produto,
null 				     as sg_grupo_produto,
null 				     as cd_mascara_grupo_produto,
null 				     as pc_desconto_max_grupo_produto,
null 				     as pc_desconto_min_grupo_produto,
null 				     as pc_acrescimo_max_grupo_produto,
null 				     as pc_acrescimo_min_grupo_produto,
null 				     as cd_tipo_embalagem,
null 				     as cd_agrupamento_produto,
null 				     as cd_unidade_medida,
null 				     as cd_tipo_grupo_produto,
null 				     as cd_imagem,
null 				     as cd_status_grupo_produto,
null 				     as cd_categoria_produto,
null 				     as cd_status_produto,
4 				     as cd_usuario,
getdate()			     as dt_usuario,
null 				     as ic_controle_pcp_grupo,
null 				     as ic_mapa_placa_grupo,
null 				     as cd_tipo_mercado,
null 				     as qt_mes_consumo_grupo,
null 				     as cd_departamento,
null 				     as cd_aplicacao_produto,
null 				     as cd_plano_compra,
null 				     as cd_tipo_requisicao,
cast(null as varchar)		     as ds_req_compra_grupo,
null 				     as ic_garantia_grupo_produto,
null 				     as ic_rast_grupo_pedido,
null 				     as ic_lote_grupo_produto,
null 				     as qt_dia_garantia_grupo_pro,
null 				     as ic_serie_grupo_produto,
null 				     as ic_rastreabi_grupo_pedido,
null 				     as cd_termo_garantia,
null 				     as ic_mapa_placa_grupo_produ,
cast(null as varchar)		     as ds_reqcompra_grupo_produt,
null 				     as ic_importacao_grupo_produ,
null 				     as pc_impostoximp_grupo_prod,
null 				     as cd_grupo_categoria,
null 				     as pc_comissao_grupo_produto,
null 				     as ic_especial_grupo_produto,
null 				     as qt_dia_orc_grupo_produto,
null 				     as ic_sob_encomenda_produto,
null 				     as ic_volume_grupo_produto,
null 				     as ic_export_grupo_produto,
null 				     as ic_repos_grupo_produto,
null 				     as ic_transf_cust_grupo_prod,
null 				     as ic_processo_grupo_produto,
null 				     as ic_etiq_pcp_grupo_produto,
null 				     as ic_inspecao_grupo_produto,
null 				     as ic_qualid_grupo_produto,
null 				     as cd_moeda,
null 				     as ic_cnc_grupo_produto,
null 				     as ic_cotacao_grupo_produto,
null 				     as cd_plano_financeiro,
null 				     as ic_dadotec_grupo_produto,
null 				     as cd_classe,
null 				     as ic_baixa_composicao_grupo,
null 				     as ic_dev_composicao_grupo,
null 				     as ic_composicao_grupo_prod,
null 				     as nm_proposta_grupo_produto,
null 				     as nm_obs_proposta_grupo,
null 				     as nm_pedido_grupo_produto,
null 				     as nm_nota_grupo_produto,
null 				     as qt_evolucao_grupo_produto,
null 				     as ic_montagem_venda_grupo,
null 				     as ic_guia_trafego_grupo,
null 				     as ic_revenda_grupo_produto,
null 				     as cd_tipo_produto_espessura,
null 				     as cd_propaganda,
cast(null as varchar)		     as ds_tecnica_grupo_produto,
null 				     as cd_mensagem_proposta,
null 				     as cd_categoria_produto_exp,
null 				     as ic_prototipo_grupo_prod,
null 				     as ic_desenv_grupo_prod,
null 				     as cd_promocao,
null 				     as ic_calculo_peso_grupo,
null 				     as cd_grupo_estoque,
null 				     as cd_tipo_retalho,
null 				     as ic_pcp_grupo_produto,
null 				     as ic_analise_grupo_produto,
null 				     as cd_sequencial_grupo_produto,
null 				     as ic_kit_grupo_produto,
null 				     as ic_entrada_estoque_fat,
null 				     as sg_projeto_grupo_produto,
null 				     as ic_compra_mp_nao_smo,
null 				     as ic_controlar_montagem_pv,
null 				     as ic_mensagem_proposta_prod  
into
  #Grupo_Produto
from
  db_altamira.dbo.co_pasta

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Grupo_Produto
select
  *
from
  #Grupo_Produto


--Deleção da Tabela Temporária

drop table #Grupo_Produto

--Mostra os registros migrados

select * from Grupo_Produto

