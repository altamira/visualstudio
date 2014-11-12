
---------------------------------------------------------------------------------------
--fn_nota_retencao_imposto_periodo
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2006
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo		: Funçao para Busca de Nota Fiscal já Destacada o Imposto
--                        porque a partir desta nota fiscal, todas terão retenção
--                        independente do valor do Teto de cálculo
--
--Data			: 20.07.2006
--Atualização           : 24.07.2006
--25.06.2008 - Ajustes Diversos - Carlos Fernandes
---------------------------------------------------------------------------------------

create FUNCTION fn_nota_retencao_imposto_periodo
(@cd_cliente    int      = 0,
 @dt_inicial    datetime = '',
 @dt_final      datetime = '',
 @cd_nota_saida int      = 0)

returns varchar

as

begin

  declare @ic_nota_imposto char(1)

  set @ic_nota_imposto = 'N'

  select
    top 1
    @ic_nota_imposto = isnull(ic_imposto_nota_saida,@ic_nota_imposto )
  from
    Nota_Saida ns with (nolock)
    left outer join Operacao_Fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where
    ns.cd_cliente = case when @cd_cliente = 0 then ns.cd_cliente else @cd_cliente end and
    ns.dt_nota_saida between @dt_inicial and @dt_final  and
    isnull(ns.ic_imposto_nota_saida,'N') = 'S'          and      --Nota Fiscal Não Destacado / Imposto
    ns.dt_cancel_nota_saida is null                     and
    isnull(opf.ic_servico_operacao,'N') = 'S'           and      --Operação Fiscal de Serviço
    ns.cd_nota_saida <> case when @cd_nota_saida = 0 then 0 else @cd_nota_saida end 
  order by
    ns.dt_nota_saida desc
 
  return isnull(@ic_nota_imposto,'N')

end
 
 
