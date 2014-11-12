-- 
-- vw_livro_registro_saida_reg51
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Elias P. Silva
-- Banco de Dados: EgisSql
-- Objetivo: Lista o Livro de Saídas utilizado nos Arquivos Magnéticos
-- Data: 19/03/2004
-- Atualizado: 12/04/04 - Inserido verificação de destinatário = empresa - ELIAS
-- 18.06.2009 - Nota de Importação de Entrada no Faturamento - Carlos Fernandes
-- ---------------------------------------------------------------------------------------
-- 
create view vw_livro_registro_saida_reg51_entrada
as

    -- NOTAS FISCAIS DE SAÍDA
    select
      distinct
      cast('S' as char(1))  as 'ENTRADASAIDA',      
      s.ic_tipo_emitente_nota as 'EMITENTE',

      ------------------------------ Dados da Nota Fiscal -------------------------
      nsri.RECEBTOSAIDA,
      nsri.EMISSAO,
      nsri.cd_nota_saida	  as 'NUMERO',
      nsri.sg_estado        as 'UF',

      case when isnull(nsri.cd_mascara_operacao,'') = ''
           then '0000'
           else dbo.fn_limpa_mascara( nsri.cd_mascara_operacao )
      end as 'CFOP',

      cast(s.nm_especie_livro_saida as varchar(20))  as 'ESPECIE', 

      IsNull(s.sg_serie_nota_fiscal,'1') as 'SERIE',

      IsNull(s.cd_modelo_serie_nota,'01') as 'MODELO',

      dbo.fn_status_cancelada( ns.cd_status_nota ) as 'Situacao',

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
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.VlrContabil end as 'VlrContabil',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.BCIPI end as 'BCIPI',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.IPI end as 'IPI',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.IPIIsento end as 'IPIIsento',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.IPIOutras end as 'IPIOutras',

      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.BCICMS end as 'BCICMS',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.ICMS end as 'ICMS',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.ICMSIsento end as 'ICMSIsento',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.ICMSOutras end as 'ICMSOutras'

    from

    ----------------------- Sub-Select dos Itens Agrupados ---------------------
    ( select distinct
        r.dt_nota_saida  as 'RECEBTOSAIDA',
        r.dt_nota_saida  as 'EMISSAO',
        r.cd_nota_saida,
        r.sg_estado,
        o.cd_mascara_operacao,

        sum(isnull(r.vl_contabil_item_nota,0))	 		as 'VlrContabil',
        sum(isnull(r.vl_base_ipi_item_nota,0))      as 'BCIPI',
        sum(isnull(r.vl_ipi_item_nota_saida,0)) 		as 'IPI',
        sum(isnull(r.vl_ipi_isento_item_nota,0)) 		as 'IPIIsento',
        sum(isnull(r.vl_ipi_outras_item_nota,0)) 		as 'IPIOutras',

        sum(isnull(r.vl_base_icms_item_nota,0)) 		as 'BCICMS',
        sum(isnull(r.vl_icms_item_nota_saida,0)) 		as 'ICMS',
        sum(isnull(r.vl_icms_isento_item_nota,0))		as 'ICMSIsento',
        sum(isnull(r.vl_icms_outras_item_nota,0))   as 'ICMSOutras'

      from
        Nota_Saida_Item_Registro r

       inner join Operacao_Fiscal o
         on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
            IsNull(o.ic_servico_operacao,'N') <> 'S'
 
       inner join Grupo_Operacao_Fiscal gop
         on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

      where
        gop.cd_tipo_operacao_fiscal = 1
        and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

      group by
        r.dt_nota_saida,
        r.cd_nota_saida,
        r.sg_estado,
        o.cd_mascara_operacao
    ) nsri

    inner join Nota_Saida ns
      on ns.cd_nota_saida = nsri.cd_nota_saida  

    left outer join Serie_Nota_Fiscal s
      on s.cd_serie_nota_fiscal = ns.cd_serie_nota

    left outer join
      vw_Destinatario_Rapida vw
    on
      vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
      vw.cd_destinatario = ns.cd_cliente

    left outer join
      Estado uf
    on
      uf.cd_pais = vw.cd_pais and
      uf.cd_estado = vw.cd_estado

    left outer join
      Egisadmin.dbo.Empresa e
    on
      e.cd_empresa = dbo.fn_empresa()

   where
     ns.cd_nota_saida not in ( select vwi.cd_nota_saida from vw_identificacao_nota_saida_entrada vwi
                               where
                                 ns.cd_cliente = vwi.cd_cliente                 and
                                 ns.cd_operacao_fiscal = vwi.cd_operacao_fiscal and
                                 ns.cd_serie_nota      = vwi.cd_serie_nota           )   


