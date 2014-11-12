
-------------------------------------------------------------------------------
--pr_geracao_numeracao_controle_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 21.03.2005
--Atualizado       : 21.03.2005
--------------------------------------------------------------------------------------------------
create procedure pr_geracao_numeracao_controle_venda
@cd_loja    int,
@qt_inicio  int,
@qt_final   int,
@cd_usuario int
as

--select * from controle_venda

declare @qt_aux      int
declare @cd_controle int

--Busca o próximo registro livre

select @cd_controle = isnull(max(cd_controle_venda),0) + 1 from Controle_Venda

set @qt_aux = @qt_inicio

while @qt_aux <= @qt_final 
begin

  --Verifica se já existe o registro na Tabela

  if not exists ( select cd_registro_controle_venda from controle_venda where @qt_aux = cd_registro_controle_venda )
  begin

    insert Controle_Venda (
      cd_controle_venda,
      cd_registro_controle_venda,
      cd_codigo_barra_controle,
      ic_status_controle,
      cd_loja,
      cd_usuario,
      dt_usuario )
    select
      @cd_controle,
      @qt_aux,
      cast ( @qt_aux as varchar(40) ),
      'L',
      @cd_loja,
      @cd_usuario,
      getdate()

      set @cd_controle = @cd_controle + 1

  end

  set @qt_aux      = @qt_aux + 1

end


--delete from controle_venda

