
CREATE PROCEDURE pr_consulta_bordero_diverso
@ic_gerado_sap char(1),  -- (S)im - borderô gerado p/ sistema antigo, (N)ão - gerado p/ sistema novo
@cd_bordero    int
AS

-------------------------------------------------------------------------------
  if @ic_gerado_sap = 'S'   -- gerado p/ sistema sap/dos (antigo)
-------------------------------------------------------------------------------
    begin

      select distinct
        t.sg_tipo_conta_pagar,
        case when (isnull(d.cd_empresa_diversa, 0)     <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
             when (isnull(d.cd_contrato_pagar, 0)      <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))
             when (isnull(d.cd_funcionario, 0)         <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))
             when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(50))
        end                             as 'nm_favorecido',               
        p.nm_obs_documento_pagar,
  	case when (isnull(d.nm_fantasia_fornecedor, '') <> '') then (select f.cd_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor)
          when (isnull(d.cd_empresa_diversa, 0) <> 0) then (select z.cd_banco from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa)
          when (isnull(d.cd_funcionario, 0) <> 0) then (select k.cd_banco from funcionario k where k.cd_funcionario = d.cd_funcionario)
          when (isnull(d.cd_contrato_pagar, 0) <> 0) then (select f.cd_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor)
    	end as 'cd_banco',               
    	case when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select f.cd_agencia_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
          when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.cd_agencia_banco from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
          when (isnull(d.cd_funcionario, 0) <> 0) then cast((select k.cd_agencia_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20))
          when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select f.cd_agencia_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar(20))
    	end as 'cd_agencia_banco',               
    	case when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select f.cd_conta_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
  	  when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.cd_conta_corrente from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
          when (isnull(d.cd_funcionario, 0) <> 0) then cast((select k.cd_conta_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20)) 
          when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select f.cd_conta_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (20))
    	end as 'cd_conta_corrente', 
    	case when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select f.nm_razao_social from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(40))
  	  when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(40))
          when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select k.nm_funcionario     from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(40)) 
          when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select f.nm_razao_social    from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (40))
    	end as 'nm_razao_social', 
    	case when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select f.cd_cnpj_fornecedor from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
  	  when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.cd_cnpj_empresa_diversa  from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
          when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select k.cd_cpf_funcionario       from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20)) 
          when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select f.cd_cnpj_fornecedor       from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (20))
    	end as 'cd_cnpj', 
        d.cd_identificacao_document,
        d.dt_vencimento_documento,
        p.vl_juros_documento_pagar -
        p.vl_abatimento_documento -
        p.vl_desconto_documento as 'vl_juros_abatimento',
        p.vl_pagamento_documento +
        p.vl_juros_documento_pagar -
        p.vl_desconto_documento - 
        p.vl_abatimento_documento as 'vl_documento',
        b.dt_debito_bordero,
        b.dt_vencimento_bordero,
        b.dt_inicial_bordero,
        b.dt_final_bordero,
        p.ic_deposito_conta,
        case when isnull(ic_tipo_deposito,'N') = 'D'
             then 'DOC'
             else
                  case when isnull(ic_tipo_deposito,'N') = 'T' then 'TED' else '' end 
        end  as 'nm_tipo_deposito'

      into #Tabela
      from 
        tipo_conta_pagar t,
        bordero b,
        documento_pagar d,
        documento_pagar_pagamento p
      where
        b.cd_bordero = @cd_bordero and
        cast(b.cd_bordero as varchar(50)) = p.cd_identifica_documento and
        p.cd_tipo_pagamento = 1 and  -- borderô
        d.cd_documento_pagar = p.cd_documento_pagar and
        d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar and
        t.ic_tipo_bordero = 'D'

    select * from #Tabela
    order by
      sg_tipo_conta_pagar,
      nm_favorecido,
      vl_documento

  drop table #Tabela

    end
