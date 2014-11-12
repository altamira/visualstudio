-------------------------------------------------------------------
--pr_diario_cliente
-------------------------------------------------------------------
--Global Business Solution Ltda                               2004
-------------------------------------------------------------------
--Stored Procedure     : SQL Server Microsoft 2002  
--Autor(es)            : Daniel C. Neto.
--Objetivo             : Diário Auxiliar de Clientes
--Data                 : 20/09/2002
--Atualizado           : 16/10/2002 - Acertos no Saldo Anterior. - Daniel C. Neto
--                     : 20/03/2003 - Otimização do Cálculo do Saldo Inicial
--                     : 31/03/2003 - Mudado calculo do campo VL_CREDITO_PENDENTE de (+) para (-)
--                     : 04/04/2003 - Re-calculo batendo com as consultas de documentos por emissão e documentos pagos por portador
--                     : 07/04/2003 - Otimizaçao do Resumo
--                     : 22/04/2002 - Validação de Valores (DUELA)
--                     : 28/07/2004 - Todos os Pagamentos devem ter o cabeçalho do documento,
--                                    modificado o relacionamento entre as tabelas documento_receber e 
--                                    documento_receber_pagamento de left outer join para inner join nos
--                                    cálculos dos valores pagos no resumo e na listagem geral. - ELIAS
--                     : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 09/01/2005 - Acerto do Título quando este possui apenas a Devolução - Carlos
--                                  - Não estava somando a Coluna Crédito Corretamente
-- 10/02/2005 - Lógica reescrita e inclusão de um novo parâmetro para verificar diferença de Saldo Atual e Anterior
-- apontando o cliente que está com diferenças.
--           - Usada nova função para achar saldo anterior do cliente - Daniel C. Neto.
-- 11/02/2005 - Não trazer duplicatas canceladas em hipótese alguma. - Daniel C. Neto.
-- 28.06.2010 - Sped Contábil - Carlos Fernandes
----------------------------------------------------------------------------------------------------------------

create procedure pr_diario_cliente
@ic_parametro           char(1),   -- se geral (G), individual (I), resumo (R)
@cd_cliente             int,       -- fornecedor
@dt_inicial             datetime,  -- período inicial
@dt_final               datetime   -- período final
as

declare @vl_total_saldo_Anterior float
declare @vl_total_debito         float
declare @vl_total_credito        float
declare @vl_total_juros          float
declare @vl_total_desconto       float
declare @vl_total_abatimento     float

set @vl_total_saldo_Anterior=0
set @vl_total_debito        =0
set @vl_total_credito       =0
set @vl_total_juros         =0
set @vl_total_desconto      =0
set @vl_total_abatimento    =0

  select * 
  into #SaldoAnterior
  from
    fn_saldo_ant_cliente
      (@dt_inicial, @cd_cliente)


