--pr_dados_consulta_EGIS
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Retorno de Dados de Consulta a ser orçada
--Data         : 28.06.2001
--Atualizado   : 18.11.2002
--             : 15.12.2004
-----------------------------------------------------------------------------------
CREATE procedure pr_dados_consulta_EGIS

@cd_consulta int,
@cd_item int

as

select b.cd_consulta,
       b.cd_item_consulta,
       c.nm_fantasia_cliente         as 'Cliente',
       a.cd_cliente                  as 'CodCliente',
       a.dt_consulta                 as 'Data',
       d.nm_contato_cliente          as 'Contato',
       a.cd_contato                  as 'CodContato',
       a.cd_consulta_representante   as 'ConsultaRepres',
       c.cd_ddd                      as 'DDD',
       c.cd_telefone                 as 'Fone',
       c.cd_fax                      as 'Fax',  
       a.cd_consulta                 as 'Numero',
       a.cd_vendedor_interno         as 'VendedorInterno',
       e.nm_condicao_pagamento       as 'CondicaoPagto',
       a.cd_condicao_pagamento       as 'CodCondPagto',
       f.nm_setor_cliente            as 'Departamento',
       b.cd_item_consulta            as 'Item', 
       b.dt_orcamento_liberado_con   as 'DataOrcado',
       b.nm_produto_consulta         as 'Descricao',
       b.qt_item_consulta            as 'Qtd.',
       b.vl_lista_item_consulta      as 'Orcado',
       b.vl_unitario_item_consulta   as 'Preco',
       b.qt_dia_entrega_consulta     as 'DiasUteis',
       b.cd_grupo_produto            as 'Grupo',
    -- b.numped                      as 'Pedido',
       0                             as 'Pedido',
       b.nm_fantasia_produto         as 'Produto',
       b.dt_perda_consulta_itens     as 'DataPerda',
       b.ic_orcamento_consulta       as 'Orcamit',
       Lorc = 
       case when dt_orcamento_liberado_con is not null then 'S' else 'N' end,
       b.ds_produto_consulta         as 'ObservacaoProduto',
       b.ds_produto_consulta,
       b.ds_observacao_fabrica       as 'ObservacaoFabrica',
       b.ds_observacao_fabrica,
       b.cd_os_consulta              as 'OS',
       b.vl_moeda_cotacao            as 'MoedaCotacao',
       b.dt_moeda_cotacao            as 'DataMoedaCotacao',
       b.cd_moeda_cotacao            as 'Moeda'

from 
   consulta_itens b

inner join consulta a on
a.cd_consulta = b.cd_consulta

inner join cliente c on
a.cd_cliente = c.cd_cliente

left outer join cliente_contato d on
a.cd_cliente = d.cd_cliente and
a.cd_contato = d.cd_contato

left outer join setor_cliente f on
d.cd_setor_cliente = f.cd_setor_cliente

left outer join condicao_pagamento e on
a.cd_condicao_pagamento = e.cd_condicao_pagamento

where
   b.cd_consulta            = @cd_consulta and
   b.cd_item_consulta       = @cd_item

