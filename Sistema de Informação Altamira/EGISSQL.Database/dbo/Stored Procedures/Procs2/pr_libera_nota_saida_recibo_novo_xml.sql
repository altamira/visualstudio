
-------------------------------------------------------------------------------
--sp_helptext pr_libera_nota_saida_recibo_novo_xml
-------------------------------------------------------------------------------
--pr_libera_nota_saida_recibo_novo_xml
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Liberação da Tabela Nota Saida Recibo para Geração 
--                   Novo arquivo XML
--                   Recuperação
--
--Data             : 02.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_libera_nota_saida_recibo_novo_xml
@dt_inicial    datetime = '',
@dt_final      datetime = '',
@cd_nota_saida int   = 0
as

--select * from nota_saida_recibo

if @cd_nota_saida >0 
begin
  update
    nota_saida_recibo
  set
    nm_arquivo_envio_xml = ''
  from
    nota_saida_recibo
  where
    cd_nota_saida = @cd_nota_saida
end
else
begin

  update
    nota_saida_recibo
  set
    nm_arquivo_envio_xml = ''
  from
    nota_saida_recibo r 
    inner join nota_saida ns on ns.cd_nota_saida = r.cd_nota_saida
  where
    ns.dt_nota_saida between @dt_inicial and @dt_final

end


