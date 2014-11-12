
-------------------------------------------------------------------------------
--sp_helptext pr_gera_produto_custo
-------------------------------------------------------------------------------
--pr_gera_produto_custo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Acerto da Tabela Produto Custo
--Data             : 01/05/2007
--Alteração        : 30.10.2007
------------------------------------------------------------------------------
create procedure pr_gera_produto_custo
@ic_parametro int = 0

as


--consulta dos itens da tabela produto que não possuem na tabela produto_custo
--select dt_cadastro_produto,* from produto where cd_produto not in (select cd_produto from produto_custo)

--select * from produto_custo where cd_produto = 1891


--Geração dos registros na tabela produto Custo

--select * from produto_custo

if @ic_parametro = 1
begin

select
  cd_produto,
  'S'                           as ic_peps_produto,
  'S'                           as ic_lista_preco_produto,
  'S'                           as ic_lista_rep_produto,
  'S'                           as ic_reposicao_produto,
  cast(0 as float )             as vl_custo_produto,
  'S'                           as ic_estoque_produto,
  'S'                           as ic_orcamento_produto,
  'S'                           as ic_imediato_produto,
  'S'                           as ic_importacao_produto,
  'S'                           as ic_reserva_estoque_produto,
  'S'                           as ic_estoque_fatura_produto,
  'S'                           as ic_estoque_venda_produto,
  'S'                           as ic_venda_saldo_negativo,
  'S'                           as ic_controle_desconto_produto,
  'S'                           as ic_fechamento_mensal_produto,
  cast(0 as float )             as qt_dia_valoracao,
  cast(1 as int )               as cd_tipo_valoracao,
  0                             as cd_tipo_lucro,
  0                             as cd_aplicacao,
  0                             as cd_grupo_preco_produto,
  0                             as  cd_cab_lista_preco,
  99                            as cd_usuario,
  getdate()                     as dt_usuario,
  3                             as qt_mes_consumo_produto,
  cd_grupo_produto,
  1                             as cd_tipo_valoracao_produto,
  'S'                           as ic_exportacao_produto,
  cast(0 as float )             as vl_custo_anterior_produto,
  0                             as cd_mat_prima,
  cast(0 as float )             as qt_consumo_mensal,
  'S'                           as ic_reserva_estoque_produt,
  'S'                           as ic_fechamento_mensal_prod,
  'S'                           as ic_controle_desconto_prod,
  0                             as cd_aplicacao_markup,
  0                             as cd_plano_financeiro,
  'N'                           as ic_smo_produto,
  cast(0 as float )             as vl_custo_contabil_produto,
  cast(0 as float )             as vl_custo_medio_produto,
  'S'                           as ic_atualiza_custo_nf,
   0                            as cd_grupo_inventario,
   0                            as cd_bitola,
   1                            as cd_metodo_valoracao,
   null                         as cd_lancamento_padrao,
  cast(0 as float )             as vl_net_outra_moeda,
  4                             as cd_grupo_estoque,
  cast('' as varchar)           as nm_obs_custo_produto,
  cast(null as datetime)        as dt_custo_produto,
  cast(0 as float )             as vl_base_custo_produto,
  cast(null as datetime)        as dt_base_custo_produto,
  cast(0 as float )             as vl_simulado_custo_produto,
  cast(null as datetime)        as dt_simulado_custo_produto,
  cast(0 as float )             as vl_temp_custo_produto,
  cast(null as datetime)        as dt_temp_custo_produto,
  0                             as cd_overprice,
  cast(null as datetime)        as dt_net_outra_moeda,
  cast(0 as float )             as vl_custo_previsto_produto,
  'N'                           as ic_mat_prima_produto,
  cast(0 as float )             as vl_custo_exportacao,
  cast(0 as float )             as vl_custo_fracionado_produto,
  'S'                           as ic_deducao_imposto,
  0                             as vl_custo_comissao,
  'N'                           as ic_custo_moeda_produto,
  1                             as cd_moeda,
  0 as vl_custo_producao_produto,
  0 as vl_custo_frete_produto


into
  #Produto_Custo
from
  Produto p
where
  p.cd_produto not in (select cd_produto from produto_custo)

insert
  produto_custo
select
  *
from 
  #produto_custo


DROP TABLE #produto_custo

end

-------------------------------------------------------------------------------
--Alteração dos Produtos
-------------------------------------------------------------------------------


if @ic_parametro = 2
begin

