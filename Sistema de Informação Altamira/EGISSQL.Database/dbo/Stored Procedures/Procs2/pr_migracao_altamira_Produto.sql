
-------------------------------------------------------------------------------
--pr_migracao_altamira_Produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Robert Gaffo
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela
--Data             : 29.09.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_Produto
as

--Delta os Registros da Tabela Destino
delete from Produto_Imagem
delete from Produto_Idioma
delete from Produto_Contabilizacao
delete from Produto_Concorrente
delete from Produto_Historico
delete from Produto_Fiscal
delete from Produto_Custo
delete from Produto_Composicao
delete from Produto_Composicao
delete from Produto_Entrega
delete from Produto_Tecnica
delete from Produto_Garantia
delete from Produto_Localizacao
delete from Produto_Grupo_Localizacao
delete from Produto_Agrupamento
delete from Produto_Fechamento
delete from Produto_Saldo
delete from Produto_Kogo
delete from Produto_Cliente
--delete from ProdutoWap
delete from Produto_Pcp
delete from Produto_Compra
delete from Produto_Alternativo
delete from Produto_Origem
delete from Produto_Preco
delete from Produto_Importacao
delete from Produto_Grade
delete from Produto_Grade_Preco
delete from Produto_Embalagem
--delete from Produto_Contrato_Parcela
delete from Produto_Cemiterio
delete from Produto_Orcamento
delete from Produto_Orcamento_Componente
delete from Produto_Orcamento_Serie
delete from Produto_Orcamento_Furo
delete from Produto_Fiscal_Observacao
--delete from Produto_Contrato_Old
delete from Produto_Inspecao
delete from Produto_Dominio
delete from Produto_Processo
delete from Produtos_Relatorio_Repnet
delete from Produto_Producao
delete from Produto_Composicao_Agrupamento
delete from Produto_Contrato
delete from Produto_Endereco
delete from Produto_Check_List
delete from Produto_Cilindro
delete from Produto_Consignacao
delete from Produto_Autor
delete from Produto_Autor
delete from Produto_Objeto
delete from Produtora
delete from Produto_Opiniao
delete from Produto_Literatura
delete from Produto_Informacao
delete from Produto_Especificacao
delete from Produto_Exportacao
delete from Produto_Proposta
delete from Produto_Venda_Tipo_Pedido
delete from Produto_Script
delete from Produto_Apresentacao
delete from Produto_Critico
delete from Produto_Caracteristica_Critica
delete from Produto_Preco_Venda
delete from Produto_Fracionamento
delete from Produto_Registro
delete from Produto_Parametro_Pesquisa
delete from Produto_Desenvolvimento
delete from Produto_Sinonimo
delete from Produto_Unidade_Medida
delete from Produto_Desenho
delete from Produto_Reposicao_Historico
delete from Produto_Fiscal_Entrada
delete from Produto_Valoracao
delete from Produto_Mercado
delete from Produto_Custo_Calculo_Temporario
delete from Produto_Custo_Item_Temporario
delete from Produto_Alteracao_Fantasia
delete from Produto_Conversao
delete from Produto_Desenho_Revisao
delete from Produto_Inventario
delete from Produto_Cliente_Historico
delete from Produto_Estampo
delete from Produto_Caracteristica_Composicao
delete from Produto_Faixa_Preco
delete from Produto_Portaria_Norma
delete from Produto_Catalogo
delete from Produto_Estampo_Markup
delete from Produto_Servico_Especial
delete from Produto_Quimico
delete from Produto_Medida
delete from Produto_Preco_Custo
delete from Produto_Classificacao
delete from Produto

