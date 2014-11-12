
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_carga
-------------------------------------------------------------------------------
--pr_resumo_carga
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo de Carga
--Data             : 03.10.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_resumo_carga
@ic_parametro int      = 0,
@cd_veiculo   int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

--select * from nota_saida

------------------------------------------------------------------------------
--Resumo
------------------------------------------------------------------------------


if @ic_parametro = 1 
begin

  select
------------------------------
   cast(' ' as varchar) as nm_fantasia_vendedor,
   0         as cd_vendedor,
   0         as cd_nota_saida,
   getdate() as dt_nota_saida,
   cast(' ' as varchar) as nm_fantasia_nota_saida,
   cast(' ' as varchar) as nm_razao_social_nota,
   0.0       as vl_total,
   cast(' ' as varchar) as     sg_condicao_pagamento,
   cast(' ' as varchar) as     nm_forma_pagamento,
   cast(' ' as varchar) as     nm_endereco,
   cast(' ' as varchar) as     nm_bairro_nota_saida,
   cast(' ' as varchar) as     nm_cidade_nota_saida,
   cast(' ' as varchar) as     sg_estado_nota_saida,
   cast(' ' as varchar) as     cd_cep_nota_saida,
   0  as     cd_pedido_venda,
------------------------------
    v.cd_veiculo,
    max(v.nm_veiculo)         as nm_veiculo,
    count( ns.cd_nota_saida ) as qt_nota,
    sum( ns.vl_total )        as vl_total_nota
    
  into
    #Resumo_Veiculo
  from 
    nota_saida ns              with (nolock) 
    left outer join Veiculo v  with (nolock) on v.cd_veiculo = ns.cd_veiculo
  where
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.cd_veiculo   = case when @cd_veiculo = 0 then ns.cd_veiculo else @cd_veiculo end and
    ns.dt_cancel_nota_saida is null
  group by
    v.cd_veiculo

  declare @vl_total_nota float
  set @vl_total_nota = 0.00

  select
    @vl_total_nota = sum( vl_total_nota )
  from
    #Resumo_Veiculo

  select
    *,
    pc_veiculo = ( vl_total_nota / @vl_total_nota ) * 100
  from
    #Resumo_Veiculo
  order by
    nm_veiculo

end


------------------------------------------------------------------------------
--Analítico
------------------------------------------------------------------------------

else
begin

select
--------------------------
  v.cd_veiculo,
  0   as qt_nota,
  0.0 as vl_total_nota,
  0.0 as pc_veiculo,
--------------------------   
  v.nm_veiculo,
  ve.nm_fantasia_vendedor,
  ns.cd_vendedor,
  ns.cd_nota_saida,
  ns.dt_nota_saida,
  ns.nm_fantasia_nota_saida,
  ns.nm_razao_social_nota,
  ns.vl_total,
  cp.sg_condicao_pagamento,
  fp.nm_forma_pagamento,
  ns.nm_endereco_nota_saida+', '+cd_numero_end_nota_saida as nm_endereco,
  ns.nm_bairro_nota_saida,
  ns.nm_cidade_nota_saida,
  ns.sg_estado_nota_saida,
  ns.cd_cep_nota_saida,
  ( select top 1 cd_pedido_venda from nota_saida_item 
    where
      cd_nota_saida = ns.cd_nota_saida ) as cd_pedido_venda
from 
  nota_saida ns  with (nolock)
  left outer join Veiculo V             on v.cd_veiculo             = ns.cd_veiculo
  left outer join Vendedor ve           on ve.cd_vendedor           = ns.cd_vendedor
  left outer join Condicao_Pagamento cp on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
  left outer join Operacao_fiscal opf   on opf.cd_operacao_fiscal   = ns.cd_operacao_fiscal
  left outer join Forma_Pagamento fp    on fp.cd_forma_pagamento    = ns.cd_forma_pagamento
where
  ns.dt_nota_saida between @dt_inicial and @dt_final                                      and
  ns.cd_veiculo   = case when @cd_veiculo = 0 then ns.cd_veiculo else @cd_veiculo end and
  ns.dt_cancel_nota_saida is null
order by
  ns.cd_veiculo,
  ns.nm_fantasia_nota_saida 
 
end

