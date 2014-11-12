
CREATE VIEW vw_in86_produto_servico
--vw_in86_produto_servico
-------------------------------------------------------------
--GBS - Global Business Solution	                       2004
--Stored Procedure	: Microsoft SQL Server               2004
--Autor(es)		      : André de Oliveira Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Código de Produto e Serviços utilizado nos Arquivos Magnéticos.
--                    São todos que estão nas notas de entrada e saída 
--                    4.9.5
--Data			        : 24/03/2004
-------------------------------------------------------------
as

select 
  Data_Atualizacao       as 'DATAATUALIZACAO',
  cd_produto_servico     as 'CODIGO',
  Produto_Servico        as 'DESCRICAO'

from
  vw_in86_Produtos_Entrada_Saida

where
  cd_produto_servico is not null


