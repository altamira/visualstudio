
CREATE procedure pr_cliente_por_vendedor
-----------------------------------------------------------------------------------
--pr_cliente_por_vendedor
-----------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                          2004
-----------------------------------------------------------------------------------                     
--Stored Procedure        : SQL Server Microsoft 2000
--Autor(es)               : Antonio Palacio Junior
--Banco de Dados          : EgisSql ou EgisAdmin
--Objettivo               : Clientes atendidos por vendedor
--Data                    : 23.04.2003
--Atualizado              : 21/08/2003
--                        : Johnny - Adicionado trecho de código para consulta pegar vendas de vendedores
--                                    para clientes que não são de sua carteira.
--                        : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                        : 28.10.2005 - Verificação/Acertos Diversos - Carlos Fernandes
-- 13.04.2009 - Complemento dos Campos - Carlos Fernandes
----------------------------------------------------------------------------------------------------------
@cd_vendedor int ,
@dt_inicial  datetime ,
@dt_final    datetime 
as

  -- Geração da Tabela Auxiliar de Vendas por Vendedor

  Select 
    Cli.cd_cliente,
    Cli.nm_fantasia_cliente     as 'Cliente',
    Cli.nm_email_cliente        as 'Email', 
    Cli.nm_endereco_cliente     as 'Endereco', 
    Cli.cd_numero_endereco      as 'Numero', 
    Cli.nm_complemento_endereco as 'Complemento', 
    Cli.nm_bairro               as 'Bairro', 
    Cli.cd_ddd                  as 'DDD', 
    Cli.cd_telefone             as 'Fone', 
    Cli.cd_fax                  as 'Fax', 
    Cid.nm_cidade               as 'Cidade', 
    Pais.nm_pais                as 'Pais', 
    Cep.cd_cep                  as 'Cep', 
    Vend.cd_vendedor            as 'CD_Vendedor',
    Vend.nm_vendedor            as 'Vendedor', 
    RegVend.nm_regiao_venda     as 'Regiao', 
    Cli.nm_dominio_cliente      as 'Site', 
    Est.sg_estado               as 'Estado', 
   
    (select
       max(pv.dt_pedido_venda)
    from
      pedido_venda pv with (nolock)      
    where
      pv.cd_vendedor = cli.cd_vendedor and
      pv.cd_cliente  = Cli.cd_cliente)            as 'UltimaCompra',
  
    (select top 1 cc.nm_contato_cliente 
     from 
       Cliente_Contato cc with (nolock)  
     where 
       cc.cd_cliente = Cli.cd_cliente)            as 'nm_contato_cliente',
  
     cast(isnull((select sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)
                  from Pedido_Venda pv             with (nolock) 
                  inner join Pedido_Venda_Item pvi with (nolock) 
                       on pv.cd_pedido_venda = pvi.cd_pedido_venda
                  where ( pv.cd_vendedor = cli.cd_vendedor )  and 
                        pv.cd_cliente = Cli.cd_cliente and
                        pv.dt_pedido_venda between @dt_inicial  and @dt_final and
                        pv.dt_cancelamento_pedido is null and
                        pvi.dt_cancelamento_item is null ),0) as decimal(15,2)) as 'CompraVendedor',
     
     (select count(pv.cd_pedido_venda)
      from Pedido_Venda pv with (nolock) 
      where pv.cd_vendedor = Cli.cd_vendedor and
            pv.cd_cliente  = Cli.cd_cliente and
            pv.dt_cancelamento_pedido is null and
            pv.dt_pedido_venda between @dt_inicial  and @dt_final )             as 'pedidos',

    ra.nm_ramo_atividade,
    isnull(ci.vl_saldo_atual_aberto,0)                              as vl_saldo_atual_aberto,
    isnull(fp.nm_forma_pagamento,'')                                as nm_forma_pagamento,
    isnull(cv.nm_criterio_visita,'')                                as nm_criterio_visita

  
  into #VendaClienteAuxSetor
  from 
    Cliente Cli                          with (nolock) 
    left outer join Vendedor Vend        with (nolock) ON Cli.cd_vendedor = Vend.cd_vendedor 
    LEFT OUTER JOIN Regiao_Venda RegVend with (nolock) ON Cli.cd_regiao = RegVend.cd_regiao_venda 
    LEFT OUTER JOIN Cep                  with (nolock) ON Cli.cd_identifica_cep = Cep.cd_identifica_cep AND Cli.cd_cep = Cep.cd_cep AND Cli.cd_pais = Cep.cd_pais AND Cli.cd_estado = Cep.cd_estado AND Cli.cd_cidade = Cep.cd_cidade
    LEFT OUTER JOIN Cidade Cid           with (nolock) ON Cli.cd_pais = Cid.cd_pais AND Cli.cd_estado = Cid.cd_estado AND Cli.cd_cidade = Cid.cd_cidade 
    LEFT OUTER JOIN Pais                 with (nolock) ON Cli.cd_pais = Pais.cd_pais 
    LEFT OUTER JOIN Estado Est           with (nolock) ON Cli.cd_estado = Est.cd_estado AND Cli.cd_pais = Est.cd_pais 
    left outer join Ramo_Atividade ra    with (nolock) on ra.cd_ramo_atividade = cli.cd_ramo_atividade
    left outer join 
         Cliente_Informacao_Credito ci   with (nolock) on ci.cd_cliente         = cli.cd_cliente
    left outer join Forma_pagamento fp   with (nolock) on fp.cd_forma_pagamento = ci.cd_forma_pagamento
    left outer join Criterio_Visita cv   with (nolock) on cv.cd_criterio_visita = cli.cd_criterio_visita

