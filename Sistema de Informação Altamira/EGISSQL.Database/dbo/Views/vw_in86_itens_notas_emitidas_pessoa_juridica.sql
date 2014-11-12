
create  VIEW vw_in86_itens_notas_emitidas_pessoa_juridica

--vw_in86_itens_notas_emitidas_pessoa_juridica

---------------------------------------------------------------------------------
--GBS - Global Business Solution	                                           2004
--Stored Procedure	: Microsoft SQL Server                                   2004
--Autor(es)		      : André Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Selecionar todos os Itens das notas de Serviço Emitidas pela Pessoa Juridica
--                    4.3.6  
--Data			        : 29/03/2004
----------------------------------------------------------------------------------

as

select  distinct
  case when snf.sg_serie_nota_fiscal = '1.' then 
         '1'
       else 
         IsNull(snf.sg_serie_nota_fiscal,'1')
       end                                                                as 'SERIE',  
  nsi.cd_nota_saida                                                       as 'NUMDOC',
  ns.dt_nota_saida                                                        as 'DATAEMISS',
  nsi.cd_item_nota_saida                                                  as 'NUMITEM',
  vwp.cd_produto_servico                                                  as 'CODIGO',
  vwp.Produto_Servico                                                     as 'DESCRICAO',
  nsi.vl_servico                                                          as 'VLRSERV',
  ( nsi.vl_servico * nsi.pc_desconto_item ) / 100                         as 'VLRDESCSERV',
  nsi.pc_iss_servico                                                      as 'ALIQISS',
  ( nsi.vl_servico) - (( nsi.vl_servico * nsi.pc_desconto_item ) / 100)   as 'BASEISS',
  nsi.vl_iss_servico                                                      as 'VLRISS'
 
from 
  nota_saida_item nsi

  left outer join operacao_fiscal opf
    on opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal

  left outer join   nota_saida ns
    on ns.cd_nota_saida = nsi.cd_nota_saida 

  left outer join  Serie_Nota_Fiscal snf
    on snf.cd_serie_nota_fiscal = ns.cd_serie_nota

  left outer join vw_in86_Produtos_Entrada_Saida vwp
    on vwp.cd_servico = nsi.cd_servico
  

where 
  vwp.sg_Serv_Prod = 'S' and
  opf.ic_servico_operacao = 'S' and
  nsi.cd_servico is not null

-- Teste de View

-- select top 100 * from vw_in86_itens_notas_emitidas_pessoa_juridica order by numdoc

-- select top 100 * from vw_in86_Produtos_Entrada_Saida order by cd_produto_servico