----------------------------------
if @ic_parametro <> 'D' 
------------------------------------
begin

  -- Cliente sem movimentação durante o período específicado

    select 
      d.cd_cliente 	                                as 'CodClienteSa',
      f.nm_razao_social_cliente		                as 'Cliente',
      Null				                as 'Documento',
      Null				                as 'Emissao',
      Null				                as 'Vencimento',
      Null				                as 'Pagamento',
      -- Débito
      Null 				                as 'Debito',
      -- Crédito
      Null				                as 'Credito', 
      Null				                as 'Juros', 
      Null				                as 'Desconto', 
      Null				                as 'Abatimento',
      cast(str(IsNull(sa.SaldoAnterior,0),25,2) as decimal(25,2))
					                as 'SaldoAnterior'

    
    into
      #Tmp_Saldo_Anterior_Cliente

    -------
    from
      Documento_Receber d  with (nolock)
    left outer join #SaldoAnterior sa on
      d.cd_cliente = sa.cd_cliente
    left outer join Documento_Receber_Pagamento p with (nolock) on
      d.cd_documento_Receber = p.cd_documento_receber
    left outer join Cliente f with (nolock) on
      d.cd_cliente = f.cd_cliente
  where  
    (d.dt_emissao_documento < @dt_inicial) and
    d.cd_cliente = ( case when @ic_parametro = 'I' then
                       @cd_cliente else
                      d.cd_cliente end ) and
    (d.dt_cancelamento_documento is null)
    group by d.cd_cliente, f.nm_razao_social_cliente, sa.SaldoAnterior
    order by f.nm_razao_social_cliente

  -- Diário Auxiliar dos cliente com movimentação no período específicado

  --Credito
     select distinct
       x.cd_documento_receber,
       case when x.dt_devolucao_documento between @dt_inicial and @dt_final 
         then ( x.vl_documento_receber ) else 
           sum(cast(str(isnull(dpa.vl_pagamento_documento, 0),25,2)  as decimal(25,2))
             - cast(str(isnull(dpa.vl_juros_pagamento, 0),25,2)      as decimal(25,2))
             + cast(str(isnull(dpa.vl_desconto_documento, 0),25,2)   as decimal(25,2))
             + cast(str(isnull(dpa.vl_abatimento_documento, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dpa.vl_despesa_bancaria, 0),25,2)     as decimal(25,2))
             - cast(str(isnull(dpa.vl_reembolso_documento, 0),25,2)  as decimal(25,2))
             - cast(str(isnull(dpa.vl_credito_pendente, 0),25,2)     as decimal(25,2)))
        end as 'Credito',
       sum(cast(str(isnull(dpa.vl_juros_pagamento, 0),25,2)        as decimal(25,2)))     as 'Juros',
       sum(cast(str(isnull(dpa.vl_desconto_documento, 0),25,2)     as decimal(25,2)))     as 'Desconto',
       sum(cast(str(isnull(dpa.vl_abatimento_documento, 0),25,2)   as decimal(25,2)))     as 'Abatimento'

       into #Credito
       from
         Documento_Receber x with (nolock)
       left outer join Documento_Receber_Pagamento dpa with (nolock) on
         dpa.cd_documento_receber = x.cd_documento_receber
       where
        ((dpa.dt_pagamento_documento between @dt_inicial and @dt_final) or
         ((x.dt_devolucao_documento between @dt_inicial and @dt_final) and (dpa.dt_pagamento_documento is null))) and
         x.cd_cliente = ( case when @ic_parametro = 'I' then
                           @cd_cliente else
                           x.cd_cliente end ) and
        (x.dt_cancelamento_documento is null)

       group by 
          x.cd_documento_receber, 
          x.vl_documento_receber, 
          x.dt_devolucao_documento

    select distinct
      d.cd_cliente 			      as 'CodCliente',
      f.nm_razao_social_cliente		      as 'Cliente',
      d.cd_identificacao		      as 'Documento',
      d.dt_emissao_documento	    	      as 'Emissao',
      d.dt_vencimento_documento		      as 'Vencimento',
      IsNull(d.dt_devolucao_documento, 
        (select max(dt_pagamento_documento) from Documento_Receber_Pagamento dp with (nolock)
         where 
          dp.dt_pagamento_documento between @dt_inicial and @dt_final and 
          dp.cd_documento_receber=d.cd_documento_receber)) as 'Pagamento',
  --      null as 'Pagamento',
      ( case when ( ( d.dt_emissao_documento between @dt_inicial and @dt_final )  or
                  ( d.dt_emissao_documento between @dt_inicial and @dt_final and d.dt_devolucao_documento between @dt_inicial and @dt_final ) )
             then isnull(cast(str(d.vl_documento_receber,25,2) as numeric(25,2)),0) else null end ) as 'Debito',
      cr.Credito as 'Credito',
      cr.Juros,
      cr.Desconto,
      cr.Abatimento,
      isnull(sa.SaldoAnterior,0)        as 'SaldoAnterior' 

    into
      #Diario_Cliente_Geral_Temp

    from
      Documento_Receber d                           with (nolock)
    left outer join Documento_Receber_Pagamento drp with (nolock) on
      drp.cd_documento_Receber = d.cd_documento_receber
    left outer join #SaldoAnterior sa on
      d.cd_cliente = sa.cd_cliente
    left outer join #Credito cr on
      cr.cd_documento_receber=d.cd_documento_receber
    left outer join Cliente f with (nolock) on
      f.cd_cliente = d.cd_cliente
    where
      ((d.dt_emissao_documento       between @dt_inicial and @dt_final) or 
        ((IsNull(d.dt_devolucao_documento, drp.dt_pagamento_documento) between @dt_inicial and @dt_final) or 
        ((d.dt_devolucao_documento between @dt_inicial and @dt_final) and (drp.dt_pagamento_documento is null)))) and
      (d.dt_cancelamento_documento is null) and 
      d.cd_cliente = ( case when @ic_parametro = 'I' then
                         @cd_cliente else
                         d.cd_cliente end ) 

    order by
       d.dt_emissao_documento 

    insert into  #Diario_Cliente_Geral_Temp 
    select * from #Tmp_Saldo_Anterior_Cliente a
    where not exists
       (select 'x' from #Diario_Cliente_Geral_Temp b
        where b.codcliente = a.codclientesa)

   if @ic_parametro in ('G','I')
   begin
    select
      distinct
      CodCliente,
      Cliente,
      Documento,
      Emissao,
      Vencimento,
      Pagamento,
      Debito, 
      Credito,
      SaldoAnterior
    from
      #Diario_Cliente_Geral_Temp
    where 
      CodCliente<>0 and
      (case when (Debito <> 0) then Debito 
            when (Credito <> 0) then Credito
            when (SaldoAnterior <> 0) then SaldoAnterior
       else 0 end ) <> 0
    order by
      Cliente    


    delete from sped_razao_auxiliar

    select
      identity(int,1,1)  as cd_controle,
      1                  as cd_livro,
      CodCliente         as cd_cliente,
      Cliente            as nm_cliente,
      Documento          as cd_documento,
      Emissao            as dt_emissao,
      Vencimento         as dt_vencimento,
      Pagamento          as dt_pagamento,
      Debito             as vl_debito,
      Credito            as vl_credito,
      SaldoAnterior      as vl_saldo,
      4                  as cd_usuario,
      getdate()          as dt_usuario

    into
      #sped_razao_auxiliar
    from
      #Diario_Cliente_Geral_Temp
    where 
      CodCliente<>0 and
      (case when (Debito <> 0) then Debito 
            when (Credito <> 0) then Credito
            when (SaldoAnterior <> 0) then SaldoAnterior
       else 0 end ) <> 0
    order by
      Cliente    

    insert into sped_razao_auxiliar
    select
      *
    from
      #sped_razao_auxiliar
   
   end

   else
   begin
     select distinct codcliente, SaldoAnterior
     into #SaldoGeral
     from  #Diario_Cliente_Geral_Temp
  
     select @vl_total_saldo_Anterior=sum(saldoAnterior)
     from #SaldoGeral

     select distinct
       CodCliente,
       Documento,
       Emissao,
       Vencimento,
       Pagamento,
       Debito, 
       Credito,
       Juros,
       Desconto,
       Abatimento,
       SaldoAnterior
     into #Tmp_Saldo_Diario_Geral1
     from
       #Diario_Cliente_Geral_Temp
     where 
       CodCliente<>0 and
       ((Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0))

     select 
       @vl_total_debito     = sum(Debito),
       @vl_total_credito    = sum(Credito),
       @vl_total_juros      = sum(Juros),
       @vl_total_desconto   = sum(Desconto),
       @vl_total_abatimento = sum(Abatimento)
     from 
       #Tmp_Saldo_Diario_Geral1
   

     select  
       @vl_total_saldo_Anterior 'SaldoAnterior',    
       'SaldoAtual' =
         isnull(@vl_total_saldo_Anterior,0) + isnull(@vl_total_debito,0) - isnull(@vl_total_credito,0),
       @vl_total_debito     as 'Debito',
       @vl_total_credito    as 'Credito',
       @vl_total_juros      as 'juros',
       @vl_total_desconto   as 'desconto',
       @vl_total_abatimento as 'abatimento'
   end

