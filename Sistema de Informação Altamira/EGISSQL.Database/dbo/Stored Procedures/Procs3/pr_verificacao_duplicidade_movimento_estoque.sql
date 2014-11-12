
-------------------------------------------------------------------------------
--sp_helptext pr_verificacao_duplicidade_movimento_estoque
-------------------------------------------------------------------------------
--pr_verificacao_duplicidade_movimento_estoque
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Verificação da Duplicidade de Movimento de Estoque
--
--Data             : 01.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_verificacao_duplicidade_movimento_estoque
@dt_inicial datetime = '',
@dt_final   datetime = ''
as


--select * from movimento_estoque

select
  max(me.dt_movimento_estoque) as dt_movimento_estoque,
  me.cd_tipo_movimento_estoque,
  me.cd_documento_movimento,
  me.cd_item_documento,
  me.cd_tipo_documento_estoque,
  me.qt_movimento_estoque,
  me.ic_mov_movimento,
  me.cd_fornecedor,   
  me.cd_produto,
  me.cd_fase_produto,
  me.ic_nf_complemento,
  count(me.cd_movimento_estoque ) as qtd_lancamento  
into
  #MovimentoDuplicado

from
  movimento_estoque me
where
  me.dt_movimento_estoque between @dt_inicial and @dt_final

group by
  me.cd_tipo_movimento_estoque,
  me.cd_documento_movimento,
  me.cd_item_documento,
  me.cd_tipo_documento_estoque,
  me.qt_movimento_estoque,
  me.ic_mov_movimento,
  me.cd_fornecedor,   
  me.cd_produto,
  me.cd_fase_produto,
  me.ic_nf_complemento  


select
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  M.*
from
  #MovimentoDuplicado M
  left outer join produto p on p.cd_produto = m.cd_produto
where
  m.qtd_lancamento > 1

order by
  p.cd_mascara_produto,
  m.cd_documento_movimento


