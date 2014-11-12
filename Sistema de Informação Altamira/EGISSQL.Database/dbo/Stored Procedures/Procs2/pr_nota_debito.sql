
CREATE PROCEDURE pr_nota_debito
@ic_parametro      int,
@dt_inicial        datetime,
@dt_final          datetime,
@cd_usuario        int,
@cd_nota_debito    int,
@cd_cliente        int,
@vl_taxa_juros     float = 0,
@vl_minimo         float = 0,
@cd_nota_inicial   int,
@dt_emissao        datetime,
@dt_vencimento     datetime,
@cd_empresa        int

as

--Busca a Taxa de Juros do Cadastro da empresa

--set @vl_taxa_juros = 5

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Listagem dos documentos p/ Geração da Nota de Débito
-------------------------------------------------------------------------------
  begin

    select
      d.*,
      p.dt_pagamento_documento,
      p.vl_pagamento_documento,
      c.nm_fantasia_cliente    as 'Cliente',  
      pt.nm_portador           as 'Portador',
      tc.nm_tipo_cobranca      as 'Cobranca',
      td.nm_tipo_documento     as 'Tipo_Documento',
      cast((p.dt_pagamento_documento - d.dt_vencimento_documento) as int) as 'Dias',
      cast(cast(str((isnull(p.vl_pagamento_documento,0) -
                     isnull(p.vl_juros_pagamento,0) +
                     isnull(p.vl_desconto_documento,0) +
                     isnull(p.vl_abatimento_documento,0) -
                     isnull(p.vl_despesa_bancaria,0) -
                     isnull(p.vl_reembolso_documento,0) -
                     isnull(p.vl_credito_pendente,0)),25,2) as decimal(25,2)) * ((@vl_taxa_juros / 100) / 30) * cast((p.dt_pagamento_documento - d.dt_vencimento_documento) as int) as decimal(25,2)) as 'Juros_Documento'
    from 
      documento_receber_pagamento p,
      documento_receber d
      left outer join Cliente c         on d.cd_cliente = c.cd_cliente
      left outer join Portador pt       on d.cd_portador = pt.cd_portador
      left outer join Tipo_Cobranca tc  on d.cd_tipo_cobranca = tc.cd_tipo_cobranca
      left outer join Tipo_Documento td on d.cd_tipo_documento = td.cd_tipo_documento
    where
      d.cd_documento_receber = p.cd_documento_receber and 
      d.cd_cliente           = @cd_cliente                     and
      d.dt_vencimento_documento between @dt_inicial  and
                                        @dt_final    and
      -- não trazer cancelados / devolvidos
      d.dt_cancelamento_documento is null            and
      -- atrasados
      d.dt_vencimento_documento < (select 
                                     max(p.dt_pagamento_documento)
                                   from
                                     documento_receber_pagamento p
                                   where
                                     p.cd_documento_receber = d.cd_documento_receber) and
      -- não trazer os abatimentos
      isnull(d.vl_documento_receber,0) <>
                               (select 
                                  sum(vl_pagamento_documento) - 
                                  sum(vl_abatimento_documento)
                                from
                                  documento_receber_pagamento p  
                                where
                                  p.cd_documento_receber = d.cd_documento_receber) and
      -- somente os que não tem Nota de Débito
      d.cd_documento_receber not in (select
                                       n.cd_documento_receber
                                     from
                                       documento_nota_debito n with (nolock) 
                                     where
                                       n.cd_documento_receber = d.cd_documento_receber )
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- Listagem das Notas de Débito do Período
-------------------------------------------------------------------------------
  begin
    select 
      n.ic_emissao_nota_debito    as 'Emitido',
      n.cd_nota_debito            as 'CodNotaDebito',
      c.nm_fantasia_cliente       as 'Cliente',
      n.dt_nota_debito            as 'Emissao',
      n.dt_vencimento_nota_debito as 'Vencimento',
      n.dt_pagamento_nota_debito  as 'Pagamento',
      n.vl_nota_debito            as 'VlNotaDebito',
      n.vl_pagamento_nota_debito  as 'VlPagamento',
      cast((n.dt_pagamento_nota_debito - n.dt_vencimento_nota_debito) as int) as 'Dias',
      (select 
         count(d.cd_nota_debito) 
       from
         Documento_Nota_Debito d
       where 
         d.cd_nota_debito = n.cd_nota_debito)
                                 as 'QtdeDocs'
    from
      Nota_Debito n
    left outer join
      Cliente c
    on
      n.cd_cliente = c.cd_cliente
    where
      (n.dt_nota_debito between @dt_inicial and @dt_final and
      n.dt_cancelamento_nota_debi is null and @cd_nota_debito = 0) or
      (n.cd_nota_debito = @cd_nota_debito)
  end      

