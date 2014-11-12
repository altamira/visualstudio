
CREATE VIEW vw_in86_Itens_prod_Serv_Nt_Saida_Entr_Emitidas
--vw_in86_Itens_prod_Serv_Nt_Saida_Entr_Emitidas
-------------------------------------------------------------
--GBS - Global Business Solution	                       2004
--Stored Procedure	: Microsoft SQL Server               2004
--Autor(es)		      : André de O. Godoi
--Banco de Dados	  : EGISSQL
--Objetivo		      : Itens, Produtos e Serviços das Notas de 
--                    Entrada e Saída emitidas pela Empresa
--                  : IN86 -  4.3.2   
--Data			        : 30/03/2004
-------------------------------------------------------------
as

select
  case when (gop.cd_tipo_operacao_fiscal) = 1 then   
         'E'
       else
         'S'    
       end                                                               as 'INDMOV',        -- 1)
  isnull(snf.cd_modelo_serie_nota,'01')                                  as 'MODDOC',       -- 2)  
  case when snf.sg_serie_nota_fiscal = '1.'
         then '1'
       else IsNull(snf.sg_serie_nota_fiscal,'1')
       end                                                               as 'SERIEDOC',
  ns.cd_nota_saida                                                       as 'NUMDOC',        -- 4)
  ns.dt_nota_saida	                                                     as 'DATAEMISS',     -- 5)
  nsi.cd_item_nota_saida	                                               as 'NUMITEM',       -- 6)
  Case When ( Isnull( nsi.cd_produto, 0 ) = 0 ) then
         Case When ( Isnull( nsi.cd_servico, 0 ) = 0 ) then
                Case when ( isnull( gp.cd_grupo_produto, 0) = 0) then
                       null  
                     else               
                       'G' + cast(gp.cd_grupo_produto as char(19))
                     end              
              Else
                'S' + cast(s.cd_servico as char(19))
              End
       Else
         'P' + cast(p.cd_produto as char(19))
       End                                                              as 'CODMERCSERV',  -- 7)
 Case When ( Isnull( nsi.cd_produto, 0 ) = 0 ) then
         Case When ( Isnull( nsi.cd_servico, 0 ) = 0 ) then
                Case when ( isnull( gp.cd_grupo_produto, 0) = 0) then
                       null  
                     else               
                       cast(gp.nm_grupo_produto as char(45))
                     end             
              Else
                cast(s.nm_servico as char(45))
              end
      Else
        cast(p.nm_produto as char(45))
      End                                                               as 'DESCOMPLEM',    -- 8)  
  opf.cd_mascara_operacao                                               as 'CFOP',          -- 9)
  isnull(nsi.cd_operacao_fiscal, ns.cd_operacao_fiscal)                 as 'CODNATOP',      -- 10)
  cf.cd_mascara_classificacao                                           as 'CLAFISMERC',    -- 11)   
  nsi.qt_item_nota_saida                                                as 'QTD',           -- 12)
  um.sg_unidade_medida                                                  as 'UNIDADE',       -- 13)
  nsi.vl_unitario_item_nota                                             as 'VLRUNIT',       -- 14) 
  nsi.vl_total_item                                                     as 'VLRTOTALITEM',  -- 15)
 ((nsi.vl_total_item * nsi.pc_desconto_item)/100)                       as 'VLRDESCITEM',   -- 16)
  -- Ver com o Elias esrte campo                                                            -- 17)
  nsi.pc_ipi                                                            as 'ALIQIPI',       -- 18)
  nsi.vl_base_ipi_item                                                  as 'BASEIPI',       -- 19)
  nsi.vl_ipi                                                            as 'VLRIPI',        -- 20)
  nsi.cd_situacao_tributaria	                                          as 'SITRIBEST',     -- 21)
  Substring(nsi.cd_situacao_tributaria,3,1)                             as 'INDTRIBICMS',   -- 22)  
  nsi.pc_icms                                                           as 'ALIQICMS',      -- 23)
  nsi.vl_base_icms_item		                                              as 'BASEISCMSPRO',  -- 24)                                
  nsi.vl_icms_item                                                      as 'VLRICMSPRO',     -- 25)
  nsi.vl_bc_subst_icms_item 	                                          as 'BASEICMSTRIB',  -- 26)
  isnull(nsi.vl_bc_subst_icms_item, nsi.vl_icms_item)                   as 'VLRICMSTRIB',   -- 27) 
  nsi.ic_movimento_estoque                                              as 'IMOVFISMERC'    -- 28)
  
from

  Nota_Saida ns

  inner  join Nota_Saida_Item nsi 
    on ns.cd_nota_saida = nsi.cd_nota_saida

  Left outer join classificacao_fiscal cf	
    on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal

  Left outer join Unidade_Medida um
    on nsi.cd_unidade_medida = um.cd_unidade_medida

  left outer join operacao_fiscal opf 
    on opf.cd_operacao_fiscal = isnull(nsi.cd_operacao_fiscal, ns.cd_operacao_fiscal)
  
  left outer join grupo_operacao_fiscal gop
    on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
  
  left outer join serie_nota_fiscal snf
    on snf.cd_serie_nota_fiscal = ns.cd_serie_nota
   
  left outer join grupo_produto gp
    on gp.cd_grupo_produto = nsi.cd_grupo_produto
  
  left outer join servico s
    on s.cd_servico = nsi.cd_servico

  left outer join produto p
    on p.cd_produto = nsi.cd_produto
 

