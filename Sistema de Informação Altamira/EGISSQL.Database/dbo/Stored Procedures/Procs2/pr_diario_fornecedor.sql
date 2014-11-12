-------------------------------------------------------------------
--pr_diario_fornecedor
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                 	       2004
-------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Autor(es)           : Elias Pereira da Silva
--Banco de Dados      : EgisSQL
--Objetivo            : Consulta Diarios de Fornecedor.
--Data                : 24/02/2003 - Daniel C. Neto.
--Atualizado          : 15/07/2004 - Vários Acertos - ELIAS
--                    : 08/09/2004 - Acerto no Gruop by que impedia listar documentos
--                                  com identificações iguais, mas com vencimentos distintos - ELIAS
--                    : 07/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
-- 31/01/2005         - Acerto no Saldo Anterior que não estava fazendo a diferença dos valores pagos quando documentos
-- 07.06.2005         - Verifica a Baixa Parcial de Documento - Carlos Fernandes.
--                    - Acertos Diversos
-- 03.10.2005         - Correção na filtragem da nota fiscal de entrada fazendo uso da Série - Fabio César.
-- 15/09/2006         - Acerto no filtro geral, estava dando ambiguos column name - Daniel C. Neto.
-- 18/09/2006         - Otimização do fonte numa única condição, não há diferença no resultado entre
--                      o geral e o individual a não ser o número maior de resultados no geral.
--                    - Daniel C Neto
-- 29.06.2010         - Sped Contábil - Carlos Fernandes
-----------------------------------------------------------------------------------------------------

create procedure pr_diario_fornecedor
@ic_parametro           char(1),   -- se geral (G), individual (I), resumo (R)
@cd_fornecedor          int,       -- fornecedor
@dt_inicial             datetime,  -- período inicial
@dt_final               datetime   -- período final
as

declare @vl_saldo_anterior float   -- guarda saldo anterior
declare @Codigo            int
declare @Fornecedor        int

set     @vl_saldo_anterior = 0
set     @Codigo            = 1


  Select
      distinct 
      max(cd_rem)                                as 'cd_rem',
      max(dt_rem)                                as 'dt_rem',
      nep.cd_documento_pagar                     as 'cd_documento_pagar',
      max(op.cd_mascara_operacao)                as 'cd_mascara_operacao',
      max(isnull(op.ic_comercial_operacao,'S'))  as 'ic_comercial_operacao',
      min(isnull(ic_destaca_vlr_livro_op_f,'N')) as 'ic_destaca_vlr_livro_op_f',
      sum(IsNull(nep.vl_parcela_nota_entrada,0)) as 'vl_parcela_nota_entrada',
      ner.cd_fornecedor                          as 'cd_fornecedor',
      ner.cd_nota_entrada                        as 'cd_nota_entrada',
      ner.cd_serie_nota_fiscal                   as 'cd_serie_nota_fiscal',
      max(ner.cd_operacao_fiscal)                as 'cd_operacao_fiscal',
      snf.sg_serie_nota_fiscal
    into
      #Nota_Entrada_Registro_Geral
    from 
      Nota_Entrada_Registro ner WITH (NOLOCK)
    inner join Nota_Entrada_Parcela nep  WITH (NOLOCK)
      on ner.cd_fornecedor = nep.cd_fornecedor and 
         ner.cd_nota_entrada = nep.cd_nota_entrada and
         ner.cd_operacao_fiscal = nep.cd_operacao_fiscal and
         ner.cd_serie_nota_fiscal = nep.cd_serie_nota_fiscal
    inner join Operacao_Fiscal op WITH (NOLOCK)
        on ner.cd_operacao_fiscal = op.cd_operacao_fiscal
        and (isnull(op.ic_comercial_operacao,'S') = 'S')
    inner join Serie_Nota_Fiscal snf WITH (NOLOCK)
        on snf.cd_serie_nota_fiscal = ner.cd_serie_nota_fiscal      
    where 
      IsNull(ner.cd_fornecedor,0) = ( case when @ic_parametro = 'I' then 
		                      @cd_fornecedor else 
				      IsNull(ner.cd_fornecedor,0) end ) 
    group by
      ner.cd_fornecedor,
      ner.cd_nota_entrada,
      ner.cd_serie_nota_fiscal,
      nep.cd_documento_pagar,
      snf.sg_serie_nota_fiscal
    having
      ( (Max(ner.dt_rem) is null) or 
        (Max(ner.dt_rem) <= @dt_final) ) and
      ( sum(nep.vl_parcela_nota_entrada) > 0 )

    -- Tabela temporária com os ITENS de REM evitando redundâncias