-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- Listagem dos Documentos das Notas de Débito do Período
-------------------------------------------------------------------------------
  begin
    select 
      n.cd_nota_debito            as 'CodNotaDebito',
      d.cd_documento_receber      as 'CodDocumento',
      d.vl_documento_nota_debito  as 'VlDocumento', 
      d.qt_dia_atraso_nota_debito as 'QtdeDiaAtraso',
      d.vl_juros_nota_debito      as 'VlJuros'
    from
      Documento_Nota_Debito d
    left outer join
      Nota_Debito n
    on
      d.cd_nota_debito = n.cd_nota_debito
    where
      d.cd_nota_debito = @cd_nota_debito
  end   

-------------------------------------------------------------------------------
else if @ic_parametro = 4  -- Listagem dos Clientes que possuem nota de débito
-------------------------------------------------------------------------------
  begin    

    IF EXISTS (SELECT name 
	     FROM   sysobjects 
 	     WHERE  name = N'#Cliente_Nota_Debito' 
	     AND 	  type = 'U')
      truncate table #Cliente_Nota_Debito      
          
--    select @vl_taxa_juros 

    select
      0                             as 'Emitir',
      c.nm_fantasia_cliente         as 'Cliente',
      d.cd_cliente                  as 'CodCliente',
      cast(cast(str((isnull(p.vl_pagamento_documento,0) -
                     isnull(p.vl_juros_pagamento,0) +
                     isnull(p.vl_desconto_documento,0) +
                     isnull(p.vl_abatimento_documento,0) -
                     isnull(p.vl_despesa_bancaria,0) -
                     isnull(p.vl_reembolso_documento,0) -
                     isnull(p.vl_credito_pendente,0)),25,2) as decimal(25,2)) * ((@vl_taxa_juros/100)/30) * cast((p.dt_pagamento_documento - d.dt_vencimento_documento) as int) as decimal(25,2))
                                    as 'ValorNotaDebito',
      d.cd_identificacao
    into
      #Cliente_Nota_debito

    from 
      documento_receber_pagamento p,
      documento_receber d,
      Cliente c
    where
      d.cd_cliente           = c.cd_cliente and
      d.cd_documento_receber = p.cd_documento_receber and 
      -- somente os que o pagamento for entre a data escolhida
      convert(int, egissql.dbo.fn_dia_util(p.dt_pagamento_documento, 'S', 'F'), 103) between @dt_inicial and @dt_final and
      -- que não foram pagamentos a vista
      convert(int, egissql.dbo.fn_dia_util(p.dt_pagamento_documento, 'S', 'F'), 103) <> convert(int, egissql.dbo.fn_dia_util(d.dt_vencimento_documento, 'S', 'F'), 103) and
      -- atrasados
      convert(int, egissql.dbo.fn_dia_util(p.dt_pagamento_documento, 'S', 'F'), 103) > convert(int, egissql.dbo.fn_dia_util(d.dt_vencimento_documento, 'S', 'F'), 103) and
      -- que não tem juros
      isnull(p.vl_juros_pagamento,0) = 0 and
      -- não trazer cancelados / devolvidos
      d.dt_cancelamento_documento is null  and 
      d.dt_devolucao_documento    is null and
      -- somente os que não tem Nota de Débito
      d.cd_documento_receber not in (select
                                       n.cd_documento_receber
                                     from
                                       documento_nota_debito n with (nolock) 
                                     left outer join nota_debito nd on
                                       nd.cd_nota_debito=n.cd_nota_debito
                                     where
                                       n.cd_documento_receber = d.cd_documento_receber and
                                       nd.dt_cancelamento_nota_debi is null)

