
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_data_entrega_proposta
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : EgisAdmin ou Egissql
--
--Objetivo         : 
--Data             : 01.01.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_atualiza_data_entrega_proposta
@cd_consulta int      = 0,
@dt_base     datetime = null
as

if @dt_base is null
begin
  set @dt_base = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end


--select * from consulta_itens where cd_consulta = 2

if @cd_consulta >0
begin

  update
    consulta_itens
  set
    dt_entrega_consulta = convert(datetime,left(convert(varchar,(isnull(qt_dia_entrega_consulta,0) + @dt_base ),121),10)+' 00:00:00',121) 

  from
    consulta_itens

  where
    cd_consulta = @cd_consulta  and
    isnull(cd_pedido_venda,0) = 0

end

