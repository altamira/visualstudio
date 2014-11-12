

-------------------------------------------------------------------------------
--pr_acerto_config_layout_nota
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Acerto dos novos atributos criados na configuração lay-out
--                   de Notas Fiscais
--Data             : 19.08.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_acerto_config_layout_nota
as

--select * from campo_nota_fiscal
--select * from nota_saida_layout

--Campos da Nota fiscal

update
  campo_nota_fiscal
set
  ic_fixo_campo_nota_fiscal = 'N'
where
  isnull(ic_fixo_campo_nota_fiscal,'N')  is null


--Lay_out da Nota Fiscal

update
  nota_saida_layout
set
  ic_div_linha_campo = 'N'
where
  isnull(ic_div_linha_campo,'N') is null


