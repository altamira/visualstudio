
CREATE PROCEDURE pr_consulta_documento_pagar_emissao_analitico
@ic_parametro as int,
@ic_duplicata_cancel as int,
@dt_inicial datetime,
@dt_final   datetime

as

begin

  declare @qt_documento_total  int
  declare @vl_saldo_acumulado  numeric(25,2)

  SET DATEFORMAT mdy

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- Somente Fornecedores
-------------------------------------------------------------------------------
  begin

    -- Tabela temporária com os REMs evitando redundâncias
    select 
      max(cd_rem)                 as 'cd_rem',
      max(dt_rem)                 as 'dt_rem',
      cd_fornecedor               as 'cd_fornecedor',
      cd_nota_entrada             as 'cd_nota_entrada',
      max(cd_serie_nota_fiscal)   as 'cd_serie_nota_fiscal',
      max(cd_operacao_fiscal)     as 'cd_operacao_fiscal'
    into
      #Tmp_Nota_Entrada_Registro
    from 
      Nota_Entrada_Registro
    group by
      cd_nota_entrada,
      cd_fornecedor 
    having
      (Max(dt_rem) is not null) and
      (Max(dt_rem) between @dt_inicial and @dt_final)

  select
    distinct
    d.cd_documento_pagar,
    d.dt_cancelamento_documento,
    d.cd_identificacao_document                       as 'Documento',
    cast(convert(varchar, d.dt_emissao_documento_paga, 101) as datetime) as 'Emissao',
    d.cd_identificacao_sap                            as 'IdentificacaoSap',
    isnull(cast(convert(varchar, e.dt_rem, 101) as datetime),
      cast(convert(varchar, d.dt_emissao_documento_paga, 101) as datetime)) as 'Entrada',
    cast(convert(varchar, d.dt_vencimento_documento, 101) as datetime) as 'Vencimento',
    t.nm_tipo_conta_pagar                             as 'Conta',
    d.vl_documento_pagar                              as 'Valor',
    d.vl_saldo_documento_pagar                        as 'Saldo',
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast(d.cd_empresa_diversa as varchar(30))
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast(d.cd_contrato_pagar as varchar(30))
           when (isnull(d.cd_funcionario, 0) <> 0) then cast(d.cd_funcionario as varchar(30))
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.cd_fornecedor as varchar(30))
      end                                             as 'Codigo',               
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_fantasia_fornecedor from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  
      end                                             as 'Favorecido',
      pf.nm_conta_plano_financeiro                    as 'PlanoFinanceiro'

  into #documento_pagar_fornec
  from
    documento_pagar d 
   

  left outer join fornecedor f on 
  d.cd_fornecedor = f.cd_fornecedor 

  left outer join tipo_conta_pagar t on 
  d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar 

  left outer join Serie_Nota_Fiscal s on
  isnull(d.cd_serie_nota_fiscal_entr,'U') = s.sg_serie_nota_fiscal

  left outer join #Tmp_Nota_Entrada_Registro e on 
    d.cd_nota_fiscal_entrada = cast(e.cd_nota_entrada as varchar) and
    d.cd_fornecedor = e.cd_fornecedor and
    isnull(s.cd_serie_nota_fiscal,28) = e.cd_serie_nota_fiscal
  left outer join
  Plano_Financeiro pf
  on
  (d.cd_plano_financeiro = pf.cd_plano_financeiro)

  where
      e.dt_rem between @dt_inicial and @dt_final and
      t.ic_tipo_bordero = 'F'

if @ic_duplicata_cancel = 1
  begin
    select * from #documento_pagar_fornec
    where
      dt_cancelamento_documento is null
    order by
      entrada,
      vencimento,
      favorecido,
      documento
  end
