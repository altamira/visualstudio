
-------------------------------------------------------------------------------
--sp_helptext pr_gera_nfe_linha_fatura
-------------------------------------------------------------------------------
--pr_gera_nfe_linha_fatura
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Gera a Linha da Nota Fiscal na Tabela Linha Fatura
--
--Data             : 29.11.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_nfe_linha_fatura
@cd_nota_saida int = 0,
@cd_usuario    int = 0
as

if @cd_nota_saida>0
begin

  declare @ds_linha_fatura varchar(8000)

  declare @p               varchar(256)
  declare @p1              varchar(256)
  declare @p2              varchar(256)
  declare @p3              varchar(256)
  declare @p4              varchar(256)
  declare @p5              varchar(256)
  declare @p6              varchar(256)
  declare @p7              varchar(256)
  declare @p8              varchar(256)
  declare @p9              varchar(256)

  set @ds_linha_fatura = ''
  set @p               = ''

  --Dados da Nota de Saída

  select 
    top 1
    @ds_linha_fatura = 
     'cobr><fat><nFat>' +
     isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') +
    '</nFat><vOrig>'        +
    isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') + 
    '</vOrig><vDesc>0.00</vDesc><vLiq>' +
    isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') + 
    '</vLiq></fat>'
  from 
    nota_saida ns with (nolock) 
  where
    ns.cd_nota_saida = @cd_nota_saida

  --deleta a linha da fatura

  delete from nota_saida_fatura
  where
     cd_nota_saida = @cd_nota_saida


  --gera a linha 

  declare @cd_parcela_nota_saida int

  select
    cd_parcela_nota_saida,
    cd_ident_parc_nota_saida,
    dt_parcela_nota_saida,
    vl_parcela_nota_saida
  into
    #Parcela
  from
    nota_saida_parcela 
  where
    cd_nota_saida = @cd_nota_saida

  select * from #Parcela

  while exists( select top 1 cd_parcela_nota_saida from #Parcela)
  begin
    set @p = ''

    select top 1
       @cd_parcela_nota_saida  = cd_parcela_nota_saida,
       @p                      = @p

       +
       
       '<dup><nDup>'+ltrim(rtrim(isnull( cd_ident_parc_nota_saida,'') ) )+
       '</nDup><dVenc>'+
	        isnull(ltrim(rtrim(replace(convert(char,dt_parcela_nota_saida,102),'.','-'))),'') +
       '</dVenc><vDup>'+
        ltrim(rtrim(isnull(CONVERT(varchar, convert(numeric(14,2),
                                   round(case when vl_parcela_nota_saida > 0 
                                         then vl_parcela_nota_saida 
                                         else null end,6,2)),103),'0.00'))) +
       '</vDup></dup>' 
    from
       #Parcela

    if @cd_parcela_nota_saida = 1
       set @p1 = @p

    if @cd_parcela_nota_saida = 2
       set @p2 = @p

    if @cd_parcela_nota_saida = 3
       set @p3 = @p

    if @cd_parcela_nota_saida = 4
       set @p4 = @p

    if @cd_parcela_nota_saida = 5
       set @p5 = @p


    delete from #Parcela where cd_parcela_nota_saida = @cd_parcela_nota_saida        
     
  end


  --Finalização
  --set @ds_linha_fatura = @ds_linha_fatura + '</cobr'

  select @ds_linha_fatura,@p1,@p2,@p3,@p4,@p5

  --gravação da tabela nota_saida_fatura

  insert into nota_saida_fatura
  select
    @cd_nota_saida,
    cast(@ds_linha_fatura 
         +
         @p1
         +
         isnull(@p2,'')
         +
         '</cobr'
         as text) as ds_linha_fatura,
    @cd_usuario,
    getdate()


  --select * from nota_saida_fatura

end

