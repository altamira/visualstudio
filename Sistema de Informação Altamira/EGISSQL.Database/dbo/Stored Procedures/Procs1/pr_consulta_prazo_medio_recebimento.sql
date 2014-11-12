

/****** Object:  Stored Procedure dbo.pr_consulta_prazo_medio_recebimento    Script Date: 13/12/2002 15:08:23 ******/
Create procedure pr_consulta_prazo_medio_recebimento
@dt_inicial DateTime,
@dt_final   DateTime
as

  Select
    DATEDIFF ( dd , dt_emissao_documento,
               dt_vencimento_documento ) as cd_dias,
    vl_documento_receber as vl_documento,
    Cast(null as float) as vl_calculo_media,
    Cast(null as float) as pc_total_documento,
    Cast(null as float) as pc_media_ponderada
  into
    #Valores
  from 
    Documento_Receber
  where 
    dt_cancelamento_documento is null and
    dt_emissao_documento Between @dt_inicial and @dt_final


  select 
    cd_dias,
    SUM(vl_documento)   as vl_documento,
    Cast(null as float) as vl_calculo_media,
    Cast(null as float) as pc_total_documento,
    Cast(null as float) as pc_media_ponderada
  Into
-- select * from
     #ValoresI
  From
    #Valores
  Group by
    cd_dias

  select 
    cd_dias,
    vl_documento,
    SUM(cd_dias * vl_documento) as vl_calculo_media,
    Cast(null as float) as pc_total_documento,
    Cast(null as float) as pc_media_ponderada
  Into
-- select * from
    #Valores_OK
  From
    #ValoresI
  Group by
    cd_dias,
    vl_documento

  Declare @vl_total_documento as decimal(25,3)
  Declare @vl_total_calculo as decimal(25,3)
  Declare @cd_total_dias as float
  Declare @cd_percentual as decimal(25,3)

  
  Select 
    @vl_total_calculo   = Sum(vl_calculo_media),
    @vl_total_documento = Sum(vl_documento),
    @cd_total_dias      = Sum(cd_dias)
  From
    #Valores_OK


  Set @cd_percentual = (@vl_total_calculo / @cd_total_dias)

  select 
    cd_dias,
    vl_documento,
    @vl_total_documento as vl_total_documento,
    vl_calculo_media,
    Cast(((vl_documento /@vl_total_documento)* 100) as numeric(25,3)) pc_total_documento,
    @cd_percentual as pc_media_ponderada
  from 
    #Valores_OK
  Order by 
    cd_dias