--    select * from #Cliente_Nota_debito


    select
      Emitir,
      Cliente,
      CodCliente,
      sum(ValorNotaDebito) as 'ValorNotaDebito',
      count(*)             as 'QtdeDocs'
    from
      #Cliente_Nota_Debito

    where
      ValorNotaDebito >= isnull(@vl_minimo,0) and
      ValorNotaDebito <> 0.00

    group by
      Emitir,
      Cliente,
      CodCliente

    order by
      Cliente

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 5  -- Listagem dos Documentos para Geração da Nota de Débito
-------------------------------------------------------------------------------
  begin

    select
      0                          as 'Emitir',
      d.cd_cliente               as 'CodCliente',
      d.cd_identificacao         as 'Documento',
      d.cd_documento_receber     as 'CodInterno',
      d.dt_emissao_documento     as 'Emissao',
      d.dt_vencimento_documento  as 'Vencimento',
      max(p.dt_pagamento_documento) as 'Pagamento',
      sum(cast(str((isnull(p.vl_pagamento_documento,0) -
                isnull(p.vl_juros_pagamento,0) +
                isnull(p.vl_desconto_documento,0) +
                isnull(p.vl_abatimento_documento,0) -
                isnull(p.vl_despesa_bancaria,0) -
                isnull(p.vl_reembolso_documento,0) -
                isnull(p.vl_credito_pendente,0)),25,2) as decimal(25,2)))    as 'Valor',
      (cast((max(p.dt_pagamento_documento) - d.dt_vencimento_documento) as int))
                                as 'Atraso',
      sum(cast(cast(str((isnull(p.vl_pagamento_documento,0) -
                     isnull(p.vl_juros_pagamento,0) +
                     isnull(p.vl_desconto_documento,0) +
                     isnull(p.vl_abatimento_documento,0) -
                     isnull(p.vl_despesa_bancaria,0) -
                     isnull(p.vl_reembolso_documento,0) -
                     isnull(p.vl_credito_pendente,0)),25,2) as decimal(25,2)) * ((@vl_taxa_juros/100)/30) * cast((p.dt_pagamento_documento - d.dt_vencimento_documento) as int) as decimal(25,2)))
                                as 'Juros'
    from 
      documento_receber_pagamento p,
      documento_receber d
    where
      d.cd_documento_receber = p.cd_documento_receber and 
      -- acima do valor mínimo
     (p.vl_pagamento_documento * ((@vl_taxa_juros/100)/30) * cast((p.dt_pagamento_documento - d.dt_vencimento_documento) as int) > isnull(@vl_minimo,0) ) and
      -- somente os que o pagamento for entre a data escolhida
      convert(int, egissql.dbo.fn_dia_util(p.dt_pagamento_documento, 'S', 'F'), 103) between @dt_inicial and @dt_final and
      -- que não foram pagamentos a vista
      convert(int, egissql.dbo.fn_dia_util(p.dt_pagamento_documento, 'S', 'F'), 103) <> convert(int, egissql.dbo.fn_dia_util(d.dt_vencimento_documento, 'S', 'F'), 103) and
      -- atrasados
      convert(int, egissql.dbo.fn_dia_util(p.dt_pagamento_documento, 'S', 'F'), 103) > convert(int, egissql.dbo.fn_dia_util(d.dt_vencimento_documento, 'S', 'F'), 103) and
      -- que não tem juros
      isnull(p.vl_juros_pagamento,0) = 0 and
      -- não trazer cancelados / devolvidos
      d.dt_cancelamento_documento is null  and d.dt_devolucao_documento is null and
      -- somente os que não tem Nota de Débito
      d.cd_documento_receber not in (select
                                       n.cd_documento_receber
                                     from
                                       documento_nota_debito n with (nolock) 
                                     left outer join nota_debito nd on
                                       nd.cd_nota_debito=n.cd_nota_debito
                                     where
                                       n.cd_documento_receber = d.cd_documento_receber and
                                       nd.dt_cancelamento_nota_debi is null)
    group by 
      d.cd_cliente, d.cd_identificacao, d.cd_documento_receber,
      d.dt_emissao_documento, d.dt_vencimento_documento
    order by
      cd_cliente

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 6  -- Nota de Débito do Cliente
-------------------------------------------------------------------------------
  begin

    select 
      c.nm_fantasia_cliente as 'Cliente', 
      c.cd_cliente as 'CodCliente',
      n.cd_nota_debito as 'NotaDebito',
      n.dt_nota_debito as 'Emissao',
      n.dt_vencimento_nota_debito as 'Vencimento',
      n.vl_nota_debito as 'ValorNotaDebito',
      n.dt_pagamento_nota_debito as 'Pagamento',
      n.vl_pagamento_nota_debito as 'ValorPagamento',
      n.dt_cancelamento_nota_debi as 'Cancelamento',
      n.nm_cancelamento_nota_debi as 'Motivo' 
    from
      nota_debito n,
      cliente c
    where
      n.cd_cliente = c.cd_cliente and
      cd_nota_debito = @cd_nota_debito

  end 
