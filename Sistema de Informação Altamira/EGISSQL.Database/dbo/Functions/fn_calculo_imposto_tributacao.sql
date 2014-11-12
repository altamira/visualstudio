
---------------------------------------------------------------------------------------
--fn_calculo_imposto_tributacao
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2010
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo		: Busca se o Imposto é Calculo de acordo com a Tributação
--
--Data			: 01.03.2010
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_calculo_imposto_tributacao

(@cd_imposto    int      = 0,
 @cd_tributacao int      = 0 )

returns char(1)

begin

declare @ic_calculo_imposto char(1)

select
--  i.cd_imposto,
--  i.sg_imposto                     as Imposto, 
--  ct.cd_tributacao,
  @ic_calculo_imposto = isnull(ct.ic_evento_tributacao,'S')
--  et.cd_evento_tributacao,
--  et.sg_evento_tributacao          as Evento
from 
  Imposto i                WITH(NOLOCK), 
  Composicao_tributacao ct WITH(NOLOCK),
  Evento_tributacao et     WITH(NOLOCK)
where
   isnull(i.ic_nota_imposto,'N') ='S' and
   i.cd_imposto            = @cd_imposto and   --Imposto     (Variável)
   i.cd_imposto            = ct.cd_imposto  and
   ct.cd_tributacao        = @cd_tributacao and   --Tributacao  (Variável) 
   ct.cd_evento_tributacao = 1 and   --Evento      (Fixo)
   ct.cd_evento_tributacao *= et.cd_evento_tributacao

return ( @ic_calculo_imposto )

end

