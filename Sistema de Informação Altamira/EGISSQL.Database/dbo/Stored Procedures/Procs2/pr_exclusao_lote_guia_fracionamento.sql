
-------------------------------------------------------------------------------
--sp_helptext pr_exclusao_lote_guia_fracionamento
-------------------------------------------------------------------------------
--pr_exclusao_lote_guia_fracionamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Exclusão Completa da Guia de Fracionamento
--Data             : 03.01.2008
--Alteração        : 31.01.2008 - Acerto da Recomposição de Saldos - Carlos Fernandes
--20.11.2010 - Complemento da Exclusão das novas tabelas para controle do Lote Interno - Carlos Fernandes
--02.12.2010 - Somente os Lotes / Laudos da Guia de Fracionamento - Carlos Fernandes
--07.12.2010 - Ajustes Diversos - Carlos Fernandes
----------------------------------------------------------------------------------------------------------
create procedure pr_exclusao_lote_guia_fracionamento

@cd_guia_fracionamento int      = 0

as

--select * from guia_fracionamento
--select * from guia_fracionamento_item
--select * from tipo_documento_estoque
--select * from requisicao_interna
--select * from movimento_estoque

if @cd_guia_fracionamento>0
begin

  select
    gfi.cd_laudo,
    lp.cd_lote_produto,
    gfi.cd_lote_fracionamento

  into
    #Laudo

  from
    guia_fracionamento_item gfi     with (nolock) 
    left outer join lote_produto lp with (nolock) on lp.nm_ref_lote_produto = gfi.cd_lote_fracionamento
    left outer join lote_produto_item lpi with (nolock) on lpi.cd_lote_produto =lp.cd_lote_produto and
                                                           lpi.cd_produto      = gfi.cd_produto_fracionamento

  where 
    gfi.cd_guia_fracionamento = @cd_guia_fracionamento and
    isnull(gfi.cd_laudo,0) > 0                         and
    isnull(lp.cd_lote_produto,0)>0                     and
    gfi.cd_lote_fracionamento is not null
     

  --select * from #Laudo

  declare @cd_laudo  int
  declare @cd_lote   int 

  while exists( select top 1 cd_laudo from #laudo )
  begin

    select top 1 
      @cd_laudo = cd_laudo,
      @cd_lote  = cd_lote_produto
    from
      #Laudo

    --Lote
    delete from lote_produto_saldo where cd_lote_produto = @cd_lote
    delete from lote_produto_item  where cd_lote_produto = @cd_lote
    delete from lote_produto       where cd_lote_produto = @cd_lote

    --Laudo

    delete from Laudo_Caracteristica
    where
      cd_laudo = @cd_laudo

    delete from Laudo_Aplicacao
    where
      cd_laudo = @cd_laudo
  
    delete from Laudo_Produto_Quimico
    where
      cd_laudo = @cd_laudo

    delete from Laudo
    where
      cd_laudo = @cd_laudo

    delete from #Laudo
    where
      cd_laudo = @cd_laudo

  end

  --select * from guia_fracionamento_item


  drop table #Laudo
  

end


