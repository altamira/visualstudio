
CREATE PROCEDURE pr_documento_receber_atraso
@cd_cliente int,
@dt_base datetime

AS

if (isnull(@cd_cliente, 0) <> 0)
  begin

  select
    DISTINCT
    c.cd_cliente as 'CodCliente',
    c.nm_razao_social_cliente + c.nm_razao_social_cliente_c as 'RazaoSocial',
    e.nm_endereco_cliente as 'Endereco',
    e.cd_numero_endereco as 'NumEnd',
    e.cd_cep_cliente as 'CEP',
    e.nm_complemento_endereco as 'CompEnd',
    e.nm_bairro_cliente as 'Bairro',
    e.cd_ddd_cliente as 'DDD',
    e.cd_telefone_cliente as 'Telefone',
    d.cd_vendedor as 'CodVendedor',
    i.qt_media_atraso_cliente as 'Media',
    i.qt_maior_atraso as 'Maior',
    i.qt_titulo_pago as 'Pagos',
    i.qt_pagamento_atraso as 'Atraso',
    d.cd_identificacao as 'NrDocumento',
    d.dt_emissao_documento as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    d.vl_documento_receber as 'Valor',
    vend.nm_fantasia_vendedor as 'NmVendedor',
    port.nm_portador as 'Portador',
    cid.nm_cidade as 'Cidade',
    uf.sg_estado as 'UF',
    p.nm_portador as 'Portador'
  from
    Documento_Receber d inner join Cliente c
  on
    c.cd_cliente = d.cd_cliente 
  left outer join
    cliente_endereco e
  on
    c.cd_cliente = e.cd_cliente and
    e.cd_tipo_endereco = 1
  left outer join
    Portador port
  on
    port.cd_portador = d.cd_portador
  left outer join
    Cidade cid
  on
    cid.cd_cidade = e.cd_cidade
  left outer join
    Cliente_Informacao_Credito i
  on
    i.cd_cliente = c.cd_cliente
  left outer join -- cada codigo de vendedor precisa de um nome.
    Vendedor vend
  on
    vend.cd_vendedor = d.cd_vendedor
  left outer join -- cada codigo de pais precisa de um nome.
    Estado uf
  on
    uf.cd_estado = e.cd_estado
  left outer join Portador p on
    p.cd_portador=d.cd_portador
  where
    c.cd_cliente = @cd_cliente and
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) >= 0.01 and
    d.dt_cancelamento_documento is null and
    d.dt_devolucao_documento is null and
    d.dt_vencimento_documento < @dt_base
  order by
    RazaoSocial, d.dt_vencimento_documento

  end  
else
  begin

  select
    DISTINCT
    c.cd_cliente as 'CodCliente',
    c.nm_razao_social_cliente + c.nm_razao_social_cliente_c as 'RazaoSocial',
    e.nm_endereco_cliente as 'Endereco',
    e.cd_numero_endereco as 'NumEnd',
    e.cd_cep_cliente as 'CEP',
    e.nm_complemento_endereco as 'CompEnd',
    e.nm_bairro_cliente as 'Bairro',
    e.cd_ddd_cliente as 'DDD',
    e.cd_telefone_cliente as 'Telefone',
    v.cd_vendedor as 'CodVendedor',
    i.qt_media_atraso_cliente as 'Media',
    i.qt_maior_atraso as 'Maior',
    i.qt_titulo_pago as 'Pagos',
    i.qt_pagamento_atraso as 'Atraso',
    d.cd_identificacao as 'NrDocumento',
    d.dt_emissao_documento as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    d.vl_documento_receber as 'Valor',
    vend.nm_fantasia_vendedor as 'NmVendedor',
    port.nm_portador as 'Portador',
    cid.nm_cidade as 'Cidade',
    uf.sg_estado as 'UF',
    p.nm_portador as 'Portador'
  from
    Documento_Receber d inner join Cliente c
  on
    c.cd_cliente = d.cd_cliente 
  left outer join
    cliente_endereco e
  on
    c.cd_cliente = e.cd_cliente and
    e.cd_tipo_endereco = 1
  left outer join
    Portador port
  on
    port.cd_portador = d.cd_portador
  left outer join
    Cidade cid
  on
    cid.cd_cidade = e.cd_cidade
  left outer join
    Cliente_Vendedor v
  on
    v.cd_cliente = c.cd_cliente and
    v.cd_cliente_vendedor = 1
  left outer join
    Cliente_Informacao_Credito i
  on
    i.cd_cliente = c.cd_cliente
  left outer join -- cada codigo de vendedor precisa de um nome.
    Vendedor vend
  on
    vend.cd_vendedor = v.cd_cliente
  left outer join -- cada codigo de pais precisa de um nome.
    Estado uf
  on
    uf.cd_estado = e.cd_estado
  left outer join Portador p on
    p.cd_portador=d.cd_portador
  where
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) >= 0.01 and
    d.dt_cancelamento_documento is null and
    d.dt_devolucao_documento is null and
    d.dt_vencimento_documento < @dt_base
  order by
    RazaoSocial, d.dt_vencimento_documento
  
  end
    
