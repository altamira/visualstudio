----------------------------------------------------------------------------------
--pr_conta_corrente_fornecedor
----------------------------------------------------------------------------------
--Global Business Solution Ltda                                               2004
----------------------------------------------------------------------------------
--Stored Procedure     : SQL Server Microsoft 7.0/2000  
--Autor(es)            : Elias Pereira da Silva
--Objetivo             : Conta Corrente de Fornecedores
--Banco de Dados       : EgisSql ou EgisAdmin
--Data                 : 31/08/2004
--                     : 28/10/2004 - Inclusão do Campo de CNPJ do Fornecedor - ELIAS
--                     : 08/12/2004 - Implementado Rotina para Listagem de Todos os 
--                                    Fornecedores - ELIAS
--                     : 07/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 15.05.2005 - Ordem de Apresentação ( CNPJ/Alfabética ) - Carlos Fernandes
--                     : 03/06/2005 - Acertado a Procedure POis não estava fazendo a busca de apenas um fornecedor Parametro 1 - RAFAEL SANTIAGO
-- 08.07.2010 - Carlos Fernandes
---------------------------------------------------------------------------------------------------

create procedure pr_conta_corrente_fornecedor
@ic_parametro           int,
@cd_fornecedor          int,
@dt_inicial             datetime,
@dt_final               datetime,
@ic_ordem_apresentacao  int = 0

