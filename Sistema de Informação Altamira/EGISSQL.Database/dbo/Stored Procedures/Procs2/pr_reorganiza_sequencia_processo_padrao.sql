
-------------------------------------------------------------------------------
--sp_helptext pr_reorganiza_sequencia_processo_padrao
-------------------------------------------------------------------------------
--pr_reorganiza_sequencia_processo_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Reorganização da sequência do Processo Padrão
--Data             : 17.10.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_reorganiza_sequencia_processo_padrao
@cd_processo_padrao int = 0

as

declare @qt_passo_seq_operacao int

select 
  @qt_passo_seq_operacao = isnull(qt_passo_seq_operacao,10)
from Parametro_Manufatura
where 
  cd_empresa=dbo.fn_empresa()

select
  *,
  cd_composicao_proc_padrao_new = identity(int,1,1),
  0 as seq
into
  #processo_padrao_composicao
from
  processo_padrao_composicao
where
  cd_processo_padrao = @cd_processo_padrao
order by
  cd_composicao_proc_padrao

update
  #processo_padrao_composicao
set
  seq = cd_composicao_proc_padrao_new * @qt_passo_seq_operacao  


select
  *,
  cd_composicao_proc_padrao_new = identity(int,1,1),
  0 as seq
into
  #processo_padrao_texto
from
  processo_padrao_texto
where
  cd_processo_padrao = @cd_processo_padrao
order by
  cd_composicao_proc_padrao

update
  #processo_padrao_texto
set
  seq = cd_composicao_proc_padrao_new * @qt_passo_seq_operacao  

--Mostra as Tabelas

select
  * 
from
  #processo_padrao_composicao


select
  * 
from
  #processo_padrao_texto

--Atualiza a nova Sequência

update
  processo_padrao_composicao
set
  cd_composicao_proc_padrao = x.cd_composicao_proc_padrao_new
from 
  processo_padrao_composicao pp
  inner join #processo_padrao_composicao x on x.cd_processo_padrao = pp.cd_processo_padrao
where
  x.cd_processo_padrao = @cd_processo_padrao



drop table #processo_padrao_composicao
drop table #processo_padrao_texto

--select * from processo_padrao_composicao




