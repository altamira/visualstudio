
--pr_diario_fornecedor
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias Pereira da Silva
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Diarios de Fornecedor.
--Data          : ???????
--Atualizado    : 24/02/2003 - Daniel C. Neto.
--              : 15/07/2004 - Vários Acertos - ELIAS
--              : 08/09/2004 - Acerto no Gruop by que impedia listar documentos
--                             com identificações iguais, mas com vencimentos distintos - ELIAS
---------------------------------------------------

create procedure pr_diario_fornecedor_teste
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

    exec pr_saldo_diario_fornecedor @cd_fornecedor, @dt_inicial, @vl_saldo = @vl_saldo_anterior output

    -- tabela temporária com os REMs evitando redundâncias na tabela devido migrações

    select 
      max(cd_rem)               as 'cd_rem',
      max(dt_rem)               as 'dt_rem',
      cd_fornecedor             as 'cd_fornecedor',
      cd_nota_entrada           as 'cd_nota_entrada',
      cd_serie_nota_fiscal      as 'cd_serie_nota_fiscal',
      cd_operacao_fiscal        as 'cd_operacao_fiscal'
    into
      #Nota_Entrada_Registro_Individual
    from 
      Nota_Entrada_Registro
    where
      cd_fornecedor = @cd_fornecedor
    group by
      cd_fornecedor,
      cd_nota_entrada,
      cd_serie_nota_fiscal,       
      cd_operacao_fiscal
    having
      ( (Max(dt_rem) is null) or 
        (Max(dt_rem) <= @dt_final) )

    -- Diário Auxiliar
    select
      d.cd_fornecedor 			    as 'CodFornecedor',
      f.nm_razao_social			    as 'Fornecedor',
      nr.cd_rem				    as 'REM',
      nr.dt_rem			 	    as 'Entrada',
      op.cd_mascara_operacao		    as 'CFOP',
      isnull(op.ic_comercial_operacao,'S')  as 'VlrComl',
      isnull(ic_destaca_vlr_livro_op_f,'N') as 'Destaca',
      d.cd_identificacao_document	    as 'Documento',
      -- Caso não tenha Identificação Anterior, Utilizar a Atual - ELIAS 15/07/2004
      isnull(d.cd_identificacao_sap, d.cd_identificacao_document) as 'DocumentoAux',
      cast(null as varchar)		    as 'Serie',
      d.dt_emissao_documento_paga	    as 'Emissao',
      d.dt_vencimento_documento		    as 'Vencimento',
      case when p.dt_pagamento_documento not between @dt_inicial and @dt_final then null
      else p.dt_pagamento_documento end	    as 'Pagamento',
      -- Débito
      case when (p.dt_pagamento_documento between @dt_inicial and @dt_final ) then p.vl_pagamento_documento
      else 0 end			    as 'Debito', 
      -- Crédito
      case when (isnull(nr.dt_rem,d.dt_emissao_documento_paga) between @dt_inicial and @dt_final ) then 
        d.vl_documento_pagar
      else 0 end 			    as 'Credito',
      cast(str(@vl_saldo_anterior,25,2) as decimal(25,2)) as 'SaldoAnterior',
      d.cd_identificacao_sap                as 'Identificador'
    into
      #Diario_Fornecedor_Individual_Temp
    from
      Documento_Pagar d 

    left outer join Documento_Pagar_Pagamento p on 
      d.cd_documento_pagar = p.cd_documento_pagar

    left outer join Fornecedor f on 
      d.cd_fornecedor = f.cd_fornecedor

    left outer join Serie_Nota_Fiscal s on
      isnull(d.cd_serie_nota_fiscal_entr, s.sg_serie_nota_fiscal) = s.sg_serie_nota_fiscal
      -- Verificar porque essa série está fixa - ELIAS 15/07/2004
      -- isnull(d.cd_serie_nota_fiscal_entr,'U') = s.sg_serie_nota_fiscal

    left outer join #Nota_Entrada_Registro_Individual nr on
    cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
    nr.cd_fornecedor = d.cd_fornecedor 

    left outer join Nota_Entrada_Item_Registro nir on
    nr.cd_rem = nir.cd_rem

    left outer join Operacao_Fiscal op on
    nir.cd_operacao_fiscal = op.cd_operacao_fiscal

    left outer join Tipo_Conta_Pagar t on 
    d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar

    where
       d.cd_fornecedor = @cd_fornecedor and
      (nr.cd_rem is not null) and
      (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final ) and
      (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
      (p.dt_pagamento_documento between @dt_inicial and @dt_final)) or
      (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
      t.ic_razao_contabil = 'S'

    order by
      nr.cd_rem,
      nr.dt_rem,
      d.dt_emissao_documento_paga,
      d.cd_identificacao_document

    select
      CodFornecedor,
      Fornecedor,
      max(REM)            as REM,
      cast(max(Entrada) as datetime) as Entrada,
      max(Documento)      as Documento,
      max(Serie)          as Serie,
      max(Emissao)        as Emissao,
      Vencimento          as Vencimento,   -- ELIAS 08/09/2004
      max(Pagamento)      as Pagamento,
      max(Debito)         as Debito, 
      max(Credito)        as Credito,
      max(SaldoAnterior)  as SaldoAnterior,
      max(Identificador)  as Identificador 
    into
      #Diario_Fornecedor_Individual
    from
      #Diario_Fornecedor_Individual_Temp
    where
      VlrComl = 'S'      
    group by CodFornecedor,
             Fornecedor,
             DocumentoAux,
             Vencimento  -- ELIAS 08/09/2004

    if not exists(select * from 
                    #Diario_Fornecedor_Individual
                  where 
                    ( (Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0) )) 
     select
       d.cd_fornecedor 		as 'CodFornecedor',
       cast(f.nm_razao_social as varchar)	as 'Fornecedor',
       null 			as 'REM',
       cast(null as datetime)	as 'Entrada',
       cast(null as varchar)	as 'Documento',
       cast(null as varchar)	as 'Serie',
       cast(null as datetime)	as 'Emissao',
       cast(null as datetime)	as 'Vencimento',
       cast(null as datetime)	as 'Pagamento',
       cast(null as float)	as 'Debito',
       cast(null as float)	as 'Credito',
       cast(str(@vl_saldo_anterior,25,2) as decimal(25,2)) as 'SaldoAnterior',
       cast(null as varchar)   as 'Identificador' 
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
       ( (Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0) )   
  end 

-------------------------------------------------------------------------------
else if @ic_parametro = 'G' -- escolha geral (todos os fornecedores)
-------------------------------------------------------------------------------
  begin

    -- Tabela temporária com os REMs evitando redundâncias
    select 
      max(cd_rem)               as 'cd_rem',
      max(dt_rem)               as 'dt_rem',
      cd_fornecedor             as 'cd_fornecedor',
      cd_nota_entrada           as 'cd_nota_entrada',
      cd_serie_nota_fiscal      as 'cd_serie_nota_fiscal',
      cd_operacao_fiscal        as 'cd_operacao_fiscal'
    into
      #Nota_Entrada_Registro_Geral
    from 
      Nota_Entrada_Registro
    group by
      cd_fornecedor,
      cd_nota_entrada,
      cd_serie_nota_fiscal,
      cd_operacao_fiscal
    having
      ( (Max(dt_rem) is null) or 
        (Max(dt_rem) <= @dt_final) )

    -- Tabela temporária com os ITENS de REM evitando redundâncias
    select cd_rem, max(cd_operacao_fiscal) as 'cd_operacao_fiscal'
    into #Nota_Entrada_Item_Registro
    from Nota_Entrada_Item_Registro nir
    group by nir.cd_rem

    -- Busca do Saldo Anterior
    select 
      distinct 
      d.cd_fornecedor           as CodFornecedorSA,
      max(f.nm_razao_social)    as Fornecedor,
--      nr.cd_rem                 as Rem,
      0                         as Rem,
      d.dt_vencimento_documento as VencimentoAux,
      -- Caso não tenha Identificação Anterior, Utilizar a Atual - ELIAS 15/07/2004
      isnull(d.cd_identificacao_sap, d.cd_identificacao_document) as 'IdentificacaoSap',
      cast(null as datetime)    as entrada,
      cast(null as varchar)     as cfop,
      cast('S' as char(1))      as vlrcoml,
      cast('S' as char(1))      as destaca,
      cast(null as varchar)     as documento,
      cast(null as varchar)     as serie,
      cast(null as datetime)    as emissao,
      cast(null as datetime)    as vencimento,
      cast(null as datetime)    as pagamento,
      cast(null as float)       as debito, 
      cast(null as float)       as credito,
      max(isnull(d.vl_documento_pagar,0)) as 'VlrSaldoAnterior',
      sum(isnull(p.vl_pagamento_documento,0)) as vl_pagamento_documento,
      cast(null as varchar)     as identificador

    ------- 
    into
      #Tmp_Saldo_Anterior_Fornecedor_Aux
    -------
    from 
      documento_pagar d

    left outer join Fornecedor f on
      d.cd_fornecedor = f.cd_fornecedor

    left outer join documento_pagar_pagamento p on
    d.cd_documento_pagar = p.cd_documento_pagar

    left outer join Serie_Nota_Fiscal s on
      isnull(d.cd_serie_nota_fiscal_entr, s.sg_serie_nota_fiscal) = s.sg_serie_nota_fiscal
      -- Verificar porque essa série está fixa - ELIAS 15/07/2004
      -- isnull(d.cd_serie_nota_fiscal_entr,'U') = s.sg_serie_nota_fiscal

    left outer join #Nota_Entrada_Registro_Geral nr on
    cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
    nr.cd_fornecedor = d.cd_fornecedor and

    -- ELIAS - Verificar forma de não ter mais isso fixo - 15/07/2004
    isnull(s.cd_serie_nota_fiscal, nr.cd_serie_nota_fiscal) = nr.cd_serie_nota_fiscal
    --isnull(s.cd_serie_nota_fiscal,28) = nr.cd_serie_nota_fiscal

    left outer join #Nota_Entrada_Item_Registro nir on
    nr.cd_rem = nir.cd_rem

    left outer join Operacao_Fiscal op on
    nr.cd_operacao_fiscal = op.cd_operacao_fiscal

    left outer join tipo_conta_pagar t on
    t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar

    where 
     (nr.cd_rem is not null) and
     (nr.dt_rem < @dt_inicial) and
     (p.dt_pagamento_documento is null or p.dt_pagamento_documento <= @dt_inicial) and
     (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
      t.ic_razao_contabil = 'S' and
      isnull(op.ic_comercial_operacao,'S') = 'S' and d.cd_fornecedor = 181

    group by d.cd_fornecedor,
             nr.cd_rem,
             d.dt_vencimento_documento,
             isnull(d.cd_identificacao_sap, d.cd_identificacao_document)  -- Ex.: Docto 157 da "Potiguar Marc." até o vencimento é o mesmo


    select  
       CodFornecedorSA,
       max(Fornecedor)        as Fornecedor,
       cast(null as int)      as rem,
       cast(null as datetime) as entrada,
       cast(null as varchar)  as cfop,
       cast('S' as char(1))   as vlrcoml,
       cast('S' as char(1))   as destaca,
       cast(null as varchar)  as documento,
       cast(null as varchar)  as documentoaux,
       cast(null as varchar)  as serie,
       cast(null as datetime) as emissao,
       cast(null as datetime) as vencimento,
       cast(null as datetime) as pagamento,
       cast(null as float)    as debito, 
       cast(null as float)    as credito,
       sum(isnull(vlrsaldoanterior,0)) - sum(Isnull(vl_pagamento_documento,0))  as 'VlrSaldoAnterior',
       cast(null as varchar)  as identificador
    -------
    into 
       #Tmp_Saldo_Anterior_Fornecedor
    -------
    from 
       #Tmp_Saldo_Anterior_Fornecedor_Aux
    group by CodFornecedorSA

 
    -- Diário Auxiliar
    select
      d.cd_fornecedor       		    as 'CodFornecedor',
      f.nm_razao_social			    as 'Fornecedor',
      nr.cd_rem				    as 'REM',
      nr.dt_rem			 	    as 'Entrada',
      op.cd_mascara_operacao		    as 'CFOP',
      isnull(op.ic_comercial_operacao,'S')  as 'VlrComl',
      isnull(ic_destaca_vlr_livro_op_f,'N') as 'Destaca',
      d.cd_identificacao_document	    as 'Documento',
      -- Caso não tenha Identificação Anterior, Utilizar a Atual - ELIAS 15/07/2004
      isnull(d.cd_identificacao_sap, d.cd_identificacao_document) as 'DocumentoAux',
      cast(null as varchar)		    as 'Serie',
      d.dt_emissao_documento_paga	    as 'Emissao',
      d.dt_vencimento_documento		    as 'Vencimento',
      case when p.dt_pagamento_documento not between @dt_inicial and @dt_final then null
      else p.dt_pagamento_documento end	    as 'Pagamento',
      -- Débito
      case when (p.dt_pagamento_documento between @dt_inicial and @dt_final ) then p.vl_pagamento_documento
      else 0 end		            as 'Debito', 
      -- Crédito
      case when (isnull(nr.dt_rem,d.dt_emissao_documento_paga) between @dt_inicial and @dt_final ) then 
        d.vl_documento_pagar
      else 0 end 			    as 'Credito',
      isnull(sa.VlrSaldoAnterior,0)         as 'SaldoAnterior',
      d.cd_identificacao_sap                as 'Identificador'
    -------
    into #Diario_Fornecedor_Geral_Temp
    -------
    from
      Documento_Pagar d

    left outer join Documento_Pagar_Pagamento p on
      d.cd_documento_pagar = p.cd_documento_pagar

    left outer join Fornecedor f on
      d.cd_fornecedor = f.cd_fornecedor

    left outer join Serie_Nota_Fiscal s on
      isnull(d.cd_serie_nota_fiscal_entr, s.sg_serie_nota_fiscal) = s.sg_serie_nota_fiscal
      -- Verificar porque essa série está fixa - ELIAS 15/07/2004
      -- isnull(d.cd_serie_nota_fiscal_entr,'U') = s.sg_serie_nota_fiscal

    left outer join #Nota_Entrada_Registro_Geral nr on
    cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
    nr.cd_fornecedor = d.cd_fornecedor and

    -- ELIAS - Verificar forma de não ter mais isso fixo - 15/07/2004
    isnull(s.cd_serie_nota_fiscal, nr.cd_serie_nota_fiscal) = nr.cd_serie_nota_fiscal
    --isnull(s.cd_serie_nota_fiscal,28) = nr.cd_serie_nota_fiscal

    left outer join Nota_Entrada_Item_Registro nir on 
    nr.cd_rem = nir.cd_rem

    left outer join Operacao_Fiscal op on
    nr.cd_operacao_fiscal = op.cd_operacao_fiscal

    left outer join Tipo_Conta_Pagar t on
    d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar

    left outer join #Tmp_Saldo_Anterior_Fornecedor sa on
    d.cd_fornecedor = sa.CodFornecedorSA

    where
      (nr.cd_rem is not null) and              
      (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final ) and
    (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
      (p.dt_pagamento_documento between @dt_inicial and @dt_final)) or
      (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
       t.ic_razao_contabil = 'S' and d.cd_fornecedor = 181

    order by
       nr.cd_rem,
       nr.dt_rem,
       d.dt_emissao_documento_paga

    insert into #Diario_Fornecedor_Geral_Temp
    select * from #Tmp_Saldo_Anterior_Fornecedor a
    where not exists
       (select 'x' from #Diario_Fornecedor_Geral_Temp 
        where codfornecedor = a.codfornecedorsa) 

    select * from #Diario_Fornecedor_Geral_Temp

    select 
      CodFornecedor,
      Fornecedor,
      max(REM)              as REM,
      max(Entrada)          as Entrada,
      max(Documento)        as Documento,
      max(Serie)            as Serie,
      max(Emissao)          as Emissao,
      Vencimento            as Vencimento,  -- ELIAS 08/09/2004
      max(Pagamento)        as Pagamento,
      sum(Debito)           as Debito, 
      max(Credito)          as Credito,
      max(SaldoAnterior)    as SaldoAnterior,
      max(Identificador)    as Identificador
    into
      #Diario_Fornecedor_Geral
    from
      #Diario_Fornecedor_Geral_Temp
    where
      VlrComl = 'S'
    group by
      CodFornecedor,
      Fornecedor,
      DocumentoAux,
      Pagamento,
      Vencimento   -- 08/09/2004

    select 
     *
    from 
      #Diario_Fornecedor_Geral      

    
    select 
     *
    from 
      #Diario_Fornecedor_Geral      
    where 
       (Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0)
    order by
      Fornecedor,
      Documento,
      Rem,
      Entrada
      
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 'R' -- resumo
-------------------------------------------------------------------------------
  begin

    select 
      max(cd_rem)               as 'cd_rem',
      max(dt_rem)               as 'dt_rem',
      cd_fornecedor             as 'cd_fornecedor',
      cd_nota_entrada           as 'cd_nota_entrada',
      cd_serie_nota_fiscal      as 'cd_serie_nota_fiscal',
      cd_operacao_fiscal        as 'cd_operacao_fiscal'
    into
      #Nota_Entrada_Registro_Resumo
    from 
      Nota_Entrada_Registro
    group by
      cd_fornecedor,
      cd_nota_entrada,
      cd_serie_nota_fiscal,       
      cd_operacao_fiscal
    having
      ( (Max(dt_rem) is null) or 
        (Max(dt_rem) <= @dt_final) )

    -- Tabela temporária com os ITENS de REM evitando redundâncias
    select cd_rem,
           max(cd_operacao_fiscal) as 'cd_operacao_fiscal'
    into #Nota_Entrada_Item_Registro_Resumo
    from Nota_Entrada_Item_Registro nir
    group by nir.cd_rem

    -- Busca do Saldo Anterior
    select 
      distinct  
      d.cd_fornecedor           as CodFornecedorSA,
      max(f.nm_razao_social)    as Fornecedor,
--    nr.cd_rem                 as Rem,
      0                         as Rem,
      d.dt_vencimento_documento as VencimentoAux,
      -- Caso não tenha Identificação Anterior, Utilizar a Atual - ELIAS 15/07/2004
      isnull(d.cd_identificacao_sap, d.cd_identificacao_document) as 'IdentificacaoSap',
      max(isnull(d.vl_documento_pagar,0)) as 'VlrSaldoAnterior',
      cast(null as varchar)     as identificador
    ------- 
    into
      #Tmp_Saldo_Anterior_Fornecedor_Resumo_Aux
    -------
    from 
      documento_pagar d

    left outer join Fornecedor f on
      d.cd_fornecedor = f.cd_fornecedor

    left outer join documento_pagar_pagamento p on
    d.cd_documento_pagar = p.cd_documento_pagar

    left outer join Serie_Nota_Fiscal s on
    isnull(d.cd_serie_nota_fiscal_entr,'U') = s.sg_serie_nota_fiscal

    left outer join #Nota_Entrada_Registro_Resumo nr on
    cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
    nr.cd_fornecedor = d.cd_fornecedor and
      isnull(d.cd_serie_nota_fiscal_entr, s.sg_serie_nota_fiscal) = s.sg_serie_nota_fiscal
      -- Verificar porque essa série está fixa - ELIAS 15/07/2004
      -- isnull(s.cd_serie_nota_fiscal,28) = nr.cd_serie_nota_fiscal


    left outer join #Nota_Entrada_Item_Registro_Resumo nir on
    nr.cd_rem = nir.cd_rem

    left outer join Operacao_Fiscal op on
    nr.cd_operacao_fiscal = op.cd_operacao_fiscal

    left outer join tipo_conta_pagar t on
    t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar

    where 
     (nr.cd_rem is not null) and
     (nr.dt_rem < @dt_inicial) and
     (p.dt_pagamento_documento is null or p.dt_pagamento_documento >= @dt_inicial) and
     (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
      t.ic_razao_contabil = 'S' and
      isnull(op.ic_comercial_operacao,'S') = 'S' 

    group by d.cd_fornecedor,
             nr.cd_rem,
             d.dt_vencimento_documento,
             isnull(d.cd_identificacao_sap, d.cd_identificacao_document)  -- Ex.: Docto 157 da "Potiguar Marc." até o vencimento é o mesmo

    select  
       1 as Chave,
       sum(isnull(vlrsaldoanterior,0)) as 'SaldoAnterior'
    -------
    into 
       #Tmp_Saldo_Anterior_Fornecedor_Resumo
    -------
    from 
       #Tmp_Saldo_Anterior_Fornecedor_Resumo_Aux

    -- Diário Auxiliar
    select
      d.cd_fornecedor 				as 'CodFornecedor',
      f.nm_razao_social                         as 'Fornecedor',
      nr.cd_rem				        as 'REM',
      nr.dt_rem			 	        as 'Entrada',
      op.cd_mascara_operacao		        as 'CFOP',
      isnull(op.ic_comercial_operacao,'S')    	as 'VlrComl',
      isnull(ic_destaca_vlr_livro_op_f,'N')     as 'Destaca',
      d.cd_identificacao_document	        as 'Documento',
      -- Caso não tenha Identificação Anterior, Utilizar a Atual - ELIAS 15/07/2004
      isnull(d.cd_identificacao_sap, d.cd_identificacao_document) as 'DocumentoAux',
      cast(null as varchar)		        as 'Serie',
      d.dt_emissao_documento_paga	        as 'Emissao',
      d.dt_vencimento_documento		        as 'Vencimento',
      case when p.dt_pagamento_documento not between @dt_inicial and @dt_final then null
      else p.dt_pagamento_documento end	        as 'Pagamento',
       -- Débito
      case when (p.dt_pagamento_documento between @dt_inicial and @dt_final ) then p.vl_pagamento_documento
      else 0 end				as 'Debito', 
      -- Crédito
      case when (isnull(nr.dt_rem,d.dt_emissao_documento_paga) between @dt_inicial and @dt_final ) then 
        d.vl_documento_pagar
      else 0 end 				as 'Credito',
      isnull(p.vl_juros_documento_pagar,0) 	as 'Juros',
      isnull(p.vl_desconto_documento,0)  	as 'Desconto',
      isnull(p.vl_abatimento_documento,0) 	as 'Abatimento',
      cast(0 as float)                          as 'SaldoAnterior',
      d.cd_identificacao_sap                    as 'Identificador'
    -------
    into #Diario_Fornecedor_Resumo_Temp
    ------- 
    from
      Documento_Pagar d

    left outer join Documento_Pagar_Pagamento p on
    d.cd_documento_pagar = p.cd_documento_pagar

    left outer join Fornecedor f on
    d.cd_fornecedor = f.cd_fornecedor

    left outer join Serie_Nota_Fiscal s on
      isnull(d.cd_serie_nota_fiscal_entr, s.sg_serie_nota_fiscal) = s.sg_serie_nota_fiscal
      -- Verificar porque essa série está fixa - ELIAS 15/07/2004
      -- isnull(d.cd_serie_nota_fiscal_entr,'U') = s.sg_serie_nota_fiscal

    left outer join #Nota_Entrada_Registro_Resumo nr on 
    cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
    nr.cd_fornecedor = d.cd_fornecedor and
    -- ELIAS - Verificar forma de não ter mais isso fixo - 15/07/2004
    isnull(s.cd_serie_nota_fiscal, nr.cd_serie_nota_fiscal) = nr.cd_serie_nota_fiscal
    --isnull(s.cd_serie_nota_fiscal,28) = nr.cd_serie_nota_fiscal

    left outer join #Nota_Entrada_Item_Registro_Resumo nir on
    nr.cd_rem = nir.cd_rem

    left outer join Operacao_Fiscal op on
    nr.cd_operacao_fiscal = op.cd_operacao_fiscal

    left outer join Tipo_Conta_Pagar t on
    d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar

    where
      (nr.cd_rem is not null) and              
      (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final ) and
      (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
      (p.dt_pagamento_documento between @dt_inicial and @dt_final)) or
      (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
       t.ic_razao_contabil = 'S'
    order by
       nr.cd_rem,
       nr.dt_rem,
       d.dt_emissao_documento_paga

    select
      1 as ChaveResumo, 
      CodFornecedor,
      Fornecedor,
      Max(REM)             as REM,
      cast(Max(Entrada) as datetime)        as Entrada,
      Max(Documento)       as Documento,
      Max(Serie)           as Serie,
      Max(Emissao)         as Emissao,
      Vencimento           as Vencimento,   -- ELIAS 08/09/2004
      Max(Pagamento)       as Pagamento,
      Max(Debito)          as Debito, 
      Max(Credito)         as Credito,
      Max(Juros)           as Juros,
      Max(Desconto)        as Desconto,
      Max(Abatimento)      as Abatimento,
      Max(SaldoAnterior)   as SaldoAnterior,
      Max(Identificador)   as Identificador
    into
      #Diario_Fornecedor_Resumo
    from
      #Diario_Fornecedor_Resumo_Temp
    where
      VlrComl = 'S'
    group by CodFornecedor,
             Fornecedor,
             DocumentoAux,
             Vencimento -- 08/09/2004

    select  
      max(sa.SaldoAnterior) 				as 'SaldoAnterior', 
      sum(Debito) 				        as 'Debito', 
      sum(Credito)				        as 'Credito',
      'SaldoAtual' =
     (max(isnull(sa.SaldoAnterior,0)) - sum(isnull(Debito,0)) + sum(isnull(Credito,0))),
      sum(Juros) 					as 'Juros',
      sum(Desconto) 					as 'Desconto',
      sum(Abatimento) 					as 'Abatimento',
      max(Identificador)                                as 'Identificador' 
    from 
      #Diario_Fornecedor_Resumo

    left outer join #Tmp_Saldo_Anterior_Fornecedor_Resumo sa on
      ChaveResumo = sa.Chave

    having 
       (Sum(Debito) <> 0) or (Sum(Credito) <> 0) or (Sum(sa.SaldoAnterior) <> 0)

  end

