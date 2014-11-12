
CREATE VIEW vw_nfe_servico_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_servico_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Detalhe Produto/Serviço da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from nota_saida_item

select
  'U'                                                         as 'ISSQN',
  isnull(nsi.vl_total_item,0)                                 as 'vBC',
  isnull(nsi.pc_iss_servico,0)                                as 'vAliq',
  isnull(nsi.vl_iss_servico,0)                                as 'vISSQN',
  cid.cd_cidade_ibge                                          as 'cMunFG',
  ms.cd_mascara_modalidade                                    as 'cListServ'
      
--select * from dI  

from
  nota_saida ns                           with (nolock) 
  inner join nota_saida_item nsi          with (nolock) on nsi.cd_nota_saida          = ns.cd_nota_saida
  left outer join egisadmin.dbo.empresa e with (nolock) on e.cd_empresa               = dbo.fn_empresa()
  left outer join Cidade cid              with (nolock) on cid.cd_cidade              = e.cd_cidade
  left outer join Servico s               with (nolock) on s.cd_servico               = nsi.cd_servico
  left outer join Modalidade_Servico ms   with (nolock) on ms.cd_modalidade_servico   = s.cd_modalidade_servico

