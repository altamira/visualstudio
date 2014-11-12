
------------------------------------------------------------------------------------------
-- vw_produto_entrada
------------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Alexandre Del Soldato
-- Banco de Dados: EgisSql
-- Objetivo   : Lista o Item de Produto da NF de Entradas utilizado nos Arquivos Magnéticos
-- Data       : 19/03/2004
-- Atualizado : 21.06.2007 - Revisão Geral
-- 02.02.2008 - Acertos Diversos - Carlos Fernandes
-- 04.03.2008 - Clientes que possuem Devolução e são Simples - Carlos Fernandes
-- 25.03.2008 - Ajustes Gerais - Carlos Fernandes
-- 24.06.2009 - Entrada no Faturamento - Importação - Carlos Fernandes
------------------------------------------------------------------------------------------
-- 
create view vw_produto_entrada
as

  select

    neri.DEBUG,
    cast('E' as char(1))                as 'ENTRADASAIDA',      

    ------------------------------ Dados da Nota Fiscal -------------------------

    neri.RECEBTOSAIDA,
    neri.cd_nota_entrada                as 'NUMERO',

    neri.cd_fornecedor,
    neri.cd_tipo_destinatario,

    neri.sg_estado                      as 'UF',

    case when isnull(neri.cd_mascara_operacao,'') = ''
         then '0000'
         else dbo.fn_limpa_mascara( neri.cd_mascara_operacao )
    end as 'CFOP',

    IsNull(s.sg_serie_nota_fiscal,'1')  as 'SERIE',

    IsNull(s.cd_modelo_serie_nota,'01') as 'MODELO',

    ------------------------------ Dados do Destinatário -------------------------

    case when (uf.sg_estado = 'EX') or (vw.cd_cnpj is null)
         then '00000000000000'
         else vw.cd_cnpj
    end as 'CNPJ',

    case when (uf.sg_estado = 'EX')
         then 'ISENTO'
         else case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
                        ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
                   then 'ISENTO'
                   else isnull(vw.cd_inscestadual,'00000000000000')
              end
    end as 'IE',

    ------------------------------ Dados dos Itens -------------------------

    neri.cd_produto,
    neri.PRODUTO,
    neri.DESCRICAO,
    neri.UNIDADEMEDIDA,
    neri.CST,
    neri.ITEM,
    neri.CLASSFISCAL,
    neri.QUANTIDADE,
    neri.VALORPRODUTO,
    neri.DESCONTO,
    neri.BCICMS,
    neri.BCTRIBUTARIA,
    neri.IPI,
    neri.ALIQIPI,
    neri.REDICMS,
    neri.BCICMSSUBST,
    neri.SITUACAOTRIB,

