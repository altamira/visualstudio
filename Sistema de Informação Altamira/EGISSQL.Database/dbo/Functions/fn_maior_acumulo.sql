
--fn_maior_acumulo
---------------------------------------------------------
--GBS - Global Business Solution   	             2004
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Calcular valor de maior acumulo do cliente.
-- Copiada lógica da pr_maior_acumulo_cliente.
--Data			: 23/04/2004
---------------------------------------------------


CREATE FUNCTION fn_maior_acumulo
  (@cd_cliente int,
   @vl_maior_acumulo money,
   @dt_maior_acumulo datetime)
RETURNS @Maior_Acumulo TABLE 
	(cd_cliente       int,
   vl_maior_acumulo money,
   dt_maior_acumulo datetime)

AS
BEGIN


  -- criar a tabela temporária na memória
  declare @DocPago table 
  ( cd_documento_receber int null,
    dt_pagamento_documento datetime null )

  declare @aux table 
  ( nm_fantasia_cliente varchar(80),
    cd_cliente int,
    cd_documento_receber int,
    vl_documento_receber int,
    dt_emissao_documento datetime,
    dt_pagamento_documento datetime )

  -- Tabela com a Data de Pagamento Ordenada
  insert into @DocPago
  select 
    d.cd_documento_receber,
    dp.dt_pagamento_documento
  from
    Cliente c, Documento_Receber d, Documento_Receber_Pagamento dp
  where
     c.cd_cliente           = @cd_cliente              and
     c.cd_cliente           = d.cd_cliente             and
     d.dt_cancelamento_documento is null               and  
     d.cd_documento_receber = dp.cd_documento_receber
  order by
     dp.dt_pagamento_documento 

  -- Tabelas com os Documentos por Ordem de Data da Emissão

  insert into @aux
  select 
    c.nm_fantasia_cliente,
    c.cd_cliente,
    d.cd_documento_receber,
    d.vl_documento_receber,
    d.dt_emissao_documento,
    dp.dt_pagamento_documento
  from
    Cliente c, Documento_Receber d, Documento_Receber_Pagamento dp
  where
     c.cd_cliente           = @cd_cliente              and
     c.cd_cliente           = d.cd_cliente             and
     d.dt_cancelamento_documento is null               and 
     d.cd_documento_receber *= dp.cd_documento_receber
  order by
     d.dt_emissao_documento 

  -- Cálculo do Maior Acumulo

  declare @vl_aux_acumulo       money

  declare @cd_documento_receber int
  declare @cd_documento_pago    int
  declare @dt_pagamento         datetime
  declare @dt_emissao           datetime
  declare @dt_emissao_acumulo   datetime
  declare @vl_documento         money
  declare @ic_deleta            int

  set @vl_aux_acumulo       = 0
  set @cd_documento_receber = 0
  set @dt_pagamento         = null

  --Atualiza a Data do 1o. Pagamento

  select top 1
    @cd_documento_pago = cd_documento_receber,
    @dt_pagamento      = dt_pagamento_documento
  from
    @DocPago

  while exists ( select top 1 * from @aux )
  begin
 
    set @ic_deleta = 0

    -- Ler o 1o. registro

    select top 1 
       @cd_documento_receber = cd_documento_receber,
       @vl_aux_acumulo       = @vl_aux_acumulo + vl_documento_receber,
       @dt_emissao           = dt_emissao_documento,
       @vl_documento         = vl_documento_receber
    from
       @aux

    if @dt_emissao_acumulo is null
       set @dt_emissao_acumulo = @dt_emissao

 -- print cast(@vl_aux_acumulo as varchar) + ' - Maior = ' + cast(@vl_maior_acumulo as varchar)
 -- print cast(@dt_emissao as varchar) + ' - ' + cast(@cd_documento_receber as varchar)
 -- print cast(@dt_pagamento as varchar)
  
    if @dt_pagamento is not null 
    begin
    
      if @dt_emissao > @dt_pagamento
      begin
          
         set @vl_aux_acumulo = @vl_aux_acumulo - @vl_documento
    
          if @vl_aux_acumulo > @vl_maior_acumulo
         begin
            set @vl_maior_acumulo = @vl_aux_acumulo      
         -- set @dt_maior_acumulo = @dt_emissao
            set @dt_maior_acumulo = @dt_emissao_acumulo
         end            
      
         delete from @DocPago
         where
            dt_pagamento_documento = @dt_pagamento or
            cd_documento_receber = @cd_documento_pago
         
         -- Atualiza a Data do 1o. Pagamento novamente
         
         select top 1
           @cd_documento_pago = cd_documento_receber,
           @dt_pagamento      = dt_pagamento_documento
         from
           @DocPago
         
         set @vl_aux_acumulo = @vl_documento
         
         -- NÃO apagar se a emissão ainda for maior que a próxima data de pagamento

         if @dt_emissao > @dt_pagamento and 
           (select count(dt_pagamento_documento) from @DocPago) > 1

            set @ic_deleta = 1
         
      end

    end

    set @dt_emissao_acumulo = @dt_emissao

    -- deleta o registro lido

    if @ic_deleta = 0 or
      (select count(*) from @Aux) = 1
    begin
      delete from @aux
      where
         cd_documento_receber = @cd_documento_receber
    end  

  end

--  select @vl_maior_acumulo as 'MaiorAcumulo',
--         @dt_maior_acumulo as 'DataMaiorAcumulo'



  insert into
    @Maior_Acumulo
  select
         @cd_cliente,
         @vl_maior_acumulo,
         @dt_maior_acumulo

  RETURN
END

