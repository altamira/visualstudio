
-------------------------------------------------------------------------------
--sp_helptext pr_importacao_campo_arquivo_magnetico
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 20.06.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_importacao_campo_arquivo_magnetico
@cd_arquivo_magnetico_origem   int,
@cd_arquivo_magnetico_destino  int,
@cd_sessao_documento           int 
as

--select * from campo_arquivo_magnetico

select
  @cd_sessao_documento         as cd_sessao_documento,
  cd_campo_magnetico,
  cd_tipo_campo,
  qt_tamanho,
  qt_decimal,
  ic_arredondamento_valor,
  cd_inicio_posicao,
  cd_fim_posicao,
  nm_conteudo_fixo,
  nm_tabela_origem,
  nm_campo_origem,
  nm_campo_chave,
  nm_conteudo_chave,
  nm_tabela_ligacao,
  nm_campo_ligacao,
  cd_usuario,
  dt_usuario,
  nm_instrucao_sql,
  nm_campo,
  ds_campo,
  @cd_arquivo_magnetico_destino as cd_arquivo_magnetico,
  ic_groupby,
  ic_valor_digitado,
  cd_posicao_orderby,
  ic_incluir_no_arquivo,
  ic_mostrar_no_relatorio,
  ic_totalizacao_grid

into
 #campo_arquivo_magnetico
from 
  campo_arquivo_magnetico
where
 cd_arquivo_magnetico = @cd_arquivo_magnetico_origem

insert into
  campo_arquivo_magnetico 
select
  *
from
  #campo_arquivo_magnetico

select * from #campo_arquivo_magnetico

drop table #campo_arquivo_magnetico

