

/****** Object:  Stored Procedure dbo.pr_dados_consulta    Script Date: 13/12/2002 15:08:26 ******/
--pr_dados_consulta
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Retorno de Dados de Consulta a ser orçada
--Data         : 28.06.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_dados_consulta
@cd_consulta int,
@cd_item int
as
select a.fan_cli   as 'Cliente',
       a.datacon   as 'Data',
       a.contato   as 'Contato',
       a.ncrep     as 'ConsultaRepres',
       a.ddd_cli   as 'DDD',
       a.fon_cli   as 'Fone',
       b.item      as 'Item', 
       b.descricao as 'Descricao',
       b.qt        as 'Qtd.',
       b.precolist as 'Orcado',
       b.preco     as 'Preco',
       b.nduteis   as 'DiasUteis',
       b.almoxit   as 'Grupo',
       b.cod_ant   as 'Produto'
from 
   cadvdi a, cadivdi b
where
   a.numero = @cd_consulta and
   a.numero = b.numeroit   and
   b.item = @cd_item


