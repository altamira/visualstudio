
--sp_helptext pr_geracao_estoque_minimo_consumo

-------------------------------------------------------------------------------
--pr_geracao_estoque_minimo_consumo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 28.04.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_estoque_minimo_consumo
--@cd_produto int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = '',
@qt_fator   int      = 1

as

update
  produto_saldo
set
  qt_minimo_produto = round(isnull(dbo.fn_consumo_medio(cd_fase_produto,cd_produto,@dt_inicial,@dt_final ),0) 
                      * case when isnull(@qt_fator,0) = 0 then 1 else @qt_fator end,2)
where
  isnull(ic_fixo_estoque_minimo,'N')='N'

-- select *,dbo.fn_consumo_medio(cd_fase_produto,cd_produto,@dt_inicial,@dt_final )
-- from produto_saldo where cd_produto = 263


