------------------------------------------------------------------------------------------
-- vw_produto_saida
------------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Alexandre Del Soldato
-- Banco de Dados: EgisSql
-- Objetivo: Lista o Item do Livro de Saídas utilizado nos Arquivos Magnéticos
-- Data: 22/03/2004
-- Atualizado : 30/03/2004 - Reformulação das Selects visando melhoria na performance - Eduardo.
-- 20.06.2007 : Notas Canceladas - Carlos Fernades
-- Atualizado     : 23.06.2009 - Ajustes Diversos - Carlos Fernandes
-- 24.06.2009 - Entrada de Importação - Carlos Fernandes
-- 08.11.2009 - Consistência de Nota saída e entrada - Carlos
-- 10.11.2009 - Ajuste do Código do Produto - Carlos Fernandes
------------------------------------------------------------------------------------------

create view vw_produto_saida_entrada
as

--select * from status_nota
--select * from nota_saida

  select
    nsri.DEBUG,
    cast('S' as char(1))        as 'ENTRADASAIDA',      

    ------------------------------ Dados da Nota Fiscal -------------------------
    nsri.RECEBTOSAIDA,
    nsri.cd_nota_saida          as 'NUMERO',

    nsri.cd_cliente,
    nsri.cd_tipo_destinatario,

    nsri.sg_estado_nota_saida   as 'UF',

