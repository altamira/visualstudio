
-------------------------------------------------------------------------------
--sp_helptext pr_atualizacao_diaria_prestacao
-------------------------------------------------------------------------------
--pr_atualizacao_diaria_prestacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Atualização da Prestação de Contas com o Total da Diária
--Data             : 19.11.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_atualizacao_diaria_prestacao
@cd_prestacao int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

--select * from prestacao_conta_composicao
--select * from prestacao_conta_diaria
--select * from tipo_diaria_hotel
--select * from tipo_diaria_hotel_indice


declare @qt_total_item_diaria      float
declare @qt_total_diaria_prestacao float
declare @vl_indice_diaria          float
declare @cd_moeda                  int
declare @vl_item_despesa           decimal(25,2)
declare @cd_tipo_diaria            int
declare @dt_diaria_prestacao       datetime

if @cd_prestacao>0 
begin

  --select * from prestacao_conta_diaria
 
  select
    cd_prestacao,
    cd_tipo_diaria
  into
    #PrestacaoDiaria
  from 
    Prestacao_Conta_Diaria

  where
    cd_prestacao = @cd_prestacao
  group by
    cd_prestacao,
    cd_tipo_diaria

--  select * from #PrestacaoDiaria

  while exists ( select top 1 cd_prestacao from #PrestacaoDiaria )
  begin

    select 
      top 1
      @cd_tipo_diaria            = cd_tipo_diaria
    from
      #PrestacaoDiaria
    
    
    select 
    
      @qt_total_item_diaria      = sum( isnull(pcd.qt_item_diaria,0 ) ), 

      @qt_total_diaria_prestacao = sum( isnull(pcd.qt_item_diaria,0 )     * 
                                      isnull(td.vl_tipo_diaria_hotel,0) *
                                     case when isnull(td.cd_moeda,1) <>1
                                     then
                                      isnull(ti.vl_indice_moeda_diaria,1) 
                                     else
                                      1
                                     end ),


      @vl_item_despesa            = sum ( isnull(td.vl_tipo_diaria_hotel,0)  *
                                  case when isnull(td.cd_moeda,1) <> 1
                                  then
                                   isnull(ti.vl_indice_moeda_diaria,1)
                                  else
                                    1
                                  end)  
    from 
      prestacao_conta_diaria pcd
      inner join prestacao_conta pc               on pc.cd_prestacao   = pcd.cd_prestacao  
      left outer join tipo_diaria_hotel td        on td.cd_tipo_diaria = pcd.cd_tipo_diaria
      left outer join tipo_diaria_hotel_indice ti on ti.cd_tipo_diaria = pcd.cd_tipo_diaria and
                                                     ti.cd_moeda       = td.cd_moeda

    where
      pcd.cd_prestacao        = @cd_prestacao        and
      pcd.cd_tipo_diaria      = @cd_tipo_diaria      and
      pc.dt_prestacao between ti.dt_inicio_indice and ti.dt_fim_indice


    group by
      pcd.cd_prestacao,
      pcd.cd_tipo_diaria
 
--    select @qt_total_item_diaria,@vl_item_despesa,@qt_total_diaria_prestacao,@cd_tipo_diaria
 
    update
      prestacao_conta_composicao
    set
      qt_item_despesa  = @qt_total_item_diaria,
      vl_item_despesa  = @vl_item_despesa,
      vl_total_despesa = @qt_total_item_diaria * @vl_item_despesa
    from
      prestacao_conta_composicao pcc
      inner join tipo_despesa td on td.cd_tipo_despesa = pcc.cd_tipo_despesa  
    where
      cd_prestacao                                  = @cd_prestacao 
      and isnull(td.ic_sel_diaria_tipo_despesa,'N') ='S'
      and td.cd_tipo_diaria                         = @cd_tipo_diaria
 
    delete from #PrestacaoDiaria where cd_prestacao        = @cd_prestacao   and
                                       cd_tipo_diaria      = @cd_tipo_diaria 


  end



end

