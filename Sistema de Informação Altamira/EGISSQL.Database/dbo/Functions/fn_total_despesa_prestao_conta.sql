
---------------------------------------------------------------------------------------
--sp_helptext fn_total_despesa_prestao_conta
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2008
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo		: Cálculo do Total das Despesas da Prestação de Contas
-- 
--Data			: 28.04.2008
--Atualização           : 11.08.2008 - Verificação - Carlos Fernandes
---------------------------------------------------------------------------------------

create FUNCTION fn_total_despesa_prestao_conta
( @cd_prestacao int )
returns decimal(25,4)

as

begin

  declare @vl_total_despesa decimal(25,4)

  set @vl_total_despesa = 0 

  --select * from prestacao_conta_composicao
  --select * from tipo_despesa

  if @cd_prestacao>0 
  begin
    select
      @vl_total_despesa = sum( isnull(pcc.vl_total_despesa,0) ) 
    from
      prestacao_conta_composicao pcc with (nolock) 
      inner join tipo_despesa td     with (nolock) on td.cd_tipo_despesa = pcc.cd_tipo_despesa
    where
      pcc.cd_prestacao = @cd_prestacao
      and isnull(td.ic_reembolsavel_despesa,'S') = 'S'

  end

  return  @vl_total_despesa

end