--     case when isnull(nsri.cd_mascara_operacao,'') = ''
--          then '0000'
--          else dbo.fn_limpa_mascara( nsri.cd_mascara_operacao )
--     end as 'CFOP',

    IsNull(s.sg_serie_nota_fiscal,'1')  as 'SERIE',

    IsNull(s.cd_modelo_serie_nota,'01') as 'MODELO',

    ------------------------------ Dados do Destinatário -------------------------

    case when (uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa) or  (vw.cd_cnpj is null)
         then '00000000000000'
         else vw.cd_cnpj
    end                                 as 'CNPJ',

    case when (uf.sg_estado = 'EX')
         then 'ISENTO'
         else case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
                        ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
                   then 'ISENTO'
                   else isnull(vw.cd_inscestadual,'00000000000000')
              end
    end                                as 'IE',

    ------------------------------ Dados dos Itens -------------------------

    nsri.cd_produto,
    nsri.PRODUTO,
    nsri.DESCRICAO,
    nsri.UNIDADEMEDIDA,
    nsri.CST,
    nsri.ITEM,
    nsri.CLASSFISCAL,
    nsri.QUANTIDADE,
    nsri.VALORPRODUTO,
    nsri.DESCONTO,

    case when isnull(nsri.ic_subst_tributaria,'N')='N' 
    then
      nsri.BCICMS
    else
      case when isnull(nsri.ALIQICMS,0)>0 
      then
         nsri.VALORPRODUTO
      else
         0.00
      end
      
    end as BCICMS,
    nsri.BCTRIBUTARIA,
    nsri.IPI,
    nsri.ALIQICMS,
    nsri.ALIQIPI,
    nsri.REDICMS,
    nsri.BCICMSSUBST,
    nsri.SITUACAOTRIB,
    nsri.CFOP,
    nsri.ic_subst_tributaria
    
  from

    ------------------------ Produtos --------------------------

  ( select 
      cast('Produto' as varchar(10)) as 'DEBUG',

      r.dt_nota_saida                as 'RECEBTOSAIDA',
      r.cd_nota_saida,
      r.cd_serie_nota,
      r.sg_estado_nota_saida,
      o.cd_mascara_operacao,
      r.cd_tipo_destinatario,
      r.cd_cliente,

      isnull(nsi.cd_produto,0)      as cd_produto,

      case when IsNull(nsi.cd_mascara_produto,'') = '' or isnull(nsi.cd_produto,0)=0
           then '999999999'
           else nsi.cd_mascara_produto
      end                            as 'PRODUTO',

      case when IsNull(nsi.cd_mascara_produto,'') = '' or isnull(nsi.cd_produto,0)=0
           then 'PRODUTO ESPECIAL'
           else --nsi.nm_produto_item_nota
                p.nm_produto
      end                            as 'DESCRICAO',

      case when IsNull(nsi.cd_produto,0) = 0
           then 
                isnull( ume.sg_unidade_medida, 'PC' )
           else 
                isnull( u.sg_unidade_medida, 'PC' )
      end                            as 'UNIDADEMEDIDA',

      cast(replace(isnull(nsi.cd_situacao_tributaria,'000'),' ','0') as char(3)) as 'CST',
      cast(nsi.cd_item_nota_saida as numeric(3))                                 as 'ITEM',
      cast(nsi.cd_classificacao_fiscal as int)                                   as 'CLASSFISCAL',

--       case when nsi.cd_classificacao_fiscal<>pf.cd_classificacao_fiscal then
--         cast(pf.cd_classificacao_fiscal as int)
--       else
--         cast(nsi.cd_classificacao_fiscal as int) 
--       end                 as 'CLASSFISCAL',

      cast(IsNull(nsi.qt_item_nota_saida,0) as float)           as 'QUANTIDADE',

      cast((IsNull(nsi.qt_item_nota_saida,0)
        * IsNull(nsi.vl_unitario_item_nota,0))as float)         as 'VALORPRODUTO',

      cast(((IsNull(nsi.qt_item_nota_saida,0)
        * IsNull(nsi.vl_unitario_item_nota,0)
        * IsNull(nsi.pc_desconto_item,0))/100)as float)         as 'DESCONTO',

      case when isnull(o.ic_subst_tributaria,'N')='N' --and isnull(o.ic_importacao_op_fiscal,'N')<>'S'
      then
         cast((IsNull(nsi.vl_base_icms_item,0)) as float)
      else
       --case when isnull(o.ic_importacao_op_fiscal,'N')='S' then
       --   nir.vl_base_icms_item_nota
       --else
         case when isnull(nsi.pc_icms,0)>0 
         then
           cast((IsNull(nsi.qt_item_nota_saida,0) * IsNull(nsi.vl_unitario_item_nota,0))as float)         
         else
           0.00
         end
        --end
      end                                                       as 'BCICMS',	


      '0'                                                       as 'BCTRIBUTARIA',

      cast(IsNUll(nsi.vl_ipi,0)  as float)                      as 'IPI',

      case when isnull(nsi.vl_total_item,0)=0
      then
        0.00
      else
        cast(isnull(nsi.pc_icms,0) as float)  
      end                                                       as 'ALIQICMS',

--       case when isnull(o.ic_complemento_op_fiscal,'N')='N'
--       then      
--         cast(isnull(nsi.pc_icms,0) as float)  
--       else
--         cast(isnull(nir.pc_icms_item_nota_saida,0) as float )
--       end         
--                                                                 as 'ALIQICMS',

      case when isnull(nsi.vl_total_item,0)=0
      then
        0.00
      else
        cast(isnull(nsi.pc_ipi,0)  as float) 
      end                                                        as 'ALIQIPI',

--select * from nota_saida_item_registro
--select * from nota_saida_item
--select * from operacao_fiscal 

--      cast(0 as float)                                          as 'ALIQICMS',
--      cast(0 as float)						as 'ALIQIPI',
      --Verificar 
      --cast(isnull(nsi.pc_reducao_icms,0) as float)              as 'REDICMS',
      cast(0 as float)                                          as 'REDICMS',
      cast(isnull(nsi.vl_bc_subst_icms_item,0) as float)        as 'BCICMSSUBST',
      nsi.cd_situacao_tributaria                                as 'SITUACAOTRIB',

      case when isnull(o.cd_mascara_operacao,'') = ''
           then '0000'
           else dbo.fn_limpa_mascara( o.cd_mascara_operacao )
      end as 'CFOP',
      isnull(o.ic_subst_tributaria,'N')                         as ic_subst_tributaria
   
    from
      Nota_Saida r                            with (nolock) 
    
      inner join Nota_Saida_Item nsi          with (nolock) 
        on nsi.cd_nota_saida = r.cd_nota_saida

      inner join Nota_Saida_Item_Registro nir with (nolock) 
         on nir.cd_nota_saida      = nsi.cd_nota_saida and
            nir.cd_item_nota_saida = nsi.cd_item_nota_saida
    
      inner join Operacao_Fiscal o            with (nolock) 
        on o.cd_operacao_fiscal = nsi.cd_operacao_fiscal and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop    with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal
  
      left outer join Produto p          with (nolock) on p.cd_produto          = nsi.cd_produto
      left outer join Produto_Fiscal pf  with (nolock) on pf.cd_produto         = nsi.cd_produto
      left outer join Unidade_Medida u   with (nolock) on u.cd_unidade_medida   = p.cd_unidade_medida
      left outer join Unidade_Medida ume with (nolock) on ume.cd_unidade_medida = nsi.cd_unidade_medida

--select * from operacao_fiscal
  
    where
      r.cd_status_nota <> 7             and --Nota Cancelada Não Entrada no Arquivo
      gop.cd_tipo_operacao_fiscal = 1   and --Entrada no Faturamento/Importação
      nsi.ic_tipo_nota_saida_item = 'P' and
      r.cd_nota_saida not in ( select vwi.cd_nota_saida from vw_identificacao_nota_saida_entrada vwi
                               where
                                 r.cd_cliente = vwi.cd_cliente                 and
                                 r.cd_operacao_fiscal = vwi.cd_operacao_fiscal and
                                 r.cd_serie_nota      = vwi.cd_serie_nota           )   

      and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

    UNION ALL 

    ------------------------ Frete --------------------------

    select
      cast('Frete' as varchar(10)) as 'DEBUG',

      r.dt_nota_saida              as 'RECEBTOSAIDA',
      r.cd_nota_saida,
      r.cd_serie_nota,
      r.sg_estado_nota_saida,
      o.cd_mascara_operacao,
      r.cd_tipo_destinatario,
      r.cd_cliente,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))         as 'UNIDADEMEDIDA',

      cast('' as char(3))         as 'CST',
      cast(991 as float)          as 'ITEM',
      cast(0 as int)	          as 'CLASSFISCAL',
      cast(0 as float)            as 'QUANTIDADE',
      cast(0 as float)            as 'VALORPRODUTO',
      cast(ns.vl_frete as float)  as 'DESCONTO',
      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))                                       as 'SITUACAOTRIB',
      --cast('' as char(4))                                       as 'CFOP'
      dbo.fn_limpa_mascara( r.cd_mascara_operacao )             as 'CFOP',
      isnull(o.ic_subst_tributaria,'N')                         as ic_subst_tributaria

    from
      Nota_Saida r              with (nolock) 
    
      inner join Nota_Saida ns  with (nolock) 
        on ns.cd_nota_saida = r.cd_nota_saida

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      ns.cd_status_nota <> 7        and --Nota Cancelada Não Entrada no Arquivo
      gop.cd_tipo_operacao_fiscal = 1   --Entrada no Faturamento/Importação
      and
      (isnull(ns.vl_frete,0) <> 0) 
      and 'S' = ( select isnull(ic_reg_991_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())
      and ns.cd_nota_saida in ( select cd_nota_saida from nota_saida_registro )
      and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

    UNION ALL 

    ------------------------ Seguro --------------------------

    select
      cast('Seguro' as varchar(10)) as 'DEBUG',

      r.dt_nota_saida               as 'RECEBTOSAIDA',
      r.cd_nota_saida,
      r.cd_serie_nota,
      r.sg_estado_nota_saida,
      o.cd_mascara_operacao,
      r.cd_tipo_destinatario,
      r.cd_cliente,

      0                             as cd_produto,
      cast('' as varchar(14))       as 'PRODUTO',
      cast('' as varchar(50))       as 'DESCRICAO',
      cast('' as char(6))           as 'UNIDADEMEDIDA',

      cast('' as char(3))           as 'CST',
      cast(992 as float)            as 'ITEM',
      cast(0 as int)			    		as 'CLASSFISCAL',
      cast(0 as float)              as 'QUANTIDADE',
      cast(0 as float)              as 'VALORPRODUTO',
      cast(ns.vl_seguro as float)   as 'DESCONTO',
      cast(0 as float)              as 'BCICMS',	
      '0'                           as 'BCTRIBUTARIA',
      cast(0 as float)              as 'IPI',
      cast(0 as float)              as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))         as 'SITUACAOTRIB',
      --cast('' as char(4))                                       as 'CFOP'
      dbo.fn_limpa_mascara( r.cd_mascara_operacao )             as 'CFOP',
      isnull(o.ic_subst_tributaria,'N')                         as ic_subst_tributaria

    from
      Nota_Saida r                with (nolock) 
    
      inner join Nota_Saida ns    with (nolock) 
        on ns.cd_nota_saida = r.cd_nota_saida

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      ns.cd_status_nota <> 7        and  --Nota Cancelada Não Entrada no Arquivo
      gop.cd_tipo_operacao_fiscal = 1 --Entrada no Faturamento/Importação
      and
      (isnull(ns.vl_seguro,0) <> 0) 
      and 'S' = ( select isnull(ic_reg_992_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())
      and ns.cd_nota_saida in ( select cd_nota_saida from nota_saida_registro )
      and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

    UNION ALL 

    ------------------------ PIS / COFINS --------------------------

    select
      cast('PIS/COFINS' as varchar(10)) as 'DEBUG',

      r.dt_nota_saida             as 'RECEBTOSAIDA',
      r.cd_nota_saida,
      r.cd_serie_nota,
      r.sg_estado_nota_saida,
      o.cd_mascara_operacao,
      r.cd_tipo_destinatario,
      r.cd_cliente,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))                                         as 'UNIDADEMEDIDA',

      cast('' as char(3))                                         as 'CST',
      cast(993 as float)                                          as 'ITEM',
      cast(0 as int)                                              as 'CLASSFISCAL',
      cast(0 as float)                                            as 'QUANTIDADE',
      cast(0 as float)                                            as 'VALORPRODUTO',

      cast(isnull(ns.vl_pis,0) + isnull(ns.vl_cofins,0) as float) as 'DESCONTO',

      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))                                         as 'SITUACAOTRIB',
