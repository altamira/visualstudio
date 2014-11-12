
-------------------------------------------------------------------------------
--sp_helptext pr_exclusao_processo_padrao
-------------------------------------------------------------------------------
--pr_exclusao_processo_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Exclusão do Processo Padrão
--Data             : 29.08.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_exclusao_processo_padrao
@cd_processo_padrao int = 0
as

--select * from processo_padrao_composicao
--select * from processo_padrao_produto

if @cd_processo_padrao>0
begin

  delete from processo_padrao_composicao        where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_produto           where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_teste             where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_ferramenta        where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_embalagem         where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_fase              where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_texto             where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_produto_alteracao where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_guia_fio          where cd_processo_padrao = @cd_processo_padrao
  delete from processo_padrao_revisao           where cd_processo_padrao = @cd_processo_padrao
  --delete from processo_padrao                   where cd_processo_padrao = @cd_processo_padrao

end


