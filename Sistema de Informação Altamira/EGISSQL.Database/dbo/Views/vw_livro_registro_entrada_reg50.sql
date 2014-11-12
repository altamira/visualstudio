
------------------------------------------------------------------------------------------
-- vw_livro_registro_entrada_reg50
------------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es)      : Elias P. Silva
-- Banco de Dados : EgisSql
-- Objetivo       : Lista o Livro de Entradas utilizado nos Arquivos Magnéticos
-- Data           : 19/03/2004
-- Atualizado     : 12/04/04 - Inserido verificação de destinatário = empresa - ELIAS
-- 02.02.2008 - Verificação por Quebra de Alíquota - Carlos Fernandes
-- 25.03.2008 - Ajustes Gerais - Carlos Fernandes - Carlos Fernandes
-- 22.10.2009 - Ajuste Subs. Tributária - Carlos Fernandes
-- 11.11.2009 - Modificações do Livro pelo manutenção fiscal - Carlos Fernandes
-- 19.03.2010 - Icms Subst. Tributária - Carlos Fernandes
------------------------------------------------------------------------------------------
-- 

create view vw_livro_registro_entrada_reg50
as

    -- NOTAS FISCAIS DE ENTRADA

    select

      cast('E' as char(1))                         as 'ENTRADASAIDA',      
      isnull(s.ic_tipo_emitente_nota,'P')          as 'EMITENTE',

      ------------------------------ Dados da Nota Fiscal -------------------------

      neri.RECEBTOSAIDA,
      neri.EMISSAO,
      neri.cd_nota_entrada                          as 'NUMERO',
      neri.sg_estado                                as 'UF',

      case when isnull(neri.cd_mascara_operacao,'') = ''
           then '0000'
           else dbo.fn_limpa_mascara( neri.cd_mascara_operacao )
      end                                           as 'CFOP',

      cast(s.nm_especie_livro_saida as varchar(20)) as 'ESPECIE', 

      IsNull(s.sg_serie_nota_fiscal,'1')            as 'SERIE',

      IsNull(s.cd_modelo_serie_nota,'01')           as 'MODELO',

      cast('N' as char(1))                          as 'Situacao',

      ------------------------------ Dados do Destinatário -------------------------

      case when (uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa) or (vw.cd_cnpj is null)
           then '00000000000000'
           else vw.cd_cnpj
      end as 'CNPJ',

      case when (uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa)
           then 'ISENTO'
           else case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
                          ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
                     then 'ISENTO'
                     else isnull(vw.cd_inscestadual,'00000000000000')
                end

      end as 'IE',

      ------------------------------ Somatório dos Itens -------------------------

      neri.VlrContabil,
      neri.AliqICMS,
      neri.pc_icms_nfe,
      neri.pc_icms_reg,
      neri.BCICMS,
      neri.ICMS,
      neri.ICMSIsento,
      neri.ICMSOutras,
      neri.BCICMSST,
      neri.ICMSST

    from

    ----------------------- Sub-Select dos Itens Agrupados ---------------------

    ( select distinct
        r.dt_receb_nota_entrada                     as 'RECEBTOSAIDA',
        r.dt_Nota_Entrada                           as 'EMISSAO',

        r.cd_nota_entrada,
        r.cd_fornecedor,
        r.cd_serie_nota_fiscal,
        ne.cd_tipo_destinatario,
        r.sg_estado,
        o.cd_mascara_operacao,
        isnull(ine.pc_icms_nota_entrada,0)                 as pc_icms_nfe,
        isnull(r.pc_icms_reg_nota_entrada,0)               as pc_icms_reg,

        --Item da Nota
        --round(isnull(ine.pc_icms_nota_entrada,0),2)      as 'AliqICMS',

        --Livro de Entrada
        round(case when r.pc_icms_reg_nota_entrada is not null then
           isnull(r.pc_icms_reg_nota_entrada,0)
        else
           isnull(ine.pc_icms_nota_entrada,0)
        end,2)                                           as 'AliqICMS',


        --Antes
--        isnull(ine.pc_icms_nota_entrada,0)          as 'AliqICMS',

--         sum(isnull(r.vl_cont_reg_nota_entrada,0))   as 'VlrContabil',
--         sum(IsNull(r.vl_bicms_reg_nota_entrada,0))  as 'BCICMS',	
--         sum(IsNull(r.vl_icms_reg_nota_entrada,0))   as 'ICMS',
--         sum(IsNull(r.vl_icmsisen_reg_nota_entr,0))  as 'ICMSIsento',
--         sum(IsNull(r.vl_icmsoutr_reg_nota_entr,0))  as 'ICMSOutras'

         --Ajustado Carlos - 25.03.2008
--        isnull(ine.pc_icms_nota_entrada,0)          as 'AliqICMS',

        sum(isnull(r.vl_cont_reg_nota_entrada,0))   as 'VlrContabil',

--Nota Fiscal
--        sum(IsNull(ine.vl_bicms_nota_entrada,0))    as 'BCICMS',	
--        sum(IsNull(ine.vl_icms_nota_entrada,0))     as 'ICMS',

--Livro de Entrada

        sum(IsNull(r.vl_bicms_reg_nota_entrada,0))  as 'BCICMS',	
        sum(IsNull(r.vl_icms_reg_nota_entrada,0))   as 'ICMS',
        sum(IsNull(r.vl_icmsisen_reg_nota_entr,0))  as 'ICMSIsento',
        sum(IsNull(r.vl_icmsoutr_reg_nota_entr,0))  as 'ICMSOutras',
        sum(IsNull(ine.vl_bc_subst_icms_item,0))    as 'BCICMSST',
        sum(Isnull(ine.vl_icms_subst_icms_item,0))  as 'ICMSST'


        --Oficial

--         sum(isnull(r.vl_cont_reg_nota_entrada,0))     as 'VlrContabil',
--         sum(IsNull(r.vl_bicms_reg_nota_entrada,0))    as 'BCICMS',	
--         sum(IsNull(r.vl_icms_reg_nota_entrada,0))     as 'ICMS',
--         sum(IsNull(r.vl_icmsisen_reg_nota_entr,0))    as 'ICMSIsento',
--         sum(IsNull(r.vl_icmsoutr_reg_nota_entr,0))    as 'ICMSOutras'

--select * from nota_entrada_item_registro

      from
        Nota_Entrada_Item_Registro r with (nolock) 

       inner join Nota_Entrada ne    with (nolock) 
         on ne.cd_nota_entrada      = r.cd_nota_entrada and
            ne.cd_fornecedor        = r.cd_fornecedor and
            ne.cd_operacao_fiscal   = r.cd_operacao_fiscal and
            ne.cd_serie_nota_fiscal = r.cd_serie_nota_fiscal

--select * from nota_entrada_item

       left outer join Nota_Entrada_Item ine    with (nolock) 
         on ine.cd_nota_entrada      = r.cd_nota_entrada      and
            ine.cd_fornecedor        = r.cd_fornecedor        and
            ine.cd_operacao_fiscal   = r.cd_operacao_fiscal   and
            ine.cd_serie_nota_fiscal = r.cd_serie_nota_fiscal --and
            --ine.pc_icms_nota_entrada = r.pc_icms_reg_nota_entrada        
            and ine.cd_item_nota_entrada = r.cd_item_nota_entrada 

       inner join Operacao_Fiscal o  with (nolock) 
         on o.cd_operacao_fiscal = r.cd_operacao_fiscal
            and IsNull(o.ic_servico_operacao,'N') <> 'S'
 
       inner join Grupo_Operacao_Fiscal gop with (nolock) 
         on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

      where
        gop.cd_tipo_operacao_fiscal = 1
        and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

      group by
        r.dt_receb_nota_entrada,
        r.dt_Nota_Entrada,
        r.cd_nota_entrada,
        r.cd_fornecedor,
        r.cd_serie_nota_fiscal,
        ne.cd_tipo_destinatario,
        r.sg_estado,
        o.cd_mascara_operacao,
        ine.pc_icms_nota_entrada,
        r.pc_icms_reg_nota_entrada

--         round(isnull(case when r.pc_icms_reg_nota_entrada is not null 
--                      then r.pc_icms_reg_nota_entrada 
--                      else ine.pc_icms_nota_entrada end ,0),2)
 
        --round(isnull(ine.pc_icms_nota_entrada,0),2)

    ) neri

    left outer join Serie_Nota_Fiscal s               with (nolock) on s.cd_serie_nota_fiscal = neri.cd_serie_nota_fiscal

    left outer join vw_Destinatario_Rapida vw         with (nolock) 

    on
      vw.cd_tipo_destinatario = neri.cd_tipo_destinatario and
      vw.cd_destinatario      = neri.cd_fornecedor

    left outer join
      Estado uf                         with (nolock) 
    on
      uf.cd_pais   = vw.cd_pais and
      uf.cd_estado = vw.cd_estado

    left outer join
      Egisadmin.dbo.Empresa e           with (nolock) 
    on
      e.cd_empresa = dbo.fn_empresa()

