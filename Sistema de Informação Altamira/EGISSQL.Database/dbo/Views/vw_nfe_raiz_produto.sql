
CREATE VIEW vw_nfe_raiz_produto
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_raiz_nota_saida
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração do Arquivo Texto para Exportar o Cadastro de Produto
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

select
  'PRODUTO' as PRODUTO,
  count(*)  as qtd_produto
from
  produto p
  inner join status_produto s                       with (nolock) on s.cd_status_produto        = p.cd_status_produto
where
  isnull(s.ic_bloqueia_uso_produto,'N') = 'N' 

 