--     Case When ( isnull( neri.ALIQICMS, 0 ) = 0 )
-- 
--          then ( select MAX( pc_icms_reg_nota_entrada )
--                 from Nota_Entrada_Item_Registro r
--                 where r.cd_nota_entrada = neri.cd_nota_entrada and
--                       r.cd_fornecedor = neri.cd_fornecedor and
--                       r.cd_operacao_fiscal = neri.cd_operacao_fiscal and
--                       r.cd_serie_nota_fiscal = neri.cd_serie_nota_fiscal )
-- 
--          else neri.ALIQICMS
-- 
--     End as ALIQICMS    

    neri.ALIQICMS

  from
    ------------------------ Produtos --------------------------
  ( select

--      distinct

      cast('Produto' as varchar(10)) as 'DEBUG',

      ne.dt_receb_nota_entrada       as 'RECEBTOSAIDA',

      ne.cd_nota_entrada,
      ne.cd_fornecedor,
      ne.cd_operacao_fiscal,
      ne.cd_serie_nota_fiscal,
      ne.cd_tipo_destinatario,

      ne.sg_estado,
      o.cd_mascara_operacao,

      isnull(p.cd_produto,0)                    as cd_produto,

      case when IsNull(p.cd_mascara_produto,'') = ''
           then '999999999'
           else p.cd_mascara_produto
      end as 'PRODUTO',

      case when IsNull(p.cd_mascara_produto,'') = ''
           then 'PRODUTO ESPECIAL'
--           else nei.nm_produto_nota_entrada
           else
                p.nm_produto
      end as 'DESCRICAO',

      case when IsNull(p.cd_produto,0) = 0
           then 
              isnull( ume.sg_unidade_medida, 'PC' )
           else 
             isnull( u.sg_unidade_medida, 'PC' )
      end as 'UNIDADEMEDIDA',

      cast(replace(isnull(nei.cd_situacao_tributaria,'000'),' ','0') as char(3)) as 'CST',
      cast(nei.cd_item_Nota_Entrada as numeric(3))              as 'ITEM',

      cast(nei.cd_classificacao_fiscal as int)                  as 'CLASSFISCAL',

--       case when nei.cd_classificacao_fiscal<>pf.cd_classificacao_fiscal then
--        cast(pf.cd_classificacao_fiscal as int)
--       else
--       cast(nei.cd_classificacao_fiscal as int) end              as 'CLASSFISCAL',

      cast(IsNull(nei.qt_item_Nota_Entrada,0)as float)          as 'QUANTIDADE',
      cast((IsNull(nei.qt_item_nota_entrada,0)
        * IsNull(nei.vl_item_nota_entrada,0)) as float)         as 'VALORPRODUTO',
      cast(((IsNull(nei.qt_item_Nota_Entrada,0)
        * IsNull(nei.vl_item_nota_entrada,0)
        * IsNull(nei.pc_desc_nota_entrada,0))/100)as float)     as 'DESCONTO',


      case when r.cd_item_nota_entrada is not null then
        cast((IsNull(r.vl_bicms_reg_nota_entrada,0))as float)
      else
        cast((IsNull(nei.vl_bicms_nota_entrada,0))as float)  
      end                                                       as 'BCICMS',	

      '0'                                                       as 'BCTRIBUTARIA',

--select * from nota_entrada_item_registro
    
    --  cast(IsNUll(nei.vl_ipi_nota_entrada,0) as float)          as 'IPI',

   case when r.cd_item_nota_entrada is not null then
      cast(isnull(r.vl_ipi_reg_nota_entrada,0) as float)
   else
      --cast(IsNUll(nei.vl_ipi_nota_entrada,0) as float)
      0.00
   end                                                          as 'IPI',

   case when r.cd_item_nota_entrada is not null then
     cast(isnull(r.pc_icms_reg_nota_entrada,0) as float)
   else
     cast(isnull(nei.pc_icms_nota_entrada,0) as float)       
   end                                                          as 'ALIQICMS',

   case when r.cd_item_nota_entrada is not null then
     cast(isnull(r.pc_ipi_reg_nota_entrada,0) as float)
   else
     0.00 
     --cast(isnull(nei.pc_ipi_nota_entrada,0) as float)       
   end                                                          as 'ALIQIPI',        

--      cast(isnull(nei.pc_icms_red_nota_entrada,0) as float)     as 'REDICMS',

--       cast(0 as float)                                          as 'ALIQICMS',
--       cast(0 as float)						as 'ALIQIPI',

      cast(0 as float)						as 'REDICMS',
      cast(0 as float)					        as 'BCICMSSUBST',
      nei.cd_situacao_tributaria                                as 'SITUACAOTRIB'

    from
      Nota_Entrada ne                  with (nolock) 
    
      inner join Nota_Entrada_Item nei with (nolock) 
        on nei.cd_nota_entrada       = ne.cd_nota_entrada       and
           nei.cd_fornecedor         = ne.cd_fornecedor         and
           nei.cd_operacao_fiscal    = ne.cd_operacao_fiscal    and
           nei.cd_serie_nota_fiscal  = ne.cd_serie_nota_fiscal

       left outer join Nota_Entrada_Item_Registro r with (nolock) 
         on ne.cd_nota_entrada            = r.cd_nota_entrada      and
            ne.cd_fornecedor              = r.cd_fornecedor        and
            ne.cd_operacao_fiscal         = r.cd_operacao_fiscal   and
            ne.cd_serie_nota_fiscal       = r.cd_serie_nota_fiscal
            and nei.cd_item_nota_entrada  = r.cd_item_nota_entrada
    
      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = ne.cd_operacao_fiscal and
           isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S' and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal
  
      left outer join Produto p            with (nolock) on p.cd_produto          = nei.cd_produto
 
      left outer join Produto_Fiscal pf    with (nolock) on pf.cd_produto         = nei.cd_produto
 
      left outer join Unidade_Medida u     with (nolock) on u.cd_unidade_medida   = p.cd_unidade_medida

      left outer join Unidade_Medida ume   with (nolock) on ume.cd_unidade_medida = nei.cd_unidade_medida     

    where
      gop.cd_tipo_operacao_fiscal   = 1
      and
      nei.ic_tipo_Nota_Entrada_item = 'P'
      and isnull(nei.qt_item_nota_entrada,0)>0
      and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

--select * from nota_entrada_item
    
    UNION ALL 

    ------------------------ Frete --------------------------

    select
      cast('Frete' as varchar(10)) as 'DEBUG',

      ne.dt_receb_nota_entrada     as 'RECEBTOSAIDA',

      ne.cd_nota_entrada,
      ne.cd_fornecedor,
      ne.cd_operacao_fiscal,
      ne.cd_serie_nota_fiscal,
      ne.cd_tipo_destinatario,

      ne.sg_estado,
      o.cd_mascara_operacao,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))         as 'UNIDADEMEDIDA',

      cast('' as char(3))         as 'CST',
      cast(991 as float)          as 'ITEM',
      cast(0 as int)	          as 'CLASSFISCAL',
      cast(0 as float)            as 'QUANTIDADE',
      cast(0 as float)            as 'VALORPRODUTO',
      cast(ne.vl_frete_nota_entrada as float)  as 'DESCONTO',
      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))                                       as 'SITUACAOTRIB'

    from
      Nota_Entrada ne with (nolock) 

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = ne.cd_operacao_fiscal and
           isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S' and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      gop.cd_tipo_operacao_fiscal = 1
      and
      (isnull(ne.vl_frete_nota_entrada,0) <> 0) 
      and 'S' = ( select isnull(ic_reg_991_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())

    UNION ALL 

    ------------------------ Seguro --------------------------
    select
      cast('Seguro' as varchar(10)) as 'DEBUG',

      ne.dt_receb_nota_entrada as 'RECEBTOSAIDA',

      ne.cd_nota_entrada,
      ne.cd_fornecedor,
      ne.cd_operacao_fiscal,
      ne.cd_serie_nota_fiscal,
      ne.cd_tipo_destinatario,

      ne.sg_estado,
      o.cd_mascara_operacao,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))         as 'UNIDADEMEDIDA',

      cast('' as char(3))         as 'CST',
      cast(992 as float)          as 'ITEM',
      cast(0 as int)			    		as 'CLASSFISCAL',
      cast(0 as float)            as 'QUANTIDADE',
      cast(0 as float)            as 'VALORPRODUTO',
      cast(ne.vl_seguro_nota_entrada as float) as 'DESCONTO',
      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))         as 'SITUACAOTRIB'

    from
      Nota_Entrada ne with (nolock) 

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = ne.cd_operacao_fiscal and
           isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S' and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      gop.cd_tipo_operacao_fiscal = 1
      and
      (isnull(ne.vl_seguro_nota_entrada,0) <> 0) 
      and 'S' = ( select isnull(ic_reg_992_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())

    UNION ALL 

    ------------------------ PIS / COFINS --------------------------
    select
      cast('PIS/COFINS' as varchar(10)) as 'DEBUG',

      ne.dt_receb_nota_entrada as 'RECEBTOSAIDA',

      ne.cd_nota_entrada,
      ne.cd_fornecedor,
      ne.cd_operacao_fiscal,
      ne.cd_serie_nota_fiscal,
      ne.cd_tipo_destinatario,

      ne.sg_estado,
      o.cd_mascara_operacao,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))         as 'UNIDADEMEDIDA',

      cast('' as char(3))         as 'CST',
      cast(993 as float)          as 'ITEM',
      cast(0 as int)			    		as 'CLASSFISCAL',
      cast(0 as float)            as 'QUANTIDADE',
      cast(0 as float)            as 'VALORPRODUTO',

      cast(isnull(ne.vl_pis_nota_entrada,0)
        + isnull(ne.vl_cofins_nota_entrada,0) as float) as 'DESCONTO',

      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))         as 'SITUACAOTRIB'

    from
      Nota_Entrada ne with (nolock) 

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = ne.cd_operacao_fiscal and
           isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S' and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      gop.cd_tipo_operacao_fiscal = 1
      and
      ((isnull(ne.vl_pis_nota_entrada,0) <> 0) or
       (isnull(ne.vl_cofins_nota_entrada,0) <> 0))
      and 'S' = ( select isnull(ic_reg_993_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())

    UNION ALL 

    ------------------------ Complemento --------------------------
    select
      cast('Complem.' as varchar(10)) as 'DEBUG',

      ne.dt_receb_nota_entrada as 'RECEBTOSAIDA',

      ne.cd_nota_entrada,
      ne.cd_fornecedor,
      ne.cd_operacao_fiscal,
      ne.cd_serie_nota_fiscal,
      ne.cd_tipo_destinatario,

      ne.sg_estado,
      o.cd_mascara_operacao,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))         as 'UNIDADEMEDIDA',

      cast('' as char(3))         as 'CST',
      cast(997 as float)          as 'ITEM',
      cast(0 as int)			    		as 'CLASSFISCAL',
      cast(0 as float)            as 'QUANTIDADE',
      cast(0 as float)            as 'VALORPRODUTO',

      cast(isnull(ne.vl_total_nota_entrada,0)
        + isnull(ne.vl_icms_nota_entrada,0) as float) as 'DESCONTO',

      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))         as 'SITUACAOTRIB'

    from
      Nota_Entrada ne with (nolock) 

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = ne.cd_operacao_fiscal and
           isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S' and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      gop.cd_tipo_operacao_fiscal = 1
      and
      (isnull(o.ic_complemento_op_fiscal,'N') = 'S')
      and
      ((isnull(ne.vl_total_nota_entrada,0) <> 0) or (isnull(ne.vl_icms_nota_entrada,0) <> 0))
      and 'S' = ( select isnull(ic_reg_997_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())

    UNION ALL 

    ------------------------ Serviços Não-Tributados --------------------------
    select
      cast('Serviços' as varchar(10)) as 'DEBUG',

      ne.dt_receb_nota_entrada as 'RECEBTOSAIDA',

      ne.cd_nota_entrada,
      ne.cd_fornecedor,
      ne.cd_operacao_fiscal,
      ne.cd_serie_nota_fiscal,
      ne.cd_tipo_destinatario,

      ne.sg_estado,
      o.cd_mascara_operacao,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))         as 'UNIDADEMEDIDA',

      cast('' as char(3))         as 'CST',
      cast(998 as float)          as 'ITEM',
      cast(0 as int)			    		as 'CLASSFISCAL',
      cast(0 as float)            as 'QUANTIDADE',
      cast(0 as float)            as 'VALORPRODUTO',

      cast(ne.vl_servico_nota_entrada as float) as 'DESCONTO',

      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))                                       as 'SITUACAOTRIB'

    from
      Nota_Entrada ne with (nolock) 

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = ne.cd_operacao_fiscal and
           isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S' and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      gop.cd_tipo_operacao_fiscal = 1
      and
      (isnull(ne.vl_servico_nota_entrada,0) <> 0) 

    UNION ALL 

    ------------------------ Despesas Acessórias --------------------------
    select
      cast('Desp.Acces' as varchar(10)) as 'DEBUG',

      ne.dt_receb_nota_entrada          as 'RECEBTOSAIDA',

      ne.cd_nota_entrada,
      ne.cd_fornecedor,
      ne.cd_operacao_fiscal,
      ne.cd_serie_nota_fiscal,
      ne.cd_tipo_destinatario,

      ne.sg_estado,
      o.cd_mascara_operacao,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))         as 'UNIDADEMEDIDA',

      cast('' as char(3))         as 'CST',
      cast(999 as float)          as 'ITEM',
      cast(0 as int)			    		as 'CLASSFISCAL',
      cast(0 as float)            as 'QUANTIDADE',
      cast(0 as float)            as 'VALORPRODUTO',

      cast(ne.vl_despac_nota_entrada as float) as 'DESCONTO',

      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))         as 'SITUACAOTRIB'

    from
      Nota_Entrada ne with (nolock) 

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = ne.cd_operacao_fiscal and
           isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S' and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      gop.cd_tipo_operacao_fiscal = 1
      and
      (isnull(ne.vl_despac_nota_entrada,0) <> 0)
      and 'S' = ( select isnull(ic_reg_999_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())

  ) neri

  inner join Nota_Entrada ne with (nolock) 
    on ne.cd_nota_entrada       = neri.cd_nota_entrada     and
       ne.cd_fornecedor         = neri.cd_fornecedor       and
       ne.cd_operacao_fiscal    = neri.cd_operacao_fiscal  and
       ne.cd_serie_nota_fiscal  = neri.cd_serie_nota_fiscal

  left outer join Serie_Nota_Fiscal s with (nolock) 
    on s.cd_serie_nota_fiscal = neri.cd_serie_nota_fiscal

  left outer join
    vw_Destinatario_Rapida vw  with (nolock) 

  on
    vw.cd_tipo_destinatario = neri.cd_tipo_destinatario and
    vw.cd_destinatario      = neri.cd_fornecedor

  left outer join 
    Estado uf with (nolock) 

  on
    uf.cd_pais   = vw.cd_pais and
    uf.cd_estado = vw.cd_estado