as 

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta apenas o fornecedor passado
-------------------------------------------------------------------------------
  begin

  -- COMPOSICÃO DE FORNECEDORES
  --select * from nota_entrada_registro

  select 
    max(cd_rem)             as 'cd_rem',
    max(dt_rem)             as 'dt_rem',
    cd_fornecedor,
    cd_nota_entrada,
    cd_serie_nota_fiscal,
    max(cd_operacao_fiscal) as 'cd_operacao_fiscal'
  into
    #NER
  from 
    Nota_Entrada_Registro with (nolock) 
  where
    cd_fornecedor = @cd_fornecedor
  group by
    cd_fornecedor,
    cd_nota_entrada,
    cd_serie_nota_fiscal

  
  select
    a.cd_documento_pagar as 'Chave',
    f.nm_razao_social    as 'raz_cli',   -- mantido p/ compatibilidade - Elias 21/05/2002
    f.cd_cnpj_fornecedor,
    a.cd_fornecedor,
    nr.cd_rem,
    isnull(nr.dt_rem,a.dt_emissao_documento_paga) as 'dt_rem',
    a.cd_identificacao_document                   as 'cd_documento_pagar',
    cast(null as char(4))                         as 'cd_serie',
    a.dt_emissao_documento_paga    as 'dt_emissao',
    a.dt_vencimento_documento      as 'dt_vencimento',
    isnull(a.vl_documento_pagar,0) as 'vl_documento',   
    (isnull(a.vl_documento_pagar,0) - isnull((select sum(dpp.vl_pagamento_documento) from
                            documento_pagar_pagamento dpp with (nolock) 
                            where
                            dpp.cd_documento_pagar = a.cd_documento_pagar and
                            dpp.dt_pagamento_documento <= @dt_final),0)) as 'vl_saldo',
   (isnull(a.vl_documento_pagar,0) - isnull(a.vl_saldo_documento_pagar,0)) as 'Pagamento'
  into #CI
  from
    Tipo_Conta_Pagar b,
    Fornecedor f,
    Documento_Pagar a
  left outer join
    #NER nr
  on
    cast(a.cd_nota_fiscal_entrada as varchar) = nr.cd_nota_entrada and
    nr.cd_fornecedor = a.cd_fornecedor                             and
    nr.cd_serie_nota_fiscal = a.cd_serie_nota_fiscal

  where     
    a.cd_fornecedor = @cd_fornecedor and
    f.cd_fornecedor = a.cd_fornecedor and
    isnull(nr.dt_rem, a.dt_emissao_documento_paga) <= @dt_final and  
    ((select 
       max(c.dt_pagamento_documento) 
     from 
       documento_pagar_pagamento c 
     where 
       c.cd_documento_pagar = a.cd_documento_pagar) is null or
    (select 
       max(c.dt_pagamento_documento) 
     from 
       documento_pagar_pagamento c 
     where 
       c.cd_documento_pagar = a.cd_documento_pagar) > @dt_final) and 
    a.dt_cancelamento_documento is null and
    a.cd_tipo_conta_pagar = b.cd_tipo_conta_pagar and
    b.ic_razao_contabil = 'S'

  -- DIÁRIO DE FORNECEDORES
  select 
    max(cd_rem)               as 'cd_rem',
    max(dt_rem)               as 'dt_rem',
    cd_fornecedor             as 'cd_fornecedor',
    cd_nota_entrada           as 'cd_nota_entrada',
    cd_serie_nota_fiscal      as 'cd_serie_nota_fiscal',
    cd_operacao_fiscal        as 'cd_operacao_fiscal'
  into
    #NERI
  from 
    nota_entrada_registro with (nolock)
  where
    cd_fornecedor = @cd_fornecedor
  group by
    cd_fornecedor,
    cd_nota_entrada,
    cd_serie_nota_fiscal,       
    cd_operacao_fiscal
  having
    ( (max(dt_rem) is null) or 
      (max(dt_rem) <= @dt_final) )

  select
    d.cd_documento_pagar 	            as 'Chave',
    d.cd_fornecedor 			    as 'CodFornecedor',
    f.nm_razao_social			    as 'Fornecedor',
    f.cd_cnpj_fornecedor		    as 'CNPJ',
    nr.cd_rem				    as 'REM',
    nr.dt_rem			 	    as 'Entrada',
    op.cd_mascara_operacao		    as 'CFOP',
    isnull(op.ic_comercial_operacao,'S')    as 'VlrComl',
    isnull(ic_destaca_vlr_livro_op_f,'N')   as 'Destaca',
    d.cd_identificacao_document	            as 'Documento',
    -- Caso não tenha Identificação Anterior, Utilizar a Atual - ELIAS 15/07/2004
    isnull(d.cd_identificacao_sap, d.cd_identificacao_document) as 'DocumentoAux',
    cast(null as varchar)		    as 'Serie',
    d.dt_emissao_documento_paga	            as 'Emissao',
    d.dt_vencimento_documento		    as 'Vencimento',
    case when p.dt_pagamento_documento not between @dt_inicial and @dt_final then null
    else p.dt_pagamento_documento end	    as 'Pagamento',
    -- Débito
    case when (p.dt_pagamento_documento between @dt_inicial and @dt_final ) then p.vl_pagamento_documento
    else 0.00 end			    as 'Debito', 
    -- Crédito
    case when (isnull(nr.dt_rem,d.dt_emissao_documento_paga) between @dt_inicial and @dt_final ) then 
           d.vl_documento_pagar
         when (p.dt_pagamento_documento between @dt_inicial and @dt_final) then
           d.vl_documento_pagar      
    else 0.00 end 			    as 'Credito',
    cast(null as decimal(25,2))             as 'SaldoAnterior',
    d.cd_identificacao_sap                 as 'Identificador'
  into
    #DFIT
  from
    Documento_Pagar d  with (nolock) 

  left outer join Documento_Pagar_Pagamento p on 
    d.cd_documento_pagar = p.cd_documento_pagar

  left outer join Fornecedor f on 
    d.cd_fornecedor = f.cd_fornecedor

  left outer join Serie_Nota_Fiscal s on
    isnull(d.cd_serie_nota_fiscal_entr, s.sg_serie_nota_fiscal) = s.sg_serie_nota_fiscal

  left outer join #NERI nr on
  cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
  nr.cd_fornecedor = d.cd_fornecedor                             and
  nr.cd_serie_nota_fiscal = d.cd_serie_nota_fiscal

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
    isnull(t.ic_razao_contabil,'S') = 'S'
  order by   
    nr.cd_rem,
    nr.dt_rem,
    d.dt_emissao_documento_paga,
    d.cd_identificacao_document

  select
    Chave,
    CodFornecedor,
    Fornecedor,
    CNPJ,
    max(REM)                       as REM,
    cast(max(Entrada) as datetime) as Entrada,
    max(Documento)                 as Documento,
    max(Serie)          as Serie,
    max(Emissao)        as Emissao,
    max(Vencimento)     as Vencimento,
    max(Pagamento)      as Pagamento,
    max(Debito)         as Debito, 
    max(Credito)        as Credito,
    max(SaldoAnterior)  as SaldoAnterior,
    max(Identificador)  as Identificador 
  into
    #DFI
  from
    #DFIT
  where
    VlrComl = 'S'      
  group by Chave,
           CodFornecedor,
           Fornecedor,
           CNPJ,
           DocumentoAux

  -- 
  if not exists(select * from 
                  #DFI
                where 
                  ( (Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0) )) 
  begin     

   select
     d.cd_documento_pagar                  as 'Chave',
     d.cd_fornecedor 		           as 'CodFornecedor',
     cast(f.nm_razao_social as varchar)    as 'Fornecedor',
     cast(f.cd_cnpj_fornecedor as varchar) as 'CNPJ',
     null 			as 'REM',
     cast(null as datetime)	as 'Entrada',
     cast(null as varchar)	as 'Documento',
     cast(null as varchar)	as 'Serie',
     cast(null as datetime)	as 'Emissao',
     cast(null as datetime)	as 'Vencimento',
     cast(null as datetime)	as 'Pagamento',
     cast(null as float)	as 'Debito',
     cast(null as float)	as 'Credito',
     cast(null as decimal(25,2)) as 'SaldoAnterior',
     cast(null as varchar)   as 'Identificador' 
   into
     #DV
   from
     Documento_Pagar d with (nolock) 
   left outer join
     Fornecedor f
   on
     d.cd_fornecedor = f.cd_fornecedor
   where
     @cd_fornecedor = f.cd_fornecedor
   group by d.cd_documento_pagar, d.cd_fornecedor, f.cd_cnpj_fornecedor, cast(f.nm_razao_social as varchar)

	insert into #DV
	select c.Chave, c.cd_fornecedor, c.raz_cli, c.cd_cnpj_fornecedor, c.cd_rem,
	    c.dt_rem, c.cd_documento_pagar, c.cd_serie, c.dt_emissao,
	    c.dt_vencimento, null, null, c.vl_documento, null, null
	from  #CI c, #DV dv
	where c.Chave <> dv.Chave
	
	select * from #DV order by REM
                        
 end            
 else
 begin 

   select * into #DC from #DFI
   where 
     ( (Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0) )  

   insert into #DC
   select c.Chave, c.cd_fornecedor, c.raz_cli, c.cd_cnpj_fornecedor, c.cd_rem,
          c.dt_rem, c.cd_documento_pagar, c.cd_serie, c.dt_emissao,
          c.dt_vencimento, null, null, c.vl_documento, null, null
   from #CI c where c.Chave not in (select dc.Chave from #DC dc)
  
   select * from #DC order by REM

 end 


