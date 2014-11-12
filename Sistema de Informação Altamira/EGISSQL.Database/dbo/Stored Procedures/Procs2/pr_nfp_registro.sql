
CREATE PROCEDURE pr_nfp_registro
------------------------------------------------------------------------------------        
--pr_nfp_registro        
------------------------------------------------------------------------------------        
--GBS - Global Business Solution                                        2008        
------------------------------------------------------------------------------------        
--Stored Procedure : Microsoft SQL Server 2000        
--Autor(es)        : Douglas de Paula Lopes        
--Banco de Dados   : EGISSQL        
--Objetivo         : Nota Fiscal Paulista        
--Data             : 25/06/2008            
--Atualização      :         
--03.07.2008 - ajustes gerais - carlos fernandes   
--28.10.2008 - Finalizando layout da NFE - Douglas de Paula Lopes     
--10.08.2009 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------------        
@ic_parametro  int = 0,    
@dt_inicial    datetime,    
@dt_final      datetime,    
@cd_nota_saida int = 0    
as        
    
if @ic_parametro = 0    
begin    

select     
  ns.cd_nota_saida    
from        
  Nota_Saida ns                           with (nolock)       
  inner join Nota_Saida_item        nsi   with (nolock) on (nsi.cd_nota_saida          = ns.cd_nota_saida and      
                                                            nsi.cd_item_nota_saida = (select       
                                                                                        min(cd_item_nota_saida)       
                                                                                      from       
                                                                                        nota_saida_item      
                                                                                      where       
                                                                                        cd_nota_saida = ns.cd_nota_saida))         
  left outer join pedido_venda_item pvi   with (nolock) on pvi.cd_pedido_venda        = nsi.cd_pedido_venda and    
                                                           pvi.cd_item_pedido_venda   = nsi.cd_item_pedido_venda    
  left outer join pedido_venda pv         with (nolock) on pv.cd_pedido_venda         = pvi.cd_pedido_venda    
  left outer join tipo_pedido tp          with (nolock) on tp.cd_tipo_pedido          = pv.cd_tipo_pedido and    
                                                           isnull(tp.ic_imposto_tipo_pedido,'N') = 'S'    
  left outer join Serie_Nota_Fiscal snf   with (nolock) on snf.cd_serie_nota_fiscal   = ns.cd_serie_nota        
  left outer join classificacao_fiscal cf with (nolocK) on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal      
  left outer join operacao_fiscal opf     with (nolock) on opf.cd_operacao_fiscal     = ns.cd_operacao_fiscal    
where    
  ns.dt_nota_saida between @dt_inicial and @dt_final and    
  ns.dt_cancel_nota_saida is null and    
  ns.cd_nota_saida = case when isnull(@cd_nota_saida,0) = 0 then ns.cd_nota_saida else @cd_nota_saida end and    
  ns.cd_nota_saida = (select top 1 cd_nota_saida from nota_saida_item where cd_nota_saida = ns.cd_nota_saida)    
  and isnull(ns.ic_nfp_nota_saida,'S')='S'

end    
else if @ic_parametro = 1    
begin       
  select      
    cast('10|' +     
    cast('1,00' as varchar)                                                  +'|'+       
    isnull(dbo.fn_Formata_Mascara('00000000000000',(select         
                                                      cd_cgc_empresa         
                                                    from         
                                                      egisadmin.dbo.empresa         
                                                    where         
                                                       cd_empresa = dbo.fn_empresa())),'') +'|'+    
    isnull(rtrim(ltrim(convert(char,cast(@dt_inicial as datetime),103))),'')                +'|'+      
    isnull(rtrim(ltrim(convert(char,cast(@dt_final as datetime),103))),'') as varchar(8000))       as CONC,
    cast('' as varchar(8000))   as CONC1
        