--select * from db_altamira.dbo.co_almoxarifado

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
identity(int, 1, 1)										      as cd_produto,
coal_Codigo											      as cd_mascara_produto,
cast(coal_Descricao       as varchar(50))							      as nm_produto,
cast(coal_Descricao       as varchar(30))							      as nm_fantasia_produto,
null 												      as nm_marca_produto,
null 												      as qt_peso_liquido,
null 												      as qt_peso_bruto,
cast(null       as varchar)									      as ds_produto,
null 												      as qt_espessura_produto,
null 												      as qt_largura_produto,
null 												      as qt_comprimento_produto,
null 												      as qt_altura_produto,
coal_Pasta											      as cd_grupo_produto,
1 												      as cd_status_produto,
isnull((select top 1 cd_unidade_medida from Unidade_Medida where sg_unidade_medida = coal_Unidade),12) as cd_unidade_medida,
null 												      as cd_tipo_embalagem,
1 												      as cd_origem_produto,
null 												      as cd_agrupamento_produto,
2 												      as cd_categoria_produto,
null 												      as qt_dias_entrega_medio,
null 												      as vl_produto,
null 												      as vl_fator_conversao_produt,
null 												      as cd_produto_baixa_estoque,
null 												      as pc_desconto_max_produto,
null 												      as pc_desconto_min_produto,
null 												      as pc_acrescimo_max_produto,
null 												      as pc_acrescimo_min_produto,
null 												      as nm_observacao_produto,
null 												      as cd_serie_produto,
4												      as cd_usuario,
getdate()											      as dt_usuario,
null 												      as ic_kogo_produto,
null 												      as cd_tipo_valoracao,
null 												      as nm_complemento_produto,
1  												      as cd_grupo_categoria,
null 												      as ic_bem_ind_acessorio_prod,
null 												      as cd_substituto_produto,
null 												      as ic_wapnet_produto,
null 												      as qt_dia_entrega_medio,
null 												      as ic_lote_produto,
null 												      as cd_termo_garantia,
null 												      as ic_Rasteabilidade_produto,
null 												      as nm_serie_produto,
null 												      as qt_dia_garantia_produto,
null 												      as ic_garantia_produto,
null 												      as ic_rastreabilidade_prod,
null 												      as cd_substituido_produto,
null 												      as cd_un_compra_produto,
null 												      as qt_conv_compra_produto,
null 												      as cd_un_estoque_produto,
null 												      as qt_convestoque_produto,
null 												      as ic_controle_pcp_produto,
null 												      as cd_codigo_barra_produto,
'N' 												      as ic_desenvolvimento_prod,
null 												      as ic_descritivo_nf_produto,
null 												      as nm_produto_complemento,
null 												      as pc_comissao_produto,
null 												      as cd_versao_produto,
null 												      as qt_leadtime_produto,
null 												      as qt_leadtime_compra,
null 												      as ic_sob_encomenda_produto,
getdate()											      as dt_cadastro_produto,
1												      as cd_moeda,
null 												      as qt_volume_produto,
null 												      as cd_plano_financeiro,
null 												      as cd_plano_compra,
null 												      as ic_baixa_composicao_prod,
null 												      as ic_dev_composicao_prod,
null 												      as ic_inspecao_produto,
null 												      as ic_estoque_inspecao_prod,
null 												      as cd_laudo_produto,
'N' 												      as ic_comercial_produto,
'S' 												      as ic_compra_produto,
'N' 												      as ic_producao_produto,
null 												      as ic_importacao_produto,
null 												      as ic_exportacao_produto,
null 												      as ic_beneficiamento_produto,
null 												      as ic_amostra_produto,
null 												      as ic_consignacao_produto,
null 												      as ic_transferencia_produto,
1 												      as cd_tipo_mercado,
null 												      as qt_evolucao_produto,
null 												      as ic_guia_trafego_produto,
null 												      as ic_pol_federal_produto,
null 												      as ic_exercito_produto,
null 												      as qt_concentracao_produto,
null 												      as qt_densidade_produto,
null 												      as ic_revenda_produto,
null 												      as ic_tecnica_produto,
'S'  												      as ic_almox_produto,
null 												      as cd_cor,
null 												      as cd_exercito_produto,
null 												      as nm_exercito_produto,
null 												      as cd_policia_federal,
null 												      as nm_policia_federal,
null 												      as cd_policia_civil,
null 												      as nm_policia_civil,
null 												      as ic_usar_valor_composicao,
null 												      as cd_preco_frete,
null 												      as cd_preco_montagem_produto,
3 												      as cd_fase_produto_baixa,
null 												      as ic_processo_produto,
null 												      as vl_anterior_produto,
null 												      as cd_periculosidade,
null 												      as dt_exportacao_registro,
null 												      as ic_mapa_exercito,
null 												      as ic_mapa_pol_civil,
null 												      as dt_alteracao_produto,
null 												      as cd_materia_prima,
null 												      as cd_propaganda,
null 												      as vl_produto_mercado,
null 												      as qt_limite_venda_mes,
null 												      as ic_controlado_exportacao,
null 												      as ic_fmea_produto,
null 												      as ic_plano_controle_produto,
null 												      as ic_emergencia_produto,
null 												      as ic_promocao_produto,
null 												      as qt_multiplo_embalagem,
null 												      as cd_tabela_preco,
null 												      as cd_tipo_retalho,
null 												      as cd_prazo,
null 												      as nm_preco_lista_produto,
null 												      as cd_local_entrega_mov_caixa,
null 												      as ic_dadotec_produto,
null 												      as ic_pcp_produto,
null 												      as ic_especial_produto,
null 												      as qt_peso_embalagem_produto,
null 												      as ic_analise_produto,
null 												      as ic_numero_serie_produto,
null 												      as nm_fantasia_produto_novo,
null 												      as ic_entrada_estoque_fat,
null 												      as pc_icms_produto,
null 												      as cd_tributacao,
null 												      as ic_estoque_caixa_produto,
null 												      as ic_lista_preco_caixa_produto,
null 												      as ic_controlar_montagem_pv,
null 												      as qt_cubagem_produto,
null 												      as nm_fantasia_antigo,
null 												      as qt_peso_especifico_produto,
null 												      as qt_minimo_venda_produto,
null 												      as cd_marca_produto,
null 												      as cd_desenho_produto,
null 												      as cd_rev_desenho_produto,
null 												      as qt_area_produto,
null 												      as cd_modalidade_dureza,
null 												      as cd_tolerancia_produto,
null 												      as cd_certificado_produto,
null 												      as cd_tipo_criticidade,
null 												      as nm_modelo_produto,
null 												      as cd_modelo_proposta,
null 												      as cd_cliente_produto,
null 												      as qt_diam_interno_produto,
null 												      as qt_diam_externo_produto,
null 												      as cd_interface,
null 												      as ic_exporta_produto,
null 												      as ic_bonificacao_produto,
null as cd_laudo_padrao,
null as cd_sequencial_produto
  

