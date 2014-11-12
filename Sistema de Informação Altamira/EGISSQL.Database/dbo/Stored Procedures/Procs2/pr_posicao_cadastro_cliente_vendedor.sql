
-------------------------------------------------------------------------------
--sp_helptext pr_posicao_cadastro_cliente_vendedor
-------------------------------------------------------------------------------
--pr_posicao_cadastro_cliente_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta / Posição de Clientes por Vendedor / Área
--
--Data             : 13.04.2009
--
--Alteração        : 16.04.2009 - Número do Endereço - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_posicao_cadastro_cliente_vendedor
@cd_vendedor        int      = 0,
@cd_criterio_visita int      = 0,
@dt_inicial         datetime = '',
@dt_final           datetime = ''

as

  -- Geração da Tabela Auxiliar de Vendas por Vendedor
  --select * from cliente

  Select 
    identity(int,1,1)           as cd_controle,
    Cli.cd_cliente,
    Cli.nm_fantasia_cliente     as 'Cliente',
    Cli.nm_razao_social_cliente,
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
    Vend.cd_vendedor            as 'cd_vendedor',
    Vend.nm_vendedor            as 'Vendedor', 
    Vend.nm_fantasia_vendedor,
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
                        pv.cd_cliente    = Cli.cd_cliente and
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
    isnull(cv.nm_criterio_visita,'')                                as nm_criterio_visita,
    cv.sg_criterio_visita,
    cv.sg_area_criterio_visita,
    sc.nm_status_cliente,
    cr.nm_cliente_regiao

--select * from cliente_regiao
  
  into
    #PosicaoClienteVendedor

  from 
    Cliente Cli                          with (nolock) 
    left outer join Vendedor Vend        with (nolock) ON Cli.cd_vendedor       = Vend.cd_vendedor 
    LEFT OUTER JOIN Regiao_Venda RegVend with (nolock) ON Cli.cd_regiao         = RegVend.cd_regiao_venda 
    LEFT OUTER JOIN Cep                  with (nolock) ON Cli.cd_identifica_cep = Cep.cd_identifica_cep AND Cli.cd_cep = Cep.cd_cep AND Cli.cd_pais = Cep.cd_pais AND Cli.cd_estado = Cep.cd_estado AND Cli.cd_cidade = Cep.cd_cidade
    LEFT OUTER JOIN Cidade Cid           with (nolock) ON Cli.cd_pais = Cid.cd_pais AND Cli.cd_estado = Cid.cd_estado AND Cli.cd_cidade = Cid.cd_cidade 
    LEFT OUTER JOIN Pais                 with (nolock) ON Cli.cd_pais = Pais.cd_pais 
    LEFT OUTER JOIN Estado Est           with (nolock) ON Cli.cd_estado = Est.cd_estado AND Cli.cd_pais = Est.cd_pais 
    left outer join Ramo_Atividade ra    with (nolock) on ra.cd_ramo_atividade = cli.cd_ramo_atividade
    left outer join 
         Cliente_Informacao_Credito ci   with (nolock) on ci.cd_cliente         = cli.cd_cliente
    left outer join Forma_pagamento fp   with (nolock) on fp.cd_forma_pagamento = ci.cd_forma_pagamento
    left outer join Criterio_Visita cv   with (nolock) on cv.cd_criterio_visita = cli.cd_criterio_visita
    left outer join Status_Cliente  sc   with (nolock) on sc.cd_status_cliente  = cli.cd_status_cliente
    left outer join Cliente_Regiao  cr   with (nolock) on cr.cd_cliente_regiao  = cli.cd_regiao
--select * from cliente_informacao_credito

  where
    isnull(cli.cd_vendedor,0)            = case when @cd_vendedor <> 0       then @cd_vendedor                     else isnull(cli.cd_vendedor,0) end
    and isnull(cli.cd_criterio_visita,0) = case when @cd_criterio_visita = 0 then isnull(cli.cd_criterio_visita,0) else @cd_criterio_visita       end 
    and isnull(sc.ic_operacao_status_cliente,'S')='S' --status do cliente


--select * from status_cliente

-------------------------------------------------------------------------------
--Mostra a Tabela dos Clientes
-------------------------------------------------------------------------------
select
  *
from
  #PosicaoClienteVendedor
order by
  nm_fantasia_vendedor,
  pais,
  estado,
  cidade,
  Endereco


