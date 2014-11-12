-----------------------------------------------------------------------------------
--pr_demonstracao_resultado
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure    : SQL Server Microsoft 2000
--Autor (es)          : Carlos Cardoso Fernandes         
--Banco Dados         : EGISSQL
--Objetivo            : Demonstração de Resultado
--Data                : 02.05.2001
--Atualizado          : 10.07.2001
--                    : 27.12.2004
--                    : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-----------------------------------------------------------------------------------
create procedure pr_demonstracao_resultado
@dt_inicial datetime,
@dt_final   datetime

as

--Carregar Dados da Tabela Parâmetro Contábil
--select * from parametro_contabil

select
  pc.cd_conta as Conta,
  gc.cd_grupo_conta as Grupo,
  gc.nm_grupo_conta as Descricao_Grupo,
  pc.cd_mascara_conta as Classificacao,
  pc.nm_conta as Descricao_Conta,
  pc.ic_conta_balanco as ic_conta_balanco,
  pc.qt_grau_conta as Quantidade_Grau_Conta,
  sc.vl_saldo_conta as Saldo_Conta,
  sc.ic_saldo_conta as Tipo_Saldo
from
  Grupo_Conta gc, 
  Plano_Conta pc,
  Saldo_Conta sc
where
  isnull(gc.ic_resultado_grupo_conta,'N') = 'S' and
  gc.cd_grupo_conta = pc.cd_grupo_conta         and
  isnull(pc.ic_conta_resultado,'N')       = 'S' and
  pc.cd_conta *= sc.cd_conta                   and
  sc.dt_saldo_conta between @dt_inicial and @dt_final

group by 
  pc.cd_conta,
  gc.cd_grupo_conta,
  gc.nm_grupo_conta,
  pc.cd_mascara_conta,
  pc.nm_conta,
  pc.ic_conta_balanco,
  pc.qt_grau_conta,
  sc.vl_saldo_conta,
  sc.ic_saldo_conta

order by
  pc.cd_mascara_conta 

