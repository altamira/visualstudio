
-------------------------------------------------------------------------------
--sp_helptext pr_ocorrencia_entrega
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Controle de Ocorrência de Entrega
-- 
--Data             : 16.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ocorrencia_entrega
@ic_parametro  int      = 0,
@cd_nota_saida int      = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = ''

as

--Consulta

if @ic_parametro = 0
begin

  select
    o.*,
   oe.nm_ocorrencia_entrega,
   mo.nm_motivo_ocorrencia
  from
    Nota_Saida_Item_Ocorrencia o                 with (nolock)
    inner join Nota_Saida_Item nsi               with (nolock) on nsi.cd_nota_saida        = o.cd_nota_saida      and
                                                                  nsi.cd_item_nota_saida   = o.cd_item_nota_saida
    left outer join Ocorrencia_Entrega oe        with (nolock) on oe.cd_ocorrencia_entrega = o.cd_ocorrencia_entrega
    left outer join Motivo_Ocorrencia_Entrega mo with (nolock) on mo.cd_motivo_ocorrencia  = o.cd_motivo_ocorrencia
  where
    o.cd_nota_saida = case when @cd_nota_saida = 0 then o.cd_nota_saida else @cd_nota_saida end
  

end

--select * from nota_saida_item_ocorrencia