--     select cd_rem, max(cd_operacao_fiscal) as 'cd_operacao_fiscal'
--     into #Nota_Entrada_Item_Registro
--     from Nota_Entrada_Item_Registro nir WITH (NOLOCK)
--     group by nir.cd_rem

   CREATE INDEX INDX_NOTA_ENTRADA
     ON #Nota_Entrada_Registro_Geral (cd_nota_entrada, cd_serie_nota_fiscal, cd_fornecedor)

   CREATE INDEX INDX_DOCUMENTO_PAGAR
     ON #Nota_Entrada_Registro_Geral (cd_documento_pagar)

    --Foram feitos 4 unions por motivo de performance, evitando "OR"
    Select 
      *
    into
      #Tmp_Saldo_Anterior_Fornecedor_Aux
    from
      -- Pegando somente os valores dos documentos em aberto.
    (
      select 
        distinct 
        d.cd_fornecedor           as CodFornecedorSA,
        f.nm_razao_social         as Fornecedor,
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
        isnull(d.vl_documento_pagar,0) as 'VlrSaldoAnterior',
        cast(null as float) as vl_pagamento_documento,
        cast(null as varchar)     as identificador
      from 
        documento_pagar d WITH (NOLOCK)
      INNER JOIN Fornecedor f WITH (NOLOCK) on
        d.cd_fornecedor = f.cd_fornecedor
      left outer join documento_pagar_pagamento p WITH (NOLOCK)
        on d.cd_documento_pagar = p.cd_documento_pagar
  
      inner join #Nota_Entrada_Registro_Geral nr WITH (NOLOCK) 
           on ( ( d.cd_documento_pagar = nr.cd_documento_pagar ) ) 
      left outer join tipo_conta_pagar t WITH (NOLOCK) on
      t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar
  
    where 
      IsNull(d.cd_fornecedor,0) = ( case when @ic_parametro = 'I' then 
		                      @cd_fornecedor else 
				      IsNull(d.cd_fornecedor,0) end ) and

       (nr.dt_rem < @dt_inicial) and
       ( (p.dt_pagamento_documento is null or p.dt_pagamento_documento >= @dt_inicial) or
         (p.dt_pagamento_documento is not null and p.dt_pagamento_documento < @dt_inicial) ) and
       (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
        t.ic_razao_contabil = 'S' and
        isnull(nr.ic_comercial_operacao,'S') = 'S' 
      UNION
      select 
        distinct 
        d.cd_fornecedor           as CodFornecedorSA,
        f.nm_razao_social         as Fornecedor,
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
        isnull(d.vl_documento_pagar,0) as 'VlrSaldoAnterior',
        cast(null as float) as vl_pagamento_documento,
        cast(null as varchar)     as identificador
      from 
        documento_pagar d WITH (NOLOCK)
      INNER JOIN Fornecedor f WITH (NOLOCK) on
        d.cd_fornecedor = f.cd_fornecedor
      left outer join documento_pagar_pagamento p WITH (NOLOCK)
        on d.cd_documento_pagar = p.cd_documento_pagar
  
      inner join #Nota_Entrada_Registro_Geral nr WITH (NOLOCK) 
           on ( ( nr.cd_documento_pagar is null ) and 
                ( d.cd_nota_fiscal_entrada = nr.cd_nota_entrada
                  and d.cd_fornecedor = nr.cd_fornecedor
                  and d.cd_serie_nota_fiscal_entr = nr.sg_serie_nota_fiscal ) )
      left outer join tipo_conta_pagar t WITH (NOLOCK) on
      t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar
  
      where 
        IsNull(d.cd_fornecedor,0) = ( case when @ic_parametro = 'I' then 
		                      @cd_fornecedor else 
				      IsNull(d.cd_fornecedor,0) end ) and

       (nr.dt_rem < @dt_inicial) and
       ( (p.dt_pagamento_documento is null or p.dt_pagamento_documento >= @dt_inicial) or
         (p.dt_pagamento_documento is not null and p.dt_pagamento_documento < @dt_inicial) ) and
       (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
        t.ic_razao_contabil = 'S' and
        isnull(nr.ic_comercial_operacao,'S') = 'S' 

    ) a
  union
  -- Pegando somente os valores pagos antes da data inicial para fazer a diferença no final evitando duplicações.
  (
    Select 
      distinct 
      d.cd_fornecedor           as CodFornecedorSA,
      f.nm_razao_social         as Fornecedor,
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
      p.dt_pagamento_documento
       as pagamento,
      cast(null as float)       as debito, 
      cast(null as float)       as credito,
      0 as 'VlrSaldoAnterior',
      p.vl_pagamento_documento,
      cast(null as varchar)     as identificador
    from 
      documento_pagar d WITH (NOLOCK)

    INNER JOIN Fornecedor f WITH (NOLOCK) on
      d.cd_fornecedor = f.cd_fornecedor

    left outer join documento_pagar_pagamento p WITH (NOLOCK) on
    d.cd_documento_pagar = p.cd_documento_pagar

    INNER join #Nota_Entrada_Registro_Geral nr 
           on ( d.cd_documento_pagar = nr.cd_documento_pagar ) 
    left outer join tipo_conta_pagar t WITH (NOLOCK) on
    t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar

    where 
      IsNull(d.cd_fornecedor,0) = ( case when @ic_parametro = 'I' then 
		                      @cd_fornecedor else 
				      IsNull(d.cd_fornecedor,0) end ) and
     (nr.dt_rem < @dt_inicial) and
     (p.dt_pagamento_documento is not null and p.dt_pagamento_documento < @dt_inicial) and
     (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
      t.ic_razao_contabil = 'S' and
      isnull(nr.ic_comercial_operacao,'S') = 'S'

    UNION

    Select 
      distinct 
      d.cd_fornecedor           as CodFornecedorSA,
      f.nm_razao_social         as Fornecedor,
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
      p.dt_pagamento_documento
       as pagamento,
      cast(null as float)       as debito, 
      cast(null as float)       as credito,
      0 as 'VlrSaldoAnterior',
      p.vl_pagamento_documento,
      cast(null as varchar)     as identificador
    from 
      documento_pagar d WITH (NOLOCK)

    INNER JOIN Fornecedor f WITH (NOLOCK) on
      d.cd_fornecedor = f.cd_fornecedor

    left outer join documento_pagar_pagamento p WITH (NOLOCK) on
    d.cd_documento_pagar = p.cd_documento_pagar

    INNER join #Nota_Entrada_Registro_Geral nr 
           on ( ( nr.cd_documento_pagar is null ) and 
                ( d.cd_nota_fiscal_entrada = nr.cd_nota_entrada
                  and d.cd_fornecedor = nr.cd_fornecedor
                  and d.cd_serie_nota_fiscal_entr = nr.sg_serie_nota_fiscal ) )
 
    left outer join tipo_conta_pagar t WITH (NOLOCK) on
    t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar

    where 
      IsNull(d.cd_fornecedor,0) = ( case when @ic_parametro = 'I' then 
		                      @cd_fornecedor else 
				      IsNull(d.cd_fornecedor,0) end ) and

     (nr.dt_rem < @dt_inicial) and
     (p.dt_pagamento_documento is not null and p.dt_pagamento_documento < @dt_inicial) and
     (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
      t.ic_razao_contabil = 'S' and
      isnull(nr.ic_comercial_operacao,'S') = 'S'

   ) 
 


    select distinct
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
       sum(isnull(vlrsaldoanterior,0) - IsNull(vl_pagamento_documento,0)) as 'VlrSaldoAnterior',
       cast(null as varchar)  as identificador,
       cast(0 as float)    as 'Juros',
       cast(0 as float)    as 'Desconto',
       cast(0 as float)    as 'Abatimento'

    -------
    into 
       #Tmp_Saldo_Anterior_Fornecedor
    -------
    from 
       #Tmp_Saldo_Anterior_Fornecedor_Aux
    group by CodFornecedorSA
  

    -- Diário Auxiliar
    select
        *
    -------
    into #Diario_Fornecedor_Geral_Temp
    -------
    From
    (
      select
        d.cd_fornecedor       		            as 'CodFornecedor',
        f.nm_razao_social			    as 'Fornecedor',
        nr.cd_rem				    as 'REM',
        nr.dt_rem			 	    as 'Entrada',
        nr.cd_mascara_operacao		            as 'CFOP',
        isnull(nr.ic_comercial_operacao,'S')        as 'VlrComl',
        isnull(ic_destaca_vlr_livro_op_f,'N')       as 'Destaca',
        d.cd_identificacao_document	            as 'Documento',
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
        isnull(d.cd_identificacao_sap, d.cd_identificacao_document)  as 'Identificador',
        isnull(p.vl_juros_documento_pagar,0) 	as 'Juros',
        isnull(p.vl_desconto_documento,0)  	as 'Desconto',
        isnull(p.vl_abatimento_documento,0) 	as 'Abatimento'
      from
        Documento_Pagar d WITH (NOLOCK)
  
      left outer join Documento_Pagar_Pagamento p WITH (NOLOCK) on
        d.cd_documento_pagar = p.cd_documento_pagar
  
      inner join Fornecedor f WITH (NOLOCK) on
        d.cd_fornecedor = f.cd_fornecedor
  
      INNER join #Nota_Entrada_Registro_Geral nr 
                 on ( ( nr.cd_documento_pagar is null )  
                      and ( d.cd_nota_fiscal_entrada = nr.cd_nota_entrada
                      and d.cd_fornecedor = nr.cd_fornecedor
                      and d.cd_serie_nota_fiscal_entr = nr.sg_serie_nota_fiscal ) )
  
      left outer join Tipo_Conta_Pagar t WITH (NOLOCK) on
        d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar
  
      left outer join #Tmp_Saldo_Anterior_Fornecedor sa on
      d.cd_fornecedor = sa.CodFornecedorSA
  
      where
      IsNull(d.cd_fornecedor,0) = ( case when @ic_parametro = 'I' then 
		                      @cd_fornecedor else 
				      IsNull(d.cd_fornecedor,0) end ) and
        (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final ) and
      (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
        (p.dt_pagamento_documento between @dt_inicial and @dt_final)) or
        (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
         t.ic_razao_contabil = 'S' 
  
    ) a
    union
    (
      select
        d.cd_fornecedor       		    as 'CodFornecedor',
        f.nm_razao_social			    as 'Fornecedor',
        nr.cd_rem				    as 'REM',
        nr.dt_rem			 	    as 'Entrada',
        nr.cd_mascara_operacao		    as 'CFOP',
        isnull(nr.ic_comercial_operacao,'S')  as 'VlrComl',
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
        isnull(d.cd_identificacao_sap, d.cd_identificacao_document)  as 'Identificador',
        isnull(p.vl_juros_documento_pagar,0) 	as 'Juros',
        isnull(p.vl_desconto_documento,0)  	as 'Desconto',
        isnull(p.vl_abatimento_documento,0) 	as 'Abatimento'
      from
        Documento_Pagar d WITH (NOLOCK)
  
      left outer join Documento_Pagar_Pagamento p WITH (NOLOCK) on
        d.cd_documento_pagar = p.cd_documento_pagar
  
      left outer join Fornecedor f WITH (NOLOCK) on
        d.cd_fornecedor = f.cd_fornecedor
  
      INNER join #Nota_Entrada_Registro_Geral nr 
                 on ( d.cd_documento_pagar = nr.cd_documento_pagar )  
      left outer join Tipo_Conta_Pagar t WITH (NOLOCK) on
      d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar
  
      left outer join #Tmp_Saldo_Anterior_Fornecedor sa on
      d.cd_fornecedor = sa.CodFornecedorSA
  
      where
        IsNull(d.cd_fornecedor,0) = ( case when @ic_parametro = 'I' then 
	 	                      @cd_fornecedor else 
				      IsNull(d.cd_fornecedor,0) end ) and
        (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final ) and
      (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
        (p.dt_pagamento_documento between @dt_inicial and @dt_final)) or
        (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
         t.ic_razao_contabil = 'S' 
      )

    
    ALTER TABLE 
      #Diario_Fornecedor_Geral_Temp 
    ALTER COLUMN Documento VARCHAR(30) NULL

    ALTER TABLE 
      #Diario_Fornecedor_Geral_Temp 
    ALTER COLUMN DocumentoAux VARCHAR(30) NULL

    ALTER TABLE 
      #Diario_Fornecedor_Geral_Temp 
    ALTER COLUMN Identificador VARCHAR(30) NULL



    insert into #Diario_Fornecedor_Geral_Temp
    select * from #Tmp_Saldo_Anterior_Fornecedor a
    where not exists
       (select 'x' from #Diario_Fornecedor_Geral_Temp 
        where codfornecedor = a.codfornecedorsa) 

    select 
      CodFornecedor,
      Fornecedor,
      max(REM)              as REM,
      max(Entrada)          as Entrada,
      max(Documento)        as Documento,
      max(Serie)            as Serie,
      max(Emissao)          as Emissao,
      Vencimento            as Vencimento,  -- ELIAS 08/09/2004
      Pagamento,
      sum(Debito)           as Debito, 
      sum(Credito)          as Credito,
      sum(SaldoAnterior)    as SaldoAnterior,
      max(Identificador)    as Identificador,
      sum(Juros)            as 'Juros',
      sum(Desconto)  	    as 'Desconto',
      sum(Abatimento) 	    as 'Abatimento'

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
      Vencimento,   -- 08/09/2004
      Pagamento

    if @ic_parametro in ('G','I')
    begin
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

        --Montagem da Tabela Auxiliar do Sped Contábi---------------------------------------
         
        delete from sped_razao_auxiliar

        select
          identity(int,1,1)  as cd_controle,
          1                  as cd_livro,
          CodFornecedor      as cd_cliente,
          Fornecedor         as nm_cliente,
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
          #Diario_Fornecedor_Geral
       where  
          isnull(CodFornecedor,0)<>0
          and 
          (Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0) 
       order by
         Fornecedor
      
       insert into sped_razao_auxiliar
       select
         *
       from
         #sped_razao_auxiliar
       where
         isnull(cd_cliente,0)>0

       --select * from sped_razao_auxiliar

    end
    else
    begin

      select  
        sum(distinct IsNull(SaldoAnterior,0)) 				as 'SaldoAnterior', 
        sum(Debito) 				        as 'Debito', 
        sum(Credito)				        as 'Credito',
        'SaldoAtual' =
       (sum(distinct IsNull(SaldoAnterior,0)) - sum(isnull(Debito,0)) + sum(isnull(Credito,0))),
        sum(Juros) 					as 'Juros',
        sum(Desconto) 					as 'Desconto',
        sum(Abatimento) 					as 'Abatimento',
        max(Identificador)                                as 'Identificador' 
      from 
        #Diario_Fornecedor_Geral
      where 
        (Debito) <> 0 or (Credito) <> 0 or (SaldoAnterior) <> 0
    end



