
CREATE PROCEDURE pr_relatorio_entrada_notas_fiscais
@ic_comercial char(1),
@dt_inicial   datetime,
@dt_final     datetime

AS

select distinct
    n.cd_nota_entrada 		     as 'Nota',
    nr.cd_rem		 	           as 'REM',
    n.dt_receb_nota_entrada	  as 'Recebimento',
    v.nm_fantasia               as 'Fornecedor',
    case 
		when (isnull(o.ic_servico_operacao,'N') = 'S') or (isnull(n.vl_prod_nota_entrada,0) <= 0) then
      	n.vl_servico_nota_entrada /* - 
     (isnull(n.vl_irrf_nota_entrada,0) + 
      isnull(n.vl_inss_nota_entrada,0) +
      (case when (n.ic_reter_iss = 'S') then
        isnull(n.vl_iss_nota_entrada,0)
       else 0 end) +
      isnull(n.vl_cofins_nota_entrada,0) +
      isnull(n.vl_pis_nota_entrada,0) +
      isnull(n.vl_csll_nota_entrada,0)) */
    else
      n.vl_prod_nota_entrada /*- 
     (isnull(n.vl_irrf_nota_entrada,0) + 
      isnull(n.vl_inss_nota_entrada,0) +
      (case when (n.ic_reter_iss = 'S') then
        isnull(n.vl_iss_nota_entrada,0)
       else 0 end) */
      --+
--       isnull(n.vl_cofins_nota_entrada,0) +
--       isnull(n.vl_pis_nota_entrada,0) +
--       isnull(n.vl_csll_nota_entrada,0)
--      )
    end				as 'TotalProduto',

    n.vl_ipi_nota_entrada	as 'IPI',
    n.vl_icms_nota_entrada	as 'ICMS',
 
    n.vl_total_nota_entrada 
/* -   (isnull(n.vl_irrf_nota_entrada,0) + 
     isnull(n.vl_inss_nota_entrada,0) +
     (case when (n.ic_reter_iss = 'S') then
       isnull(n.vl_iss_nota_entrada,0)
      else 0 end) */
--+
--      isnull(n.vl_cofins_nota_entrada,0) +
--      isnull(n.vl_pis_nota_entrada,0) +
--      isnull(n.vl_csll_nota_entrada,0)   )    
   as 'TotalNota',
    n.ic_scp		               as 'ContasPagar',
   'SemVlrComercial' = case when isnull(o.ic_comercial_operacao, 'N') = 'N' then '!' else null end,
    -- ELIAS 25/09/2003
    'Servico' = case when isnull(o.ic_servico_operacao,'N') = 'S' or (isnull(n.vl_prod_nota_entrada,0) <= 0) then '*' else null end,
    'S'				as 'Forn',
    ( select top 1 IsNull(p.ic_aprov_pedido_compra,'N')
      from Pedido_Compra p inner join
           Nota_Entrada_Item nei on p.cd_pedido_compra = nei.cd_pedido_compra
      where
        nei.cd_nota_entrada = n.cd_nota_entrada and
        nei.cd_fornecedor = n.cd_fornecedor and
        nei.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal ) as ic_aprov_pedido_compra,
     isnull(n.vl_irrf_nota_entrada,0)   as 'IRRF',
     isnull(n.vl_inss_nota_entrada,0)   as 'INSS',
     isnull(n.vl_iss_nota_entrada,0)    as 'ISS',
     isnull(n.vl_cofins_nota_entrada,0) as 'COFINS',
     isnull(n.vl_pis_nota_entrada,0)    as 'PIS',
     isnull(n.vl_csll_nota_entrada,0)   as 'CSLL',
     n.cd_tipo_destinatario,
     o.cd_mascara_operacao,
     o.nm_operacao_fiscal

from
    Nota_Entrada n           with (nolock) left outer join 
    Nota_Entrada_Registro nr with (nolock) on n.cd_nota_entrada      = nr.cd_nota_entrada and
                                n.cd_fornecedor        = nr.cd_fornecedor   and
                                n.cd_operacao_fiscal   = nr.cd_operacao_fiscal and
                                n.cd_serie_nota_fiscal = nr.cd_serie_nota_fiscal left outer join 
    vw_Destinatario v  with (nolock) on n.cd_fornecedor = v.cd_destinatario and isnull(n.cd_tipo_destinatario,2) = v.cd_tipo_destinatario left outer join 
    Operacao_fiscal o  with (nolock) on n.cd_operacao_fiscal = o.cd_operacao_fiscal 

where
    n.dt_receb_nota_entrada between @dt_inicial and @dt_final
    and
    ((@ic_comercial = 'A') or (o.ic_comercial_operacao = @ic_comercial))

order by
    v.nm_fantasia,
    n.cd_nota_entrada,
    nr.cd_rem 

--select * from operacao_fiscal

