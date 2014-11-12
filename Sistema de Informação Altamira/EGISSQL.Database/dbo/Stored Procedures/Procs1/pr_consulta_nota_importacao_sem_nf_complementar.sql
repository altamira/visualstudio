create procedure pr_consulta_nota_importacao_sem_nf_complementar
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Consulta das Notas de importacao sem invoice ou DI
--Data: 01.04.2004
---------------------------------------------------
@dt_inicial as DateTime,
@dt_final as DateTime
as
Begin

select
  i.cd_nota_saida,
  i.dt_nota_saida,
  i.nm_invoice,
  IsNull(cast(c.vl_total as decimal(15,2)),0) as vl_total_complementar,
  c.cd_nota_complementar
from
   --Notas de Importação
  (select
  	distinct 
  	nsi.cd_nota_saida,
	nsi.dt_nota_saida,
  	ltrim(rtrim(nm_invoice)) as nm_invoice
   from
  	Nota_Saida_Item 	nsi,
  	Nota_Saida 		ns,
  	Operacao_Fiscal     ofi
   where
  	ns.cd_nota_saida 	  = nsi.cd_nota_saida 	and
  	nsi.nm_invoice 	  is not null	and
  	ns.dt_nota_saida 	  between @dt_inicial and @dt_final and
  	ns.dt_cancel_nota_saida is null and
  	isnull(nsi.pc_ipi,0)    > 0 and
  	ns.cd_operacao_fiscal   = ofi.cd_operacao_fiscal and    
  	ofi.ic_importacao_op_fiscal = 'S') i
  left outer join 
  --Notas complementáres
  (select 
  	ns.cd_nota_saida as cd_nota_complementar,
  	ltrim(rtrim(substring(ns.ds_obs_compl_nota_saida, charindex('INVOICE', ns.ds_obs_compl_nota_saida) + 8, abs(charindex('DI',ns.ds_obs_compl_nota_saida) - (charindex('INVOICE', ns.ds_obs_compl_nota_saida) + 8))))) as nm_invoice,
  	ltrim(rtrim(substring(ns.ds_obs_compl_nota_saida, (charindex('DI', ns.ds_obs_compl_nota_saida) + 3), 13))) as nm_di,
  	ns.vl_total
   from 
  	nota_saida ns,
  	operacao_fiscal ofi,
  	grupo_operacao_fiscal gof
   where 
  	ns.cd_operacao_fiscal 			= ofi.cd_operacao_fiscal 	and
  	ofi.cd_grupo_operacao_fiscal 			= gof.cd_grupo_operacao_fiscal 	and
  	isnull(ofi.ic_complemento_op_fiscal,'N') 	= 'S' 			and
  	gof.cd_tipo_operacao_fiscal 			= 1 ) c
   on i.nm_invoice = c.nm_invoice
   where
	c.cd_nota_complementar is null
   order by 
     2,1
end
