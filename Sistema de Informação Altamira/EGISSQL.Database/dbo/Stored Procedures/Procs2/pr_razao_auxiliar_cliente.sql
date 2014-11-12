

CREATE PROCEDURE pr_razao_auxiliar_cliente

@cd_cliente int,
@dt_inicial datetime,
@dt_final   datetime

as
 
  declare @vl_saldo_anterior decimal(25,2)
  declare @vl_saldo_atual decimal(25,2)
  declare @cd_documento_receber int

  set     @vl_saldo_anterior = 0.00
  set     @vl_saldo_atual = 0.00
  set     @cd_documento_receber = 0
    
  -- saldo inicial do razão  

  select
    @vl_saldo_anterior = @vl_saldo_anterior +
                         cast(str(d.vl_saldo_documento,25,2) as decimal(25,2))
  from
    documento_receber d
  left outer join
    documento_receber_pagamento p
  on
    d.cd_documento_receber = p.cd_documento_receber
  where
    d.cd_cliente = @cd_cliente and
    p.dt_pagamento_documento is null or p.dt_pagamento_documento >= @dt_inicial and
    d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_inicial and
    d.dt_emissao_documento < @dt_inicial 

  print ('Valor do Saldo Anterior: '+cast(@vl_saldo_anterior as varchar(50)))

-------------------------------------------------------------------------------------OK
-- Pega todos os Códigos de Documento Referentes ao Cliente
  IF EXISTS (SELECT name 
	     FROM   sysobjects 
	     WHERE  name = N'#tab_chave' 
             AND type = 'u')
  DROP table #tab_chave

  select    
    d.cd_documento_receber
  into
    #tab_chave
  from
    documento_receber d
  left outer join documento_receber_pagamento p on
    p.cd_documento_receber=d.cd_documento_receber
  where
    d.cd_cliente = @cd_cliente and
    (p.dt_pagamento_documento is null or p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    d.dt_cancelamento_documento is null and
    d.dt_emissao_documento between @dt_inicial and @dt_final
  order by
    d.dt_emissao_documento,
    d.cd_identificacao

-------------------------------------------------------------------------------------
-- razão auxiliar (tabela temporária, sem o saldo atual)

  IF EXISTS (SELECT name 
             FROM   sysobjects 
	     WHERE  name = N'#documento_receber' 
             AND type = 'u')
  DROP table #documento_receber

  select
    @vl_saldo_anterior        as 'Saldo_Anterior',
    d.cd_documento_receber    as 'CodDocumento',  
    d.cd_cliente,
    d.cd_identificacao        as 'Documento',
    d.dt_emissao_documento    as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    p.dt_pagamento_documento  as 'Pagamento',
    case when p.dt_pagamento_documento is null then cast(str(d.vl_documento_receber,25,2) as decimal(25,2)) else 0 end as 'Debito',
    case when p.dt_pagamento_documento between @dt_inicial and @dt_final then cast(str(p.vl_pagamento_documento,25,2) as decimal(25,2)) else 0 end as 'Credito',
    cast(0.00 as decimal(25,2)) as 'Saldo_Atual'
  into
    #Documento_Receber
  from
    documento_receber d
  left outer join
    documento_receber_pagamento p
  on
    d.cd_documento_receber = p.cd_documento_receber
  where
    d.cd_cliente = @cd_cliente and
    (p.dt_pagamento_documento is null or p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    d.dt_cancelamento_documento is null and
    d.dt_emissao_documento between @dt_inicial and @dt_final
  order by
    d.dt_emissao_documento,
    d.cd_identificacao

-------------------------------------------------------------------------------------
  -- lendo a tabela temporária para calcular saldo atual 
  while exists(select cd_documento_receber from #tab_chave ) 
    begin
      -- guardando a chave
      select 
        @cd_documento_receber = cd_documento_receber
      from
        #tab_chave

      select 
        @vl_saldo_atual = @vl_saldo_anterior + (Debito - Credito)
      from
        #Documento_Receber 
      where
        CodDocumento = @cd_documento_receber

      print('Saldo Atual:'+cast(@vl_saldo_atual as varchar(20)))
      print('Saldo Anterior:'+cast(@vl_saldo_anterior as varchar(20)))

      update
        #Documento_receber
      set
        Saldo_Atual = @vl_saldo_atual
      where
        CodDocumento = @cd_documento_receber

      set @vl_saldo_anterior = @vl_saldo_atual

      delete from 
        #tab_chave
      where
        cd_documento_receber = @cd_documento_receber
    end

  select * from 
    #documento_receber
  order by 
    Emissao,
    Documento


