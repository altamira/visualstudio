

create procedure pr_atualiza_extrato_banco
@dt_extrato_banco        datetime,
@nm_extrato_banco        varchar(40),
@vl_extrato_banco        varchar(23)

as

declare @dt_usuario datetime
set @dt_usuario = getdate()

insert Extrato_Bancario 
values
 (
  1,
  null,
  null,
  1,
  1,
  cast(@dt_extrato_banco as datetime),
  @nm_extrato_banco,
  --cast( replace (@vl_extrato_banco,',','.') as float),
   convert(float,replace (@vl_extrato_banco,',','.')),

  1,
  @dt_usuario
   
  )