-------------------------------------------------------------------------------
  else  -- gerado p/ sistema novo (sql)
-------------------------------------------------------------------------------
    begin

      select distinct
        t.sg_tipo_conta_pagar,
        case when (isnull(d.cd_empresa_diversa, 0)     <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
             when (isnull(d.cd_contrato_pagar, 0)      <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))
             when (isnull(d.cd_funcionario, 0)         <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))
             when (isnull(d.cd_fornecedor, 0)          <> 0) then cast((select top 1 f.nm_razao_social from Fornecedor f where f.cd_fornecedor = d.cd_fornecedor) as varchar(50))
        end                             as 'nm_favorecido',               
        p.nm_obs_documento_pagar,
  	case when (isnull(d.cd_fornecedor, 0) <> 0) then (select f.cd_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor)
          when (isnull(d.cd_empresa_diversa, 0) <> 0) then (select z.cd_banco from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa)
          when (isnull(d.cd_funcionario, 0) <> 0) then (select k.cd_banco from funcionario k where k.cd_funcionario = d.cd_funcionario)
          when (isnull(d.cd_contrato_pagar, 0) <> 0) then (select f.cd_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor)
    	end as 'cd_banco',               
    	case when (isnull(d.cd_fornecedor, 0) <> 0) then cast((select f.cd_agencia_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
          when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.cd_agencia_banco from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
          when (isnull(d.cd_funcionario, 0) <> 0) then cast((select k.cd_agencia_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20))
          when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select f.cd_agencia_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar(20))
    	end as 'cd_agencia_banco',               
    	case when (isnull(d.cd_fornecedor, 0) <> 0) then cast((select f.cd_conta_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
  	  when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.cd_conta_corrente from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
          when (isnull(d.cd_funcionario, 0) <> 0) then cast((select k.cd_conta_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20)) 
          when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select f.cd_conta_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (20))
    	end as 'cd_conta_corrente', 
    	case when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select f.nm_razao_social from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(40))
  	  when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(40))
          when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select k.nm_funcionario     from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(40)) 
          when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select f.nm_razao_social    from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (40))
    	end as 'nm_razao_social', 
    	case when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select f.cd_cnpj_fornecedor from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
  	  when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.cd_cnpj_empresa_diversa  from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
          when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select k.cd_cpf_funcionario       from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20)) 
          when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select f.cd_cnpj_fornecedor       from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (20))
    	end as 'cd_cnpj', 
        d.cd_identificacao_document,
        d.dt_vencimento_documento,
        p.vl_juros_documento_pagar -
        p.vl_abatimento_documento -
        p.vl_desconto_documento as 'vl_juros_abatimento',
        p.vl_pagamento_documento +
        p.vl_juros_documento_pagar -
        p.vl_desconto_documento - 
        p.vl_abatimento_documento as 'vl_documento',
        b.dt_debito_bordero,
        b.dt_vencimento_bordero,
        b.dt_inicial_bordero,
        b.dt_final_bordero,
        p.ic_deposito_conta,
        case when isnull(ic_tipo_deposito,'N') = 'D'
             then 'DOC'
             else
                  case when isnull(ic_tipo_deposito,'N') = 'T' then 'TED' else '' end 
        end  as 'nm_tipo_deposito'
        
      into #Tabela2

      from
        bordero b
      left outer join
        documento_pagar_pagamento p
      on
        p.cd_identifica_documento = cast(@cd_bordero as varchar(50))
      left outer join 
        documento_pagar d
      on
        d.cd_documento_pagar = p.cd_documento_pagar
      left outer join
        tipo_conta_pagar t
      on
        d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar
      where
        b.cd_bordero = @cd_bordero and
        p.cd_tipo_pagamento = 1

    select * from #Tabela2
    order by
      sg_tipo_conta_pagar,
      nm_favorecido,
      vl_documento

    drop table #Tabela2
  end

  --Write your procedures's statement here

