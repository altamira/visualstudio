
-------------------------------------------------------------------------------
--pr_geracao_apontamento_operacao_categoria
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Geração Automática da Tabela de Apontamentos por Processo
--
--Data             : 14.01.2006
--Atualizado       : 14.01.2006
--------------------------------------------------------------------------------------------------
create procedure pr_geracao_apontamento_operacao_categoria
@cd_processo int = 0,
@cd_usuario  int = 0
as

--Processo e as Operações
--select * from processo_producao_composicao

select 
 cd_processo,
 cd_item_processo,
 cd_operacao,
 cd_maquina,
 cd_seq_processo
into
 #Processo
from
 Processo_Producao_Composicao
where
 cd_processo = @cd_processo

--Categorias Padrões

select
  p.cd_processo,
  p.cd_item_processo,
  p.cd_maquina,
  p.cd_seq_processo,
  o.cd_operacao,
  o.nm_fantasia_operacao      as Operacao,
  ca.cd_categoria_apontamento,
  ca.nm_categoria_apontamento as Categoria,
  ca.qt_ordem_apontamento     as Ordem
into
  #CategoriaPadrao
from
  #Processo p, Operacao o, Categoria_Apontamento ca
where
  p.cd_operacao = o.cd_operacao and
  isnull(ca.ic_pad_categoria,'N')='S'


--select * from #CategoriaPadrao

select
  p.cd_processo,
  p.cd_item_processo,
  p.cd_maquina,
  p.cd_seq_processo,
  o.cd_operacao,
  o.nm_fantasia_operacao      as Operacao,
  ca.cd_categoria_apontamento, 
  ca.nm_categoria_apontamento as Categoria,
  ca.qt_ordem_apontamento     as Ordem  
into 
  #CategoriaOperacao
from
  #Processo p
  left outer join Operacao o               on o.cd_operacao = p.cd_operacao
  inner join Operacao_Apontamento  oa on oa.cd_operacao = o.cd_operacao
  left outer join Categoria_Apontamento ca on ca.cd_categoria_apontamento = oa.cd_categoria_apontamento

insert into #CategoriaOperacao
  select * from #CategoriaPadrao


--select * from #CategoriaOperacao

-------------------------------------------------------------------------------------
--Inserindo os registros automaticamente na Tabela : Processo_Categoria_Apontamento
-------------------------------------------------------------------------------------
--Select * from Processo_Categoria_Apontamento

insert into Processo_Categoria_Apontamento
 ( cd_processo,
   cd_item_processo,
   cd_processo_apontamento,
   cd_categoria_apontamento,
   cd_operacao,
   cd_maquina,
   dt_processo_apontamento,
   dt_inicio,
   dt_fim,
   cd_usuario,
   dt_usuario )
 select
   cd_processo, 
   cd_item_processo,   
   cd_categoria_apontamento,--cd_seq_processo,
   cd_categoria_apontamento,
   cd_operacao,
   cd_maquina,
   getdate(),
   getdate(),
   getdate(),
   @cd_usuario,
   getdate()   
 from
   #CategoriaOperacao


