
---------------------------------------------------------------------------------------
--sp_helptext fn_primeiro_dia_proximo_mes
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2010
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo		: Gera o Primeiro dia do próximo mês
--                        Utilização na Geração de Data para Parcela - Condição de Pagamento
--
--Data			: 02.11.2010
--Atualização           : 02.11.2010
---------------------------------------------------------------------------------------

create FUNCTION fn_primeiro_dia_proximo_mes

(@Data    datetime      = '' )

returns DATETIME

as

begin

declare @Data_Aux as Datetime

Set @Data_Aux = @Data + (31 - Day(@Data))

  if Month(@Data_Aux) <> Month(@Data) 
    set @Data_Aux = @Data_Aux - Day(@Data_Aux);

  set @Data_Aux = @Data_Aux + 1

return @Data_Aux

end

