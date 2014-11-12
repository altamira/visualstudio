
-------------------------------------------------------------------------------
--sp_helptext pr_copia_programacao_entrega
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cópia da Programação de Entrega
--Data             : 19/09/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_programacao_entrega
@cd_programacao int = 0
as

declare @cd_programacao_entrega int

set @cd_programacao_entrega =0


if @cd_programacao>0
begin

   select
     *
   into
     #programacao_entrega
   from
     programacao_entrega 
   where
     cd_programacao_entrega = @cd_programacao


   declare @Tabela	           varchar(80)

   set @Tabela      = cast(DB_NAME()+'.dbo.Programacao_Entrega' as varchar(80))

   -- campo chave utilizando a tabela de códigos
   exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_programacao_entrega', @codigo = @cd_programacao_entrega output

   while exists(Select top 1 'x' from programacao_entrega where cd_programacao_entrega = @cd_programacao_entrega)
   begin
     exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_programcao_entrega', @codigo = @cd_programacao_entrega output	     
     -- limpeza da tabela de código
     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_programacao_entrega, 'D'
   end

   update
     #programacao_entrega
   set
     cd_programacao_entrega = @cd_programacao_entrega

   insert into
     programacao_entrega
   select
     *
   from
     #Programacao_Entrega

   delete from #programacao_entrega


   -- limpeza da tabela de código
   exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_programacao_entrega, 'D'

end

--Mostra o Código Gerado

select 
  @cd_programacao_entrega as cd_programacao_entrega


