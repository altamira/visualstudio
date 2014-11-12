
--pr_meta_faturamento_empresa
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Lucio        
--Meta da Empresa do Período Selecionado
--Data          : 06.07.2001
--Atualizado    : 
--------------------------------------------------------------------------------------
create procedure pr_meta_faturamento_empresa

@dt_inicial datetime,
@dt_final   datetime

as

--Meta do Mês

select sum(a.vl_fat_meta_categoria )   as 'MetaFaturamentoMes' 
from
  SapSql.Dbo.Meta_Categoria_Produto a
WHERE
  a.dt_inicial_meta_categoria between @dt_inicial and @dt_final


