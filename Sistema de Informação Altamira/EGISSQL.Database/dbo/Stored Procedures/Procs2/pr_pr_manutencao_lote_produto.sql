-----------------------------------------------------------------------------------
--pr_pr_manutencao_lote_produto
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2005                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Paulo Santos         
--Banco Dados      : EGISSQL
--Objetivo         : Manutenção do Cadastro de Lote
--Data             : 21.01.2005
-----------------------------------------------------------------------------------
create procedure pr_pr_manutencao_lote_produto

@cd_lote_produto int

as

select 
  lp.nm_lote_produto as Codigo,
  lp.nm_ref_lote_produto as Descricao,
  lp.cd_lote_produto as Lote,
  lp.ic_status_lote_produto as Status,
  lp.dt_entrada_lote_produto as Entrada,
  lp.dt_saida_lote_produto as Saida,
  lp.dt_inicial_lote_produto as ValidadeInicial,
  lp.dt_final_lote_produto as ValidadeFinal,
  lp.ic_inspecao_lote_produto as Inspecao,
  lp.ic_rastro_lote_produto as Rastreabilidade,
  pa.nm_pais as pais,
  lp.nm_obs_lote_produto as Observacao,
  lps.qt_saldo_atual_lote as SaldoAtual,
  lps.qt_saldo_reserva_lote as SaldoReserva
from 
  lote_produto lp 
left outer join pais pa
on lp.cd_pais = pa.cd_pais
left outer join lote_produto_saldo lps
on lp.cd_lote_produto = lps.cd_lote_produto

