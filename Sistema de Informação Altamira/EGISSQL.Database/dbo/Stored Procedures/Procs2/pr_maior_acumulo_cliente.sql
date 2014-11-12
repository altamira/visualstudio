
create procedure pr_maior_acumulo_cliente
------------------------------------------------------------------------
--pr_maior_acumulo_cliente
------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                               2004
------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Cálculo do Maior Acumulo de Pagamento Cliente 
--Alteração
--Data			: 13/01/2003
--Desc. Alteração	: 14/01/2003 - Pequenos ajustes - Lucio
--                      : 06/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 12/07/2005 - Inserido Cursor para melhorar a performace - ELIAS
--                      : 25.11.2006 - Ajuste - Carlos Fernandes
---------------------------------------------------------------------------------
@cd_cliente       int,
@vl_maior_acumulo money output,
@dt_maior_acumulo datetime output

as

  -- Tabela com a Data de Pagamento Ordenada

  set @vl_maior_acumulo = 0.00
  set @dt_maior_acumulo = null

  select 
    d.cd_documento_receber,
    dp.dt_pagamento_documento
  -----
  into #DocPago
  -----
  from
    Cliente c, Documento_Receber d, Documento_Receber_Pagamento dp
  where
     d.cd_documento_receber = dp.cd_documento_receber  and
     c.cd_cliente           = @cd_cliente              and
     c.cd_cliente           = d.cd_cliente             and
     d.dt_cancelamento_documento is null               
  order by
     dp.dt_pagamento_documento 

  -- Cálculo do Maior Acumulo
  declare @vl_aux_acumulo       numeric(25,2)
  declare @cd_documento_receber int
  declare @cd_documento_pago    int
  declare @dt_pagamento         datetime
  declare @dt_emissao           datetime
  declare @dt_emissao_acumulo   datetime
  declare @vl_documento         numeric(25,2)
  declare @ic_deleta            int
  declare @cd_identificacao     varchar(20)

  set @vl_aux_acumulo       = 0
  set @cd_documento_receber = 0
  set @dt_pagamento         = null

  --Atualiza a Data do 1o. Pagamento

  select top 1
    @cd_documento_pago = cd_documento_receber,
    @dt_pagamento      = dt_pagamento_documento
  from
    #DocPago

  -- Cursor com os Documentos por Ordem de Data da Emissão
  declare cCursor cursor for
  select 
    d.cd_identificacao,
    d.cd_documento_receber,
    d.vl_documento_receber,
    d.dt_emissao_documento
  from
    Documento_Receber d, Documento_Receber_Pagamento dp
  where
    d.cd_cliente           = @cd_cliente              and
    d.dt_cancelamento_documento is null               and 
    d.cd_documento_receber *= dp.cd_documento_receber
  order by
     d.dt_emissao_documento 

  open cCursor

  fetch next from cCursor into @cd_identificacao, @cd_documento_receber, @vl_documento, @dt_emissao

  while (@@fetch_status = 0) 
  begin

    set @ic_deleta = 0

    set @vl_aux_acumulo = @vl_aux_acumulo + @vl_documento

    if @dt_emissao_acumulo is null
       set @dt_emissao_acumulo = @dt_emissao

    if @dt_pagamento is not null 
    begin
    
      if @dt_emissao > @dt_pagamento
      begin
          
        set @vl_aux_acumulo = @vl_aux_acumulo - @vl_documento
    
        if @vl_aux_acumulo > @vl_maior_acumulo
        begin
          set @vl_maior_acumulo = @vl_aux_acumulo      
          set @dt_maior_acumulo = @dt_emissao_acumulo
        end            
      
        delete from #DocPago
        where
          dt_pagamento_documento = @dt_pagamento or
          cd_documento_receber = @cd_documento_pago
         
       -- Atualiza a Data do 1o. Pagamento novamente         
       select top 1
         @cd_documento_pago = cd_documento_receber,
         @dt_pagamento      = dt_pagamento_documento
       from
         #DocPago
         
       set @vl_aux_acumulo = @vl_documento
         
       -- NÃO apagar se a emissão ainda for maior que a próxima data de pagamento
       if (@dt_emissao > @dt_pagamento) and ((select count(dt_pagamento_documento) from #DocPago) > 1)
        set @ic_deleta = 1

       print('Documento :'+@cd_identificacao)
         
      end

    end

    set @dt_emissao_acumulo = @dt_emissao

    -- deleta o registro lido
    if (@ic_deleta = 0)
      fetch next from cCursor into @cd_identificacao, @cd_documento_receber, @vl_documento, @dt_emissao

  end

  close cCursor
  deallocate cCursor

--  select @vl_maior_acumulo as 'MaiorAcumulo',
--         @dt_maior_acumulo as 'DataMaiorAcumulo'