into
  #Produto
from
  db_altamira.dbo.co_almoxarifado

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Produto
select
  *
from
  #Produto

--Mostra os registros migrados

select * from Produto

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
p.cd_produto 		as cd_produto,
'S'			as ic_peps_produto,
'N'			as ic_lista_preco_produto,
'N'			as ic_lista_rep_produto,
'S'			as ic_reposicao_produto,
ca.coal_valor   	as vl_custo_produto,
'S'			as ic_estoque_produto,
'N'			as ic_orcamento_produto,
null			as ic_imediato_produto,
null			as ic_importacao_produto,
'S'			as ic_reserva_estoque_produto,
'S'			as ic_estoque_fatura_produto,
'N'			as ic_estoque_venda_produto,
'S'			as ic_venda_saldo_negativo,
null			as ic_controle_desconto_produto,
'S'			as ic_fechamento_mensal_produto,
null			as qt_dia_valoracao,
1			as cd_tipo_valoracao,
null			as cd_tipo_lucro,
null			as cd_aplicacao,
null			as cd_grupo_preco_produto,
null			as cd_cab_lista_preco,
4			as cd_usuario,
getdate()		as dt_usuario,
null			as qt_mes_consumo_produto,
null			as cd_grupo_produto,
null			as cd_tipo_valoracao_produto,
null			as ic_exportacao_produto,
null			as vl_custo_anterior_produto,
null			as cd_mat_prima,
3			as qt_consumo_mensal,
null			as ic_reserva_estoque_produt,
null			as ic_fechamento_mensal_prod,
null			as ic_controle_desconto_prod,
null			as cd_aplicacao_markup,
null			as cd_plano_financeiro,
null			as ic_smo_produto,
null			as vl_custo_contabil_produto,
null			as vl_custo_medio_produto,
'S'			as ic_atualiza_custo_nf,
2			as cd_grupo_inventario,
null			as cd_bitola,
1			as cd_metodo_valoracao,
null			as cd_lancamento_padrao,
null			as vl_net_outra_moeda,
4			as cd_grupo_estoque,
null			as nm_obs_custo_produto,
getdate()		as dt_custo_produto,
null			as vl_base_custo_produto,
null			as dt_base_custo_produto,
null			as vl_simulado_custo_produto,
null			as dt_simulado_custo_produto,
null			as vl_temp_custo_produto,
null			as dt_temp_custo_produto,
null			as cd_overprice,
null			as dt_net_outra_moeda,
ca.coal_valor		as vl_custo_previsto_produto,
null			as ic_mat_prima_produto,
null			as vl_custo_exportacao,
null			as vl_custo_fracionado_produto,
null			as ic_deducao_imposto,
null			as vl_custo_comissao,
null			as ic_custo_moeda_produto,
1 			as cd_moeda,
null			as vl_custo_producao_produto,
null			as vl_custo_frete_produto  
into
  #Produto_Custo
