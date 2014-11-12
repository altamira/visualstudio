
-------------------------------------------------------------------------------
--sp_helptext pr_grava_movimento_terceiro_nota_saida
-------------------------------------------------------------------------------
--pr_grava_movimento_terceiro_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Grava a Tabela de Movimento de Terceiro
--Data             : 23.06.2010
--Alteração        : 23.06.2010 - Ajustes Diversos - Carlos / Amanda
--
--
------------------------------------------------------------------------------
create procedure pr_grava_movimento_terceiro_nota_saida
@cd_nota_saida int = 0

as

declare @cd_movimento_produto_terceiro int
declare @cd_movimento_origem           int


--set @cd_nota_saida = 58871

--select * from nota_saida_Item where cd_nota_saida = 58863

--movimento_produto_terceiro

-- select * from movimento_produto_terceiro where cd_nota_saida = 58866
-- select * from movimento_produto_terceiro where cd_nota_entrada  = 12471
-- select * from movimento_produto_terceiro where cd_movimento_produto_terceiro = 116996

-- select
--   *
-- from
--   movimento_produto_terceiro
-- where
--   cd_nota_entrada = 12036 and cd_item_nota_fiscal 
-- 


select
  @cd_movimento_produto_terceiro = max(cd_movimento_produto_terceiro)
from
  movimento_produto_terceiro with (nolock) 

  
select
  @cd_movimento_produto_terceiro   as cd_movimento_produto_terceiro,
  i.cd_produto,
  null                             as cd_nota_entrada,
  n.cd_serie_nota                  as cd_serie_nota_fiscal,
  n.cd_tipo_destinatario,
  n.cd_cliente                     as cd_destinatario,
  n.cd_operacao_fiscal,
  n.cd_nota_saida,
  n.dt_nota_saida                  as dt_movimento_terceiro,
  i.qt_item_nota_saida             as qt_movimento_terceiro,
  i.cd_usuario,
  i.dt_usuario,
  i.cd_item_nota_saida             as cd_item_nota_fiscal,
  'S'                              as ic_tipo_movimento,
  t.cd_movimento_produto_terceiro  as cd_movimento_origem,
  null                             as cd_fase_produto_terceiro,
  null                             as cd_tipo_documento_terceiro,
  identity(int,1,1)                as cd_documento_terceiro,
  n.nm_fantasia_nota_saida         as nm_destinatario,
  null                             as nm_historico_movimento,
  null                             as cd_tipo_movimento_terceiro,
  'S'                              as ic_movimento_terceiro

into
  #movimento_produto_terceiro

from

  nota_saida_item i                            with (nolock) 

  left outer join nota_saida n                 with (nolock) on n.cd_nota_saida        = i.cd_nota_saida
  left outer join movimento_produto_terceiro t with (nolock) on t.cd_produto           = i.cd_produto      and
                                                                t.cd_nota_entrada      = i.cd_nota_entrada and
                                                                t.cd_item_nota_fiscal  = i.cd_item_nota_entrada

  left outer join operacao_fiscal opf          with (nolock) on opf.cd_operacao_fiscal = i.cd_operacao_fiscal

where
  i.cd_nota_saida     = @cd_nota_saida
  and i.cd_nota_saida not in ( select x.cd_nota_saida 
                               from
                                 movimento_produto_terceiro x with (nolock) 
                               where
                                 x.cd_nota_saida         = i.cd_nota_saida      and
                                 x.cd_item_nota_fiscal   = i.cd_item_nota_saida and
                                 x.qt_movimento_terceiro = i.qt_item_nota_saida  )

  and isnull(opf.ic_terceiro_op_fiscal,'N') = 'S'  --Terceiro
  and isnull(opf.ic_estoque_op_fiscal,'N')  = 'S'  --Movimento Estoque

--select * from operacao_fiscal

update
  #movimento_produto_terceiro
set
  cd_movimento_produto_terceiro = cd_movimento_produto_terceiro + cd_documento_terceiro

-- select 
--   *
-- from
--   #movimento_produto_terceiro

insert into
  movimento_produto_terceiro
select
  *
from
  #movimento_produto_terceiro
  

update
  movimento_produto_terceiro
set
 cd_documento_terceiro = null  
where
 cd_movimento_produto_terceiro in ( select cd_movimento_produto_terceiro from #movimento_produto_terceiro )


--select * from  movimento_produto_terceiro where cd_movimento_produto_terceiro = 116996


-- insert into
--   movimento_produto_terceiro
-- select
--   *
-- from
--   #movimento_produto_terceiro
--   
-- 

drop table #movimento_produto_terceiro


