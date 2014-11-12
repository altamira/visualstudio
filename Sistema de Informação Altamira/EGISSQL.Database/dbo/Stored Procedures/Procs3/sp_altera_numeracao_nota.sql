
-------------------------------------------------------------------------------
--sp_helptext sp_altera_numeracao_nota
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Alteração do Número da Nota Fiscal de Saída
--                   para quando a empresa muda o formulário
--Data             : 26.10.2007
--Alteração        : 27.10.2007
-- 30.01.2008 - Acerto da procedure - Carlos Fernandes
-- 01.02.2008 - Formulário - Carlos Fernandes
------------------------------------------------------------------------------
create procedure sp_altera_numeracao_nota
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

delete from nota_saida_entrega
--select * from nota_saida

--Montagem de Uma Tabela Temporária

select
  cd_nota_saida,
  case when len(ltrim(rtrim(cast(cd_nota_saida as varchar)))) <=6 then 
    cast( '999'+cast(cd_nota_saida as varchar) as int )
  else
    cast(cd_nota_saida as varchar)
  end                                        as cd_identificacao_nota_saida

into
  #AuxNota
 
from
  Nota_saida
where
  dt_nota_saida between @dt_inicial and @dt_final

select
  *
from
  #AuxNota

--Atualização das Tabelas Envolvidas

--Nota Saida
--select * from nota_saida

update
  Nota_Saida
set
  cd_nota_saida = x.cd_identificacao_nota_saida,
  cd_num_formulario_nota = cast( '999'+cast(cd_num_formulario_nota as varchar) as int )
from
  Nota_Saida n
  inner join #AuxNota x on x.cd_nota_saida = n.cd_nota_saida

update
  Nota_Saida_Item
set
  cd_nota_saida = x.cd_identificacao_nota_saida  
from
  Nota_Saida_item i
  inner join #AuxNota x on x.cd_nota_saida = i.cd_nota_saida


--select * from nota_saida_parcela

-- select
--   cd_nota_saida,
--   cd_ident_parc_nota_saida,
--   cast( '999'+cast(cd_nota_saida as varchar) as int )+substring(cd_ident_parc_nota_saida,7,2) as cd_parcela
  

update
  Nota_Saida_Parcela
set
  cd_nota_saida            = x.cd_identificacao_nota_saida,
  cd_ident_parc_nota_saida = cast(x.cd_identificacao_nota_saida as varchar)+substring(cd_ident_parc_nota_saida,7,5)  
from
  Nota_Saida_parcela p
  inner join #AuxNota x on x.cd_nota_saida = p.cd_nota_saida

--select * from documento_receber

update
  Documento_Receber
set
  cd_nota_saida    = x.cd_identificacao_nota_saida,
  cd_identificacao = cast(x.cd_identificacao_nota_saida as varchar)+substring(cd_identificacao,7,5)    
from
  Documento_Receber d
  inner join #AuxNota x on x.cd_nota_saida = d.cd_nota_saida

--select * from documento_receber
--select * from nota_saida_parcela

update
  Documento_Pagar
set
  cd_nota_saida = x.cd_identificacao_nota_saida  
from
  Documento_Pagar p
  inner join #AuxNota x on x.cd_nota_saida = p.cd_nota_saida

--select * from movimento_estoque

update
  movimento_estoque
set
  cd_documento_movimento = x.cd_identificacao_nota_saida,
  nm_historico_movimento = rtrim(ltrim( nm_historico_movimento)) + ' ' + x.cd_identificacao_nota_saida
from
  Movimento_estoque me
  inner join #AuxNota x on x.cd_nota_saida = cast( me.cd_documento_movimento as int )
where
  cd_tipo_movimento_estoque = 11 and
  cd_tipo_documento_estoque = 4

--select * from tipo_movimento_estoque
--select * from tipo_documento_estoque