--select * from cliente_informacao_credito

  where
    isnull(cli.cd_vendedor,0) = case when @cd_vendedor <> 0 then @cd_vendedor else isnull(cli.cd_vendedor,0) end

  order by
    CompraVendedor desc
  
  --Buscando vendas que foram feitas para clientes de outro vendedor
  --Buscando vendedores externos

  select
    cd_vendedor
  into
    #Vendedor
  from
    Vendedor
  where
    isnull(cd_vendedor,0) = case when @cd_vendedor <> 0 then @cd_vendedor else isnull(cd_vendedor,0) end and
    cd_tipo_vendedor = 2

  declare @cd_vendedor_outro int

  while exists(select 1 from #Vendedor)
  begin
    select
      @cd_vendedor_outro = cd_vendedor
    from
      #Vendedor

    insert into
      #VendaClienteAuxSetor
    select 
      Cli.cd_cliente,
      Cli.nm_fantasia_cliente     as 'Cliente',
      Cli.nm_email_cliente        as 'Email', 
      Cli.nm_endereco_cliente     as 'Endereco', 
      Cli.cd_numero_endereco      as 'Numero', 
      Cli.nm_complemento_endereco as 'Complemento', 
      Cli.nm_bairro               as 'Bairro', 
      Cli.cd_ddd                  as 'DDD', 
      Cli.cd_telefone             as 'Fone', 
      Cli.cd_fax                  as 'Fax', 
      Cid.nm_cidade               as 'Cidade', 
      Pais.nm_pais                as 'Pais', 
      Cep.cd_cep                  as 'Cep', 
      Vend.cd_vendedor            as 'CD_Vendedor',
      Vend.nm_vendedor            as 'Vendedor', 
      RegVend.nm_regiao_venda     as 'Regiao', 
      Cli.nm_dominio_cliente      as 'Site', 
      Est.sg_estado               as 'Estado', 
      (select max(pv.dt_pedido_venda)
       from pedido_venda pv
       where pv.cd_cliente = Cli.cd_cliente)  as 'UltimaCompra',

      (select top 1 cc.nm_contato_cliente 
       from Cliente_Contato cc 
       where cc.cd_cliente = Cli.cd_cliente) as 'nm_contato_cliente',

      sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)      as 'CompraVendedor',

      (select count(pv.cd_pedido_venda)
       from Pedido_Venda pv
       where pv.cd_cliente = Cli.cd_cliente and
             pv.dt_cancelamento_pedido is null and
             pv.dt_pedido_venda between @dt_inicial and @dt_final ) as 'pedidos',

    MAX(ra.nm_ramo_atividade)                                       as nm_ramo_atividade,
    sum(isnull(ci.vl_saldo_atual_aberto,0))                              as vl_saldo_atual_aberto,
    max(isnull(fp.nm_forma_pagamento,''))                                as nm_forma_pagamento,
    max(isnull(cv.nm_criterio_visita,''))                                as nm_criterio_visita

    from
      Pedido_Venda pv with (nolock) 
        inner join
      Pedido_Venda_Item pvi with (nolock) 
        on pv.cd_pedido_venda = pvi.cd_pedido_venda 
        left outer join
      Cliente Cli 
        on pv.cd_cliente = cli.cd_cliente 
        left outer join
      Vendedor Vend 
        ON pv.cd_vendedor = Vend.cd_vendedor 
        LEFT OUTER JOIN
      Regiao_Venda RegVend ON Cli.cd_regiao = RegVend.cd_regiao_venda LEFT OUTER JOIN
      Cep ON Cli.cd_identifica_cep = Cep.cd_identifica_cep AND Cli.cd_cep = Cep.cd_cep AND Cli.cd_pais = Cep.cd_pais AND Cli.cd_estado = Cep.cd_estado AND Cli.cd_cidade = Cep.cd_cidade LEFT OUTER JOIN
      Cidade Cid ON Cli.cd_pais = Cid.cd_pais AND Cli.cd_estado = Cid.cd_estado AND Cli.cd_cidade = Cid.cd_cidade LEFT OUTER JOIN
      Pais ON Cli.cd_pais = Pais.cd_pais LEFT OUTER JOIN
      Estado Est ON Cli.cd_estado = Est.cd_estado AND Cli.cd_pais = Est.cd_pais 
      left outer join Ramo_Atividade ra    with (nolock) on ra.cd_ramo_atividade = cli.cd_ramo_atividade
      left outer join 
           Cliente_Informacao_Credito ci   with (nolock) on ci.cd_cliente         = cli.cd_cliente
      left outer join Forma_pagamento fp   with (nolock) on fp.cd_forma_pagamento = ci.cd_forma_pagamento
      left outer join Criterio_Visita cv   with (nolock) on cv.cd_criterio_visita = cli.cd_criterio_visita


    where
      pv.dt_pedido_venda between @dt_inicial and @dt_final and
      pv.dt_cancelamento_pedido is null and
      pvi.dt_cancelamento_item is null and
      pv.cd_vendedor = @cd_vendedor_outro and
      pv.cd_cliente not in (select cd_cliente from cliente where cd_vendedor = @cd_vendedor_outro)
    group by 
      Cli.cd_cliente,
      Cli.nm_fantasia_cliente,
      Cli.nm_email_cliente, 
      Cli.nm_endereco_cliente, 
      Cli.cd_numero_endereco, 
      Cli.nm_complemento_endereco, 
      Cli.nm_bairro, 
      Cli.cd_ddd, 
      Cli.cd_telefone, 
      Cli.cd_fax, 
      Cid.nm_cidade, 
      Pais.nm_pais, 
      Cep.cd_cep, 
      Vend.cd_vendedor,
      Vend.nm_vendedor, 
      RegVend.nm_regiao_venda, 
      Cli.nm_dominio_cliente, 
      Est.sg_estado 

    delete #Vendedor
    where cd_vendedor = @cd_vendedor_outro

  end

  select 
    identity(int, 1, 1) posicao, 
    cast(0 as float) perc,
    cast(0 as float) perctotal, 
    cast(0 as float) CompraTotalEmpresa,
    * into #teste from #VendaClienteAuxSetor

  select * from #teste order by posicao

