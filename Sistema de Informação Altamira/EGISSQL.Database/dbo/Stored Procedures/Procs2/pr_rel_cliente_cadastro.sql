
CREATE PROCEDURE pr_rel_cliente_cadastro
@ic_parametro as int, 
@nm_fantasia as varchar(50),
@nm_vendedor as varchar(50),
@cd_cidade as int,
@cd_fonte_informacao as int,
@cd_ramo_atividade as int,
@cd_status_cliente as int
AS

    select 
    cli.*,
    ve.nm_vendedor,
    sc.nm_status_cliente,
    ra.nm_ramo_atividade,
    ci.nm_cidade,
    es.sg_estado,

    entrega.nm_endereco_cliente as endereco_entrega,
    entrega.nm_bairro_cliente   as bairro_entrega,
    entrega.cd_cidade           as cidade_entrega,
    entrega.cd_estado           as estado_entrega,
    entrega.cd_cep_cliente      as cep_entrega,
    entrega.cd_ddd_cliente      as ddd_entrega,
    entrega.cd_telefone_cliente as telefone_entrega,
    entrega.cd_fax_cliente      as fax_entrega,
    es_entrega.sg_estado        as sg_estado_entrega,

    cobranca.nm_endereco_cliente as endereco_cobranca,
    cobranca.nm_bairro_cliente   as bairro_cobranca,
    cobranca.cd_cidade           as cidade_cobranca,
    cobranca.cd_estado           as estado_cobranca,
    cobranca.cd_cep_cliente      as cep_cobranca,
    cobranca.cd_ddd_cliente      as ddd_cobranca,
    cobranca.cd_telefone_cliente as telefone_cobranca,
    cobranca.cd_fax_cliente      as fax_cobranca,
    es_cobranca.sg_estado        as sg_estado_cobranca,

    cc.nm_contato_cliente,
    cc.nm_fantasia_contato,
    cc.cd_ddd_contato_cliente,
    cc.cd_telefone_contato,
    cc.cd_fax_contato,
    cg.nm_cargo                  as nm_cargo_contato,
    dp.nm_departamento_cliente   as nm_departamento_contato 

    
    from cliente cli

    left outer join 
      Cidade ci
    on cli.cd_cidade = ci.cd_cidade

    left outer join 
      Estado es
    on cli.cd_estado = es.cd_estado

    left outer join 
      Ramo_Atividade ra
    on cli.cd_ramo_atividade = ra.cd_ramo_atividade

   left outer join 
      Fonte_Informacao fi
    on cli.cd_fonte_informacao = fi.cd_fonte_informacao

    left outer join 
      Vendedor ve
    on cli.cd_vendedor = ve.cd_vendedor

   left outer join 
      Status_Cliente sc
    on cli.cd_status_cliente = sc.cd_status_cliente

   left outer join
     cliente_endereco entrega
   on (cli.cd_cliente = entrega.cd_cliente) and (entrega.cd_tipo_endereco = 4)

   left outer join
     cliente_endereco cobranca
   on (cli.cd_cliente = cobranca.cd_cliente) and (cobranca.cd_tipo_endereco = 3)

   left outer join 
      cliente_contato cc
   on (cli.cd_cliente = cc.cd_cliente) 

  left outer join
    Estado es_cobranca
  on (cobranca.cd_estado = es_cobranca.cd_estado)

  left outer join
    Estado es_entrega
  on (entrega.cd_estado = es_entrega.cd_estado)

  left outer join
    Cargo cg
  on (cc.cd_cargo = cg.cd_cargo)

  left outer join
    departamento_cliente dp
  on (cc.cd_departamento_cliente = dp.cd_departamento_cliente)


    where 
    (cli.nm_fantasia_cliente like @nm_fantasia + '%')and

    (ve.nm_vendedor like @nm_vendedor + '%')
    AND
     (((@cd_cidade = 0) or ( ci.cd_cidade = @cd_cidade))
     and 
     ((@cd_fonte_informacao = 0) or (fi.cd_fonte_informacao = @cd_fonte_informacao)) 
     and
     ((@cd_ramo_atividade = 0) or (ra.cd_ramo_atividade = @cd_ramo_atividade)) 
     and
     ((@cd_status_cliente = 0) or (sc.cd_status_cliente = @cd_status_cliente)))

