
--pr_consulta_diario_fornecedor
-----------------------------------------------------------------------------------
--Global Business Solution Ltda
--Stored Procedure - SQL Server Microsoft 7.0/2000  
--Elias Pereira da Silva         
--Diário Auxiliar de Fornecedores
--Data       : 05.Novembro.2001
--Atualizado : 30/01/2002 - Inclusão da consulta geral e resumo - ELIAS 
--             13/03/2002 - Alteração de vl_saldo_documento_pagar - CARRASCO
--             20/04/2002 - Migração p/ EGISSQL - Elias
--             05/08/2002 - Acertos e Migração p/ EGISSQL - ELIAS
--             11/09/2002 - Alteração do parametro nm-fantasia_fornecedor p/ cd_fornecedor
--             11/09/2002 - Acertos gerais - ELIAS  
-----------------------------------------------------------------------------------

create procedure pr_consulta_diario_fornecedor
@ic_parametro           char(1),   -- se geral (G), individual (I), resumo (R)
@cd_fornecedor          int,       -- fornecedor
@dt_inicial             datetime,  -- período inicial
@dt_final               datetime   -- período final
as

declare @vl_saldo_anterior float   -- guarda saldo anterior
declare @Codigo int
declare @Fornecedor int

set     @vl_saldo_anterior = 0
set     @Codigo = 1

