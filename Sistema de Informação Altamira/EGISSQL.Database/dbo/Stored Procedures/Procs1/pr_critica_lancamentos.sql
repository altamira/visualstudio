


/****** Object:  Stored Procedure dbo.pr_critica_lancamentos    Script Date: 13/12/2002 15:08:25 ******/
--pr_critica_lancamentos
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Crítica dos Lançamentos contábeis
--Data         : 01.06.2001
--Atualizado   : 05.03.2003 - Victor Dimitrov
--               Adição de novos parametros e adição de novos sistemas de busca
--               com os novos parâmetros                 
-----------------------------------------------------------------------------------
CREATE  procedure pr_critica_lancamentos
@ic_parametro         int,
@cd_empresa           int,
@cd_lancamento_inicial int, -- 05.03.2003 - Victor Dimitrov
@cd_lancamento_final int, -- 05.03.2003 - Victor Dimitrov
@cd_lote_inicial int, -- 05.03.2003 - Victor Dimitrov
@cd_lote_final int, -- 05.03.2003 - Victor Dimitrov
@dt_inicial_exercicio datetime,
@dt_final_exercicio   datetime

as
select
    a.dt_lancamento_contabil as 'Data',
    a.cd_lancamento_contabil as 'Lancamento',
    a.cd_reduzido_debito        as 'debito',
    a.cd_reduzido_credito       as 'credito',
    a.vl_lancamento_contabil as 'Valorlancamento',
    a.cd_historico_contabil  as 'Codhis',
    a.ds_historico_contabil  as 'Historico',
    a.cd_lote as 'Lote'                                
from
    Movimento_contabil a
where
   (a.cd_empresa = @cd_empresa) and
   (a.dt_lancamento_contabil between @dt_inicial_exercicio and @dt_final_exercicio) and
   (a.cd_lancamento_contabil between @cd_lancamento_inicial and @cd_lancamento_final) and -- 05.03.2003 - Victor Dimitrov
   (a.cd_lote between @cd_lote_inicial and @cd_lote_final) -- 05.03.2003 - Victor Dimitrov 
order by
   a.dt_lancamento_contabil      



