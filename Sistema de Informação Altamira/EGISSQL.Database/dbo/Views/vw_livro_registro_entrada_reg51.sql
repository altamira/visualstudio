
-- vw_livro_registro_entrada_reg51
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Elias P. Silva
-- Banco de Dados: EgisSql
-- Objetivo: Lista o Livro de Entradas utilizado nos Arquivos Magnéticos
-- Data: 19/03/2004
-- Atualizado: 12/04/04 - Inserido verificação de destinatário = empresa - ELIAS
-- ---------------------------------------------------------------------------------------
-- 
create view vw_livro_registro_entrada_reg51
as

    -- NOTAS FISCAIS DE SAÍDA--------------------------------------------------------------

    select
      cast('E' as char(1))    as 'ENTRADASAIDA',      
      s.ic_tipo_emitente_nota as 'EMITENTE',

      ------------------------------ Dados da Nota Fiscal -------------------------
      neri.RECEBTOSAIDA,
      neri.EMISSAO,
      neri.cd_nota_entrada  as 'NUMERO',
      neri.sg_estado        as 'UF',

      case when isnull(neri.cd_mascara_operacao,'') = ''
           then '0000'
           else dbo.fn_limpa_mascara( neri.cd_mascara_operacao )
      end as 'CFOP',

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
      neri.BCIPI,
      neri.IPI,
      neri.IPIIsento,
      neri.IPIOutras,

      neri.BCICMS,
      neri.ICMS,
      neri.ICMSIsento,
      neri.ICMSOutras

    from

    ----------------------- Sub-Select dos Itens Agrupados ---------------------
    ( select distinct
        r.dt_receb_nota_entrada as 'RECEBTOSAIDA',
        r.dt_Nota_Entrada       as 'EMISSAO',

        r.cd_nota_entrada,
        r.cd_fornecedor,
        r.cd_serie_nota_fiscal,
        ne.cd_tipo_destinatario,

        r.sg_estado,
        o.cd_mascara_operacao,

        sum(isnull(r.vl_cont_reg_nota_entrada,0))	as 'VlrContabil',
        sum(isnull(r.vl_bipi_reg_nota_entrada,0))       as 'BCIPI',
        sum(isnull(r.vl_ipi_reg_nota_entrada,0))        as 'IPI',
        sum(isnull(r.vl_ipiisen_reg_nota_entr,0))       as 'IPIIsento',
        sum(isnull(r.vl_ipioutr_reg_nota_entr,0))       as 'IPIOutras',

        sum(IsNull(r.vl_bicms_reg_nota_entrada,0))      as 'BCICMS',	
        sum(IsNull(r.vl_icms_reg_nota_entrada,0))       as 'ICMS',
        sum(IsNull(r.vl_icmsisen_reg_nota_entr,0))      as 'ICMSIsento',
        sum(IsNull(r.vl_icmsoutr_reg_nota_entr,0))      as 'ICMSOutras'

      from
        Nota_Entrada_Item_Registro r

       inner join Nota_Entrada ne
         on ne.cd_nota_entrada      = r.cd_nota_entrada and
            ne.cd_fornecedor        = r.cd_fornecedor and
            ne.cd_operacao_fiscal   = r.cd_operacao_fiscal and
            ne.cd_serie_nota_fiscal = r.cd_serie_nota_fiscal

       inner join Operacao_Fiscal o
         on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
            IsNull(o.ic_servico_operacao,'N') <> 'S'
 
       inner join Grupo_Operacao_Fiscal gop
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
        o.cd_mascara_operacao
    ) neri

    left outer join Serie_Nota_Fiscal s
      on s.cd_serie_nota_fiscal = neri.cd_serie_nota_fiscal

    left outer join
      vw_Destinatario_Rapida vw

    on
      vw.cd_tipo_destinatario = neri.cd_tipo_destinatario and
      vw.cd_destinatario = neri.cd_fornecedor

    left outer join
      Estado uf
    on
      uf.cd_pais   = vw.cd_pais and
      uf.cd_estado = vw.cd_estado

    left outer join
      Egisadmin.dbo.Empresa e
    on
      e.cd_empresa = dbo.fn_empresa()

