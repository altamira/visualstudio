CREATE view vw_dev_operacao_interestadual_reg50 as

select distinct

  ns.sg_estado_nota_saida
  , ns.dt_nota_dev_nota_saida
  , ns.cd_nota_saida
  , ns.sg_estado_nota_saida   as 'UF'
  , ns.cd_nota_saida          as 'Numero'

  , vw.cd_cnpj                as 'CNPJ'
  , 'InscricaoEstadual' =
      Case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
                 ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
           then 'Isento'
           else vw.cd_inscestadual
      End
  , IsNull(snf.cd_modelo_serie_nota,'01')  as 'Modelo'
  , IsNull(snf.sg_serie_nota_fiscal,'1')   as 'Serie'
  , IsNull(snf.ic_tipo_emitente_nota,'P')  as 'Emitente'

  , dbo.fn_status_cancelada( ns.cd_status_nota ) as 'Situacao'

  , opf.cd_mascara_operacao as 'CFOP'

  , IsNull( nsi.pc_icms, 0 ) as 'Aliquota'

  , MAX( nsi.dt_restricao_item_nota ) as 'DataDevolucao'
  , round( SUM( ((nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) -
                ((nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) * IsNull(nsi.pc_icms_desc_item,0)/100)) +
                 IsNull(nsi.vl_ipi,0) +
                 IsNull(nsi.vl_ipi_corpo_nota_saida,0) +
                 IsNull(nsi.vl_frete_item,0) ), 2 ) as 'ValorTotal'

  , round( SUM( nsi.vl_base_icms_item ), 2 )    as 'BaseCalculoICMS'
  , round( SUM( nsi.vl_icms_item ), 2 )         as 'ValorICMS'
  , round( SUM( nsi.vl_icms_isento_item ), 2 )  as 'IsentaNaoTributada'
  , round( SUM( nsi.vl_icms_outros_item ), 2 )  as 'Outras'

from
  nota_saida ns

  inner join nota_saida_item nsi
  on nsi.cd_nota_saida = ns.cd_nota_saida 

  left outer join serie_nota_fiscal snf
  on snf.cd_serie_nota_fiscal = ns.cd_serie_nota

  , operacao_fiscal opf
  , vw_Destinatario_Rapida vw

where
  ns.sg_estado_nota_saida <> 'EX' and
  ns.cd_status_nota in ( 3, 4 )
  and
  opf.cd_operacao_fiscal = IsNull(nsi.cd_operacao_fiscal,ns.cd_operacao_fiscal) and
  opf.ic_opinterestadual_op_fis = 'S' and
  IsNull(opf.ic_servico_operacao,'N') <> 'S'
  and
  vw.cd_destinatario = ns.cd_cliente and
  vw.cd_tipo_destinatario = ns.cd_tipo_destinatario

group by
  ns.sg_estado_nota_saida
  , ns.dt_nota_dev_nota_saida
  , ns.cd_nota_saida

  , vw.cd_cnpj
  , Case when (( IsNull( vw.ic_isento_inscestadual, 'N' ) = 'S' ) and
               ( Upper( IsNull(vw.cd_inscestadual,'') ) <> 'ISENTO' ))
         then 'Isento'
         else vw.cd_inscestadual
    End
  , IsNull(snf.cd_modelo_serie_nota,'01')
  , IsNull(snf.sg_serie_nota_fiscal,'1')
  , IsNull(snf.ic_tipo_emitente_nota,'P')

  , dbo.fn_status_cancelada( ns.cd_status_nota )

  , opf.cd_mascara_operacao

  , IsNull( nsi.pc_icms, 0 )