end

else
begin

  declare @dt_inicial_teste datetime
  declare @dt_final_teste   datetime

  set @dt_inicial_teste = DATEADD(mm, -1, @dt_inicial)
  set @dt_final_teste = dbo.fn_ultimo_dia_mes(DATEADD(mm, -1, @dt_inicial))


  select
    *
  into #SaldoAnterior1
  from
    fn_saldo_ant_cliente
      (@dt_inicial_teste, @cd_cliente)

    -- Cliente sem movimentação durante o período específicado
    select 
      d.cd_cliente 	          		        as 'CodClienteSa',
      f.nm_razao_social_cliente	                        as 'Cliente',
      Null				                as 'Documento',
      Null				                as 'Emissao',
      Null				                as 'Vencimento',
      Null				                as 'Pagamento',
      -- Débito
      Null 				                as 'Debito',
      -- Crédito
      Null				                as 'Credito', 
      Null				                as 'Juros', 
      Null				                as 'Desconto', 
      Null				                as 'Abatimento',
      cast(str(IsNull(sa.SaldoAnterior,0),25,2) as decimal(25,2))
					                        as 'SaldoAnterior'

    
    into
      #Tmp_Saldo_Anterior_Cliente1
    -------
    from
      Documento_Receber d with (nolock)
    left outer join #SaldoAnterior1 sa on
      d.cd_cliente = sa.cd_cliente
    left outer join Documento_Receber_Pagamento p with (nolock) on
      d.cd_documento_Receber = p.cd_documento_receber
    left outer join Cliente f with (nolock) on
      d.cd_cliente = f.cd_cliente
  where  
    (d.dt_emissao_documento < @dt_inicial_teste) and
    d.cd_cliente = ( case when @ic_parametro = 'I' then
                       @cd_cliente else
                      d.cd_cliente end ) 
    group by d.cd_cliente, f.nm_razao_social_cliente, sa.SaldoAnterior
    order by f.nm_razao_social_cliente

  -- Diário Auxiliar dos cliente com movimentação no período específicado

  --Credito
     select distinct
       x.cd_documento_receber,
       case when IsNull(x.dt_devolucao_documento,x.dt_cancelamento_documento) between @dt_inicial_teste and @dt_final_teste 
         then x.vl_documento_receber else 
           sum(cast(str(isnull(dpa.vl_pagamento_documento, 0),25,2)  as decimal(25,2))
             - cast(str(isnull(dpa.vl_juros_pagamento, 0),25,2)      as decimal(25,2))
             + cast(str(isnull(dpa.vl_desconto_documento, 0),25,2)   as decimal(25,2))
             + cast(str(isnull(dpa.vl_abatimento_documento, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dpa.vl_despesa_bancaria, 0),25,2)     as decimal(25,2))
             - cast(str(isnull(dpa.vl_reembolso_documento, 0),25,2)  as decimal(25,2))
             - cast(str(isnull(dpa.vl_credito_pendente, 0),25,2)     as decimal(25,2)))
        end as 'Credito',
       sum(cast(str(isnull(dpa.vl_juros_pagamento, 0),25,2)        as decimal(25,2)))     as 'Juros',
       sum(cast(str(isnull(dpa.vl_desconto_documento, 0),25,2)     as decimal(25,2)))     as 'Desconto',
       sum(cast(str(isnull(dpa.vl_abatimento_documento, 0),25,2)   as decimal(25,2)))     as 'Abatimento'

       into #Credito1
       from
         Documento_Receber x with (nolock)
       left outer join Documento_Receber_Pagamento dpa with (nolock) on
         dpa.cd_documento_receber = x.cd_documento_receber
       where
        ((IsNull(x.dt_devolucao_documento, dpa.dt_pagamento_documento) between @dt_inicial_teste and @dt_final_teste) or 
        ((IsNull(x.dt_devolucao_documento,x.dt_cancelamento_documento)   between @dt_inicial_teste and @dt_final_teste) and (dpa.dt_pagamento_documento is null))) and
         x.cd_cliente = ( case when @ic_parametro = 'I' then
                           @cd_cliente else
                           x.cd_cliente end ) 

       group by 
          x.cd_documento_receber, 
          x.vl_documento_receber, 
          IsNull(x.dt_devolucao_documento,x.dt_cancelamento_documento)

    select distinct
      d.cd_cliente 			          as 'CodCliente',
      f.nm_razao_social_cliente		as 'Cliente',
      d.cd_identificacao		      as 'Documento',
      d.dt_emissao_documento		  as 'Emissao',
      d.dt_vencimento_documento		as 'Vencimento',
      IsNull(d.dt_devolucao_documento, 
        (select max(dt_pagamento_documento) from Documento_Receber_Pagamento dp with (nolock)
         where 
          dp.dt_pagamento_documento between @dt_inicial_teste and @dt_final_teste and 
          dp.cd_documento_receber=d.cd_documento_receber)) as 'Pagamento',
      ( case when d.dt_emissao_documento between @dt_inicial_teste and @dt_final_teste and
                 ( (d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final_teste) or
                   (d.dt_cancelamento_documento between @dt_inicial_teste and @dt_final_teste) or
                   (d.dt_devolucao_documento is null) or (d.dt_devolucao_documento between @dt_inicial_teste and @dt_final_teste)  )
             then isnull(cast(str(d.vl_documento_receber,25,2) as numeric(25,2)),0) else null end ) as 'Debito',
      cr.Credito as 'Credito',
      cr.Juros,
      cr.Desconto,
      cr.Abatimento,
      isnull(sa.SaldoAnterior,0)        as 'SaldoAnterior' 
    into
      #Diario_Cliente_Geral_Temp1
    from
      Documento_Receber d with (nolock)
    left outer join Documento_Receber_Pagamento drp with (nolock) on
      drp.cd_documento_Receber = d.cd_documento_receber
    left outer join #SaldoAnterior1 sa on
      d.cd_cliente = sa.cd_cliente
    left outer join #Credito1 cr on
      cr.cd_documento_receber=d.cd_documento_receber
    left outer join Cliente f with (nolock) on
      f.cd_cliente = d.cd_cliente
    where
      ((d.dt_emissao_documento       between @dt_inicial_teste and @dt_final_teste) or 
        ((drp.dt_pagamento_documento between @dt_inicial_teste and @dt_final_teste) or 
        ((IsNull(d.dt_devolucao_documento, d.dt_cancelamento_documento) between @dt_inicial_teste and @dt_final_teste) and (drp.dt_pagamento_documento is null)))) and
      ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final_teste or 
                                                 d.dt_cancelamento_documento between @dt_inicial_teste and @dt_final_teste)) and 
      d.cd_cliente = ( case when @ic_parametro = 'I' then
                         @cd_cliente else
                         d.cd_cliente end ) 

    order by
       d.dt_emissao_documento 

    insert into  #Diario_Cliente_Geral_Temp1 
    select * from #Tmp_Saldo_Anterior_Cliente1 a
    where not exists
       (select 'x' from #Diario_Cliente_Geral_Temp1 b
        where b.codcliente = a.codclientesa)

    select 
      CodCliente, 
      sum(Debito) as Debito, 
      sum(Credito) as Credito
    into #Diario_Cliente1
    from #Diario_Cliente_Geral_Temp1
    group by
      CodCliente

    select
      CodCliente,
      IsNull(s.SaldoAnterior,0) + IsNull(d.Debito,0) - IsNull(d.Credito,0) as SaldoAtual
    into #Diario2
    from
      #Diario_Cliente1 d left outer join
      #SaldoAnterior1  s on d.CodCliente = s.cd_cliente
    where
      ( IsNull(s.SaldoAnterior,0) + IsNull(d.Debito,0) - IsNull(d.Credito,0) ) <> 0

    select 
      IsNull(d.CodCliente,s.cd_cliente) as CodCliente,
      c.nm_razao_social_cliente,
      d.SaldoAtual,
      s.SaldoAnterior
    from 
      #SaldoAnterior s left outer join
      #Diario2 d on s.cd_cliente = d.CodCliente left outer join
      Cliente c on c.cd_cliente = IsNull(d.CodCliente,s.cd_cliente)
    where
      s.SaldoAnterior <> cast(str(isnull(d.SaldoAtual, 0),25,2)  as decimal(25,2))
    order by
      c.nm_razao_social_cliente


end

drop table #SaldoAnterior