-------------------------------------------------------------------------------
else if @ic_parametro = 7  -- Documentos de uma Nota de Débito p/ Emissão
-------------------------------------------------------------------------------
  begin
    select 
      n.cd_nota_debito            as 'NotaDebito',
      d.cd_identificacao          as 'Duplicata',
      d.dt_emissao_documento      as 'Emissao',
      d.dt_vencimento_documento   as 'Vencimento',
      (select max(p.dt_pagamento_documento)
       from Documento_receber_pagamento p    
       where
         p.cd_documento_receber = n.cd_documento_receber) as 'Pagamento',
      cast(str(n.vl_documento_nota_debito,25,2) as decimal(25,2))  as 'Valor',
      n.qt_dia_atraso_nota_debito as 'Atraso',
      cast(str(n.vl_juros_nota_debito,25,2) as decimal(25,2))      as 'Juros'
    from
      Documento_nota_debito n,
      Documento_receber d      
    where
      n.cd_nota_debito = @cd_nota_debito and
      d.cd_documento_receber = n.cd_documento_receber
    order by
      d.cd_identificacao


  end 
-------------------------------------------------------------------------------
else if @ic_parametro = 8   -- Demais Dados p/ a Emissão
-------------------------------------------------------------------------------
  begin

    select 
      x.NomeEmpresa,
      x.NomeBanco,
      x.AgenciaEmpresa,
      x.CodAgenciaBanco,
      x.ContaEmpresa,
      x.TelefoneDepartamento,
      c.nm_razao_social_cliente		          as 'RazaoSocialCliente',
  
      vw.nm_endereco_cob+
      rtrim(isnull(vw.cd_numero_endereco_cob,'')+
      isnull(vw.nm_complemento_endereco_cob,''))+
      ' - '+vw.nm_bairro_cob            	  as 'EnderecoCliente',
      vw.cd_cep_cob                         as 'CEPCliente',
      d.nm_cidade			   	  as 'CidadeCliente',
      u.sg_estado			 	  as 'EstadoCliente',
      
      cast(isnull(x.ds_msg_cab_nota_debito,    
      'Informamos a V.Sas., que estamos levando a '+
      'débito de sua conta, a importância acima, '+ 
      'referente a juros não pagos na(s) '+
      'liquidação(ões) da(s) duplicata(s) '+
      'abaixo relacionada(s):') as text)                    as 'MensagemCabecalho',
      
      isnull(x.ds_msg_det_nota_debito,
      'Assim sendo, solicitamos que o valor desta '+ 
      'ND seja creditada em nossa conta-corrente '+
      'conforme segue:')                           as 'MensagemRodape1',
      'Sem mais, antecipadamente agradecemos,'    as 'MensagemRodape2',

      'DEPTO. CRÉDITO/COBRANÇA                '+
      'FONE: ' + Cast(x.TelefoneDepartamento as varchar) as 'Assinatura'
    from
    (select
      p.nm_empresa                                        as 'NomeEmpresa',
      b.nm_banco                                          as 'NomeBanco',
      IsNull(ag.nm_agencia_banco, '') + ' ' + IsNull(cid.nm_cidade,'') + ' ' + IsNull(est.sg_estado, '') as 'AgenciaEmpresa',
      cab.nm_conta_banco                                  as 'ContaEmpresa',
      ag.cd_numero_agencia_banco                          as 'CodAgenciaBanco',
      pf.cd_telefone_financeiro                           as 'TelefoneDepartamento',
      pf.ds_msg_cab_nota_debito,
      pf.ds_msg_det_nota_debito  
    From
      Empresa p
    Left Outer Join Parametro_Financeiro pf on 
      p.cd_empresa = pf.cd_empresa
    left outer join Conta_Agencia_Banco cab on 
      cab.cd_empresa = pf.cd_empresa and 
      cab.cd_conta_banco = pf.cd_conta_banco_n_debito
    left outer join Banco b on 
      b.cd_banco = cab.cd_banco
    Left Outer Join Agencia_banco ag on 
     ag.cd_banco = cab.cd_banco and 
      ag.cd_agencia_banco = cab.cd_agencia_banco
    Left Outer Join Cidade cid on 
      cid.cd_cidade = ag.cd_cidade and
      cid.cd_estado = ag.cd_estado
    Left Outer Join Estado est on 
      est.cd_estado = ag.cd_estado
    Where
      p.cd_empresa = @cd_empresa) x,
      Cliente c
    inner join vw_destinatario vw on 
      c.cd_cliente = vw.cd_destinatario and vw.cd_tipo_destinatario = 1
    left outer join Cidade d on 
      vw.cd_cidade = d.cd_cidade
    left outer join Estado u on 
      vw.cd_estado = u.cd_estado
    where
      c.cd_cliente = @cd_cliente

  end 
