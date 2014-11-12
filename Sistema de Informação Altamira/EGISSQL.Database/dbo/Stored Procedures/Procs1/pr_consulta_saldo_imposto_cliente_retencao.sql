
-------------------------------------------------------------------------------
--pr_consulta_saldo_imposto_cliente_retencao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Notas Fiscais de Serviços com Saldo
--Data             : 09/12/2004
--Alteração        : 26.06.2008 - Ajustes Gerais - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_saldo_imposto_cliente_retencao
@cd_cliente int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from Nota_Saida
--select * from operacao_fiscal

select

  --ns.cd_nota_saida                      as Nota,

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida                              
  end                                   as Nota,

  ns.dt_nota_saida                      as Emissao,
  ns.nm_fantasia_nota_saida             as Cliente,
  ns.vl_total                           as Total,
  isnull(ns.ic_imposto_nota_saida,'N')  as Destacado,
  SaldoImposto = ( select dbo.fn_saldo_imposto_nota_retencao(ns.cd_cliente,@dt_inicial,@dt_final,0) ),
  isnull(vl_csll,0)                     as CSLL,
  isnull(vl_pis,0)                      as PIS,
  isnull(vl_cofins,0)                   as COFINS

from
  Nota_Saida ns                       with (nolock)
  left outer join Operacao_Fiscal opf with (nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
where
  ns.cd_cliente = case when @cd_cliente = 0 then ns.cd_cliente else @cd_cliente end and
  ns.dt_nota_saida between @dt_inicial and @dt_final  and
  ns.dt_cancel_nota_saida is null                     and
--  isnull(ns.ic_imposto_nota_saida,'N') = 'N'          and
  isnull(opf.ic_servico_operacao,'N')  = 'S'          --Operação Fiscal de Serviço

order by
  ns.nm_fantasia_nota_saida, 
  ns.dt_nota_saida desc

