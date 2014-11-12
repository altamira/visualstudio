
CREATE PROCEDURE pr_consulta_nota_faturamento_sem_pedido
-------------------------------------------------------------------------------
--pr_consulta_nota_faturamento_sem_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                       2004
-------------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : Johnny Mendes de Souza
--Banco de Dados         : <Database>
--Objetivo               : Consultar notas de faturamento que não possuem pedido
--Data                   : 20/01/04
--Atualizado             : 12/02/2004 - Inserindo novos Campos cd_mascara_produto,cd_mascara_operacao - Chico
--                       : 12/03/2004 - Acerto do Nome do Produto - Eduardo e Chico  
--                       : 20/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                       : 27.06.2005 - Verificação da Operação Fiscal que possui Valor Comercial 
--                                      Categoria do Produto que efetua pagamento de Comissão - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------------

@dt_inicial 			datetime,
@dt_final 			datetime
AS

  select
--    ns.cd_nota_saida           as Nota,
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
            ns.cd_identificacao_nota_saida
          else
            ns.cd_nota_saida                              
    end                        as Nota,

    c.nm_razao_social_cliente  as Cliente,
    nsi.cd_item_nota_saida     as Item,

    'Produto' = case when isnull(nsi.nm_produto_item_nota,'') <> ''
                     then nsi.nm_produto_item_nota
                     else (case when (isnull(nsi.cd_produto,0) = 0)
                                then s.nm_servico
                                else p.nm_produto
                           end)
                end,

    v.nm_vendedor                as Vendedor,
    ofi.cd_mascara_operacao      as OpercaoFiscal,
    p.cd_mascara_produto         as Masacraproduto,
    nsi.vl_total_item            as Total 

  from
    Nota_Saida ns                with (nolock) 

    inner join Nota_Saida_Item 	nsi      on nsi.cd_nota_saida  = ns.cd_nota_saida

    inner join Operacao_Fiscal ofi       on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal

    left outer join Cliente c            on ns.cd_cliente = c.cd_cliente
    left outer join Vendedor v           on c.cd_vendedor = v.cd_vendedor
    left outer join Produto p            on p.cd_produto = nsi.cd_produto
    left outer join Servico s            on s.cd_servico = nsi.cd_servico
    left outer join Categoria_Produto cp on cp.cd_categoria_produto = p.cd_categoria_produto and
                                            isnull(cp.ic_comissao_categoria,'N')='S'
    left outer join Categoria_produto cs on cs.cd_categoria_produto = s.cd_categoria_produto and
                                            isnull(cs.ic_comissao_categoria,'N')='S'

  where
    ns.dt_nota_saida               between @dt_inicial and @dt_final and
    ns.cd_tipo_destinatario        = 1   and
    ofi.ic_comercial_operacao      = 'S' and 
    (isnull(nsi.cd_pedido_venda,0) = 0 or isnull(nsi.cd_item_pedido_venda,0) = 0) and
    isnull(ns.dt_cancel_nota_saida,'') = '' 

  order by 1,3


