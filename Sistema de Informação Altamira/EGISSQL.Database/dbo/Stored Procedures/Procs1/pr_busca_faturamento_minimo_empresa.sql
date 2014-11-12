
create procedure pr_busca_faturamento_minimo_empresa
as

declare @vl_faturamento_minimo float
set @vl_faturamento_minimo = 0

select 
    vl_fat_minimo_empresa as 'FaturamenoMinimo'
from
   Parametro_Faturamento
where
   cd_empresa = dbo.fn_empresa()

 