/* Voltar a versão para o normal....foi a pedido do Carlos que comentamos este procedimento abaixo. Igor/Elias - 22.06.2004
  declare @vl_total_vendedor float
  declare @vl_total_empresa float

  set @vl_total_empresa = isnull((select 
                                    Sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)
                                  from
                                    Pedido_Venda pv inner join
                                    Pedido_venda_Item pvi on pv.cd_pedido_venda = pvi.cd_pedido_venda
                                  where
                                    pv.dt_pedido_venda between @dt_inicial and @dt_final and
                                    pv.dt_cancelamento_pedido is null and
                                    pvi.dt_cancelamento_item is null and
                                    IsNull(pv.cd_vendedor,0) <> 0),0)
  
  select  
    cd_vendedor, 
    sum(CompraVendedor) as 'TotalCompraVendedor'
  into 
    #VendaClienteAuxAgrupado
  from 
    #VendaClienteAuxSetor
  group by 
    cd_vendedor
  order by 
    2 desc

  select 
    v.*,
    c.TotalCompraVendedor
  into 
    #VendaClienteAuxSetor1
  from 
    #VendaClienteAuxSetor v,
    #VendaClienteAuxAgrupado c
  where
    v.cd_vendedor = c.cd_vendedor
  order by
    v.CompraVendedor desc

  select
    IDENTITY(int, 1,1) as 'Posicao',
    a.Cliente, 
    a.Endereco, 
    a.Numero, 
    a.Complemento, 
    a.Bairro, 
    a.Cidade, 
    a.Estado,   
    a.Cep, 
    a.Pais, 
    a.DDD, 
    a.Fone, 
    a.Fax, 
    a.Email, 
    a.Site, 
    a.nm_contato_cliente,
    a.Vendedor, 
    a.CD_Vendedor,
    a.Regiao, 
    a.CompraVendedor, 
    case when  IsNull(( select x.TotalCompraVendedor 
                 from #VendaClienteAuxAgrupado x
                 where x.cd_vendedor = a.cd_vendedor ),0) = 0
         then 0 else
               ( (a.CompraVendedor * 100)/ 
                 ( select x.TotalCompraVendedor 
                   from #VendaClienteAuxAgrupado x
                   where x.cd_vendedor = a.cd_vendedor ) ) 
         end    as 'Perc',
     case when  IsNull((a.CompraVendedor),0) = 0
         then 0 else
               ( (a.CompraVendedor * 100) / 
                 (@vl_total_empresa ) ) 
         end as 'PercTotal',
    a.UltimaCompra,
    a.pedidos,
    @vl_total_empresa as 'CompraTotalEmpresa'
  
  Into  
    #VendaClienteVendedor
  from 
    #VendaClienteAuxSetor1 a
  Order by 
    a.CompraVendedor desc

  --Mostra tabela ao usuário
  select * from 
    #VendaClienteVendedor
  order by 
    Posicao
*/  
