
create procedure pr_operacao_interestadual
@ic_parametro int,     -- 1: realizadas,  2: devolvidas  
@sg_estado    char(2),
@dt_inicial   datetime,
@dt_final     datetime  

as

if ( @ic_parametro = 1 ) begin

   select distinct
     ns.sg_estado_nota_saida       as 'Estado',
--     , ns.cd_nota_saida            as 'NotaSaida'

     case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
       ns.cd_identificacao_nota_saida
     else
       ns.cd_nota_saida
     end                       as 'NotaSaida'

     , ns.dt_nota_saida            as 'Emissao'
     , IsNull(snf.sg_serie_nota_fiscal,'1') as 'Serie'
     , td.nm_tipo_destinatario     as 'Destinatario'
     , ns.nm_fantasia_destinatario as 'Fantasia'
     , ns.nm_razao_social_cliente  as 'RazaoSocial'
     , ns.cd_cnpj_nota_saida       as 'CGC'
     , ns.cd_inscest_nota_saida    as 'IE'
     , ns.nm_endereco_nota_saida	 as 'Endereco'
     , ns.cd_numero_end_nota_saida as 'NumeroEnd'
     , ns.nm_cidade_nota_saida     as 'Cidade'
     , ns.cd_cep_nota_saida        as 'CEP'

     , cast(null as DateTime)      as 'DataDevolucao'
     , IsNull( SUM( nsi.vl_total_item + nsi.vl_ipi ), SUM( ns.vl_total ) ) as 'ValorContabil'
     , IsNull( SUM( nsi.vl_base_icms_item ), SUM( ns.vl_bc_icms ) )        as 'BaseCalculoICMS'
     , IsNull( SUM( nsi.vl_icms_item ), SUM( ns.vl_icms ) )                as 'ICMS'
     , IsNull( SUM( nsi.vl_icms_isento_item ), SUM( ns.vl_icms_isento ) )  as 'IsentasICMS'
     , IsNull( SUM( nsi.vl_icms_outros_item ), SUM( ns.vl_icms_outros ) )  as 'OutrasICMS'
     , IsNull( SUM( nsi.vl_icms_obs_item ), SUM( ns.vl_icms_obs ) )        as 'ObservacaoICMS'

     , IsNull( SUM( nsi.vl_base_ipi_item ), SUM( ns.vl_bc_ipi ) )          as 'BaseCalculoIPI'
     , IsNull( SUM( nsi.vl_ipi ), SUM( ns.vl_ipi ) )                       as 'IPI'
     , IsNull( SUM( nsi.vl_ipi_isento_item ), SUM( ns.vl_ipi_isento ) )    as 'IsentasIPI'
     , IsNull( SUM( nsi.vl_ipi_outros_item ), SUM( ns.vl_ipi_outros ) )    as 'OutrasIPI'
     , IsNull( SUM( nsi.vl_ipi_obs_item ), SUM( ns.vl_ipi_obs ) )          as 'ObservacaoIPI'
   from
     nota_saida ns                  with (nolock) 

     inner join Tipo_Destinatario td
     on   td.cd_tipo_destinatario = isnull(ns.cd_tipo_destinatario,7)

     inner join operacao_fiscal opf
     on   opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
     and  opf.ic_opinterestadual_op_fis = 'S'
     and  IsNull(opf.ic_servico_operacao,'N') <> 'S'

     left outer join serie_nota_fiscal snf
     on snf.cd_serie_nota_fiscal = ns.cd_serie_nota

     left outer join nota_saida_item nsi
     on nsi.cd_nota_saida = ns.cd_nota_saida 

     left outer join operacao_fiscal opf_i
     on   opf_i.cd_operacao_fiscal = nsi.cd_operacao_fiscal
     and  opf_i.ic_opinterestadual_op_fis = 'S'
     and  IsNull(opf_i.ic_servico_operacao,'N') <> 'S'

   where
     ns.dt_nota_saida between @dt_inicial and @dt_final
     and
     (( @sg_estado is null ) or ( ns.sg_estado_nota_saida = @sg_estado ))
     and
     ns.sg_estado_nota_saida <> 'EX' and
     ns.cd_status_nota <> 7

   group by
     ns.sg_estado_nota_saida
     , ns.cd_nota_saida
     , ns.cd_identificacao_nota_saida
     , ns.dt_nota_saida
     , IsNull(snf.sg_serie_nota_fiscal,'1')
     , td.nm_tipo_destinatario
     , ns.nm_fantasia_destinatario
     , ns.nm_razao_social_cliente
     , ns.cd_cnpj_nota_saida
     , ns.cd_inscest_nota_saida
     , ns.nm_endereco_nota_saida
     , ns.cd_numero_end_nota_saida
     , ns.nm_cidade_nota_saida
     , ns.cd_cep_nota_saida

   order by 
     1,2

