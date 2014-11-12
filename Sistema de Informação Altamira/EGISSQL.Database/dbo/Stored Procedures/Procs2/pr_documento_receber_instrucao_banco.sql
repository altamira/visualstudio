

CREATE  PROCEDURE pr_documento_receber_instrucao_banco
@ic_parametro     int,
@cd_instrucao     int,
@cd_banco         int,
@dt_inicial       datetime,
@dt_final         datetime,
@cd_identificacao varchar(20)

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- consulta as instruções bancárias do período
-------------------------------------------------------------------------------
  begin

    if @cd_identificacao is Null
      begin
        select
          0 as 'Imprimir',
          a.cd_doc_instrucao_banco,
          a.dt_instrucao_banco,
          d.cd_identificacao,     
          d.dt_emissao_documento,
          d.dt_vencimento_documento,
          d.vl_documento_receber,
          d.vl_saldo_documento,
          a.dt_cancel_instrucao_banco,
          a.nm_cancelamento_instrucao,
          a.cd_documento_receber,
          a.cd_banco,
          cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'vl_saldo_documento',
          a.ic_emissao_instrucao_banc,
          a.ic_envio_instrucao_banco,
          b.nm_fantasia_banco,
          c.nm_fantasia_cliente,
          c.cd_cliente_sap,
          c.nm_razao_social_cliente,
          a.ds_instrucao_banco,
          a.cd_banco_documento_recebe,
          a.cd_usuario,
          a.dt_usuario,
          d.dt_envio_banco_documento
        from
          Documento_Instrucao_Bancaria a,
          Cliente c,
          Documento_receber d,
          Banco b      
        where
          a.cd_documento_receber = d.cd_documento_receber          and
          a.cd_banco = b.cd_banco                                  and
          d.cd_cliente = c.cd_cliente                              and
          a.ic_envio_instrucao_banco = 'N'                         and
          a.dt_cancel_instrucao_banco is null   	                 and
          a.dt_instrucao_banco between @dt_inicial and @dt_final   
        
        Order By
         a.cd_doc_instrucao_banco Desc
        
     end
    else
      begin
        select
          0 as 'Imprimir',
          a.cd_doc_instrucao_banco,
          a.dt_instrucao_banco,
          d.cd_identificacao,     
          d.dt_emissao_documento,
          d.dt_vencimento_documento,
          d.vl_documento_receber,
          d.vl_saldo_documento,
          a.dt_cancel_instrucao_banco,
          a.nm_cancelamento_instrucao,
          a.cd_documento_receber,
          a.cd_banco,
          cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'vl_saldo_documento',
          a.ic_emissao_instrucao_banc,
          a.ic_envio_instrucao_banco,
          b.nm_fantasia_banco,
          c.nm_fantasia_cliente,
          c.cd_cliente_sap,
          c.nm_razao_social_cliente,
          a.ds_instrucao_banco,
          a.cd_banco_documento_recebe,
          a.cd_usuario,
          a.dt_usuario,
          d.dt_envio_banco_documento
        from
          Documento_Instrucao_Bancaria a,
          Cliente c,
          Documento_receber d,
          Banco b      
        where
          a.cd_documento_receber = d.cd_documento_receber          and
          a.cd_banco = b.cd_banco                                  and
          d.cd_cliente = c.cd_cliente                              and
--          a.ic_envio_instrucao_banco = 'N'                         and
          a.dt_cancel_instrucao_banco is null   	           and
          d.cd_identificacao like @cd_identificacao+'%'
        Order By
          d.dt_emissao_documento Desc

      end
end

-------------------------------------------------------------------------------
else if @ic_parametro = 3 -- consulta o documento da instrução bancária
-------------------------------------------------------------------------------
  begin

    select
      c.nm_fantasia_cliente,
      c.nm_razao_social_cliente + c.nm_razao_social_cliente_c as 'RazaoSocial',
      c.cd_ddd                  as 'cd_ddd_cliente',
      c.cd_telefone             as 'cd_telefone_cliente',  
      doc.cd_documento_receber,
      doc.cd_identificacao,
      doc.ds_documento_receber,
      doc.cd_banco_documento_recebe,
      doc.dt_emissao_documento,
      doc.dt_vencimento_documento,
      doc.dt_vencimento_original,
      doc.vl_documento_receber,
      cast(str(doc.vl_saldo_documento,25,2) as decimal(25,2)) as 'vl_saldo_documento',
      p.cd_portador,
      p.nm_portador,
      doc.cd_pedido_venda,
      doc.dt_cancelamento_documento,
      doc.nm_cancelamento_documento,
      doc.dt_devolucao_documento,
      doc.nm_devolucao_documento,
      doc.cd_tipo_liquidacao,
      doc.cd_banco_documento_recebe,
      p.cd_banco,
      b.nm_fantasia_banco,
      doc.dt_envio_banco_documento
    from
      Documento_Receber doc
    inner join
      Cliente c
    on
      c.cd_cliente = doc.cd_cliente
    inner join
      Portador p
    on
      p.cd_portador = doc.cd_portador
    left outer join
      Banco b
    on
      b.cd_banco = p.cd_banco
    where
      cd_identificacao = @cd_identificacao

  end

