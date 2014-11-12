
CREATE VIEW vw_nfe_cofins_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_cofins_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do COFINS da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

select
  ns.dt_nota_saida,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida,
  'S'                                                            as 'COFINS',
  rtrim(ltrim(cast(ti.cd_digito_tributacao_cofins as varchar(80))))            as 'CST',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item > 0 then nsi.vl_total_item else null end,6,2)),103),'')      as 'vBC',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.pc_cofins > 0 then 
                                                        nsi.pc_cofins 
                                                      else
                                                        case when nsi.vl_cofins > 0 then
                                                          isnull(CONVERT(varchar, convert(numeric(14,2),round(((nsi.vl_cofins * 100)/(nsi.vl_total_item)),6,2)),103),'')   
                                                        else
                                                          null
                                                        end 
                                                      end,6,2)),103),'')   as 'pCOFINS',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_cofins > 0 then nsi.vl_cofins else null end,6,2)),103),'')          as 'vCOFINS',
  'S03'                                                          as 'COFINSQtde',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.qt_item_nota_saida > 0 then nsi.qt_item_nota_saida else null end,6,2)),103),'') as 'qBCProd',

  ''                                                           as 'vAliqProd',
  'S04'                                                            as 'COFINSNT',
  'S05'                                                            as 'COFINSOutr'


from
  nota_saida_item nsi                               with (nolock)
  inner join nota_saida ns                          with (nolock) on ns.cd_nota_saida            = nsi.cd_nota_saida
  left outer join produto_fiscal pf                 with (nolock) on pf.cd_produto               = nsi.cd_produto
  left outer join tributacao t                      with (nolock) on t.cd_tributacao             = pf.cd_tributacao
  left outer join tributacao_cofins ti              with (nolock) on ti.cd_tributacao_cofins     = t.cd_tributacao_cofins 
   

--select * from nota_saida_item

