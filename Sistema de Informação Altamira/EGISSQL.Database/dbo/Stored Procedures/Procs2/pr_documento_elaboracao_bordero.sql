
CREATE PROCEDURE pr_documento_elaboracao_bordero
@cd_empresa int,
@dt_inicial datetime,
@dt_final   datetime

as


  -- carrega tabela temporária c/ as informações do documento_pagar

  select 
    d.*,
    isnull(p.ic_deposito_conta, 'N') as 'ic_deposito_conta'
  into
    #Documento_pagar
  from
    Documento_pagar d
  left outer join
    Documento_pagar_pagamento p
  on
    d.cd_documento_pagar = p.cd_documento_pagar
  where
    d.dt_vencimento_documento between @dt_inicial and @dt_final and
    cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) > 0 and
    not exists(select top 1 cd_documento_pagar from documento_pagar_pagamento p where  p.cd_documento_pagar = d.cd_documento_pagar and p.cd_identifica_documento is not null)

--    Carlos 28.09.2005
--     select
--       d.cd_pedido_compra
--     into
--       #Temp
--     from
--       #Documento_pagar d
--     inner join
--       Pedido_Compra pc 
--     on
--       pc.cd_pedido_compra = d.cd_pedido_compra
--     where     
--        dbo.fn_verifica_aprov_pedido(pc.cd_pedido_compra) <> IsNull(pc.ic_aprov_pedido_compra,'N')
--     update Pedido_Compra
--     set ic_aprov_pedido_compra = dbo.fn_verifica_aprov_pedido(cd_pedido_compra)
--     where
--      cd_pedido_compra in ( select cd_pedido_compra from #Temp )
-- 
          
  select
    distinct
    d.cd_documento_pagar,
    d.dt_vencimento_documento,
    c.nm_tipo_conta_pagar,
    c.sg_tipo_conta_pagar,
    c.ic_tipo_bordero,          
      case when (isnull(d.cd_fornecedor, 0) <> 0) then cast(d.nm_fantasia_fornecedor as varchar(30))
           when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))
      end                             as 'cd_favorecido',               
      case when (isnull(d.cd_fornecedor, 0) <> 0) then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  
           when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))                      
      end                             as 'nm_favorecido',     
    d.cd_identificacao_document,
    cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar',
    'S' as 'ic_pagar',
    d.cd_pedido_compra,
     case when exists ( select top 1 x.cd_pedido_compra
                        from Pedido_Compra x 
                        where x.cd_pedido_compra = d.cd_pedido_compra ) and IsNull(d.cd_pedido_compra,0) <> 0 
          then
            ( SELECT ISNULL(IC_APROV_PEDIDO_COMPRA,'N')
              FROM 
                PEDIDO_COMPRA B 
              WHERE 
                D.CD_PEDIDO_COMPRA = B.CD_PEDIDO_COMPRA )
          else 'S' end
      as 'ic_pedido_compra_aprovado',         
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
    end as 'cd_conta_banco',               
    case when (isnull(d.cd_fornecedor, 0) <> 0)      then cast((select f.nm_razao_social    from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(40))
	 when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(40))
         when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select k.nm_funcionario     from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(40)) 
         when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select f.nm_razao_social    from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (40))
    end as 'nm_razao_social',               
    case when (isnull(d.cd_fornecedor, 0) <> 0)      then cast((select f.cd_cnpj_fornecedor      from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
	 when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select z.cd_cnpj_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
         when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select k.cd_cpf_funcionario      from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20)) 
         when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select f.cd_cnpj_fornecedor      from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (20))
    end as 'cd_cnpj',               
    d.ic_deposito_conta, 
    d.nm_observacao_documento,
    d.ic_tipo_deposito
  from
    #Documento_pagar d left outer join
    tipo_conta_pagar c on d.cd_tipo_conta_pagar = c.cd_tipo_conta_pagar left outer join
    Pedido_Compra pc on pc.cd_pedido_compra = d.cd_pedido_compra
  order by
    d.dt_vencimento_documento desc,
    c.nm_tipo_conta_pagar,
    cd_favorecido,
    d.cd_identificacao_document