from
  #Produto P
inner join db_altamira.dbo.co_almoxarifado  ca on coal_Codigo = P.cd_mascara_produto

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Produto_Custo
select
  *
from
  #Produto_Custo

--Mostra os registros migrados

select * from Produto_Custo

--produto_compra

select
  p.cd_produto,
  null as nm_compra_produto,
  null as nm_marca_produto,
  null as cd_unidade_medida,
  null as qt_fatcompra_produto,
  null as cd_destinacao_produto,
  null as cd_aplicacao_produto,
  null as nm_obs_aplicacao_produto,
  null as nm_obs_producao_produto,
  null as qt_mes_compra_produto,
  coal_QtdMinima as qt_lotecompra_produto,
4 as cd_usuario,
getdate() as dt_usuario,
  null as cd_fase_produto,
  null as cd_fase_produto_entrada,
  cast('' as varchar) as ds_produto_compra,
  null as nm_produto_compra,
  null as ic_cotacao_grupo_produt,
'S' as ic_cotacao_produto,
  null as cd_plano_compra,
  null as qt_dia_validade_minima
into
  #Produto_Compra

from
  #Produto P
inner join db_altamira.dbo.co_almoxarifado  ca on coal_Codigo = P.cd_mascara_produto


insert into Produto_Compra
select
  *
from
  #Produto_Compra

--Produto_Fiscal

select
  p.cd_produto,
  null as cd_destinacao_produto,
  null as cd_dispositivo_legal_ipi,
  null as cd_dispositivo_legal_icms,
  1    as cd_tipo_produto,
  1    as cd_procedencia_produto,
  null as cd_classificacao_fiscal,
  1    as cd_tributacao,
  4    as cd_usuario,
  getdate() as dt_usuario,
  null as pc_aliquota_iss_produto,
  null as pc_aliquota_icms_produto,
  'N'  as ic_substrib_produto,
  18   as qt_aliquota_icms_produto,
  18   as pc_interna_icms_produto,
  'N'  as ic_isento_icms_produto,
  null as vl_ipi_produto_fiscal,
  null as cd_modalidade_icms,
  null as cd_modalidade_icms_st,
  null as vl_pauta_icms_produto,
  null as pc_iva_icms_produto
into
  #Produto_Fiscal
from
  #Produto p
inner join db_altamira.dbo.co_almoxarifado  ca on coal_Codigo = P.cd_mascara_produto

insert into
  produto_fiscal
select
  *
from
  #Produto_Fiscal

--Deleção da Tabela Temporária

drop table #Produto

--Deleção da Tabela Temporária

drop table #Produto_Custo

drop table #Produto_Compra

drop table #Produto_Fiscal

