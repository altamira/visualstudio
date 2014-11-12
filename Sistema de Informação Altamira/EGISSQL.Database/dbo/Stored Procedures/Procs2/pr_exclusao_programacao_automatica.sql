
-------------------------------------------------------------------------------
--sp_helptext pr_exclusao_programacao_automatica
-------------------------------------------------------------------------------
--pr_exclusao_programacao_automatica
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Exclusão completa da Programação e acerto do retorno do 
--                  Processo de Produção
--Data             : 05.09.2007
--Alteração        :  28.09.2007 - Situação da Op no Processo - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_exclusao_programacao_automatica
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

select
  cd_processo
into
  #processo
from 
 Processo_Producao
where 
 dt_processo between @dt_inicial and @dt_final

--select * from #processo

declare @cd_processo int

while exists ( select top 1 cd_processo from #Processo )
begin

  select top 1 
    @cd_processo = isnull(cd_processo,0)
  from 
   #Processo

  --select @cd_processo

  if @cd_processo>0
  begin 
    exec pr_exclusao_programacao_processo @cd_processo
  end

  update
    Processo_Producao
  set cd_usuario_mapa_processo  = null,
      dt_prog_processo          = null,
      dt_entrega_prog_processo  = null,
      nm_situacao_op            = null,
      ic_prog_mapa_processo     = 'N'

  where
    cd_processo = @cd_processo

  delete from #processo where cd_processo = @cd_processo

end

--select * from programacao
--select * from programacao_composicao

