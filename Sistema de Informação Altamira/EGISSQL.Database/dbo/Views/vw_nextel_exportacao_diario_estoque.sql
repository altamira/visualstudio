
CREATE VIEW vw_nextel_exportacao_diario_estoque
------------------------------------------------------------------------------------
--vw_nextel_exportacao_diario_estoque
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Carodos Fernandes
--Banco de Dados	: EGISSQL
--
--Objetivo	        : Remessa do Movimento Diário de Estoque
--
--Data                  : 30.03.2009 
--Atualização           : 
--                        
----------------------------------------------------------------------------------------------------
as

--select * from tipo_movimento_estoque
--select * from manutencao_saldo

select
  p.cd_mascara_produto                        as CODIGO,
  dbo.fn_strzero( (case when tme.ic_mov_tipo_movimento = 'E'
  then
    isnull(ms.qt_produto_manutencao,0) 
  else
    0.00
  end),8)                                         as ENTRADA,

  dbo.fn_strzero( (case when tme.ic_mov_tipo_movimento = 'S'
  then
    isnull(ms.qt_produto_manutencao,0) 
  else
    0.00
  end),8)                                         as SAIDA,

  --date

  cast(cast(datepart(hh,getdate()) as varchar(02)) + ':00' as varchar(5)) as Hora
    
from
  produto                              p     with (nolock)
  inner join Manutencao_Saldo          ms    with (nolock) on ms.cd_produto                 = p.cd_produto 
  left outer join Tipo_Movimento_Estoque tme with (nolock) on tme.cd_tipo_movimento_estoque = ms.cd_tipo_movimento_estoque
 
--select * from manutencao_saldo
--select * from produto_custo
--select * from tabela_preco_produto

--select cast(datepart(hh,getdate()) as varchar(02)) + ':00'
