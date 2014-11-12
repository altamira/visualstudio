  
CREATE FUNCTION fn_juros_documento_receber
(@cd_documento_receber int,
 @dt_base              datetime )

RETURNS float


AS
BEGIN 

  declare @vl_juros          float 
  declare @vl_total          float 
  declare @pc_taxa_juros     float
  declare @dt_base_documento datetime

  set @pc_taxa_juros = 0.00
  set @vl_juros      = 0.00
  set @vl_total      = 0.00

  select
    @pc_taxa_juros = isnull(pc_juro_empresa,0) 
    --isnull(pc_juro_empresa,0) 
  from
    EgisAdmin.dbo.Empresa
  where
    cd_empresa = dbo.fn_empresa()

  --Verifica se existe baixa parcial do documento------------------------------

  select
    @dt_base_documento = max(dp.dt_pagamento_documento)
  from
    documento_receber_pagamento dp with (nolock) 
  where
    dp.cd_documento_receber = @cd_documento_receber  
  group by
    dp.cd_documento_receber
 
   select
     @vl_juros = isnull(d.vl_saldo_documento,0) * ( ( (@pc_taxa_juros / 100) / 30) * (cast( @dt_base - case when @dt_base_documento is null then d.dt_vencimento_documento else @dt_base_documento end as int) )  ) 
   from
     documento_receber d with (nolock) 
   where
     d.cd_documento_receber = @cd_documento_receber
     and d.dt_vencimento_documento < @dt_base 
     and isnull(d.vl_saldo_documento,0) >0

  --Retorno do Valor 
  return(@vl_juros)

end
   
  
