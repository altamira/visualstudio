
CREATE VIEW vw_nfe_transporte_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_transporte_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Dados do Transporte 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 24.11.2008
--06.04.2009 - Ajustes Diversos - Carlos Fernandes
--23.06.2009 - Verificação dos Dados da Transportadora - Carlos Fernandes 
--10.09.2009 - Telefone da Transportadora - Carlos Fernandes
--16.09.2009 - Transportadora Retira, colocar o Dados do Endereço do Cliente 
--14.07.2010 - Ajuste no Campo Espécie - Carlos Fernandes
-- 
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
-- 22.12.2010 - Verificação de Pessoa Física - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from nota_saida_item
--select * from nota_saida
--select * from transportadora

select
  ns.cd_identificacao_nota_saida,
  ns.dt_nota_saida,
  ns.cd_nota_saida,
  'X'                                                         as 'transp',
  rtrim(ltrim(cast(case when isnull(tp.cd_identifica_nota_fiscal,1) = 1 then '0' else '1' end as varchar(80))))
                                                              as 'modFrete',

  'X03'                                                       as 'transporta',

  --select * from tipo_pessoa
   
  t.cd_tipo_pessoa,

  case when isnull(t.ic_destinatario,'N')='N' then
  
     case when t.cd_tipo_pessoa = 1 then
       cast(replace(replace(replace(t.cd_cnpj_transportadora,'-',''),'.',''),'/','') as varchar(15))
     else
       cast('' as varchar(14))
     end
  else
     case when t.cd_tipo_pessoa = 1 then
       cast(replace(replace(replace(vw.cd_cnpj,'-',''),'.',''),'/','') as varchar(15))
     else
       cast('' as varchar(14))
     end
  end                                                                                               as 'CNPJ',

  case when isnull(t.ic_destinatario,'N')='N' then
     case when t.cd_tipo_pessoa = 2 then
       cast(replace(replace(replace(t.cd_cnpj_transportadora,'-',''),'.',''),'/','') as varchar(15))
     else
       cast('' as varchar(11) )
     end                                                                                         
   else
     case when t.cd_tipo_pessoa = 2 then
       cast(replace(replace(replace(vw.cd_cnpj,'-',''),'.',''),'/','') as varchar(15))
     else
       cast('' as varchar(11) )
     end                                                                                         

   end                                                                                              as 'CPF',
  
  ltrim(rtrim(cast(nm_transportadora as varchar(60))))                                              as 'xNome',

  --Inscrição Estadual

  case when isnull(t.ic_icms_transportadora,'S')='N'  
  then
    cast('' as varchar(15))
  else
    case when isnull(t.ic_ie_isento_transportadora,'N')='S' then
      cast('ISENTO' as varchar(15))
    else
      case when isnull(t.ic_destinatario,'N')='N' then
        cast(replace(replace(replace(t.cd_insc_estadual,'-',''),'.',''),'/','') as varchar(15))      
      else
        cast(replace(replace(replace(vw.cd_inscestadual,'-',''),'.',''),'/','') as varchar(15))      
      end                                                                                       
    end
  end                                                                                               as 'IE',

  --Endereço
  --select * from vw_destinatario

  case when isnull(t.ic_destinatario,'N')='N' then
    cast(rtrim(ltrim(t.nm_endereco))+'-'+
         rtrim(ltrim(t.cd_numero_endereco))+' '+
         rtrim(ltrim(t.nm_bairro)) as varchar(60))
  else
    --Dados do Destinatario
    cast(rtrim(ltrim(vw.nm_endereco))+'-'+
         rtrim(ltrim(vw.cd_numero_endereco))+' '+
         rtrim(ltrim(vw.nm_bairro)) as varchar(60))

  end                                                                                               as 'xEnder',
 
  --Cidade 

  case when isnull(t.ic_destinatario,'N')='N' then
     rtrim(ltrim(cast(cid.nm_cidade as varchar(80))))
  else
     rtrim(ltrim(cast(vw.nm_cidade as varchar(80))))
  end                                                                                            as 'xMun', 

  --Estado

  case when isnull(t.ic_destinatario,'N')='N' then
    rtrim(ltrim(cast(est.sg_estado as varchar(2))))
  else
    rtrim(ltrim(cast(vw.sg_estado as varchar(2))))
  end                                                                                            as 'UF',


  case when isnull(t.ic_destinatario,'N')='N' then
    rtrim(ltrim(t.cd_ddd)) + '-' + rtrim(ltrim(t.cd_telefone))                                 
  else
    rtrim(ltrim(vw.cd_ddd)) + '-' + rtrim(ltrim(vw.cd_telefone))                                 
  end                                                                                            as 'Telefone',
  
  'X11'                                                         as 'retTransp', 


  --EGIS não tem os campos-----------------------------------------------------
  ''                                                            as 'vServ',
  ''                                                            as 'vBCRet',
  ''                                                            as 'pICMSRet',
  ''                                                            as 'vICMSRet',
  cast('' as varchar(4))                                        as 'CFOP',
  rtrim(ltrim(cast(cid.cd_cidade_ibge as varchar(10))))                                        as 'cMunFG',

  'X18'                                                         as 'VeicTrans',
  rtrim(ltrim(cast(replace(isnull(ns.cd_placa_nota_saida,'0000000'),'-','') as varchar(80))))                                      as 'Placa',
  rtrim(ltrim(cast(isnull(ns.sg_estado_placa,'')            as varchar(20))))                               as 'UFPlaca',
  rtrim(ltrim(cast(isnull(t.cd_registro_transportadora,'') as varchar(20))))                                as 'RTNC',


  --Dados do Reboque --> Não tem no Egis

  'X22'                                                              as 'Reboque',
  cast('' as varchar(08))                                            as 'placa_X23',
  cast('' as varchar(02))                                            as 'UF_X24',
  cast('' as varchar(20))                                            as 'RTNC_X25',
  cast('' as varchar(20))                                            as 'vagao_X25a',
  cast('' as varchar(20))                                            as 'balsa_X25b',

  'X26'                                                              as 'vol',

  isnull(CONVERT(varchar, convert(int,case when ns.qt_volume_nota_saida > 0 then ns.qt_volume_nota_saida else null end),103),'')              as 'qVol',    

  rtrim(ltrim(cast(isnull(ns.nm_especie_nota_saida,'') as varchar(80)))) as 'esp',

  --'1'                                                            as 'esp',

  rtrim(ltrim(cast(ns.nm_marca_nota_saida      as varchar(80)))) as 'marca',
  rtrim(ltrim(cast(ns.nm_numero_emb_nota_saida as varchar(80)))) as 'nVol',

  isnull(CONVERT(varchar, convert(int,case when ns.qt_peso_liq_nota_saida   > 0 then ns.qt_peso_liq_nota_saida   else null end),103),'')      as 'pesoL',
  isnull(CONVERT(varchar, convert(int,case when ns.qt_peso_bruto_nota_saida > 0 then ns.qt_peso_bruto_nota_saida else null end),103),'') as 'pesoB',

  --Egis não tem----------------------------

  'X33'                                                              as 'lacres',
  cast('' as varchar(60))                                            as 'nLacres',
  rtrim(ltrim(cast(t.cd_registro_transportadora as varchar(20))))    as 'RNTC',

  --Dados da Cobrança------------------------

   'cobr><fat><nFat>'+
   isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') +
   '</nFat><vOrig>' +
   isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') + 
   '</vOrig><vLiq>' +
   isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') + 
   '</vLiq></fat>'                                                   as 'Y_DADOS_CAB', 

   -------------------------------------------------------------------------------------------------
   --Parcela 1
   -------------------------------------------------------------------------------------------------

   case when ( select top 1 nsp.cd_parcela_nota_saida
               from nota_saida_parcela nsp
               where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 1) > 0
   then
  
     '<dup><nDup>'+
     ltrim(rtrim(isnull( (select top 1 nsp.cd_ident_parc_nota_saida
                          from nota_saida_parcela nsp with (nolock) 
                          where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 1),'')))+
   '</nDup><dVenc>'+
     isnull(( select top 1 ltrim(rtrim(replace(convert(char,nsp.dt_parcela_nota_saida,102),'.','-')))  
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 1),'') +
   '</dVenc><vDup>'+
     ltrim(rtrim(isnull(( select top 1 isnull(CONVERT(varchar, convert(numeric(14,2),round(case when vl_parcela_nota_saida       > 0 then vl_parcela_nota_saida else null end,6,2)),103),'0.00')
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 1),''))) +
    '</vDup></dup>'                                                  

   else 
     cast('' as varchar)
   end                                                               as 'Y_DUP1',

   -------------------------------------------------------------------------------------------------
   --Parcela 2
   -------------------------------------------------------------------------------------------------

   case when ( select top 1 nsp.cd_parcela_nota_saida
               from nota_saida_parcela nsp with (nolock) 
               where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 2) > 0
   then
  
     '<dup><nDup>'+
     ltrim(rtrim(isnull( (select top 1 nsp.cd_ident_parc_nota_saida
                          from nota_saida_parcela nsp
                          where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 2),'')))+
   '</nDup><dVenc>'+
     isnull(( select top 1 ltrim(rtrim(replace(convert(char,nsp.dt_parcela_nota_saida,102),'.','-')))  
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 2),'') +
   '</dVenc><vDup>'+
     ltrim(rtrim(isnull(( select top 1 isnull(CONVERT(varchar, convert(numeric(14,2),round(case when vl_parcela_nota_saida       > 0 then vl_parcela_nota_saida else null end,6,2)),103),'0.00')
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 2),''))) +
    '</vDup></dup>'                                                  

   else 
     cast('' as varchar)
   end                                                               as 'Y_DUP2',

   -------------------------------------------------------------------------------------------------
   --Parcela 3
   -------------------------------------------------------------------------------------------------

   case when ( select top 1 nsp.cd_parcela_nota_saida
               from nota_saida_parcela nsp
               where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 3) > 0
   then
  
     '<dup><nDup>'+
     ltrim(rtrim(isnull( (select top 1 nsp.cd_ident_parc_nota_saida
                          from nota_saida_parcela nsp with (nolock) 
                          where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 3),'')))+
   '</nDup><dVenc>'+
     isnull(( select top 1 ltrim(rtrim(replace(convert(char,nsp.dt_parcela_nota_saida,102),'.','-')))  
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 3),'') +
   '</dVenc><vDup>'+
     ltrim(rtrim(isnull(( select top 1 isnull(CONVERT(varchar, convert(numeric(14,2),round(case when vl_parcela_nota_saida       > 0 then vl_parcela_nota_saida else null end,6,2)),103),'0.00')
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 3),''))) +
    '</vDup></dup>'                                                  

   else 
     cast('' as varchar)
   end                                                               as 'Y_DUP3',


   -------------------------------------------------------------------------------------------------
   --Parcela 4
   -------------------------------------------------------------------------------------------------

   case when ( select top 1 nsp.cd_parcela_nota_saida
               from nota_saida_parcela nsp
               where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 4) > 0
   then
  
     '<dup><nDup>'+
     ltrim(rtrim(isnull( (select top 1 nsp.cd_ident_parc_nota_saida
                          from nota_saida_parcela nsp
                          where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 4),'')))+
   '</nDup><dVenc>'+
     isnull(( select top 1 ltrim(rtrim(replace(convert(char,nsp.dt_parcela_nota_saida,102),'.','-')))  
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 4),'') +
   '</dVenc><vDup>'+
     ltrim(rtrim(isnull(( select top 1 isnull(CONVERT(varchar, convert(numeric(14,2),round(case when vl_parcela_nota_saida       > 0 then vl_parcela_nota_saida else null end,6,2)),103),'0.00')
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 4),''))) +
    '</vDup></dup>'                                                  

   else 
     cast('' as varchar)
   end                                                               as 'Y_DUP4',

   -------------------------------------------------------------------------------------------------
   --Parcela 5
   -------------------------------------------------------------------------------------------------

   case when ( select top 1 nsp.cd_parcela_nota_saida
               from nota_saida_parcela nsp
               where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 5) > 0
   then
  
     '<dup><nDup>'+
     ltrim(rtrim(isnull( (select top 1 nsp.cd_ident_parc_nota_saida
                          from nota_saida_parcela nsp
                          where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 5),'')))+
   '</nDup><dVenc>'+
     isnull(( select top 1 ltrim(rtrim(replace(convert(char,nsp.dt_parcela_nota_saida,102),'.','-')))  
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 5),'') +
   '</dVenc><vDup>'+
     ltrim(rtrim(isnull(( select top 1 isnull(CONVERT(varchar, convert(numeric(14,2),round(case when vl_parcela_nota_saida       > 0 then vl_parcela_nota_saida else null end,6,2)),103),'0.00')
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida and nsp.cd_parcela_nota_saida = 5),''))) +
    '</vDup></dup>'                                                  

   else 
     cast('' as varchar)
   end                                                               as 'Y_DUP5',



   -------------------------------------------------------------------- 

   '</cobr'                                          as 'Y_DADOS_FEC',


   cast(ns.ds_obs_compl_nota_saida as varchar(8000))                as complemento,

   isnull(t.ic_icms_transportadora,'S')                             as ic_icms_transportadora

   --Tabela temporária
   --cast(isnull(nsf.ds_linha_fatura,'') as varchar(8000))                     as Y_DADOS

--select * from nota_saida_fatura
 
from
  nota_saida ns                           with (nolock) 
  left outer join tipo_pagamento_frete tp with (nolock) on tp.cd_tipo_pagamento_frete = ns.cd_tipo_pagamento_frete
  left outer join transportadora t        with (nolock) on t.cd_transportadora        = ns.cd_transportadora
  left outer join cidade cid              with (nolock) on cid.cd_cidade              = t.cd_cidade           
  left outer join estado est              with (nolock) on est.cd_estado              = t.cd_estado
  left outer join vw_destinatario vw      with (nolock) on vw.cd_tipo_destinatario    = ns.cd_tipo_destinatario and
                                                           vw.cd_destinatario         = ns.cd_cliente

  --left outer join nota_saida_fatura nsf   with (nolock) on nsf.cd_nota_saida          = ns.cd_nota_saida

--select * from transportadora
--select * from tipo_pagamento_frete
--select * from nota_saida
--select * from cidade
--select * from campo_arquivo_magnetico

