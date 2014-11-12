
CREATE PROCEDURE pr_emissao_ordem_separacao

@ic_parametro 		int,
@cd_pedido_venda 	int,
@cd_pedido_venda_final 	int

AS
---------------------------------------------------------------------------------------------
if @ic_parametro = 0 or @ic_parametro = 1 --Emissão da ordem avulsa e por range
---------------------------------------------------------------------------------------------
begin
  
  declare @cd_pedido_venda_c  int
  declare @cd_tipo_endereco_c int

  declare cPedido_Venda cursor for 
  select 
    cd_pedido_venda,
    cd_tipo_endereco
  from 
    Pedido_Venda
  where 
    cd_pedido_venda between @cd_pedido_venda and @cd_pedido_venda_final and
    dt_cancelamento_pedido is null and
    dt_fechamento_pedido is not null
  order by 1

  open cPedido_Venda

  fetch next from cPedido_Venda
  into 
    @cd_pedido_venda_c,
    @cd_tipo_endereco_c

  --Criando tabela de saída para a emissão do relatório de ordem de separação
  select     
    pv.cd_pedido_venda, 
    pv.dt_pedido_venda, 
    cli.nm_razao_social_cliente, 
    con.nm_contato, 
    cli.nm_fantasia_cliente, 
    cli.cd_ddd, 
    cli.cd_telefone, 
    cli.cd_fax, 
    cli.nm_endereco_cliente, 
    cli.cd_numero_endereco, 
    cli.nm_complemento_endereco, 
    cli.nm_bairro, 
    cli.cd_cep, 
    p.nm_pais, 
    e.sg_estado, 
    cid.nm_cidade, 
    rv.nm_regiao_venda, 
    cet.ds_especificacao_tecnica, 
    sp.sg_status_pedido, 
    v.nm_vendedor as nm_vendedor_externo, 
    --Pegando vendedor interno
    (select nm_vendedor from vendedor where cd_vendedor = pv.cd_vendedor_interno) as nm_vendedor_interno,
    t.nm_fantasia as nm_fantasia_transportadora, 
    tp.sg_tipo_pedido, 
    pv.ds_observacao_pedido, 
    pv.dt_fechamento_pedido
  into
    #Ordem_Separacao
  from         
    transportadora t right outer join
    pedido_venda pv left outer join
    tipo_pedido tp on pv.cd_tipo_pedido = tp.cd_tipo_pedido on t.cd_transportadora = pv.cd_transportadora left outer join
    vendedor v on pv.cd_vendedor = v.cd_vendedor left outer join
    status_pedido sp on pv.cd_status_pedido = sp.cd_status_pedido left outer join
    contato con on pv.cd_cliente = con.cd_cliente and pv.cd_contato = con.cd_contato left outer join
    cliente_especificacao_tecnica cet right outer join
    cliente cli on cet.cd_cliente = cli.cd_cliente left outer join
    regiao_venda rv on cli.cd_regiao = rv.cd_regiao_venda left outer join
    cidade cid right outer join
    cep on cid.cd_pais = cep.cd_pais and cid.cd_estado = cep.cd_estado and cid.cd_cidade = cep.cd_cidade left outer join
    estado e on cep.cd_pais = e.cd_pais and cep.cd_estado = e.cd_estado left outer join
    pais p on cep.cd_pais = p.cd_pais on cli.cd_identifica_cep = cep.cd_identifica_cep on pv.cd_cliente = cli.cd_cliente
  where     
    1 = 2

  while @@fetch_status = 0
  begin
    --Verificando se usuário informou algum tipo de endereço no pedido
    if isnull(@cd_tipo_endereco_c, 0) = 0
    begin
      insert into
        #Ordem_Separacao
      select     
        pv.cd_pedido_venda, 
        pv.dt_pedido_venda, 
        cli.nm_razao_social_cliente, 
        con.nm_contato, 
        cli.nm_fantasia_cliente, 
        cli.cd_ddd, 
        cli.cd_telefone, 
        cli.cd_fax, 
        cli.nm_endereco_cliente, 
        cli.cd_numero_endereco, 
        cli.nm_complemento_endereco, 
        cli.nm_bairro, 
        cli.cd_cep, 
        p.nm_pais, 
        e.sg_estado, 
        cid.nm_cidade, 
        rv.nm_regiao_venda, 
        cet.ds_especificacao_tecnica, 
        sp.sg_status_pedido, 
        v.nm_vendedor as nm_vendedor_externo, 
        --Pegando vendedor interno
        (select nm_vendedor from vendedor where cd_vendedor = pv.cd_vendedor_interno) as nm_vendedor_interno,
        t.nm_fantasia as nm_fantasia_transportadora, 
        tp.sg_tipo_pedido, 
        pv.ds_observacao_pedido, 
        pv.dt_fechamento_pedido
      from         
        transportadora t right outer join
        pedido_venda pv left outer join
        tipo_pedido tp on pv.cd_tipo_pedido = tp.cd_tipo_pedido on t.cd_transportadora = pv.cd_transportadora left outer join
        vendedor v on pv.cd_vendedor = v.cd_vendedor left outer join
        status_pedido sp on pv.cd_status_pedido = sp.cd_status_pedido left outer join
        contato con on pv.cd_cliente = con.cd_cliente and pv.cd_contato = con.cd_contato left outer join
        cliente_especificacao_tecnica cet right outer join
        cliente cli on cet.cd_cliente = cli.cd_cliente left outer join
        regiao_venda rv on cli.cd_regiao = rv.cd_regiao_venda left outer join
        cidade cid right outer join
        cep on cid.cd_pais = cep.cd_pais and cid.cd_estado = cep.cd_estado and cid.cd_cidade = cep.cd_cidade left outer join
        estado e on cep.cd_pais = e.cd_pais and cep.cd_estado = e.cd_estado left outer join
        pais p on cep.cd_pais = p.cd_pais on cli.cd_identifica_cep = cep.cd_identifica_cep on pv.cd_cliente = cli.cd_cliente
      where     
        pv.cd_pedido_venda = @cd_pedido_venda_c
    end
    else
    begin
      insert into
        #Ordem_Separacao
      SELECT     
        pv.cd_pedido_venda, 
        pv.dt_pedido_venda, 
        cli.nm_razao_social_cliente, 
        con.nm_contato, 
        cli.nm_fantasia_cliente, 
        ce.cd_ddd_cliente as cd_ddd, 
        ce.cd_telefone_cliente as cd_telefone, 
        ce.cd_fax_cliente as cd_fax,
        ce.nm_endereco_cliente, 
        ce.cd_numero_endereco, 
        ce.nm_complemento_endereco, 
        ce.nm_bairro_cliente as nm_bairro,
        ce.cd_cep_cliente as cd_cep,
        p.nm_pais, 
        e.sg_estado,   
        cid.nm_cidade, 
        rv.nm_regiao_venda, 
        cet.ds_especificacao_tecnica, 
        sp.sg_status_pedido, 
        v.nm_vendedor as nm_vendedor_externo, 
        --Pegando vendedor interno
        (select nm_vendedor from vendedor where cd_vendedor = pv.cd_vendedor_interno) as nm_vendedor_interno,
        t.nm_fantasia AS nm_fantasia_transportadora, 
        tp.sg_tipo_pedido, 
        pv.ds_observacao_pedido, 
        pv.dt_fechamento_pedido
      FROM         
        Contato con RIGHT OUTER JOIN
        Status_Pedido sp RIGHT OUTER JOIN
        Vendedor v RIGHT OUTER JOIN
        Pedido_Venda pv LEFT OUTER JOIN
        Cep RIGHT OUTER JOIN
        Regiao_Venda rv RIGHT OUTER JOIN
        Cliente_Endereco ce ON rv.cd_regiao_venda = ce.cd_regiao ON Cep.cd_identifica_cep = ce.cd_identifica_cep LEFT OUTER JOIN
        Cidade cid ON Cep.cd_pais = cid.cd_pais AND Cep.cd_estado = cid.cd_estado AND Cep.cd_cidade = cid.cd_cidade LEFT OUTER JOIN
        Estado e ON Cep.cd_pais = e.cd_pais AND Cep.cd_estado = e.cd_estado LEFT OUTER JOIN
        Pais p ON Cep.cd_pais = p.cd_pais ON pv.cd_tipo_endereco = ce.cd_tipo_endereco AND pv.cd_cliente = ce.cd_cliente LEFT OUTER JOIN
        Tipo_Pedido tp ON pv.cd_tipo_pedido = tp.cd_tipo_pedido LEFT OUTER JOIN
        Transportadora t ON pv.cd_transportadora = t.cd_transportadora ON v.cd_vendedor = pv.cd_vendedor ON 
        sp.cd_status_pedido = pv.cd_status_pedido ON con.cd_cliente = pv.cd_cliente AND con.cd_contato = pv.cd_contato LEFT OUTER JOIN
        Cliente_Especificacao_Tecnica cet RIGHT OUTER JOIN
        Cliente cli ON cet.cd_cliente = cli.cd_cliente ON pv.cd_cliente = cli.cd_cliente
      WHERE     
         pv.cd_pedido_venda = @cd_pedido_venda_c
    end

    fetch next from cPedido_Venda
    into 
      @cd_pedido_venda_c,
      @cd_tipo_endereco_c
  end

  close      cPedido_Venda
  deallocate cPedido_Venda

  select * from #Ordem_Separacao

end