--      cast('' as char(4))                                       as 'CFOP'
      dbo.fn_limpa_mascara( r.cd_mascara_operacao )             as 'CFOP',
      isnull(o.ic_subst_tributaria,'N')                         as ic_subst_tributaria

    from
      Nota_Saida r                 with (nolock) 
    
      inner join Nota_Saida ns     with (nolock) 
        on ns.cd_nota_saida = r.cd_nota_saida

      inner join Operacao_Fiscal o with (nolock) 
        on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      ns.cd_status_nota <> 7        and --Nota Cancelada Não Entrada no Arquivo
      gop.cd_tipo_operacao_fiscal = 1   --Entrada no Faturamento/Importação 
      and
      ((isnull(ns.vl_pis,0) <> 0) or (isnull(ns.vl_cofins,0) <> 0))
      and 'S' = ( select isnull(ic_reg_993_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())
      and ns.cd_nota_saida in ( select cd_nota_saida from nota_saida_registro )
      and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

    UNION ALL 

    ------------------------ Complemento --------------------------

    select
      cast('Complem.' as varchar(10)) as 'DEBUG',

      r.dt_nota_saida                 as 'RECEBTOSAIDA',
      r.cd_nota_saida,
      r.cd_serie_nota,
      r.sg_estado_nota_saida,
      o.cd_mascara_operacao,
      r.cd_tipo_destinatario,
      r.cd_cliente,

      0                               as cd_produto,
      cast('' as varchar(14))         as 'PRODUTO',
      cast('' as varchar(50))         as 'DESCRICAO',
      cast('' as char(6))             as 'UNIDADEMEDIDA',

      cast('' as char(3))             as 'CST',
      cast(997 as float)              as 'ITEM',
      cast(0 as int)	              as 'CLASSFISCAL',
      cast(0 as float)                as 'QUANTIDADE',
      cast(0 as float)                as 'VALORPRODUTO',

      cast(isnull(ns.vl_total,0) + isnull(ns.vl_icms,0) as float) as 'DESCONTO',

      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))         as 'SITUACAOTRIB',