end      
else if @ic_parametro = 2    
begin    
select    
--   cast('20|'+    
--   case when ns.dt_cancel_nota_saida is not null then        
--     'C'        
--   else        
--     'I'               
--   end                                                                                                       +'|'+        
--   case when ns.dt_cancel_nota_saida is not null then        
--     isnull(cast(ns.nm_mot_cancel_nota_saida as varchar(230)),' ')        
--   else        
--     ''        
--   end                                                                                                       +'|'+        
--   isnull(cast(rtrim(ltrim(ns.nm_operacao_fiscal)) as varchar(60)),' ')                                                     +'|'+        
--   '000'                                                                                                     +'|'+        
--   isnull(cast(ns.cd_nota_saida as varchar(10)),'')                                                          +'|'+        
--   isnull(rtrim(ltrim(convert(char,ns.dt_nota_saida,103))) + ' ' +        
--   rtrim(ltrim(convert(char,ns.dt_nota_saida,108))),'')                                                      +'|'+        
--   isnull(rtrim(ltrim(convert(char,ns.dt_nota_saida,103))) + ' ' +        
--   rtrim(ltrim(convert(char,ns.dt_nota_saida,108))),'')                                                      +'|'+    
--   case when ns.cd_tipo_operacao_fiscal = 2 then '1' else '0' end                                            +'|'+    
--   isnull(cast(replace(opf.cd_mascara_operacao,'.','') as varchar(4)),'')                                    +'|'+    
--   cast('' as varchar(14))                                                                                   +'|'+          
--   isnull((select nm_inscricao_municipal from egisadmin.dbo.empresa where cd_empresa = dbo.fn_empresa()),' ') +'|'+    
--   case when lower(ns.nm_pais_nota_saida) = 'brasil' then        
--     isnull(cast(ns.cd_cnpj_nota_saida as varchar(14)),'0')                                                
--   else
--     '00000000000000'
--   end     +'|'+     
--   isnull(cast(ns.nm_razao_social_nota as varchar(60)),' ')                                                   +'|'+       
-- --  isnull(cast(ns.nm_endereco_nota_saida  as varchar(60)),' ')                                                +'|'+ 
--   case when rtrim(ltrim(ns.nm_endereco_nota_saida)) = '' then ' ' else isnull(cast(ns.nm_endereco_nota_saida as varchar(60)),' ') end +'|'+      
-- --  isnull(ltrim(rtrim(cast(ns.cd_numero_end_nota_saida as varchar(60)))),'0')                                     +'|'+
--   case when rtrim(ltrim(ns.cd_numero_end_nota_saida)) = '' then '00' else isnull(cast(ns.cd_numero_end_nota_saida as varchar(60)),'00') end +'|'+       
--   isnull(cast(ns.nm_compl_endereco_nota as varchar(60)),' ')                                                 +'|'+       
--   case when rtrim(ltrim(ns.nm_bairro_nota_saida)) = '' then ' ' else isnull(cast(ns.nm_bairro_nota_saida as varchar(60)),' ') end +'|'+    
--   case when lower(ns.nm_pais_nota_saida) = 'brasil' then        
--     isnull(cast(ns.nm_cidade_nota_saida as varchar(60)),' ')                
--   else        
--     'EXTERIOR'         
--   end                                                                                                       +'|'+      
--   case when lower(ns.nm_pais_nota_saida) = 'brasil' then        
--     isnull(cast(ns.sg_estado_nota_saida as varchar(2)),' ')                
--   else        
--     'EX'         
--   end                                                                                                       +'|'+      
--   case when lower(ns.nm_pais_nota_saida) = 'brasil' then isnull(cast(replace(ns.cd_cep_nota_saida, '-', '') as varchar(10)),'0') else '' end +'|'+        
--   isnull(cast(ns.nm_pais_nota_saida as varchar(60)),'0')                                                     +'|'+        
-- 
--   --Telefone
--   case when lower(ns.nm_pais_nota_saida) = 'brasil' then
--     case when SUBSTRING(ns.cd_ddd_nota_saida,1,1) = '0' then        
--       isnull(cast(SUBSTRING(ns.cd_ddd_nota_saida,2,2) + replace(ns.cd_telefone_nota_saida,'-','') as varchar(10)),'0')        
--     else        
--       isnull(cast(replace(ns.cd_ddd_nota_saida,' ','') + replace(ns.cd_telefone_nota_saida,'-','') as varchar(10)),'0')        
--     end
--   else
--     ''
--   end                                                                                                       +'|'+        
--   isnull(cast(ns.cd_inscest_nota_saida as varchar(14)),'0') as varchar(8000))                                as CONC         
  --

  rtrim(ltrim(cast('20|'+    
  case when ns.dt_cancel_nota_saida is not null then        
    'C'        
  else        
    'I'               
  end                                                                                                       +'|'+        
  case when ns.dt_cancel_nota_saida is not null then        
    isnull(cast(ns.nm_mot_cancel_nota_saida as varchar(230)),' ')        
  else        
    ''        
  end                                                                                                       +'|'+        
  isnull(cast(rtrim(ltrim(ns.nm_operacao_fiscal)) as varchar(60)),' ')                                                     +'|'+        
  '000'                                                                                                     +'|'+        
  isnull(cast(ns.cd_nota_saida as varchar(10)),'')                                                          +'|'+        
  isnull(rtrim(ltrim(convert(char,ns.dt_nota_saida,103))) + ' ' +        
  rtrim(ltrim(convert(char,ns.dt_nota_saida,108))),'')                                                      +'|'+        
  isnull(rtrim(ltrim(convert(char,ns.dt_nota_saida,103))) + ' ' +        
  rtrim(ltrim(convert(char,ns.dt_nota_saida,108))),'')                                                      +'|'+    
  case when ns.cd_tipo_operacao_fiscal = 2 then '1' else '0' end                                            +'|'+    
  isnull(cast(replace(opf.cd_mascara_operacao,'.','') as varchar(4)),'')                                    +'|'+    
  cast('' as varchar(14))                                                                                   +'|'+          
  isnull((select nm_inscricao_municipal from egisadmin.dbo.empresa where cd_empresa = dbo.fn_empresa()),' ') +'|'+    
  case when lower(ns.nm_pais_nota_saida) = 'brasil' then        
    isnull(cast(ns.cd_cnpj_nota_saida as varchar(14)),'0')                                                
  else
    '00000000000000'
  end     +'|'+     
  isnull(cast(ns.nm_razao_social_nota as varchar(60)),' ')                                                   +'|'+       
--  isnull(cast(ns.nm_endereco_nota_saida  as varchar(60)),' ')                                                +'|'+ 
  case when rtrim(ltrim(ns.nm_endereco_nota_saida)) = '' then ' ' else isnull(cast(ns.nm_endereco_nota_saida as varchar(60)),' ') end +'|'+      
--  isnull(ltrim(rtrim(cast(ns.cd_numero_end_nota_saida as varchar(60)))),'0')                                     +'|'+
  case when rtrim(ltrim(ns.cd_numero_end_nota_saida)) = '' then '00' else isnull(cast(ns.cd_numero_end_nota_saida as varchar(60)),'00') end +'|'+       
  isnull(cast(ns.nm_compl_endereco_nota as varchar(60)),' ')                                                 +'|'+       
  case when rtrim(ltrim(ns.nm_bairro_nota_saida)) = '' then ' ' else isnull(cast(ns.nm_bairro_nota_saida as varchar(60)),' ') end +'|'
  as varchar(8000))))                              as CONC,         


  rtrim(ltrim(cast(''+
  case when lower(ns.nm_pais_nota_saida) = 'brasil' then        
    isnull(cast(ns.nm_cidade_nota_saida as varchar(60)),' ')                
  else        
    'EXTERIOR'         
  end                                                                                                       +'|'+      
  case when lower(ns.nm_pais_nota_saida) = 'brasil' then        
    isnull(cast(ns.sg_estado_nota_saida as varchar(2)),' ')                
  else        
    'EX'         
  end                                                                                                       +'|'+      
  case when lower(ns.nm_pais_nota_saida) = 'brasil' then isnull(cast(replace(ns.cd_cep_nota_saida, '-', '') as varchar(10)),'0') else '' end +'|'+        
  isnull(cast(ns.nm_pais_nota_saida as varchar(60)),'0')                                                     +'|'+        

  --Telefone
  case when lower(ns.nm_pais_nota_saida) = 'brasil' then
    case when SUBSTRING(ns.cd_ddd_nota_saida,1,1) = '0' then        
      isnull(cast(SUBSTRING(ns.cd_ddd_nota_saida,2,2) + replace(ns.cd_telefone_nota_saida,'-','') as varchar(10)),'0')        
    else        
      isnull(cast(replace(ns.cd_ddd_nota_saida,' ','') + replace(ns.cd_telefone_nota_saida,'-','') as varchar(10)),'0')        
    end
  else
    ''
  end                                                                                                       +'|'+        
  isnull(cast(ns.cd_inscest_nota_saida as varchar(14)),'0') as varchar(8000))))                              as CONC1         


