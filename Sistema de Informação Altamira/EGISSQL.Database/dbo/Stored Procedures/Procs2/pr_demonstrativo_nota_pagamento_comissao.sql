
-------------------------------------------------------------------------------
--sp_helptext pr_demonstrativo_nota_pagamento_comissao
-------------------------------------------------------------------------------
--pr_demonstrativo_nota_pagamento_comissao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : demonstrativo de comissão por período e Nota Fiscal
--
--Data             : 16.09.2010
--Alteração        : 
--
-- 03.11.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_demonstrativo_nota_pagamento_comissao
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

declare @qt_ano int
--declare @qt_mes int

set @qt_ano = year(@dt_final)
--set @qt_mes = month(@dt_final)

--select * from vw_faturamento

select
  distinct

--  vw.cd_nota_saida,

  case when isnull(vw.cd_identificacao_nota_saida,0)>0 then
     vw.cd_identificacao_nota_saida
  else
     vw.cd_nota_saida                  
  end                                as 'cd_nota_saida',

  vw.dt_nota_saida,
  vw.nm_razao_social_nota,
  vw.nm_fantasia_destinatario,
  cast(vw.vl_total as decimal(25,2)) as vl_total,
  vw.nm_vendedor_externo,
  vw.cd_mascara_operacao,
  cp.nm_condicao_pagamento,

  qtd_parcela = isnull( ( select count(*)
    from
      nota_saida_parcela nsp with (nolock) 
    where
      nsp.cd_nota_saida = vw.cd_nota_saida) ,0),


   0.00                          as vl_pis,
   0.00                          as vl_cofins,
   0.00                          as vl_frete,

   cast(nsc.vl_icms_comissao_nota as decimal(25,2))     as vl_icms_comissao_nota,
   cast(nsc.vl_red_piscofins_comissao as decimal(25,2)) as vl_red_piscofins,
   cast(nsc.vl_ipi_comissao_nota as decimal(25,2))      as vl_ipi,

   vw.vl_total - ( 

   cast(nsc.vl_icms_comissao_nota as decimal(25,2))    +
   cast(nsc.vl_red_piscofins_comissao as decimal(25,2))+
   cast(nsc.vl_ipi_comissao_nota as decimal(25,2))    )  as vl_liquido,

   cast(nsc.vl_base_comissao_nota as decimal(25,2))     as vl_base_comissao,
   nsc.pc_comissao_nota                                 as pc_comissao,
   
   isnull(vp.pc_emissao_nota_comissao,0)                as pc_emissao_nota_comissao,

   (cast(nsc.vl_base_comissao_nota as decimal(25,2)) * (isnull(vp.pc_emissao_nota_comissao,0)/100)*
   (nsc.pc_comissao_nota/100))                                                                      as vl_comissao_emissao,

   isnull(vp.pc_baixa_comissao,0)                                                                  as pc_baixa_comissao,

   (vw.vl_total - ( 

   cast(nsc.vl_icms_comissao_nota as decimal(25,2))    +
   cast(nsc.vl_red_piscofins_comissao as decimal(25,2))+
   cast(nsc.vl_ipi_comissao_nota as decimal(25,2))    )  )*(isnull(vp.pc_baixa_comissao,0)/100)
   * (nsc.pc_comissao_nota /100)
                                                                                                   as vl_comissao_baixa,

  ( select max(d.dt_vencimento_documento)
    from
      documento_receber d with (nolock) 
    where
      d.cd_nota_saida = vw.cd_nota_saida )
  as 'Data Prevista'
  


-- into
--   #Total_Comissao

--select * from vw_faturamento

from
  vw_faturamento vw                       with (nolock) 
  left outer join condicao_pagamento cp   with (nolock) on cp.cd_condicao_pagamento = vw.cd_condicao_pagamento
  left outer join vendedor_parametro vp   with (nolock) on vp.cd_vendedor           = vw.cd_vendedor
  left outer join Nota_Saida_Comissao nsc with (nolock) on nsc.cd_nota_saida        = vw.cd_nota_saida

--select * from nota_saida_comissao

--   left outer join nota_saida_item  nsi  with (nolock) on nsi.cd_nota_saida       = vw.cd_nota_saida and
--                                                          nsi.cd_item_nota_saida  = vw.cd_item_nota_saida


where
  vw.dt_nota_saida between @dt_inicial and @dt_final
  and isnull(vw.ic_comercial_operacao,'N')='S'
  --Status da Nota Fiscal 
  and (isnull(vw.cd_status_nota,1) = 5 or isnull(vw.cd_status_nota,1) = 3)
  and ( vw.ic_analise_op_fiscal    = 'S' )    --Verifica apenas as operações fiscais selecionadas para o BI
  and ( vw.cd_tipo_operacao_fiscal = 2 )      --and     --Desconsiderar notas de entrada

order by
  --nsc.pc_comissao_nota,
  vw.dt_nota_saida