---------------------------------------------------------------------------------
else if @ic_parametro = 9  -- Listagem do relatório de notas em aberto p/ cliente
---------------------------------------------------------------------------------
  begin   

    select 
      c.nm_fantasia_cliente as 'Cliente',
      n.cd_nota_debito as 'NotaDebito',
      n.dt_nota_debito as 'Emissao',
      n.dt_vencimento_nota_debito as 'Vencimento',
      n.vl_nota_debito as 'ValorNotaDebito',
      n.ic_emissao_nota_debito as 'Emitida',
      d.cd_identificacao as 'Duplicata',
      d.dt_emissao_documento as 'EmissaoDuplicata',
      d.dt_vencimento_documento as 'VencimentoDuplicata',
      b.dt_pagamento_documento as 'PagamentoDuplicata',
      p.vl_documento_nota_debito as 'ValorDuplicata',
      p.qt_dia_atraso_nota_debito as 'AtrasoDuplicata',
      p.vl_juros_nota_debito as 'JurosDuplicata'
    from
      nota_debito n,
      documento_nota_debito p,
      documento_receber d,
      documento_receber_pagamento b,
      cliente c
    where
      p.cd_nota_debito = n.cd_nota_debito and
      p.cd_documento_receber = d.cd_documento_receber and
      b.cd_documento_receber = p.cd_documento_receber and
      n.cd_cliente = c.cd_cliente and
      n.dt_pagamento_nota_debito is null and
      n.dt_cancelamento_nota_debi is null and   -- ELIAS 03/11/2003
      (n.dt_nota_debito between @dt_inicial and @dt_final and @cd_nota_debito = 0) or
      (n.cd_nota_debito = @cd_nota_debito)
    order by
      Cliente,
      NotaDebito
     
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 10 -- listagem do resumo de notas de débito
-------------------------------------------------------------------------------
  begin

    select 
      c.nm_fantasia_cliente as 'Cliente',
      n.cd_nota_debito as 'NotaDebito',
      n.dt_nota_debito as 'Emissao',
      n.dt_vencimento_nota_debito as 'Vencimento',
      n.vl_nota_debito as 'ValorNotaDebito',
      n.ic_emissao_nota_debito as 'Emitida'
    from
      nota_debito n inner join
      cliente c on n.cd_cliente = c.cd_cliente
    where
      ((n.dt_cancelamento_nota_debi is null) and   -- ELIAS 03/11/2003
      (n.dt_pagamento_nota_debito is null) and
      (n.dt_nota_debito between @dt_inicial and @dt_final and @cd_nota_debito = 0) or
      (n.cd_nota_debito = @cd_nota_debito))
    order by
      Cliente,
      NotaDebito


--select * from nota_debito where cd_nota_debito = 4890

end    
