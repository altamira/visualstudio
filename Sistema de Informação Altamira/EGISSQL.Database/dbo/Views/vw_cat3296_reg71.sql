
create view vw_cat3296_reg71
as
  select
    ENTRADASAIDA,
    RECEBTOSAIDA,

--    e.cd_cgc_empresa  as CNPJ,
--    e.cd_iest_empresa as IE,

    CNPJ,
    IE,

    UF,

--    MODELO,

    case when ((CFOP >= 1350 and CFOP <= 1356) or
               (CFOP >= 2350 and CFOP <= 2356) or
               (CFOP >= 3350 and CFOP <= 3356)) then '08' -- Transporte Rodoviário

         else MODELO
    end as MODELO,

--    SERIE,

    case when ((CFOP >= 1350 and CFOP <= 1356) or
               (CFOP >= 2350 and CFOP <= 2356) or
               (CFOP >= 3350 and CFOP <= 3356))
              and 
              substring(SERIE,1,1) in ('0','1','2','3','4','5','6','7','8','9') then 'U'

         when ( SERIE in ('1.','NFE','NFF') ) then '1'

         when ( SERIE in ('.') ) then ' '

         else SERIE
    end as SERIE,

    cast('00' as char(2)) as SUBSERIE,        

    NUMERO,
    VALORPRODUTO,
    '01' as Modelo_Conhecimento,
    
    --Dados da Nota de Saída que se refere o Transporte---------------------------------------------
    ns.cd_nota_saida           as cd_nota_saida,
    ns.dt_nota_saida,
    ns.vl_total                as vl_total_nota,
    --IsNull(s.sg_serie_nota_fiscal,'1')  as 'SERIE_SAIDA',
    '1' as 'SERIE_SAIDA',

    IsNull(s.cd_modelo_serie_nota,'01') as 'MODELO_SAIDA',
      case when (ns.sg_estado_nota_saida = 'EX' ) or (uf.sg_estado = 'EX') or (vw.cd_cnpj = e.cd_cgc_empresa) or (vw.cd_cnpj is null)
           then '00000000000000'
           else vw.cd_cnpj
      end as 'CNPJ_SAIDA',

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
      end as 'IE_SAIDA',

      case when isnull(uf.sg_estado,'')<>'' then
         uf.sg_estado 
      else
         ns.sg_estado_nota_saida
      end                                 as 'UF_SAIDA'



  from

    vw_produto_registro_geral vwg              with (nolock) 
    left outer join  egisadmin.dbo.empresa e   with (nolock) on e.cd_empresa           = dbo.fn_empresa()

    left outer join  nota_entrada_item nei     with (nolock) on nei.cd_nota_entrada      = NUMERO AND
                                                                nei.cd_item_nota_entrada = case when DEBUG='Serviços' then 998 else ITEM end  AND
                                                                isnull(nei.cd_produto,0) = isnull(vwg.cd_produto,0) 

    left outer join  nota_saida ns             with (nolock) on ns.cd_nota_saida       = nei.cd_nota_saida 
                                           

    left outer join  serie_nota_fiscal s       with (nolock) on s.cd_serie_nota_fiscal = ns.cd_serie_nota

    left outer join  vw_Destinatario_Rapida vw with (nolock) on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
                                                                vw.cd_destinatario      = ns.cd_cliente

    left outer join  Estado uf                 with (nolock) on uf.cd_pais   = vw.cd_pais and
                                                                uf.cd_estado = vw.cd_estado

                                                      
  where
    (CFOP >= 1350 and CFOP <= 1356) or
    (CFOP >= 2350 and CFOP <= 2356) or
    (CFOP >= 3350 and CFOP <= 3356)