-----------------------------------------------------------------------------------------
else if @ic_parametro = 4 -- consulta a composicao da instrução bancária
-----------------------------------------------------------------------------------------

  begin
    select 
      i.cd_doc_instrucao_banco,    -- código do documento (cabeçalho/master)
      i.cd_item_instrucao_banco,   -- item do documento   (detalhe)
      i.cd_instrucao,              -- instrução (tabela Instrucao_banco)
      i.vl_instrucao_banco_compos,
      i.dt_instrucao_banco_comp,
      i.nm_instrucao_banco_compos,
      i.cd_usuario,
      i.dt_usuario,      
      b.nm_obs_instrucao_banco,
      b.ic_valor_instrucao_banco,
      b.ic_data_instrucao_banco
    from
      Doc_Instrucao_Banco_Composicao i
    left outer join
      Instrucao_Banco b
    on
      i.cd_instrucao = b.cd_instrucao and
      b.cd_banco     = @cd_banco
    where
      i.cd_doc_instrucao_banco = @cd_instrucao
    order by
      i.cd_item_instrucao_banco
      
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 5  -- Listagem da Instrução bancária
-------------------------------------------------------------------------------
  begin
    declare @cd_empresa int
    set @cd_empresa = dbo.fn_empresa()
--select top 1 * from Vw_destinatario
    select
      distinct
      cast(dib.cd_banco as varchar(20)) + ' - ' + bco.nm_banco as 'nm_banco',                   -- banco
      ( select top 1 x.cd_numero_agencia_banco from Agencia_Banco x where x.cd_banco = bco.cd_banco) as 'Agencia',
      cli.nm_razao_social_cliente,                                         -- nome do cliente
      isnull(IsNull(ce.nm_endereco_cliente,cli.nm_endereco_cliente),'') + ' ' +
      isnull(IsNull(ce.cd_numero_endereco,cli.cd_numero_endereco),'') +
      isnull(' - ' + IsNull(ce.nm_complemento_endereco,cli.nm_complemento_endereco),'') as 'RuaN',
      isnull(ce.nm_bairro_cliente, cli.nm_bairro) as 'nm_bairro_cliente',  -- bairro
      cid.nm_cidade + '-' + est.sg_estado     as 'CidEstado',                  -- estado
      isnull(ce.cd_cep_cliente, cli.cd_cep)   as 'cd_cep_cliente',                               -- cep
      doc.cd_documento_receber,       -- cód int documento
      doc.cd_identificacao,           -- num documento
      doc.dt_emissao_documento,       -- emissao
      doc.dt_vencimento_documento,    -- vencimento
      doc.dt_vencimento_original,     -- vencimento original
      doc.vl_documento_receber,       -- valor
      doc.cd_banco_documento_recebe,  -- num bancário
      cast(IsNull(ibp.nm_instrucao,'') + IsNull(' ' + dic.nm_instrucao_banco_compos,'') as varchar(100)) as 'Instrucao', -- instrução 
      dib.cd_doc_instrucao_banco,     -- num instrução
      dib.dt_instrucao_banco,         -- data da instrução
      dic.cd_item_instrucao_banco,    -- item da instrução
      IsNull(dic.vl_instrucao_banco_compos,0) as 'vl_instrucao_banco_compos',  -- valor de entrada
      dic.dt_instrucao_banco_comp,     -- data de entrada 
      cab.nm_conta_banco,
      doc.dt_envio_banco_documento
    from
      Documento_Instrucao_Bancaria dib   
    left outer join Documento_Receber doc on  
      doc.cd_documento_receber   = dib.cd_documento_receber 
    inner join Doc_Instrucao_Banco_Composicao dic on 
      dic.cd_doc_instrucao_banco = dib.cd_doc_instrucao_banco 
    left outer join Banco bco on 
      bco.cd_banco = dib.cd_banco 
    left outer join Instrucao_Bancaria ibp on 
      dic.cd_instrucao = ibp.cd_instrucao 
    left outer join Cliente cli on
      cli.cd_cliente=doc.cd_cliente
    left outer join Cliente_Endereco ce on
      ce.cd_cliente=cli.cd_cliente and ce.cd_tipo_endereco=3
    left outer join Cidade cid on 
      cid.cd_cidade = IsNull(ce.cd_cidade, cli.cd_cidade) and 
      cid.cd_estado = IsNull(ce.cd_estado, cli.cd_estado) and 
      cid.cd_pais =   IsNull(ce.cd_pais, cli.cd_pais)
    left outer join Estado est on 
      est.cd_estado = IsNull(ce.cd_estado, cli.cd_estado) and 
      est.cd_pais = 1 
    left outer join Conta_Agencia_Banco cab on 
      cab.cd_empresa = @cd_empresa and 
      cab.cd_banco = bco.cd_banco
    where 
      dib.cd_doc_instrucao_banco = @cd_instrucao 
  end
--else  
--  return