-------------------------------------------------------------------------------
if @ic_parametro = 'I'                     -- escolha individual do fornecedor
-------------------------------------------------------------------------------
  begin

    exec dbo.pr_saldo_diario_fornecedor @cd_fornecedor, @dt_inicial, @vl_saldo = @vl_saldo_anterior output

    -- Diário Auxiliar
    select
      d.cd_fornecedor 			as 'CodFornecedor',
      f.nm_razao_social			as 'Fornecedor',
      nr.cd_rem				as 'REM',
      nr.dt_rem			 	as 'Entrada',
      d.cd_identificacao_document	as 'Documento',
      cast(null as varchar)		as 'Serie',
      d.dt_emissao_documento_paga	as 'Emissao',
      d.dt_vencimento_documento		as 'Vencimento',
      p.dt_pagamento_documento		as 'Pagamento',
      -- Débito
      case when (p.dt_pagamento_documento between @dt_inicial and @dt_final ) then 
        p.vl_pagamento_documento
      else 0 end			as 'Debito', 
      -- Crédito
      case when (isnull(nr.dt_rem,d.dt_emissao_documento_paga) between @dt_inicial and @dt_final ) then 
        d.vl_documento_pagar
      else 0 end 			as 'Credito',
      cast(str(@vl_saldo_anterior,25,2) as decimal(25,2))					as 'SaldoAnterior' 
    into
      #Diario_Fornecedor_Individual     
    from
      Documento_Pagar d 
    left outer join 
      Documento_Pagar_Pagamento p 
    on 
      d.cd_documento_pagar = p.cd_documento_pagar
    left outer join 
      Fornecedor f 
    on 
      d.cd_fornecedor = f.cd_fornecedor
    left outer join 
      Nota_Entrada n 
    on 
      d.cd_nota_fiscal_entrada = cast(n.cd_nota_entrada as varchar) and
      d.cd_fornecedor = n.cd_fornecedor
    left outer join 
      Nota_Entrada_Registro nr 
    on
      cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
      nr.cd_fornecedor = d.cd_fornecedor
    left outer join  
      Tipo_Conta_Pagar t 
    on 
      d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar
    where
      d.cd_fornecedor = @cd_fornecedor and
      (nr.cd_rem is not null) and
      (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_inicial ) and
      (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
      (p.dt_pagamento_documento between @dt_inicial and @dt_final)) or
      (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
      t.ic_razao_contabil = 'S' 
    order by
      nr.cd_rem,
      nr.dt_rem,
      d.dt_emissao_documento_paga,
      d.cd_identificacao_document


    if not exists(select * from 
                    #Diario_Fornecedor_Individual
                  where 
                    ((Debito <> 0) or (Credito <> 0)))
     select
       d.cd_fornecedor 		as 'CodFornecedor',
       f.nm_razao_social	as 'Fornecedor',
       null 			as 'REM',
       null 			as 'Entrada',
       null 			as 'Documento',
       null 			as 'Serie',
       null 			as 'Emissao',
       null 			as 'Vencimento',
       null 			as 'Pagamento',
       null 			as 'Debito',
       null 			as 'Credito',
       cast(str(@vl_saldo_anterior,25,2) as decimal(25,2)) as 'SaldoAnterior'
     from
       Documento_Pagar d
     left outer join
       Fornecedor f
     on
       d.cd_fornecedor = f.cd_fornecedor
     where
       @cd_fornecedor = f.cd_fornecedor
   else
     select * from 
       #Diario_Fornecedor_Individual
     where 
       ((Debito <> 0) or (Credito <> 0))   
  end 
-------------------------------------------------------------------------------
else if @ic_parametro = 'G' -- escolha geral (todos os fornecedores)
-------------------------------------------------------------------------------
  begin

    -- Diário Auxiliar
    select
      d.cd_fornecedor 			as 'CodFornecedor',
      f.nm_razao_social			as 'Fornecedor',
      nr.cd_rem				as 'REM',
      nr.dt_rem			 	as 'Entrada',
      d.cd_identificacao_document	as 'Documento',
      cast(null as varchar)		as 'Serie',
      d.dt_emissao_documento_paga	as 'Emissao',
      d.dt_vencimento_documento		as 'Vencimento',
      p.dt_pagamento_documento		as 'Pagamento',
      -- Débito
      case when (p.dt_pagamento_documento between @dt_inicial and @dt_final ) then 
        p.vl_pagamento_documento
      else 0 end			as 'Debito', 
      -- Crédito
      case when (isnull(nr.dt_rem,d.dt_emissao_documento_paga) between @dt_inicial and @dt_final ) then 
        d.vl_documento_pagar
      else 0 end 			as 'Credito',
      cast(0.00 as decimal(25,2))	as 'SaldoAnterior'
    into
      #Diario_Fornecedor_Geral
    from
      Documento_Pagar d
    left outer join 
      Documento_Pagar_Pagamento p 
    on
      d.cd_documento_pagar = p.cd_documento_pagar
    left outer join 
      Fornecedor f
    on
      d.cd_fornecedor = f.cd_fornecedor
    left outer join 
      Nota_Entrada n 
    on 
      d.cd_nota_fiscal_entrada = cast(n.cd_nota_entrada as varchar) and
      d.cd_fornecedor = n.cd_fornecedor
    left outer join 
      Nota_Entrada_Registro nr 
    on
      cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
      nr.cd_fornecedor = d.cd_fornecedor
    left outer join
      Tipo_Conta_Pagar t
    on
      d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar
    where
       d.cd_fornecedor = f.cd_fornecedor                     and
      (nr.cd_rem is not null) and              
      (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_inicial ) and
      (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
        (p.dt_pagamento_documento between @dt_inicial and @dt_final)) or
      (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
       t.ic_razao_contabil = 'S'
    order by
       nr.cd_rem,
       nr.dt_rem,
       d.dt_emissao_documento_paga

    select 
      distinct
      CodFornecedor
    into
      #CodFornecedor
    from
      #Diario_Fornecedor_Geral

    select
      identity(int,1,1) as Codigo,
      CodFornecedor,
      cast(0 as float) as 'Saldo' 
    into
      #SaldoFornecedor
    from
      #CodFornecedor

    while exists (select Codigo from #SaldoFornecedor where Codigo = @Codigo)
      begin

        select 
          @Fornecedor = CodFornecedor
        from 
          #SaldoFornecedor 
        where 
          Codigo = @Codigo        

        exec dbo.pr_saldo_diario_fornecedor @Fornecedor, @dt_inicial, @vl_saldo = @vl_saldo_anterior output

        update
          #SaldoFornecedor
        set
          Saldo = @vl_saldo_anterior
        where
          Codigo = @Codigo

        set @Codigo = @Codigo + 1

      end

    update
      #Diario_Fornecedor_Geral
    set
      SaldoAnterior = a.Saldo
    from
      #SaldoFornecedor a,
      #Diario_Fornecedor_Geral b
    where
      a.CodFornecedor = b.CodFornecedor    

    select 
     *
    into
      #Diario_Movimento
    from 
      #Diario_Fornecedor_Geral      
    where 
      ((Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0))

    select * from 
      #Diario_Movimento
    where 
      ((Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0))
    order by
      Fornecedor,
      Rem,
      Entrada
      
      
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 'R' -- resumo
-------------------------------------------------------------------------------
  begin

        
    -- Diário Auxiliar
    select
      d.cd_fornecedor	as 'CodFornecedor',
      -- Débito
      case when (p.dt_pagamento_documento between @dt_inicial and @dt_final ) then 
        p.vl_pagamento_documento
      else 0 end			as 'Debito', 
      -- Crédito
      case when (isnull(nr.dt_rem,d.dt_emissao_documento_paga) between @dt_inicial and @dt_final ) then 
        d.vl_documento_pagar
      else 0 end 			as 'Credito',
      p.vl_juros_documento_pagar as 'Juros',
      p.vl_desconto_documento  as 'Desconto',
      p.vl_abatimento_documento as 'Abatimento'
    into 
      #Diario_Resumo
    from
      Documento_Pagar d
    left outer join
      Documento_Pagar_Pagamento p
    on
      d.cd_documento_pagar = p.cd_documento_pagar
    left outer join 
      Nota_Entrada_Registro nr 
    on
      cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
      nr.cd_fornecedor = d.cd_fornecedor
    left outer join
      Tipo_Conta_Pagar t
    on
      d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar
    where
      (nr.cd_rem is not null) and
      (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_inicial ) and
      (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
        (p.dt_pagamento_documento between @dt_inicial and @dt_final)) and
      (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
      t.ic_razao_contabil = 'S'

    select 
      distinct
      CodFornecedor
    into
      #CodFornecedorResumo
    from
      #Diario_Resumo

    select
      CodFornecedor,
      EgisSql.dbo.fn_saldo_diario_fornecedor(CodFornecedor, @dt_inicial) as 'Saldo' 
    into
      #SaldoFornecedorResumo
    from
      #CodFornecedorResumo

    select
      @vl_saldo_anterior = sum(Saldo)
    from
      #SaldoFornecedorResumo

    select
      @vl_saldo_anterior 				as 'SaldoAnterior',
      sum(Debito)					as 'Debito',
      sum(Credito)					as 'Credito',
      @vl_saldo_anterior - sum(Debito) + sum(Credito)	as 'SaldoAtual',
      sum(Juros)					as 'Juros',
      sum(Desconto)					as 'Desconto', 
      sum(Abatimento)   				as 'Abatimento'
    from 
      #Diario_Resumo
      

  end

