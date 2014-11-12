
CREATE VIEW vw_in86_Nota_Ent_Said_Emit_Pess_Juridica

--vw_in86_Nota_Ent_Said_Emit_Pess_Juridica

------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                                          2004
--Stored Procedure	    : Microsoft SQL Server                                              2004
--Autor(es)		          : André de Oliveira Godoi
--Banco de Dados	      : EGISSQL
--Objetivo		          : Arquivo Notas Fiscal de Saída e Entrada Emitidas pela Pessoas Juridicas.
--                        Só esta os casos das notas de saída.      4.3.1
--Data			            : 01/04/2004
-------------------------------------------------------------------------------------------------
as

select
  case when (gop.cd_tipo_operacao_fiscal) = 1 then   
         'E'
       else
         'S'    
       end                                                    as 'INDMOV',    -- 1)
  isnull(snf.cd_modelo_serie_nota,'01')                       as 'MODDOC',    -- 2)  
  case when snf.sg_serie_nota_fiscal = '1.'
         then '1'
       else IsNull(snf.sg_serie_nota_fiscal,'1')
       end                                                    as 'SERIEDOC',  -- 3)
  ns.cd_nota_saida                                            as 'NUMDOC',    -- 4)
  ns.dt_nota_saida		                                        as 'DATAEMISS', -- 5)
  case when ns.cd_tipo_destinatario = 1 then
         'Cl' + cast(ns.cd_cliente as varchar(12))
       else
         case when ns.cd_tipo_destinatario = 2 then
           'Fo' + cast(ns.cd_cliente as varchar (12)) 
         else
           case when ns.cd_tipo_destinatario = 3 then
             'Ve' + cast(ns.cd_cliente as varchar(12))      
           end
         end
       end                                                    as 'CODPART',  
  ns.dt_saida_nota_saida                                      as 'DATAES',        -- 7)
  ns.vl_produto                                               as 'VLRTOTALMERC',  -- 8)
  ns.vl_desconto_nota_saida                                   as 'VLRTOTALDESC',  -- 9)
  ns.vl_frete                                                 as 'VLRFRETE',      -- 10)
  ns.vl_seguro                                                as 'VLRSEGURO',     -- 11)
  ns.vl_desp_acess                                            as 'VLROUTDESP',    -- 12)
  ns.vl_ipi                                                   as 'VLRIPI',        -- 13)
  -- Ver com o Elias sobre este campo                                             -- 14) 
  ns.vl_total                                                 as 'VLRTOTALNF',    -- 15)
  -- Ver com o Elias sobre este campo                                             -- 16)
  ttr.nm_tipo_transporte                                      as 'VIATRANSP',     -- 17)
  'Tr' + cast(ns.cd_transportadora as char(12))               as 'CODTRANSP',     -- 18)
  ns.qt_volume_nota_saida                                     as 'QTDVOL',        -- 19)
  cast(ee.nm_especie_embalagem as char(10))                   as 'ESPVOL',        -- 20)
  ns.qt_peso_bruto_nota_saida                                 as 'PESOBRUTO',     -- 21)
  ns.qt_peso_liq_nota_saida                                   as 'PESOLIQUIDO',   -- 22)
  -- Ver com o Elias sobre este campo                                             -- 23)
  ns.cd_placa_nota_saida                                      as 'IDVEIC',        -- 24)
  case when isnull(ns.cd_status_nota,0) = 7 then
         'S'
       else
         'N'
       end                                                    as 'SITCANCDOC',    -- 25)
  case when(ns.cd_condicao_pagamento <> 1) then
         '2'
       else
         '1'
       end                                                     as 'TIPOFAT',      -- 26)
  ns.ds_obs_compl_nota_saida                                   as 'OBS'           -- 27)  

from

  Nota_Saida ns

  left outer join serie_nota_fiscal snf
    on snf.cd_serie_nota_fiscal = ns.cd_serie_nota

  left outer join operacao_fiscal opf 
    on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal

  left outer join grupo_operacao_fiscal gop
    on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal

  left outer join transportadora t
    on t.cd_transportadora = ns.cd_transportadora
 
  left outer join tipo_transporte ttr
    on ttr.cd_tipo_transporte = t.cd_tipo_transporte
  
  left outer join especie_embalagem ee
    on ee.cd_especie_embalagem = ns.cd_especie_embalagem
   