union 





select  
  case when (gop.cd_tipo_operacao_fiscal) = 1 then   
       'E'
    else
       'S'    
    end                                                                 as 'INDMOV',        -- 1)
  IsNull(snf.cd_modelo_serie_nota,'01')                                 as 'MODDOC',
  case when snf.sg_serie_nota_fiscal = '1.'
         then '1'
       else IsNull(snf.sg_serie_nota_fiscal,'1')
       end                                                              as 'SERIEDOC',

  ne.cd_nota_entrada                                                    as 'NUMDOC',        -- 4)
  ne.dt_nota_entrada	                                                  as 'DATAEMISS',     -- 5)
  nei.cd_item_nota_entrada	                                            as 'NUMITEM',       -- 6)
  Case When ( Isnull( nei.cd_produto, 0 ) = 0 ) then
         Case When ( Isnull( nei.cd_servico, 0 ) = 0 ) then
                null  
              Else
                'S' + cast(s.cd_servico as char(19))
              End
       Else
         'P' + cast(p.cd_produto as char(19))
       End                                                              as 'CODMERCSERV',  -- 7)
 Case When ( Isnull( nei.cd_produto, 0 ) = 0 ) then
         Case When ( Isnull( nei.cd_servico, 0 ) = 0 ) then
                null  
              Else
                cast(s.nm_servico as char(45))
              end
      Else
        cast(p.nm_produto as char(45))
      End                                                               as 'DESCOMPLEM',    -- 8)  
  opfi.cd_mascara_operacao                                              as 'CFOP',          -- 9)
  isnull(nei.cd_operacao_fiscal, ne.cd_operacao_fiscal)                 as 'CODNATOP',      -- 10)
  cf.cd_mascara_classificacao                                           as 'CLAFISMERC',    -- 11)   
  nei.qt_item_nota_entrada                                              as 'QTD',           -- 12)
  um.sg_unidade_medida                                                  as 'UNIDADE',       -- 13)
  nei.vl_item_nota_entrada                                              as 'VLRUNIT',       -- 14) 
  nei.vl_total_nota_entr_item                                           as 'VLRTOTALITEM',  -- 15)
  null                                                                  as 'VLRDESCITEM',   -- 16)
  -- Ver com o Elias esrte campo                                                            -- 17)
  nei.pc_ipi_nota_entrada                                               as 'ALIQIPI',       -- 18)
  nei.vl_bipi_nota_entrada                                              as 'BASEIPI',       -- 19)
  nei.vl_ipi_nota_entrada                                               as 'VLRIPI',        -- 20)
  nei.cd_situacao_tributaria	                                          as 'SITRIBEST',     -- 21)
  Substring(nei.cd_situacao_tributaria,3,1)                             as 'INDTRIBICMS',   -- 22)  
  nei.pc_icms_nota_entrada                                              as 'ALIQICMS',      -- 23)
  nei.vl_bicms_nota_entrada                                             as 'BASEICMSPROP',  -- 24)                                
  nei.vl_icms_nota_entrada                                              as 'VLRICMSPRO',     -- 25)
  null 	                                                                as 'BASEICMSTRIB',  -- 26)
  null                                                                  as 'VLRICMSTRIB',   -- 27) 
  null                                                                  as 'IMOVFISMERC'    -- 28)
  
from

  Nota_Entrada ne

  Left Outer join Nota_Entrada_Item nei 
    on ne.cd_nota_entrada = nei.cd_nota_entrada

  Left outer join classificacao_fiscal cf	
    on cf.cd_classificacao_fiscal = nei.cd_classificacao_fiscal

  Left outer join Unidade_Medida um
    on nei.cd_unidade_medida = um.cd_unidade_medida

  -- Este Relacionamento abaixo é para pegar somente o tipo de operação da nota de entrada
  -- pois na nota de entrada não vem se é de Saída ou Entrada.

  left outer join operacao_fiscal opf 
    on opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  
  left outer join grupo_operacao_fiscal gop
    on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal

  -- O relacionamento abaixo é para pegar a Operação Fiscal dos Produtos ou Serviços, individual (Itens)
  ------------------------------------------------------------------------------------------------------
  left outer join operacao_fiscal opfi 
    on opfi.cd_operacao_fiscal = nei.cd_operacao_fiscal
  ------------------------------------------------------------------------------------------------------
  left outer join serie_nota_fiscal snf
    on snf.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
  
  left outer join servico s
    on s.cd_servico = nei.cd_servico

  left outer join produto p
    on p.cd_produto = nei.cd_produto


