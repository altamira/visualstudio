
-------------------------------------------------------------------------------
--pr_gera_calculo_pis_cofins_item_nota
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Acerto do Cálculo do PIS/COFINS DO ITEM DA NOTA
--                   
--Data             : 02.03.2006
--Atualizado       : 04.10.2007 - Ajustes Gerais - Carlos Fernandes
-------------------------------------------------------------------------------
create procedure pr_gera_calculo_pis_cofins_item_nota
@dt_inicial datetime,
@dt_final   datetime

as

--select * from imposto_aliquota

declare @pis    as float
declare @cofins as float

select @pis    = (isnull(pc_imposto,0) / 100) from IMPOSTO_ALIQUOTA where cd_imposto = 5
select @cofins = (isnull(pc_imposto,0) / 100) from IMPOSTO_ALIQUOTA where cd_imposto = 4

if @pis = 0
begin
   set @pis = 1.65/100
end

if @cofins = 0
begin
   set @cofins = 7.60/100
end

--select @pis,@cofins

-- select
--   n.cd_nota_saida,
--   n.dt_nota_saida,
--   ni.vl_cofins,
--   ni.vl_pis  
-- from
--   Nota_Saida n
--   inner join Nota_Saida_Item ni on ni.cd_nota_saida = n.cd_nota_saida
-- where
--   n.dt_nota_saida between @dt_inicial and @dt_final
-- 

--Geração do Cálculo

Update 
   Nota_saida_item
 set 
   vl_cofins = round((vl_total_item * @cofins),2),
   vl_pis    = round((vl_total_item * @pis),2)
from
  Nota_Saida n
  inner join Nota_Saida_Item ni on ni.cd_nota_saida = n.cd_nota_saida
where
  n.dt_nota_saida between @dt_inicial and @dt_final

--Atualização no Corpo da Nota Fiscal

select
  ns.cd_nota_saida,
  vl_pis    = sum( isnull(i.vl_pis   ,0) ),
  vl_cofins = sum( isnull(i.vl_cofins,0) )
into
  #Nota
from
  Nota_Saida_item i
  inner join Nota_Saida ns on ns.cd_nota_saida = i.cd_nota_saida
where
  ns.dt_nota_saida between @dt_inicial and @dt_final
group by
  ns.cd_nota_saida

-- select
--   *
-- from
--   #Nota

update 
  Nota_Saida
set
  vl_pis    = isnull(i.vl_pis   ,0 ),
  vl_cofins = isnull(i.vl_cofins,0 )
from
  Nota_Saida ns
  inner join #Nota i on ns.cd_nota_saida = i.cd_nota_saida
where
  ns.dt_nota_saida between @dt_inicial and @dt_final
  