else if @ic_duplicata_cancel = 0
  begin
    select * from #documento_pagar_fornec
   
    order by
      entrada,
      vencimento,
      favorecido,
      documento
  end

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- Somente Diversos
-------------------------------------------------------------------------------
  begin

  select
    distinct
    d.cd_documento_pagar,
    d.dt_cancelamento_documento,
    d.cd_identificacao_document                       as 'Documento',
    cast(convert(varchar, d.dt_emissao_documento_paga, 101) as datetime) as 'Emissao',
    isnull(cast(convert(varchar, e.dt_rem, 101) as datetime),
      cast(convert(varchar, d.dt_emissao_documento_paga, 101) as datetime)) as 'Entrada',
    cast(convert(varchar, d.dt_vencimento_documento, 101) as datetime) as 'Vencimento',
    t.nm_tipo_conta_pagar                             as 'Conta',
    d.vl_documento_pagar                              as 'Valor',
    d.vl_saldo_documento_pagar                        as 'Saldo',
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast(d.cd_empresa_diversa as varchar(30))
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast(d.cd_contrato_pagar as varchar(30))
           when (isnull(d.cd_funcionario, 0) <> 0) then cast(d.cd_funcionario as varchar(30))
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.cd_fornecedor as varchar(30))
      end                                             as 'Codigo',               
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_fantasia_fornecedor from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  
      end                                             as 'Favorecido',
      pf.nm_conta_plano_financeiro                    as 'PlanoFinanceiro'
  into #documento_pagar_div   
  from
    documento_pagar d 
  left outer join
    fornecedor f 
  on 
    d.cd_fornecedor = f.cd_fornecedor 
  left outer join
    tipo_conta_pagar t 
  on 
    d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar 
  left outer join
    Nota_Entrada_Registro e 
  on 
    d.cd_nota_fiscal_entrada = cast(e.cd_nota_entrada as varchar) and
    d.cd_fornecedor = e.cd_fornecedor
  left outer join
  Plano_Financeiro pf
  on
  d.cd_plano_financeiro = pf.cd_plano_financeiro
  where
    e.dt_rem between @dt_inicial and @dt_final and
    t.ic_tipo_bordero = 'D'

if @ic_duplicata_cancel = 1
  begin
    select * from #documento_pagar_div
    where
      dt_cancelamento_documento is null
    order by
      entrada,
      vencimento,
      favorecido,
      documento
  end
else if @ic_duplicata_cancel = 0
  begin
    select * from #documento_pagar_div
   
    order by
      entrada,
      vencimento,
      favorecido,
      documento
  end
  
 end
-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- Todos (Fornecedores e Diversos)
-------------------------------------------------------------------------------
  begin

  select
    distinct
    d.cd_documento_pagar,
    d.dt_cancelamento_documento,
    d.cd_identificacao_document                       as 'Documento',
    cast(convert(varchar, d.dt_emissao_documento_paga, 101) as datetime) as 'Emissao',
    isnull(cast(convert(varchar, e.dt_rem, 101) as datetime),
      cast(convert(varchar, d.dt_emissao_documento_paga, 101) as datetime)) as 'Entrada',
    cast(convert(varchar, d.dt_vencimento_documento, 101) as datetime) as 'Vencimento',
    t.nm_tipo_conta_pagar                             as 'Conta',
    d.vl_documento_pagar                              as 'Valor',
    d.vl_saldo_documento_pagar                        as 'Saldo',
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast(d.cd_empresa_diversa as varchar(30))
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast(d.cd_contrato_pagar as varchar(30))
           when (isnull(d.cd_funcionario, 0) <> 0) then cast(d.cd_funcionario as varchar(30))
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.cd_fornecedor as varchar(30))
      end                                             as 'Codigo',               
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_fantasia_fornecedor from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  
      end                                             as 'Favorecido',
      pf.nm_conta_plano_financeiro                    as 'PlanoFinanceiro'
  into #documento_pagar_todos
  from
    documento_pagar d 
  left outer join
    fornecedor f 
  on 
    d.cd_fornecedor = f.cd_fornecedor 
  left outer join
    tipo_conta_pagar t 
  on 
    d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar 
  left outer join
    Nota_Entrada_Registro e 
  on 
    d.cd_nota_fiscal_entrada = cast(e.cd_nota_entrada as varchar) and
    d.cd_fornecedor = e.cd_fornecedor
  left outer join
  Plano_Financeiro pf
  on
  d.cd_plano_financeiro = pf.cd_plano_financeiro
  where
    e.dt_rem between @dt_inicial and @dt_final

if @ic_duplicata_cancel = 1
  begin
    select * from #documento_pagar_todos
    where
      dt_cancelamento_documento is null
    order by
      entrada,
      vencimento,
      favorecido,
      documento
  end
else if @ic_duplicata_cancel = 0
  begin
    select * from #documento_pagar_todos
   
    order by
      entrada,
      vencimento,
      favorecido,
      documento
  end

end
  
end

