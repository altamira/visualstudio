
create  VIEW vw_in86_Doc_Itens_Prod_Serv_Entrada_Terc
-- vw_in86_Doc_Itens_Prod_Serv_Entrada_Terc
-------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                 2004
--Stored Procedure	: Microsoft SQL Server                                       2004
--Autor(es)		      : André Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Itens de Produtos / Serviços (Entradas) - Emitidas por Terceiro 
--                    4.3.4
--Data			        : 02/04/2004
-------------------------------------------------------------------------------------
as

select
  isnull(snf.cd_modelo_serie_nota,'01')                               as 'MODDOC',    -- 1)  
  case when snf.sg_serie_nota_fiscal = '1.' then 
         '1'
       else 
         IsNull(snf.sg_serie_nota_fiscal,'1')
       end                                                            as 'SERIE',     -- 2)
  nei.cd_nota_entrada                                                 as 'NUMDOC',    -- 3)
  ne.dt_nota_entrada                                                  as 'DATAEMISS', -- 4)
  case when ne.cd_tipo_destinatario = 1 then
        'Cl' + cast(ne.cd_fornecedor as varchar(4))
       else
         case when ne.cd_tipo_destinatario = 2 then       
                'Fo' + cast(ne.cd_fornecedor as varchar(4))   
              else
                case when ne.cd_tipo_destinatario = 3 then
                      'Ve' + cast(ne.cd_fornecedor as varchar(4))
                     else
                       null      
                end
         end      
  end                                                                 as 'CODPART',     -- 5)
  nei.cd_item_nota_entrada                                            as 'NUMITEM',     -- 6)
  case when isnull(nei.cd_produto,0)>=0 then
         'P' + cast(p.cd_produto as char(16))
       else
         'S' + cast(s.cd_servico as char(16))         
       end                                                            as 'CODMERCSERV', -- 7)
  case when isnull(nei.cd_produto,0)>=0 then
         p.nm_produto
       else
         s.nm_servico
       end                                                            as 'DESCOMPLPROD', -- 8)
  opf.cd_mascara_operacao                                             as 'CFOP',         -- 9)
  isnull(nei.cd_operacao_fiscal, ne.cd_operacao_fiscal)               as 'CODNATOP',     -- 10)
  cf.cd_mascara_classificacao                                         as 'CLAFISMERC',   -- 11)   
  nei.qt_item_nota_entrada                                            as 'QTDE',         -- 12)
  um.sg_unidade_medida                                                as 'UNIDADE',      -- 13)
  nei.vl_item_nota_entrada                                            as 'VLRUNIT',      -- 14)
  nei.vl_total_nota_entr_item                                         as 'VLRTOTITEM',   -- 15)
  ( nei.vl_item_nota_entrada * pc_desc_nota_entrada )/100             as 'VLRDESCITEM',  -- 16)
  -- Duvida ver com o Elias                                                            item 17)
  nei.pc_ipi_nota_entrada                                             as 'ALIQIPI',      -- 18)
  nei.vl_bipi_nota_entrada                                            as 'BASEIPI',      -- 19)
  nei.vl_ipi_nota_entrada                                             as 'VLRIPI',       -- 20)
  nei.cd_situacao_tributaria                                          as 'SITRIBEST',    -- 21)
  -- Duvida ver com o Elias                                                            item 22)
  nei.pc_icms_nota_entrada                                            as 'ALIQICMS',     -- 23)
  nei.vl_bicms_nota_entrada                                           as 'BASEICMSPROP', -- 24)  
  nei.vl_icms_nota_entrada                                            as 'VLRICMSPROP',  -- 25)  
  0                                                                   as 'BASEICMSTRIB', -- 26)
  0                                                                   as 'VLRICMSTRIB',  -- 27)
  case when ic_estocado_nota_entrada <> 'S' then
         'N'
       else
         'S'
       end                                                            as 'IMOVFISMERC'   -- 28)

from
  nota_entrada_item nei

  left outer join nota_entrada ne
    on ( ne.cd_nota_entrada = nei.cd_nota_entrada )

  left outer join serie_nota_fiscal snf
    on ( snf.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal)

  left outer join produto p 
    on p.cd_produto = nei.cd_produto

  left outer join servico s 
    on s.cd_servico = nei.cd_servico  

  left outer join operacao_fiscal opf 
    on opf.cd_operacao_fiscal = isnull(nei.cd_operacao_fiscal, ne.cd_operacao_fiscal)

  left outer join classificacao_fiscal cf 
    on cf.cd_classificacao_fiscal = nei.cd_classificacao_fiscal

  left outer join unidade_medida um
    on um.cd_unidade_medida = nei.cd_unidade_medida


