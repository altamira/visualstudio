
create function fn_GetQtdDiaUtilPeriodo
(@dt_inicial datetime,
 @dt_final datetime,
 @ic_tipo_agenda char(1)) 
returns int


-------------------------------------------------------------------------------
--fn_GetQtdDiaUtilPeriodo
-------------------------------------------------------------------------------
--GBS - Global Business Solution LTDA           	                   2004
-------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Retorna a Quantidade de Dias Úteis
--Data			: 20/11/2003 
--Atualizado            : 04/12/2004 - Carlos
--                      : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--------------------------------------------------------------------------------

as
begin
  declare @dias as int

  select @dias = count(dt_agenda)
  from agenda
  where
    dt_agenda between @dt_inicial and @dt_final and
    case @ic_tipo_agenda
      when 'U' then ic_util
      when 'F' then ic_financeiro 
      when 'V' then ic_plantao_vendas
      when 'I' then ic_fiscal
      when 'O' then ic_fabrica_operacao
    end = 'S'

  return(@dias)
end

--------------------------------------------------------------------------------
--Example to execute function
--------------------------------------------------------------------------------
--Select * From fn_GetQtdDiaUtilPeriodo
