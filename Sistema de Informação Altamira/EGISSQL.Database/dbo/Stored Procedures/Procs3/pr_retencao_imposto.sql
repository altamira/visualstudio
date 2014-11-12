
CREATE PROCEDURE pr_retencao_imposto
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- lista o resumo p/ CFOP
-------------------------------------------------------------------------------
  begin
--select * from nota_entrada 
	select 
	  cd_rem                    as 'REM',
	  cd_nota_entrada           as 'NOTA',
	  cd_serie_nota_fiscal      as 'SERIE',
	  nm_razao_social           as 'FORNECEDOR',
	  dt_nota_entrada           as 'DATA',
	  vl_total_nota_entrada     as 'VALOR',
	  vl_irrf_nota_entrada      as 'IR',
	  case when isnull(ic_reter_iss, 'N') = 'S' then 
              vl_iss_nota_entrada
	    else
	      0
	    end                     as 'ISS',
	  vl_cofins_nota_entrada    as 'COFINS',
	  vl_pis_nota_entrada       as 'PIS',
	  vl_csll_nota_entrada      as 'CSLL',
	  vl_inss_nota_entrada      as 'INSS'
	from nota_entrada
	where
    dt_nota_entrada between @dt_inicial and @dt_final and
	  ( IsNull(vl_cofins_nota_entrada,0) > 0 or
	    IsNull(vl_pis_nota_entrada,0) > 0    or
	    IsNull(vl_csll_nota_entrada,0) > 0   or
	    IsNull(vl_inss_nota_entrada,0) > 0   or
            IsNull(vl_irrf_nota_entrada,0) > 0   or
            IsNull(vl_iss_nota_entrada,0)  >0 )
  order by
    dt_nota_entrada

end

--select * from nota_entrada

-------------------------------------------------------------------------------
else if @ic_parametro = 2 -- lista resumo p/ estado
-------------------------------------------------------------------------------
  begin

    select
--      cd_nota_saida            as 'NOTA',

      case when isnull(cd_identificacao_nota_saida,0)<>0 then
        cd_identificacao_nota_saida
      else
        cd_nota_saida
      end                      as 'NOTA',
      dt_nota_saida            as 'DATA',
      cd_tipo_destinatario     as 'TIPO',
      nm_fantasia_nota_saida   as 'FANTASIA',
      vl_total                 as 'VALOR',
      vl_irrf_nota_saida       as 'IR',
      vl_iss_retido            as 'ISS',
      vl_cofins                as 'COFINS',
      vl_pis                   as 'PIS',
      vl_csll                  as 'CSLL',
      0                        as 'INSS'
    from
      nota_saida
    where
      dt_nota_saida between @dt_inicial and @dt_final and
      ( isnull(vl_iss_retido,0) > 0 or
        isnull(vl_cofins,0) > 0 or
        isnull(vl_pis,0) > 0 or
        isnull(vl_csll,0) > 0 or
        IsNull(vl_irrf_nota_saida,0) > 0 )

  end

else  

  return
    
