
--pr_dados_produto_EGIS
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Retorno de Dados de Produto de Orçamento
--Data         : 21.08.2001
--Atualizado   : 18.11.2002
-----------------------------------------------------------------------------------
CREATE procedure pr_dados_produto_EGIS

@cod_ant char(15)

as

select a.cd_grupo_produto          as 'Grupo',
       a.cd_produto                as 'Codigo',
       a.nm_fantasia_produto       as 'Produto',
       a.cd_mascara_produto        as 'CodigoCompleto',
       a.nm_produto                as 'Descricao',
       e.qt_saldo_reserva_produto  as 'Saldo',
       a.vl_produto                as 'Preco',
       a.qt_espessura_produto      as 'Espessura',
       a.qt_largura_produto        as 'Largura',
       a.qt_comprimento_produto    as 'Comprimento',
--     isnull(a.opcaocq,'N')       as 'Acessorio',
       cast('N' as char(1))        as 'Acessorio',
       d.ds_produto_tecnica        as 'DescricaoTecnica',
       b.ds_produto_garantia       as 'Garantia',
       c.pc_ipi_classificacao      as 'Ipi'
from 
   egissql.dbo.produto a, 
   egissql.dbo.produto_garantia b, 
   egissql.dbo.classificacao_fiscal c, 
   egissql.dbo.produto_tecnica d,
   egissql.dbo.produto_saldo e,
   egissql.dbo.produto_fiscal f   
where
   a.nm_fantasia_produto = @cod_ant and
   a.cd_produto *= b.cd_produto and
   a.cd_produto = f.cd_produto and
   f.cd_classificacao_fiscal *= c.cd_classificacao_fiscal and
   a.cd_produto *= d.cd_produto and
   a.cd_produto = e.cd_produto and
   e.cd_fase_produto = 3