from        
  Nota_Saida ns                           with (nolock)       
  inner join Nota_Saida_item        nsi   with (nolock) on (nsi.cd_nota_saida          = ns.cd_nota_saida and      
                                                            nsi.cd_item_nota_saida = (select       
                                             min(cd_item_nota_saida)       
                                                                                      from       
                                                                                        nota_saida_item      
                                                                                      where       
                                                                                        cd_nota_saida = ns.cd_nota_saida))         
  left outer join pedido_venda_item pvi   with (nolock) on pvi.cd_pedido_venda        = nsi.cd_pedido_venda and    
                                                           pvi.cd_item_pedido_venda   = nsi.cd_item_pedido_venda    
  left outer join pedido_venda pv         with (nolock) on pv.cd_pedido_venda         = pvi.cd_pedido_venda    
  left outer join tipo_pedido tp          with (nolock) on tp.cd_tipo_pedido          = pv.cd_tipo_pedido and    
                                                           isnull(tp.ic_imposto_tipo_pedido,'N') = 'S'    
  left outer join Serie_Nota_Fiscal snf   with (nolock) on snf.cd_serie_nota_fiscal   = ns.cd_serie_nota        
  left outer join classificacao_fiscal cf with (nolocK) on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal      
  left outer join operacao_fiscal opf     with (nolock) on opf.cd_operacao_fiscal     = ns.cd_operacao_fiscal    
