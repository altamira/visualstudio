
-------------------------------------------------------------------------------
--sp_helptext pr_validacao_automatica_implantacao_nfe
-------------------------------------------------------------------------------
--pr_validacao_automatica_implantacao_nfe
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Validação Automática para Implantação da 
--                   Nota Fiscal Eletrônica
--Data             : 16.09.2009
--Alteração        : 
--
------------------------------------------------------------------------------
create procedure pr_validacao_automatica_implantacao_nfe

as

declare @cd_tipo_validacao int

set @cd_tipo_validacao = 0


--Processamento Automático
set @cd_tipo_validacao = 1

select
  cd_tipo_validacao
into
  #ValidaNFE
from
  tipo_validacao

--select * from tipo_validacao

while exists ( select top 1 cd_tipo_validacao from #ValidaNFE )
begin

  select top 1
    @cd_tipo_validacao = cd_tipo_validacao
  from
    #ValidaNFE

  --Processamento de Validação 
  exec pr_controle_validacao_implantacao_nfe @cd_tipo_validacao,@cd_tipo_validacao,null

  delete from #ValidaNFE 
  where
   cd_tipo_validacao = @cd_tipo_validacao

end

