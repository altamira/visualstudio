
---------------------------------------------------------------------------------------
--fn_saldo_imposto_nota_retencao
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2006
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo		: Funçao para Cálculo do Saldo de Nota Fiscal não Destacada 
--                        Imposto
--
--Data			: 20.07.2006
--Atualização           : 20.07.2006
---------------------------------------------------------------------------------------

create FUNCTION fn_saldo_imposto_nota_retencao
(@cd_cliente    int      = 0,
 @dt_inicial    datetime = '',
 @dt_final      datetime = '',
 @cd_nota_saida int      = 0)

returns float

as

begin

  declare @vl_saldo_cliente float

  set @vl_saldo_cliente = 0

  select
    @vl_saldo_cliente = sum( isnull(ns.vl_total,0) )
  from
    Nota_Saida ns with (nolock)
    left outer join Operacao_Fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where
    ns.cd_cliente = case when @cd_cliente = 0 then ns.cd_cliente else @cd_cliente end and
    ns.dt_nota_saida between @dt_inicial and @dt_final  and
    isnull(ns.ic_imposto_nota_saida,'N') = 'N'          and      --Nota Fiscal Não Destacado / Imposto
    ns.dt_cancel_nota_saida is null                     and
    isnull(opf.ic_servico_operacao,'N') = 'S'           and      --Operação Fiscal de Serviço
    ns.cd_nota_saida <> case when @cd_nota_saida = 0 then 0 else @cd_nota_saida end 

  return isnull(@vl_saldo_cliente,0)

end
 
 