--      cast('' as char(4))                                       as 'CFOP'
      dbo.fn_limpa_mascara( r.cd_mascara_operacao )             as 'CFOP',
      isnull(o.ic_subst_tributaria,'N')                         as ic_subst_tributaria

    from
      Nota_Saida r                         with (nolock) 
    
      inner join Nota_Saida ns             with (nolock) 
        on ns.cd_nota_saida = r.cd_nota_saida

      inner join Operacao_Fiscal o         with (nolock) 
        on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      ns.cd_status_nota <> 7        and --Nota Cancelada Não Entrada no Arquivo
      gop.cd_tipo_operacao_fiscal = 1   --Entrada no Faturamento/Importação
      and
      (isnull(o.ic_complemento_op_fiscal,'N') = 'S')
      and
      ((isnull(ns.vl_total,0) <> 0) or (isnull(ns.vl_icms,0) <> 0))
      and 'S' = ( select isnull(ic_reg_997_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())
      and ns.cd_nota_saida in ( select cd_nota_saida from nota_saida_registro )
      and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

    UNION ALL 

    ------------------------ Serviços Não-Tributados --------------------------

    select
      cast('Serviços' as varchar(10)) as 'DEBUG',

      r.dt_nota_saida                 as 'RECEBTOSAIDA',
      r.cd_nota_saida,
      r.cd_serie_nota,
      r.sg_estado_nota_saida,
      o.cd_mascara_operacao,
      r.cd_tipo_destinatario,
      r.cd_cliente,

      0                               as cd_produto,
      cast('' as varchar(14))         as 'PRODUTO',
      cast('' as varchar(50))         as 'DESCRICAO',
      cast('' as char(6))             as 'UNIDADEMEDIDA',

      cast('' as char(3))             as 'CST',
      cast(998 as float)              as 'ITEM',
      cast(0 as int)			    		as 'CLASSFISCAL',
      cast(0 as float)                as 'QUANTIDADE',
      cast(0 as float)                as 'VALORPRODUTO',

      cast(ns.vl_servico as float)    as 'DESCONTO',

      cast(0 as float)                as 'BCICMS',	
      '0'                             as 'BCTRIBUTARIA',
      cast(0 as float)                as 'IPI',
      cast(0 as float)                as 'ALIQICMS',
      cast(0 as float)						as 'ALIQIPI',
      cast(0 as float)						as 'REDICMS',
      cast(0 as float)						as 'BCICMSSUBST',
      cast('' as char(3))             as 'SITUACAOTRIB',
--      cast('' as char(4))                                       as 'CFOP'
     dbo.fn_limpa_mascara( r.cd_mascara_operacao )             as 'CFOP',
      isnull(o.ic_subst_tributaria,'N')                         as ic_subst_tributaria

    from
      Nota_Saida r                         with (nolock) 
    
      inner join Nota_Saida ns             with (nolock) 
        on ns.cd_nota_saida = r.cd_nota_saida

      inner join Operacao_Fiscal o         with (nolock) 
        on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      ns.cd_status_nota <> 7        and --Nota Cancelada Não Entrada no Arquivo
      gop.cd_tipo_operacao_fiscal = 1   --Entrada no Faturamento/Importação
      and
      (isnull(ns.vl_servico,0) <> 0) 
      and ns.cd_nota_saida in ( select cd_nota_saida from nota_saida_registro )
      and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'


    UNION ALL 

    ------------------------ Despesas Acessórias --------------------------

    select
      cast('Desp.Acces' as varchar(10)) as 'DEBUG',

      r.dt_nota_saida  as 'RECEBTOSAIDA',
      r.cd_nota_saida,
      r.cd_serie_nota,
      r.sg_estado_nota_saida,
      o.cd_mascara_operacao,
      r.cd_tipo_destinatario,
      r.cd_cliente,

      0                           as cd_produto,
      cast('' as varchar(14))     as 'PRODUTO',
      cast('' as varchar(50))     as 'DESCRICAO',
      cast('' as char(6))         as 'UNIDADEMEDIDA',

      cast('' as char(3))         as 'CST',
      cast(999 as float)          as 'ITEM',
      cast(0 as int)			    		as 'CLASSFISCAL',
      cast(0 as float)            as 'QUANTIDADE',
      cast(0 as float)            as 'VALORPRODUTO',

      cast(isnull(ns.vl_desp_acess,0) as float) as 'DESCONTO',

      cast(0 as float)            as 'BCICMS',	
      '0'                         as 'BCTRIBUTARIA',
      cast(0 as float)            as 'IPI',
      cast(0 as float)            as 'ALIQICMS',
      cast(0 as float)	          as 'ALIQIPI',
      cast(0 as float)		  as 'REDICMS',
      cast(0 as float)		  as 'BCICMSSUBST',
      cast('' as char(3))         as 'SITUACAOTRIB',
--      cast('' as char(4))                                       as 'CFOP'
      dbo.fn_limpa_mascara( r.cd_mascara_operacao )             as 'CFOP',
      isnull(o.ic_subst_tributaria,'N')                         as ic_subst_tributaria

    from
      Nota_Saida r                  with (nolock) 
    
      inner join Nota_Saida ns      with (nolock) 
        on ns.cd_nota_saida = r.cd_nota_saida

      inner join Operacao_Fiscal o  with (nolock) 
        on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
           IsNull(o.ic_servico_operacao,'N') <> 'S'
    
      inner join Grupo_Operacao_Fiscal gop with (nolock) 
        on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    where
      ns.cd_status_nota <> 7        and --Nota Cancelada Não Entrada no Arquivo
      gop.cd_tipo_operacao_fiscal = 1   --Entrada no Faturamento/Importação
      and
      (isnull(ns.vl_desp_acess,0) <> 0)
      and 'S' = ( select isnull(ic_reg_999_geracao,'S') from parametro_magnetico where cd_empresa = dbo.fn_empresa())
--      and ns.cd_nota_saida in ( select cd_nota_saida from nota_saida_registro )
      and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

  ) nsri

  left outer join Serie_Nota_Fiscal s with (nolock) 
    on s.cd_serie_nota_fiscal = nsri.cd_serie_nota

  left outer join
    vw_Destinatario_Rapida vw         with (nolock) 
  on
    vw.cd_tipo_destinatario = nsri.cd_tipo_destinatario and
    vw.cd_destinatario      = nsri.cd_cliente

  left outer join
    Estado uf                         with (nolock) 

  on
    uf.cd_pais   = vw.cd_pais and
    uf.cd_estado = vw.cd_estado

  left outer join
      Egisadmin.dbo.Empresa e        with (nolock) 
    on
      e.cd_empresa = dbo.fn_empresa()