end
-------------------------------------------------------------------------------
else if @ic_parametro = 2    -- consulta geral (Todos os Fornecedores)
-------------------------------------------------------------------------------
  begin

  -- COMPOSIÇÃO
  select 
    max(cd_rem) as 'cd_rem',
    max(dt_rem) as 'dt_rem',
    cd_fornecedor,
    cd_nota_entrada,
    cd_serie_nota_fiscal,
    max(cd_operacao_fiscal) as 'cd_operacao_fiscal'
  into
    #NER_Geral
  from 
    Nota_Entrada_Registro with (nolock) 
  group by
    cd_fornecedor,
    cd_nota_entrada,
    cd_serie_nota_fiscal

  
  select
    a.cd_documento_pagar as 'Chave',
    f.nm_razao_social as 'raz_cli',   -- mantido p/ compatibilidade - Elias 21/05/2002
    f.cd_cnpj_fornecedor,
    a.cd_fornecedor,
    nr.cd_rem,
    isnull(nr.dt_rem,a.dt_emissao_documento_paga) as 'dt_rem',
    a.cd_identificacao_document as 'cd_documento_pagar',
    cast(null as char(4)) as 'cd_serie',
    a.dt_emissao_documento_paga as 'dt_emissao',
    a.dt_vencimento_documento as 'dt_vencimento',
    isnull(a.vl_documento_pagar,0) as 'vl_documento',   
    (isnull(a.vl_documento_pagar,0) - isnull((select sum(dpp.vl_pagamento_documento) from
                            documento_pagar_pagamento dpp where
                            dpp.cd_documento_pagar = a.cd_documento_pagar and
                            dpp.dt_pagamento_documento <= @dt_final),0)) as 'vl_saldo',
   (isnull(a.vl_documento_pagar,0) - isnull(a.vl_saldo_documento_pagar,0)) as 'Pagamento'
  into #CI_Geral
  from
    Tipo_Conta_Pagar b,
    Fornecedor f,
    Documento_Pagar a
  left outer join
    #NER_Geral nr
  on
    cast(a.cd_nota_fiscal_entrada as varchar) = nr.cd_nota_entrada and
    nr.cd_fornecedor = a.cd_fornecedor and
    nr.cd_serie_nota_fiscal = a.cd_serie_nota_fiscal


  where     
    f.cd_fornecedor = a.cd_fornecedor and
    isnull(nr.dt_rem, a.dt_emissao_documento_paga) <= @dt_final and  
    ((select 
       max(c.dt_pagamento_documento) 
     from 
       documento_pagar_pagamento c with (nolock) 
     where 
       c.cd_documento_pagar = a.cd_documento_pagar) is null or
    (select 
       max(c.dt_pagamento_documento) 
     from 
       documento_pagar_pagamento c with (nolock) 
     where 
       c.cd_documento_pagar = a.cd_documento_pagar) > @dt_final) and 
    a.dt_cancelamento_documento is null and
    a.cd_tipo_conta_pagar = b.cd_tipo_conta_pagar and
    b.ic_razao_contabil = 'S'

  -- DIÁRIO
  select 
    max(cd_rem)               as 'cd_rem',
    max(dt_rem)               as 'dt_rem',
    cd_fornecedor             as 'cd_fornecedor',
    cd_nota_entrada           as 'cd_nota_entrada',
    cd_serie_nota_fiscal      as 'cd_serie_nota_fiscal',
    cd_operacao_fiscal        as 'cd_operacao_fiscal'
  into
    #NERI_Geral
  from 
    nota_entrada_registro with (nolock) 
  group by
    cd_fornecedor,
    cd_nota_entrada,
    cd_serie_nota_fiscal,       
    cd_operacao_fiscal
  having
    ( (max(dt_rem) is null) or 
      (max(dt_rem) <= @dt_final) )

  select
    d.cd_documento_pagar 	    as 'Chave',
    d.cd_fornecedor 			    as 'CodFornecedor',
    f.nm_razao_social			    as 'Fornecedor',
    f.cd_cnpj_fornecedor		  as 'CNPJ',
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
         when (p.dt_pagamento_documento between @dt_inicial and @dt_final) then
           d.vl_documento_pagar      
    else 0 end 			    as 'Credito',
    cast(null as decimal(25,2)) as 'SaldoAnterior',
    d.cd_identificacao_sap                as 'Identificador'
  into
    #DFIT_Geral
  from
    Documento_Pagar d with (nolock) 

  left outer join Documento_Pagar_Pagamento p on 
    d.cd_documento_pagar = p.cd_documento_pagar

  left outer join Fornecedor f on 
    d.cd_fornecedor = f.cd_fornecedor

  left outer join Serie_Nota_Fiscal s on
    isnull(d.cd_serie_nota_fiscal_entr, s.sg_serie_nota_fiscal) = s.sg_serie_nota_fiscal

  left outer join #NERI_Geral nr on
  cast(nr.cd_nota_entrada as varchar) = d.cd_nota_fiscal_entrada and
  nr.cd_fornecedor = d.cd_fornecedor  and
  nr.cd_serie_nota_fiscal = d.cd_serie_nota_fiscal

  left outer join Nota_Entrada_Item_Registro nir on
  nr.cd_rem = nir.cd_rem

  left outer join Operacao_Fiscal op on
  nir.cd_operacao_fiscal = op.cd_operacao_fiscal

  left outer join Tipo_Conta_Pagar t on 
  d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar

  where
    (nr.cd_rem is not null) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final ) and
    (((p.dt_pagamento_documento is null and nr.dt_rem between @dt_inicial and @dt_final) or 
    (p.dt_pagamento_documento between @dt_inicial and @dt_final)) or
    (nr.dt_rem is null or nr.dt_rem between @dt_inicial and @dt_final)) and
    isnull(t.ic_razao_contabil,'S') = 'S'
  order by   
    nr.cd_rem,
    nr.dt_rem,
    d.dt_emissao_documento_paga,
    d.cd_identificacao_document

  select
    Chave,
    CodFornecedor,
    Fornecedor,
    CNPJ,
    max(REM)            as REM,
    cast(max(Entrada) as datetime) as Entrada,
    max(Documento)      as Documento,
    max(Serie)          as Serie,
    max(Emissao)        as Emissao,
    max(Vencimento)     as Vencimento,
    max(Pagamento)      as Pagamento,
    max(Debito)         as Debito, 
    max(Credito)        as Credito,
    max(SaldoAnterior)  as SaldoAnterior,
    max(Identificador)  as Identificador 
  into
    #DFI_Geral
  from
    #DFIT_Geral
  where
    VlrComl = 'S'      
  group by Chave,
           CodFornecedor,
           Fornecedor,
           CNPJ,
           DocumentoAux

  if not exists(select * from 
                  #DFI_Geral
                where 
                  ( (Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0) )) 
  begin     

   select
     d.cd_documento_pagar        as 'Chave',
     d.cd_fornecedor 		       as 'CodFornecedor',
     cast(f.nm_razao_social as varchar)  	as 'Fornecedor',
     cast(f.cd_cnpj_fornecedor as varchar) as 'CNPJ',
     null 			as 'REM',
     cast(null as datetime)	as 'Entrada',
     cast(null as varchar)	as 'Documento',
     cast(null as varchar)	as 'Serie',
     cast(null as datetime)	as 'Emissao',
     cast(null as datetime)	as 'Vencimento',
     cast(null as datetime)	as 'Pagamento',
     cast(null as float)	as 'Debito',
     cast(null as float)	as 'Credito',
     cast(null as decimal(25,2)) as 'SaldoAnterior',
     cast(null as varchar)   as 'Identificador' 
   into
     #DV_Geral
   from
     Documento_Pagar d with (nolock) 
   left outer join
     Fornecedor f
   on
     d.cd_fornecedor = f.cd_fornecedor
   group by d.cd_documento_pagar, d.cd_fornecedor, f.cd_cnpj_fornecedor, cast(f.nm_razao_social as varchar)

	insert into #DV_Geral
	select c.Chave, c.cd_fornecedor, c.raz_cli, c.cd_cnpj_fornecedor, c.cd_rem,
	    c.dt_rem, c.cd_documento_pagar, c.cd_serie, c.dt_emissao,
	    c.dt_vencimento, null, null, c.vl_documento, null, null
	from  #CI_Geral c, #DV_Geral dv
	where c.Chave <> dv.Chave

	select * from #DV_Geral order by Fornecedor, REM
                        
 end            
 else
 begin 

   select * into #DC_Geral from #DFI_Geral
   where 
     ( (Debito <> 0) or (Credito <> 0) or (SaldoAnterior <> 0) )  

   insert into #DC_Geral
   select c.Chave, c.cd_fornecedor, c.raz_cli, c.cd_cnpj_fornecedor, c.cd_rem,
          c.dt_rem, c.cd_documento_pagar, c.cd_serie, c.dt_emissao,
          c.dt_vencimento, null, null, c.vl_documento, null, null
   from #CI_Geral c where c.Chave not in (select dc.Chave from #DC_Geral dc)
  
   if @ic_ordem_apresentacao = 1
      select * from #DC_Geral order by CNPJ, REM
   else
      select * from #DC_Geral order by Fornecedor, REM

 end 

end
