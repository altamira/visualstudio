
-----------------------------------------------------------------------------------
--pr_balanco_patrimonial
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure    : SQL Server Microsoft 2000
--Autor (es)          : Carlos Cardoso Fernandes         
--Banco Dados         : EGISSQL
--Objetivo            : Balanço Patrimonial
--Data                : 02.05.2001
--Atualizado          : 10.07.2001
--                    : 27.12.2004
--                    : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-----------------------------------------------------------------------------------
create procedure pr_balanco_patrimonial
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_grau_conta int


--Carregar Dados da Tabela Parâmetro Contábil

set @qt_grau_conta = 3 --


select
  pc.cd_conta,
  gc.cd_grupo_conta,
  gc.nm_grupo_conta,
  pc.cd_mascara_conta,
  pc.nm_conta,
  pc.ic_conta_balanco,
  pc.qt_grau_conta,
  sc.vl_saldo_conta,
  sc.ic_saldo_conta  
from
  Grupo_Conta gc, 
  Plano_Conta pc,
  Saldo_Conta sc
where
  isnull(gc.ic_balanco_grupo_conta,'N') = 'S' and
  gc.cd_grupo_conta = pc.cd_grupo_conta       and
  isnull(pc.ic_conta_balanco,'N')       = 'S' and
  pc.qt_grau_conta  <= @qt_grau_conta         and
  pc.cd_conta *= sc.cd_conta                  and
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

