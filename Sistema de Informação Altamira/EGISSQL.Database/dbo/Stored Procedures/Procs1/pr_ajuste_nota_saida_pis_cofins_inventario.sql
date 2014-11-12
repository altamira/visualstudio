
CREATE PROCEDURE pr_ajuste_nota_saida_pis_cofins_inventario

------------------------------------------------------------------------------------
--sp_helptext pr_ajuste_nota_saida_pis_cofins_inventario
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo	        : Ajuste do Pis / Cofins dos Itens das Notas Fiscais de Saída
--Data                  : 18.08.2005  
--Atualização           : 06.03.2006
--                      : 22.03.2007 - Ajustes Diversos - Carlos Fernandes
--                      : 24.03.2007 - Verificação - Carlos Fernandes
--                      : 26.03.2007 - Dedução do IPI - Carlos Fernandes
--                      : 27.03.2007 - Cálculo do PIS/COFINS - Carlos Fernandes
-- 20.11.2009 - Nota Fiscal de Saída - Desenvolvimento
-- 05.05.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------------
@ic_parametro int = 0,
@dt_inicial   datetime,
@dt_final     datetime,
@ic_icms      char(1) = 'N'
as

declare @pc_pis    decimal(12,2)
declare @pc_cofins decimal(12,2)

set @pc_pis    = 1.65
set @pc_cofins = 7.60

--select * from nota_saida_item
select
  ns.cd_nota_saida,
  ns.dt_nota_saida
into
  #CalculoNota
from
  nota_saida ns
  left outer join operacao_fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal

where
 ns.dt_nota_saida between @dt_inicial and @dt_final
 and
 ( isnull(opf.ic_pis_operacao_fiscal,'N') = 'S' or isnull(opf.ic_cofins_operacao_fiscal,'N') = 'S' )



update
  nota_saida_item
set
  pc_cofins = @pc_cofins,
  pc_pis    = @pc_pis,
  vl_cofins = vl_total_item * (@pc_cofins/100),
  vl_pis    = vl_total_item * (@pc_pis/100)
from
  nota_saida_item i
where
  i.cd_nota_saida in ( select cd_nota_saida from #CalculoNota )


--montagem de uma tabela auxiliar calculado

select
  n.cd_nota_saida,
  vl_pis    = sum(i.vl_pis),
  vl_cofins = sum(i.vl_cofins)
into #AuxCalculo
from
  nota_saida n
  inner join nota_saida_item i on i.cd_nota_saida = n.cd_nota_saida
where
  n.cd_nota_saida in ( select cd_nota_saida from #CalculoNota )
group by
  n.cd_nota_saida

update
  nota_saida
set
  vl_pis    = c.vl_pis,
  vl_cofins = c.vl_cofins
from
  nota_saida n
  inner join nota_saida_item i on i.cd_nota_saida = n.cd_nota_saida
  inner join #AuxCalculo     c on c.cd_nota_saida = n.cd_nota_saida
where
  n.cd_nota_saida in ( select cd_nota_saida from #CalculoNota )

--select * from nota_saida

