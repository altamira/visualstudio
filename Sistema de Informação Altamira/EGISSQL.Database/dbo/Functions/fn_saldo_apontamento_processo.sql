
---------------------------------------------------------------------------------------
--fn_saldo_apontamento_processo
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Autor
--Banco de Dados	: EGISSQL 
--Objetivo		: Busca o Saldo para Apontamento de Uma Ordem de Produção
--
--Data			: 29.10.2008
--Atualização           : 29.10.2008
---------------------------------------------------------------------------------------

create FUNCTION fn_saldo_apontamento_processo
(@cd_processo int )
returns float

as

begin

declare @qt_planejada_processo float
declare @qt_apontamento        float
declare @qt_saldo_apontamento  float

select
  @qt_planejada_processo = isnull(pp.qt_planejada_processo,0) 
from
 processo_producao pp with (nolock)
where
 cd_processo = @cd_processo 

--select * from processo_producao_apontamento

select
  @qt_apontamento = sum ( isnull(qt_peca_boa_apontamento,0) - isnull(qt_peca_ruim_produzida,0) )
from
  processo_producao_apontamento ppa           with (nolock)
  inner join processo_producao_composicao ppc with (nolock) on ppc.cd_processo      = ppa.cd_processo AND
                                                               ppc.cd_item_processo = ppa.cd_item_processo


where
  ppa.cd_processo = @cd_processo and
  isnull(ppc.ic_movimenta_estoque,'N')='S'


set
  @qt_saldo_apontamento = @qt_planejada_processo - isnull(@qt_apontamento,0)

if @qt_saldo_apontamento < 0
   set @qt_saldo_apontamento = 0

return ( @qt_saldo_apontamento )

end

--select * from processo_producao_composicao
--select * from processo_producao_APONTAMENTO