where    
  ns.dt_nota_saida between @dt_inicial and @dt_final and    
  ns.cd_nota_saida = case when isnull(@cd_nota_saida,0) = 0 then ns.cd_nota_saida else @cd_nota_saida end    
  and isnull(ns.ic_nfp_nota_saida,'S')='S'

end     
else if @ic_parametro = 3    
begin    
select     
  cast('30|' +     
  isnull(cast(nsi.cd_mascara_produto as varchar(60)),'')                  +'|'+           
--  isnull(ltrim(cast(p.nm_produto as varchar(120))),'')                    +'|'+   
  case when rtrim(ltrim(p.nm_produto)) = '' then ' ' else isnull(ltrim(rtrim(cast(p.nm_produto as varchar(120)))),' ') end +'|'+                   
  case when lower(nsi.ic_tipo_nota_saida_item) = 'p' then          
    isnull(cast(cf.cd_mascara_classificacao as varchar(8)),'')          
  else          
    ''          
  end                                                          +'|'+                                                
--  isnull(rtrim(cast(um.sg_unidade_medida as varchar(6))),'')                     +'|'+     
  case when rtrim(ltrim(um.sg_unidade_medida)) = '' then 'UN' else isnull(ltrim(rtrim(cast(um.sg_unidade_medida as varchar(60)))),'UN') end +'|'+                
  isnull(replace(CONVERT(varchar, convert(numeric(14,4),round(nsi.qt_item_nota_saida,6,2)),103),'.',','),'0,0000') +'|'+                 
  isnull(replace(CONVERT(varchar, convert(numeric(14,4),round(nsi.vl_unitario_item_nota,6,2)),103),'.',','),'0,0000') +'|'+                         
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(nsi.vl_total_item,6,2)),103),'.',','),'0,00')       +'|'+          
  isnull(convert(varchar,nsi.cd_situacao_tributaria),'000') +'|'+                        
  isnull(replace(CONVERT(varchar, convert(numeric(5,2),round(nsi.pc_icms,6,2)),103),'.',','),'0,00') +'|'+          
  isnull(replace(CONVERT(varchar, convert(numeric(5,2),round(nsi.pc_ipi,6,2)),103),'.',','),'0,00')  +'|'+      
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(nsi.vl_ipi,6,2)),103),'.',','),'0,00') as varchar(8000))  as CONC,
  cast('' as varchar(8000))   as CONC1
               
from          
  nota_saida ns                            with (nolock)          
  inner join nota_saida_item           nsi with (nolock) on nsi.cd_nota_saida          = ns.cd_nota_saida          
  left outer join classificacao_fiscal cf  with (nolock) on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal          
  left outer join produto              p   with (nolock) on p.cd_produto               = nsi.cd_produto            
  left outer join unidade_medida       um  with (nolock) on um.cd_unidade_medida       = nsi.cd_unidade_medida     
  left outer join procedencia_produto  pp  with (nolock) on pp.cd_procedencia_produto  = nsi.cd_procedencia_produto
where    
  ns.dt_nota_saida between @dt_inicial and @dt_final and    
  ns.dt_cancel_nota_saida is null and    
  ns.cd_nota_saida = case when isnull(@cd_nota_saida,0) = 0 then ns.cd_nota_saida else @cd_nota_saida end      
  and isnull(ns.ic_nfp_nota_saida,'S')='S'
end    
else if @ic_parametro = 4    
begin    
select     
  '40|' +           
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_bc_icms,6,2)),103),'.',','),'0,00')        +'|'+     
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_icms,6,2)),103),'.',','),'0,00')           +'|'+    
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_bc_subst_icms,6,2)),103),'.',','),'0,00')  +'|'+    
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_icms_subst,6,2)),103),'.',','),'0,00')  +'|'+    
  --isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_produto,6,2)),103),'.',','),'0,00')  +'|'+    
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round((select 
     sum( round(i.vl_total_item,6,2) )
   from
      nota_saida_item i
   where
      ns.cd_nota_saida = i.cd_nota_saida ),6,2)),103),'.',','),'0.00')  +'|'+    
  
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_frete,6,2)),103),'.',','),'0,00')  +'|'+    
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_seguro,6,2)),103),'.',','),'0,00')  +'|'+    
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_desconto_nota_saida,6,2)),103),'.',','),'0,00')  +'|'+    
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_ipi,6,2)),103),'.',','),'0,00')  +'|'+    
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_desp_acess,6,2)),103),'.',','),'0,00')  +'|'+    
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_total,6,2)),103),'.',','),'0,00')  +'|'+       
  cast('0,00' as varchar)                                          +'|'+    
  cast('0,00' as varchar)                                          +'|'+    
  cast('0,00' as varchar)                                         as CONC,
  cast('' as varchar(8000))   as CONC1
        
