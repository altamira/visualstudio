
CREATE VIEW vw_nfe_medicamento_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_medicamento_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Local da Retirada da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
--------------------------------------------------------------------------------------------
as


select
  'K'                                                            as 'med',
  
  ns.dt_nota_saida,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida,

  isnull(CONVERT(varchar, convert(numeric(11,3),round(nsi.qt_item_nota_saida,6,3)),103),'0.000') as qt_item_nota_saida,

  --nsi.qt_item_nota_saida,
  nsi.cd_lote_item_nota_saida,

  case when isnull(nsi.cd_lote_item_nota_saida,'')<>'' then
    ltrim(rtrim(nsi.cd_lote_item_nota_saida))
  else
   ''
  end                                                                         as 'Lote',

  lp.dt_entrada_lote_produto,
  lp.dt_inicial_lote_produto,
  lp.dt_final_lote_produto,

  ltrim(rtrim(replace(convert(char,lp.dt_entrada_lote_produto,102),'.','-'))) as Fabricacao,
  ltrim(rtrim(replace(convert(char,lp.dt_final_lote_produto,102),'.','-')))   as Validade,


  --0.00                                                                        as preco_maximo
  isnull(CONVERT(varchar, convert(numeric(14,2),round(0.00,6,2)),103),'0.00')   as preco_maximo
  

from
  nota_saida ns                                     with (nolock) 
  inner join nota_saida_item nsi                    with (nolock) on nsi.cd_nota_saida             = ns.cd_nota_saida
  left outer join lote_produto lp                   with (nolock) on lp.nm_ref_lote_produto        = nsi.cd_lote_item_nota_saida

--select * from lote_produto
--select cd_lote_produto,cd_lote_item_nota_saida,* from nota_saida_item

