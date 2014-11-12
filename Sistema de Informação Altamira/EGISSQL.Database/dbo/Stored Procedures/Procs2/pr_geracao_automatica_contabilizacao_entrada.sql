
--sp_helptext pr_geracao_automatica_contabilizacao_entrada

-------------------------------------------------------------------------------
--pr_geracao_automatica_contabilizacao_entrada
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Tabela de Contabilização de Notas Fiscais
--Data             : 19.12.2006
--Alteração        : 02.01.2007
--                 : 22.03.2007 - Verificação Geral
------------------------------------------------------------------------------
create procedure pr_geracao_automatica_contabilizacao_entrada
@dt_inicial          datetime = '',
@dt_final            datetime = '',
@cd_usuario          int      = 0,
@cd_nota_entrada_aux int      = 0
as

--Ajusta PIS/COFINS

exec pr_ajuste_nota_entrada_pis_cofins_inventario 1,@dt_inicial,@dt_final,'N'

select
  cd_nota_entrada,
  cd_fornecedor,
  cd_operacao_fiscal,
  cd_serie_nota_fiscal,
  dt_receb_nota_entrada
into
  #AuxNotaEntradaContabil
from
  Nota_Entrada e
where
  e.cd_nota_entrada = case when @cd_nota_entrada_aux=0 then e.cd_nota_entrada else @cd_nota_entrada_aux end and
  e.dt_receb_nota_entrada between @dt_inicial and @dt_final

--select * from nota_entrada
--select * from #AuxNotaEntradaContabil

declare @cd_nota_entrada    int
declare @cd_fornecedor      int
declare @cd_operacao_fiscal int
declare @cd_serie_nota_fiscal int

while exists ( select top 1 cd_nota_entrada from #AuxNotaEntradaContabil )
begin

  select
    top 1
    @cd_nota_entrada      = cd_nota_entrada,
    @cd_fornecedor        = cd_fornecedor,       
    @cd_operacao_fiscal   = cd_operacao_fiscal,   
    @cd_serie_nota_fiscal = cd_serie_nota_fiscal
  from
    #AuxNotaEntradaContabil     
  order by
    dt_receb_nota_entrada

  --Gera a Contabilização
    exec pr_gerar_contabilizacao_entrada
         1, @cd_nota_entrada,@cd_fornecedor, @cd_operacao_fiscal,@cd_serie_nota_fiscal,@cd_usuario 


  delete from #AuxNotaEntradaContabil 
  where
    cd_nota_entrada      = @cd_nota_entrada      and
    cd_fornecedor        = @cd_fornecedor        and
    cd_operacao_fiscal   = @cd_operacao_fiscal   and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal


end

-- exec pr_gerar_contabilizacao_entrada
-- @ic_parametro = 1,
-- @cd_nota_entrada = 15288,
-- @cd_fornecedor = 7885,
-- @cd_operacao_fiscal = 741,
-- @cd_serie_nota_fiscal = 1,
-- @cd_usuario = 0