select
  p.cd_produto,
  'S'                           as ic_peps_produto,
  'S'                           as ic_lista_preco_produto,
  'S'                           as ic_lista_rep_produto,
  'S'                           as ic_reposicao_produto,
  cast(0 as float )             as vl_custo_produto,
  'S'                           as ic_estoque_produto,
  'S'                           as ic_orcamento_produto,
  'S'                           as ic_imediato_produto,
  'S'                           as ic_importacao_produto,
  'S'                           as ic_reserva_estoque_produto,
  'S'                           as ic_estoque_fatura_produto,
  'S'                           as ic_estoque_venda_produto,
  'S'                           as ic_venda_saldo_negativo,
  'S'                           as ic_controle_desconto_produto,
  'S'                           as ic_fechamento_mensal_produto,
  cast(0 as float )             as qt_dia_valoracao,
  cast(1 as int )               as cd_tipo_valoracao,
  0                             as cd_tipo_lucro,
  0                             as cd_aplicacao,
  0                             as cd_grupo_preco_produto,
  0                             as  cd_cab_lista_preco,
  99                            as cd_usuario,
  getdate()                     as dt_usuario,
  3                             as qt_mes_consumo_produto,
  p.cd_grupo_produto,
  1                             as cd_tipo_valoracao_produto,
  'S'                           as ic_exportacao_produto,
  cast(0 as float )             as vl_custo_anterior_produto,
  0                             as cd_mat_prima,
  cast(0 as float )             as qt_consumo_mensal,
  'S'                           as ic_reserva_estoque_produt,
  'S'                           as ic_fechamento_mensal_prod,
  'S'                           as ic_controle_desconto_prod,
  0                             as cd_aplicacao_markup,
  0                             as cd_plano_financeiro,
  'N'                           as ic_smo_produto,
  cast(0 as float )             as vl_custo_contabil_produto,
  cast(0 as float )             as vl_custo_medio_produto,
  'S'                           as ic_atualiza_custo_nf,
   0                            as cd_grupo_inventario,
   0                            as cd_bitola,
   1                            as cd_metodo_valoracao,
   null                         as cd_lancamento_padrao,
  cast(0 as float )             as vl_net_outra_moeda,
  4                             as cd_grupo_estoque,
  cast('' as varchar)           as nm_obs_custo_produto,
  cast(null as datetime)        as dt_custo_produto,
  cast(0 as float )             as vl_base_custo_produto,
  cast(null as datetime)        as dt_base_custo_produto,
  cast(0 as float )             as vl_simulado_custo_produto,
  cast(null as datetime)        as dt_simulado_custo_produto,
  cast(0 as float )             as vl_temp_custo_produto,
  cast(null as datetime)        as dt_temp_custo_produto,
  0                             as cd_overprice,
  cast(null as datetime)        as dt_net_outra_moeda,
  cast(0 as float )             as vl_custo_previsto_produto,
  'N'                           as ic_mat_prima_produto,
  cast(0 as float )             as vl_custo_exportacao,
  cast(0 as float )             as vl_custo_fracionado_produto,
  'S'                           as ic_deducao_imposto,
  0                             as vl_custo_comissao,
  'N'                           as ic_custo_moeda_produto,
  1                             as cd_moeda,
  0 as vl_custo_producao_produto,
  0 as vl_custo_frete_produto




into
  #Produto_Custo_Alteracao

from
  Produto p with (nolock)
  left outer join produto_custo pc on pc.cd_produto = p.cd_produto

--where
--  isnull(pc.ic_estoque_produto,'N') = 'N'
  
-- insert
--   produto_custo
-- select
--   *
-- from 
--   #produto_custo

  update
    produto_custo
  set
    ic_peps_produto              = pa.ic_peps_produto,
    ic_lista_preco_produto       = pa.ic_lista_preco_produto,
    ic_lista_rep_produto         = pa.ic_lista_rep_produto,
    ic_reposicao_produto         = pa.ic_reposicao_produto,
    ic_estoque_produto           = pa.ic_estoque_produto,
    ic_orcamento_produto         = pa.ic_orcamento_produto,
    ic_imediato_produto          = pa.ic_imediato_produto,
    ic_importacao_produto        = pa.ic_importacao_produto,
    ic_reserva_estoque_produto   = pa.ic_reserva_estoque_produto,
    ic_estoque_fatura_produto    = pa.ic_estoque_fatura_produto,
    ic_estoque_venda_produto     = pa.ic_estoque_venda_produto,
    ic_venda_saldo_negativo      = pa.ic_venda_saldo_negativo,
    ic_controle_desconto_produto = pa.ic_controle_desconto_produto,
    ic_fechamento_mensal_produto = pa.ic_fechamento_mensal_produto,
    ic_reserva_estoque_produt    = pa.ic_reserva_estoque_produt,
    ic_fechamento_mensal_prod    = pa.ic_fechamento_mensal_prod,
    ic_controle_desconto_prod    = pa.ic_controle_desconto_prod,
    ic_smo_produto               = pa.ic_smo_produto,
    ic_atualiza_custo_nf         = pa.ic_atualiza_custo_nf,
    ic_mat_prima_produto         = pa.ic_mat_prima_produto,
    ic_deducao_imposto           = pa.ic_deducao_imposto,
    ic_custo_moeda_produto       = pa.ic_custo_moeda_produto,
    cd_moeda                     = pa.cd_moeda,
    vl_custo_producao_produto    = pa.vl_custo_producao_produto

  from
    produto_custo pc
    inner join #produto_custo_alteracao pa on pa.cd_produto = pc.cd_produto


  DROP TABLE #produto_custo_alteracao

end


--Somente atualiza os flags mais importantes

if @ic_parametro=3
begin
  update
    produto_custo
  set  ic_peps_produto              = 'S',
       ic_lista_preco_produto       = 'S',
       ic_lista_rep_produto         = 'S',
       ic_reposicao_produto         = 'S',
       ic_estoque_produto           = 'S',
       ic_reserva_estoque_produto   = 'S',
       ic_fechamento_mensal_produto = 'S',
       ic_reserva_estoque_produt    = 'S',
       ic_fechamento_mensal_prod    = 'S',
       ic_atualiza_custo_nf         = 'S',
       ic_estoque_fatura_produto    = 'S'
  from
    produto

end