end
else begin

   select distinct
     ns.sg_estado_nota_saida       as 'Estado',

--     , ns.cd_nota_saida            as 'NotaSaida'
     case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
       ns.cd_identificacao_nota_saida
     else
       ns.cd_nota_saida
     end                           as 'NotaSaida'

     , ns.dt_nota_saida            as 'Emissao'
     , IsNull(snf.sg_serie_nota_fiscal,'1') as 'Serie'
     , td.nm_tipo_destinatario     as 'Destinatario'
     , ns.nm_fantasia_destinatario as 'Fantasia'
     , ns.nm_razao_social_cliente  as 'RazaoSocial'
     , ns.cd_cnpj_nota_saida       as 'CGC'
     , ns.cd_inscest_nota_saida    as 'IE'
     , ns.nm_endereco_nota_saida	 as 'Endereco'
     , ns.cd_numero_end_nota_saida as 'NumeroEnd'
     , ns.nm_cidade_nota_saida     as 'Cidade'
     , ns.cd_cep_nota_saida        as 'CEP'

     , MAX( nsi.dt_restricao_item_nota ) as 'DataDevolucao'
     , IsNull( SUM( nsi.vl_total_item + nsi.vl_ipi ), SUM( ns.vl_total ) ) as 'ValorContabil'
     , IsNull( SUM( nsi.vl_base_icms_item ), SUM( ns.vl_bc_icms ) )        as 'BaseCalculoICMS'
     , IsNull( SUM( nsi.vl_icms_item ), SUM( ns.vl_icms ) )                as 'ICMS'
     , IsNull( SUM( nsi.vl_icms_isento_item ), SUM( ns.vl_icms_isento ) )  as 'IsentasICMS'
     , IsNull( SUM( nsi.vl_icms_outros_item ), SUM( ns.vl_icms_outros ) )  as 'OutrasICMS'
     , IsNull( SUM( nsi.vl_icms_obs_item ), SUM( ns.vl_icms_obs ) )        as 'ObservacaoICMS'

     , IsNull( SUM( nsi.vl_base_ipi_item ), SUM( ns.vl_bc_ipi ) )          as 'BaseCalculoIPI'
     , IsNull( SUM( nsi.vl_ipi ), SUM( ns.vl_ipi ) )                       as 'IPI'
     , IsNull( SUM( nsi.vl_ipi_isento_item ), SUM( ns.vl_ipi_isento ) )    as 'IsentasIPI'
     , IsNull( SUM( nsi.vl_ipi_outros_item ), SUM( ns.vl_ipi_outros ) )    as 'OutrasIPI'
     , IsNull( SUM( nsi.vl_ipi_obs_item ), SUM( ns.vl_ipi_obs ) )          as 'ObservacaoIPI'
   from
     nota_saida ns

     inner join nota_saida_item nsi
     on nsi.cd_nota_saida = ns.cd_nota_saida 

     inner join Tipo_Destinatario td
     on   td.cd_tipo_destinatario = isnull(ns.cd_tipo_destinatario,7)

     inner join operacao_fiscal opf
     on   opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
     and  opf.ic_opinterestadual_op_fis = 'S'
     and  IsNull(opf.ic_servico_operacao,'N') <> 'S'

     left outer join serie_nota_fiscal snf
     on snf.cd_serie_nota_fiscal = ns.cd_serie_nota

     left outer join operacao_fiscal opf_i
     on   opf_i.cd_operacao_fiscal = nsi.cd_operacao_fiscal
     and  opf_i.ic_opinterestadual_op_fis = 'S'
     and  IsNull(opf_i.ic_servico_operacao,'N') <> 'S'

   where
     nsi.dt_restricao_item_nota between @dt_inicial and @dt_final
     and
     (( @sg_estado is null ) or ( ns.sg_estado_nota_saida = @sg_estado ))
     and
     ns.sg_estado_nota_saida <> 'EX' and
     ns.cd_status_nota in ( 3, 4 )

   group by
     ns.sg_estado_nota_saida
     , ns.cd_nota_saida
     , ns.cd_identificacao_nota_saida
     , ns.dt_nota_saida
     , IsNull(snf.sg_serie_nota_fiscal,'1')
     , td.nm_tipo_destinatario
     , ns.nm_fantasia_destinatario
     , ns.nm_razao_social_cliente
     , ns.cd_cnpj_nota_saida
     , ns.cd_inscest_nota_saida
     , ns.nm_endereco_nota_saida
     , ns.cd_numero_end_nota_saida
     , ns.nm_cidade_nota_saida
     , ns.cd_cep_nota_saida

   order by 
     1,2

end

