-- 
-- vw_livro_registro_saida
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Elias P. Silva
-- Banco de Dados: EgisSql
-- Objetivo: Lista o Livro de Saídas utilizado nos Arquivos Magnéticos
-- Data: 19/03/2004
-- Atualizado: 12/04/2004 - Quando o destinatário da NFE for a própria Polimold 
--                          zerar CNPJ e IE Isento - ELIAS
-- ---------------------------------------------------------------------------------------
-- 
create view vw_livro_registro_saida
as

    -- NOTAS FISCAIS DE SAÍDA
    select
      distinct
      cast('S' as char(1))			       	as 'ENTRADASAIDA',      
      cast(r.dt_nota_saida as datetime)               	as 'RECEBTOSAIDA',
      cast(s.nm_especie_livro_saida as varchar(20)) 	as 'ESPECIE', 

      IsNull(s.sg_serie_nota_fiscal,'1')  as 'SERIE',
      IsNull(s.cd_modelo_serie_nota,'01') as 'MODELO',

      cast('P' as char(1))				as 'EMITENTE',
      cast(r.cd_nota_saida as char(6))      		as 'NUMERO',
      cast(r.dt_nota_saida as datetime)                	as 'EMISSAO',
      cast(r.sg_estado as char(2))			as 'UF',
      'CNPJ' = case when ((uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa)) then
                 '00000000000000'
               else
                 isnull(vw.cd_cnpj,'00000000000000')
               end,
      'IE' = case when ((uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa)) then
               'ISENTO'
             else
               case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
                 ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
               then 
                 'Isento'
               else 
                 isnull(vw.cd_inscestadual,'00000000000000')
               end
             end,
      sum(isnull(r.vl_contabil_item_nota,0))	 		as 'VlrContabil',

      case when isnull(o.cd_mascara_operacao,'') = '' then
        '0000'
      else
        dbo.fn_limpa_mascara( o.cd_mascara_operacao )
      end as 'CFOP',

      sum(isnull(r.vl_base_icms_item_nota,0)) 		as 'BCICMS',
      sum(isnull(r.pc_icms_item_nota_saida,0)) 		as 'AliqICMS',
      sum(isnull(r.vl_icms_item_nota_saida,0)) 		as 'ICMS',
      sum(isnull(r.vl_icms_isento_item_nota,0))		as 'ICMSIsento',
      sum(isnull(r.vl_icms_outras_item_nota,0))		as 'ICMSOutras',
      sum(isnull(r.vl_base_ipi_item_nota,0)) 		as 'BCIPI',
      sum(isnull(r.vl_ipi_item_nota_saida,0)) 		as 'IPI',
      sum(isnull(r.vl_ipi_isento_item_nota,0)) 		as 'IPIIsento',
      sum(isnull(r.vl_ipi_outras_item_nota,0)) 		as 'IPIOutras',

      MAX( --case when (isnull(r.ic_servico_item_nota,'N') = 'S') then 
--             'E'
--           else
             case when (isnull(r.ic_cancelada_item_nota,'N') = 'S') then
               'S'
             else
               'N'
  --           end
           end ) as 'Situacao'

    from
      Nota_Saida_Item_Registro r

    inner join Nota_Saida n
      on r.cd_nota_saida = n.cd_nota_saida  

    inner join Operacao_Fiscal o
      on o.cd_operacao_fiscal = IsNull(r.cd_operacao_fiscal,n.cd_operacao_fiscal)

    left outer join Grupo_Operacao_Fiscal gop
      on gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal

    left outer join Plano_Conta c
      on r.cd_conta = c.cd_conta and c.cd_empresa = dbo.fn_empresa()

    left outer join Serie_Nota_Fiscal s
      on s.cd_serie_nota_fiscal = n.cd_serie_nota

    left outer join Nota_Saida_Item nsi 
      on nsi.cd_nota_saida = r.cd_nota_saida and
         nsi.cd_item_nota_saida = r.cd_item_nota_saida  

    left outer join
      vw_Destinatario_Rapida vw
    on
      vw.cd_tipo_destinatario = n.cd_tipo_destinatario and
      vw.cd_destinatario = n.cd_cliente

    left outer join
      Estado uf
    on
      uf.cd_pais = vw.cd_pais and
      uf.cd_estado = vw.cd_estado

    left outer join
      EgisAdmin.dbo.Empresa e
    on
      e.cd_empresa = dbo.fn_empresa()

    where
      gop.cd_tipo_operacao_fiscal = 2 

    group by
      r.dt_nota_saida,
      s.nm_especie_livro_saida,

      IsNull(s.sg_serie_nota_fiscal,'1'),
      IsNull(s.cd_modelo_serie_nota,'01'),

      r.cd_nota_saida,
      r.sg_estado,
      uf.sg_estado,
      vw.cd_cnpj,
      vw.ic_isento_inscestadual,
      vw.cd_inscestadual,

      case when isnull(o.cd_mascara_operacao,'') = '' then
        '0000'
      else
        dbo.fn_limpa_mascara( o.cd_mascara_operacao )
      end,
      e.cd_cgc_empresa

