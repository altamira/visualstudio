

/****** Object:  Stored Procedure dbo.pr_dados_produto    Script Date: 13/12/2002 15:08:26 ******/
--pr_dados_produto
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Retorno de Dados de Produto de Orçamento
--Data         : 21.08.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_dados_produto
@cod_ant char(15)
as
select a.almox     as 'Grupo',
       a.codigo    as 'Codigo',
       a.cod_ant   as 'Produto',
       a.almox +
       a.codigo    as 'CodigoCompleto',
       a.descricao as 'Descricao',
       a.saldo     as 'Saldo',
       a.preco     as 'Preco',
       a.espessura as 'Espessura',
       a.largura   as 'Largura',
       a.comprim   as 'Comprimento',
       isnull(a.opcaocq,'N') as 'Acessorio' 
from 
   ftprod a
where
   a.cod_ant = @cod_ant