from        
  nota_saida ns with (nolock)     
where    
  ns.dt_nota_saida between @dt_inicial and @dt_final and    
  ns.dt_cancel_nota_saida is null and    
  ns.cd_nota_saida = case when isnull(@cd_nota_saida,0) = 0 then ns.cd_nota_saida else @cd_nota_saida end      
  and isnull(ns.ic_nfp_nota_saida,'S')='S'
end    
else if @ic_parametro = 5    
begin    
select      
  '50|' +             
  case when ns.cd_tipo_pagamento_frete = 1 then '0' else '1' end                                +'|'+    
  isnull(cast(replace(replace(replace(t.cd_cnpj_transportadora,'-',''),'/',''),'.','') as varchar(14)),'') +'|'+    
  isnull(cast(ltrim(t.nm_transportadora) as varchar(60)),'')                                    +'|'+          
  isnull(cast(t.cd_insc_estadual as varchar(14)),'')                                            +'|'+       
  isnull(cast(ns.nm_endereco_entrega + ' ' + rtrim(ltrim(ns.cd_numero_endereco_ent)) as varchar(60)),'')   +'|'+       
  isnull(cast(ns.nm_cidade_entrega  as varchar(60)),'')                                         +'|'+       
  isnull(cast(ns.sg_estado_entrega  as varchar(2)),'')                                          +'|'+       
  isnull(cast(ns.cd_placa_nota_saida as varchar(8)),'')                                         +'|'+       
  isnull(cast(sg_estado_placa as varchar(2)),'')                                                +'|'+       
  isnull(cast(ns.qt_volume_nota_saida as varchar(15)),'')                                               +'|'+         
  isnull(cast(ns.nm_especie_nota_saida as varchar(60)),'')                                      +'|'+      
  isnull(cast(ns.nm_marca_nota_saida as varchar(60)),'')                                        +'|'+     
  isnull(cast(ns.nm_numero_emb_nota_saida as varchar(60)),'')                                   +'|'+     
  isnull(replace(CONVERT(varchar, convert(numeric(15,3),round(ns.qt_peso_liq_nota_saida,6,2)),103),'.',','),'0,000')   +'|'+           
  isnull(replace(CONVERT(varchar, convert(numeric(15,3),round(ns.qt_peso_bruto_nota_saida,6,2)),103),'.',','),'0,000') as CONC,
  cast('' as varchar(8000))   as CONC1
           
from         
  nota_saida ns        
  left outer join Transportadora t on t.cd_transportadora = ns.cd_transportadora        
  left outer join Cidade c         on c.cd_cidade         = t.cd_cidade           and         
                                      c.cd_estado         = t.cd_estado           and        
                             c.cd_pais           = t.cd_pais        
  left outer join Estado e         on e.cd_estado         = t.cd_estado           and        
                                      e.cd_pais           = t.cd_pais     
where    
  ns.dt_nota_saida between @dt_inicial and @dt_final and    
  ns.dt_cancel_nota_saida is null and    
  ns.cd_nota_saida = case when isnull(@cd_nota_saida,0) = 0 then ns.cd_nota_saida else @cd_nota_saida end    
  and isnull(ns.ic_nfp_nota_saida,'S')='S'
end    
else if @ic_parametro = 6    
begin    
select     
  '60|' +      
  isnull(cast(ns.ds_obs_compl_nota_saida as varchar(256)),'') +'|'+    
  cast('' as varchar(256))    +'|'+    
  cast('' as varchar(8000))   as CONC,
  cast('' as varchar(8000))   as CONC1
      
from      
  nota_saida ns with (nolock)    
where    
  ns.dt_nota_saida between @dt_inicial and @dt_final and    
  ns.dt_cancel_nota_saida is null and    
  ns.cd_nota_saida = case when isnull(@cd_nota_saida,0) = 0 then ns.cd_nota_saida else @cd_nota_saida end    
  and isnull(ns.ic_nfp_nota_saida,'S')='S'
end    
    
 