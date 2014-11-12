
------------------------------------------------------------------------------------------
-- vw_livro_registro_saida_reg50
-----------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Elias P. Silva
-- Banco de Dados: EgisSql
-- Objetivo: Lista o Livro de Saídas utilizado nos Arquivos Magnéticos
-- Data: 19/03/2004
-- Atualizado: 12/04/04 - Inserido verificação de destinatário = empresa - ELIAS
--                      - Caso esteja cancelado, não mostrar valores - ELIAS
-- 29.06.2007           - Verificação Geral - Carlos Fernandes
-- 05.09.2007           - Acertos do Emitente - Carlos Fernandes
-- 25.03.2008 - Ajuste Gerais - Carlos Fernandes
-- 22.10.2009 - Verificação da Subst. Tributária - Carlos Fernandes
-- 18.03.2010 - Complemento das Informações - Carlos Fernandes
-- 11.10.2010 - Identificação Nota Fiscal - Carlos Fernandes
-----------------------------------------------------------------------------------------
-- 
--
create view vw_livro_registro_saida_reg50
as

    -- NOTAS FISCAIS DE SAÍDA
    --select * from nota_saida

    select
      distinct
      cast('S' as char(1))                as 'ENTRADASAIDA',      
      isnull(s.ic_tipo_emitente_nota,'P') as 'EMITENTE',

      ------------------------------ Dados da Nota Fiscal -------------------------
      nsri.RECEBTOSAIDA,
      nsri.EMISSAO,
      nsri.cd_nota_saida                  as 'NUMERO',

      case when isnull(nsri.sg_estado,'')<>'' then
         nsri.sg_estado 
      else
         ns.sg_estado_nota_saida
      end                                 as 'UF',

      case when isnull(nsri.cd_mascara_operacao,'') = ''
           then '0000'
           else dbo.fn_limpa_mascara( nsri.cd_mascara_operacao )
      end as 'CFOP',

      cast(s.nm_especie_livro_saida as varchar(20))  as 'ESPECIE', 

      IsNull(s.sg_serie_nota_fiscal,'1')             as 'SERIE',

      IsNull(s.cd_modelo_serie_nota,'01')            as 'MODELO',

      dbo.fn_status_cancelada( ns.cd_status_nota )   as 'Situacao',

      ------------------------------ Dados do Destinatário -------------------------

      case when (ns.sg_estado_nota_saida = 'EX' ) or (uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa) or (vw.cd_cnpj is null)
           then '00000000000000'
           else vw.cd_cnpj
      end as 'CNPJ',

      --04.09.2008
      --comentado por Carlos/Igor para o Cliente Atlas
      --verificado legislação *****

      case when (ns.sg_estado_nota_saida = 'EX' ) or (uf.sg_estado = 'EX') --or (vw.cd_cnpj = e.cd_cgc_empresa)
           then 'ISENTO'
           else case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
                          ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
                     then 'ISENTO'
                     else isnull(vw.cd_inscestadual,'00000000000000')
                end
      end as 'IE',

      ------------------------------ Somatório dos Itens -------------------------

      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.VlrContabil end  as 'VlrContabil',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.BCICMS      end  as 'BCICMS',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.AliqICMS    end  as 'AliqICMS',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.ICMS        end  as 'ICMS',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.ICMSIsento  end  as 'ICMSIsento',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.ICMSOutras  end  as 'ICMSOutras',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.BCICMSST    end  as 'BCICMSST',
      case when dbo.fn_status_cancelada( ns.cd_status_nota ) = 'S' then 0 else nsri.ICMSST      end  as 'ICMSST'

    from

    ----------------------- Sub-Select dos Itens Agrupados ---------------------

    ( select distinct
        r.dt_nota_saida  as 'RECEBTOSAIDA',
        r.dt_nota_saida  as 'EMISSAO',
        r.cd_nota_saida,
        r.sg_estado,
        o.cd_mascara_operacao,
        isnull(r.pc_icms_item_nota_saida,0)                     as 'AliqICMS',
        sum(isnull(r.vl_contabil_item_nota,0))	 		as 'VlrContabil',
        sum(isnull(r.vl_base_icms_item_nota,0)) 		as 'BCICMS',
        sum(isnull(r.vl_icms_item_nota_saida,0)) 		as 'ICMS',
        sum(isnull(r.vl_icms_isento_item_nota,0))		as 'ICMSIsento',
        sum(isnull(r.vl_icms_outras_item_nota,0))               as 'ICMSOutras',
        sum(isnull(r.vl_base_icms_subs_item,0))		        as 'BCICMSST',
        sum(isnull(r.vl_icms_subs_item_nota,0))                 as 'ICMSST'

      from
        Nota_Saida_Item_Registro r          with (nolock) 

       inner join Operacao_Fiscal o         with (nolock) 
         on o.cd_operacao_fiscal = r.cd_operacao_fiscal and
            IsNull(o.ic_servico_operacao,'N') <> 'S'
 
       inner join Grupo_Operacao_Fiscal gop with (nolock) 
         on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

      where
        gop.cd_tipo_operacao_fiscal = 2 
        and isnull(o.ic_destaca_vlr_livro_op_f,'S') = 'S'

      group by
        r.dt_nota_saida,
        r.cd_nota_saida,
        r.sg_estado,
        o.cd_mascara_operacao,
        isnull(r.pc_icms_item_nota_saida,0)

    ) nsri

    inner join Nota_Saida ns            with (nolock) 
      on ns.cd_nota_saida = nsri.cd_nota_saida  

    left outer join Serie_Nota_Fiscal s with (nolock) 
      on s.cd_serie_nota_fiscal = ns.cd_serie_nota

    left outer join 
      vw_Destinatario_Rapida vw         with (nolock) 
    on
      vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
      vw.cd_destinatario      = ns.cd_cliente

    left outer join
      Estado uf                         with (nolock) 
    on
      uf.cd_pais   = vw.cd_pais and
      uf.cd_estado = vw.cd_estado

    left outer join
      Egisadmin.dbo.Empresa e
    on
      e.cd_empresa = dbo.fn_empresa()

   where
     ns.cd_nota_saida not in ( select vwi.cd_nota_saida from vw_identificacao_nota_saida_entrada vwi
                               where
                                 ns.cd_cliente         = vwi.cd_cliente         and
                                 ns.cd_operacao_fiscal = vwi.cd_operacao_fiscal and
                                 ns.cd_serie_nota      = vwi.cd_serie_nota           )   


