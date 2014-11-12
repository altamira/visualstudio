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
-- 08.11.2009 - não permitir nota de saída igual a nota de entrada - Carlos Fernandes
-- 10.11.2009 - Foi colocado o Código do produto - Carlos Fernandes\
-- 24.03.2010 - Movimento de Caixa - Carlos Fernandes
------------------------------------------------------------------------------------------

create view vw_produto_saida_caixa
as

--select * from movimento_caixa

  select

--    nsri.cd_produto,
    'MC' as DEBUG,
    cast('S' as char(1))        as 'ENTRADASAIDA',      

    ------------------------------ Dados da Nota Fiscal -------------------------
    nsri.RECEBTOSAIDA,
    nsri.NUMERO       as 'NUMERO',

    nsri.cd_cliente,
    nsri.cd_tipo_destinatario,

    uf.sg_estado                        as 'UF',

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

--      nsi.cd_produto                 as 'cd_produto',
      r.cd_movimento_caixa           as 'NUMERO',
      r.dt_movimento_caixa           as 'RECEBTOSAIDA',
      r.cd_movimento_caixa,
      1                              as cd_serie_nota,
      ''                             as sg_estado,
      1 as cd_tipo_destinatario,
      r.cd_cliente,

      isnull(nsi.cd_produto,0)       as cd_produto,

      case when IsNull(p.cd_mascara_produto,'') = '' or isnull(nsi.cd_produto,0)=0
           then '999999999'
           else p.cd_mascara_produto
      end                            as 'PRODUTO',

      case when IsNull(p.cd_mascara_produto,'') = '' or isnull(nsi.cd_produto,0)=0
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

      cast(replace(isnull('000','000'),' ','0') as char(3)) as 'CST',
      cast(nsi.cd_item_movimento_caixa as numeric(3))                           as 'ITEM',
      cast(pf.cd_classificacao_fiscal as int)                                   as 'CLASSFISCAL',

--select * from movimento_caixa_item

--       case when nsi.cd_classificacao_fiscal<>pf.cd_classificacao_fiscal then
--         cast(pf.cd_classificacao_fiscal as int)
--       else
--         cast(nsi.cd_classificacao_fiscal as int) 
--       end                 as 'CLASSFISCAL',

      cast(IsNull(nsi.qt_item_movimento_caixa,0) as float)           as 'QUANTIDADE',

      cast((IsNull(nsi.qt_item_movimento_caixa,0)
        * IsNull(nsi.vl_produto,0))as float)         as 'VALORPRODUTO',

      cast(((IsNull(nsi.qt_item_movimento_caixa,0)
        * IsNull(nsi.vl_produto,0)
        * IsNull(nsi.pc_desc_movimento_caixa,0))/100)as float)         as 'DESCONTO',

      nsi.vl_total_item                                         as 'BCICMS',	

      '0'                                                       as 'BCTRIBUTARIA',

      cast(IsNUll(0.00,0)  as float)                      as 'IPI',

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
        cast(isnull(0,0)  as float) 
      end                                                        as 'ALIQIPI',

      --cast(isnull(nsi.pc_reducao_icms,0) as float)              as 'REDICMS',
      cast(0.00 as float)                                          as 'REDICMS',
      cast(isnull(0.00,0) as float)        as 'BCICMSSUBST',
      '000'                                                        as 'SITUACAOTRIB',
      '5102'                                                       as 'CFOP',
      isnull('N','N')                            as 'ic_subst_tributaria'
   
    from
      Movimento_caixa r                            with (nolock) 
    
      inner join Movimento_Caixa_Item nsi          with (nolock) 
        on nsi.cd_movimento_caixa = r.cd_movimento_caixa

      left outer join Produto p          with (nolock) on p.cd_produto          = nsi.cd_produto
      left outer join Produto_Fiscal pf  with (nolock) on pf.cd_produto         = nsi.cd_produto
      left outer join Unidade_Medida u   with (nolock) on u.cd_unidade_medida   = p.cd_unidade_medida
      left outer join Unidade_Medida ume with (nolock) on ume.cd_unidade_medida = nsi.cd_unidade_medida

 
    where
      r.dt_cancel_movimento_caixa is null  --Nota Cancelada Não Entrada no Arquivo


--select * from tipo_operacao_fiscal


  ) nsri

  left outer join Serie_Nota_Fiscal s with (nolock) 
    on s.cd_serie_nota_fiscal = 1

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
      Egisadmin.dbo.Empresa e
    on
      e.cd_empresa = dbo.fn_empresa()

