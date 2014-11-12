
create procedure pr_registro_linha_faturamento_mes
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_linha_faturamento int

set @qt_linha_faturamento = 0

select  
  @qt_linha_faturamento = count(cd_item_nota_saida)
from 
  vw_faturamento_bi
where
  dt_nota_saida between @dt_inicial and @dt_final  

--select * from carta_correcao

--Resultado

select 
  @qt_linha_faturamento as 'QtdLinhaFaturamentoMes'



