
CREATE VIEW vw_movimento_produto_terceiro

--------------------------------------------------------------------------
--GBS - Global Business Solution	                              2004
--------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server           2003
--Autor(es)             : Elias Pereira da Silva
--Banco de Dados	: EGISSQL
--Objetivo		: Lista o Movimento de Produto de Terceiros
--Data                  : 04/04/2005
--Atualizado            : 02/05/2005 - Acréscimo da Coluna PedidoVenda
-- 29.01.2008 - Ajustes gerais na procedure para baixa em outro código de produto
--              TabSheet Logística preenchido - Carlos Fernandes
-- 31/03/2008
-- 29.08.2010 - Mostrar o Operação Fiscal - Carlos Fernandes
--------------------------------------------------------------------------
as


select
       0                               as Selecionado,
       m.cd_movimento_produto_terceiro as Codigo,
       m.cd_movimento_origem           as Origem,
       m.cd_nota_entrada               as NFEntrada,
       case when m.cd_nota_entrada is null then null else m.dt_movimento_terceiro end as DTEntrada,
       nsi.cd_pedido_venda             as PedidoVenda, 
       m.cd_nota_saida                 as NFSaida,       
       case when m.cd_nota_entrada is null then m.dt_movimento_terceiro else null end as DTSaida,
       case when m.cd_nota_entrada is null then m.qt_movimento_terceiro else null end as QtdSaida,       
       case when m.cd_nota_entrada is null then null else m.qt_movimento_terceiro end as QtdEntrada,
       m.cd_destinatario               as Destinatario,
       m.cd_tipo_destinatario          as TipoDestinatario,
       case when m.cd_nota_entrada is null then null else
       cast(m.qt_movimento_terceiro - isnull((select sum(a.qt_movimento_terceiro)
                                              from movimento_produto_terceiro a
                                              where a.cd_movimento_origem = m.cd_movimento_produto_terceiro and
                                                    a.ic_tipo_movimento in ('E','S')),0) as decimal(25,5)) end 
                                             as Saldo,
       m.cd_produto                          as Produto,
       isnull(nei.vl_item_nota_entrada,0)    as vl_item_nota_entrada,
       snf.sg_serie_nota_fiscal,
       vw.nm_fantasia,
       nei.cd_item_nota_entrada,
       m.cd_item_nota_fiscal  ,
       p.cd_produto_baixa_estoque,
       nsi.cd_item_nota_saida,
       nei.cd_operacao_fiscal

       
from vw_destinatario vw,
     movimento_produto_terceiro m 

     left outer join Produto p on p.cd_produto =  m.cd_produto

     left outer join nota_saida_item nsi on nsi.cd_nota_saida      = m.cd_nota_saida and 
                            nsi.cd_item_nota_saida = m.cd_item_nota_fiscal and
--                            nsi.cd_produto         = m.cd_produto
                            nsi.cd_produto           = case when isnull(m.cd_produto,0)=isnull(nsi.cd_produto,0) 
                                                          then
                                                            m.cd_produto
                                                          else
                                                            case when isnull(p.cd_produto_baixa_estoque,0)>0 and
                                                               isnull(p.cd_produto_baixa_estoque,0)<>m.cd_produto
                                                                then
                                                                    p.cd_produto_baixa_estoque
                                                                 --nei.cd_produto 
                                                                else
                                                                   nsi.cd_produto 
                                                                end
                                                          end               


     left outer join Operacao_fiscal opf on opf.cd_operacao_fiscal = m.cd_operacao_fiscal

     left outer join 
     nota_entrada_item nei on nei.cd_nota_entrada      = m.cd_nota_entrada      and 
                              nei.cd_serie_nota_fiscal = m.cd_serie_nota_fiscal and 
                              nei.cd_item_nota_entrada = m.cd_item_nota_fiscal  and
                              nei.cd_fornecedor        = m.cd_destinatario      and
                              opf.cd_tipo_destinatario = m.cd_tipo_destinatario and
                              nei.cd_operacao_fiscal   = m.cd_operacao_fiscal   and
                              m.ic_tipo_movimento      = 'E'
     
     --Produto ( Plaspint : 29.01.2008 )

--                               and
--                                nei.cd_produto           = case when isnull(m.cd_produto,0)=isnull(nei.cd_produto,0) 
--                                                           then
--                                                             m.cd_produto
--                                                           else
--                                                             case when isnull(p.cd_produto_baixa_estoque,0)>0 and
--                                                                isnull(p.cd_produto_baixa_estoque,0)<>m.cd_produto
--                                                                 then
--                                                                     p.cd_produto_baixa_estoque
--                                                                  --nei.cd_produto 
--                                                                 else
--                                                                    nei.cd_produto 
--                                                                 end
--                                                           end               


     left outer join Serie_Nota_Fiscal snf on snf.cd_serie_nota_fiscal = m.cd_serie_nota_fiscal

where
      m.qt_movimento_terceiro > isnull((select sum( isnull(a.qt_movimento_terceiro,0) )
                                          from movimento_produto_terceiro a with (nolock) 
                                          where a.cd_movimento_origem = m.cd_movimento_produto_terceiro and
                                                a.ic_tipo_movimento in ('E','S')),0) 
                                                       and
      vw.cd_destinatario      = m.cd_destinatario      and
      vw.cd_tipo_destinatario = m.cd_tipo_destinatario and
      m.ic_tipo_movimento in ('E','S')                 and
      isnull(m.ic_movimento_terceiro,'S')='S'


