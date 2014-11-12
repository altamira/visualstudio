
-------------------------------------------------------------------------------
--sp_helptext pr_atualizacao_quilometragem_prestacao
-------------------------------------------------------------------------------
--pr_atualizacao_quilometragem_prestacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Atualização da Prestação de Contas com o Total da Quilometragem
--Data             : 19.11.2007
--Alteração        : 20.03.2008 - Separação por Projeto e Centro de Custo - Carlos Fernandes
--08.12.2008 - Ajustes Diversos
--             Agrupamento do Centro de Custo e Projeto - Carlos Fernandes
---------------------------------------------------------------------------------------------
create procedure pr_atualizacao_quilometragem_prestacao
@cd_prestacao int = 0,
@cd_usuario   int = 0

as

--select * from prestacao_conta_composicao

declare @qt_total_km_prestacao float

if @cd_prestacao>0 
begin

  -- Tipo de Despesa
  --select * from tipo_despesa

  declare @cd_tipo_despesa   int
  declare @cd_item_prestacao int
  declare @vl_tipo_despesa   float

  select
    top 1
    @cd_tipo_despesa = isnull(td.cd_tipo_despesa,0),
    @vl_tipo_despesa = isnull(td.vl_tipo_despesa,0)
  from
    Tipo_Despesa td with (nolock) 
  where
    isnull(td.ic_sel_km_tipo_despesa,'N')='S'

  --deleta a despesa de quilometragem do cadastro 

  delete from
    prestacao_conta_composicao
  where
    cd_prestacao    = @cd_prestacao and
    cd_tipo_despesa = @cd_tipo_despesa

  select
    @cd_item_prestacao = isnull(max( cd_item_prestacao ),0)
  from
    prestacao_conta_composicao
  where
    cd_prestacao = @cd_prestacao

  --if @cd_item_prestacao = 0
  --   set @cd_item_prestacao = 1

  -- Centro de Custo
 
  ---------------------------------------------------------------------------------------------
  --Atualização da Prestação de Contas Geral
  --Única Conta de Quilometragem lançada na Composição
  ---------------------------------------------------------------------------------------------

  select 
    identity(int,1,1)            as cd_item,
    isnull(cd_centro_custo,0)    as cd_centro_custo,
    isnull(cd_projeto_viagem,0)  as cd_projeto_viagem,
    isnull(nm_projeto_viagem,'') as nm_projeto_viagem,
    qt_total_km_prestacao = sum( isnull(qt_item_km_prestacao,0 ) ) 
  into 
    #pc_quilometragem
  from 
    prestacao_conta_quilometragem with (nolock) 
  where
    cd_prestacao = @cd_prestacao
  group by
    cd_centro_custo,
    cd_projeto_viagem,
    nm_projeto_viagem

--  select * from #pc_quilometragem

  declare @i                 int
  declare @cd_centro_custo   int
  declare @cd_projeto_viagem int
  declare @nm_projeto_viagem varchar(40)

  while exists ( select top 1 'x' from #pc_quilometragem )
  begin
 
    select top 1
      @i                     = cd_item,
      @cd_centro_custo       = cd_centro_custo,
      @cd_projeto_viagem     = cd_projeto_viagem,
      @nm_projeto_viagem     = nm_projeto_viagem,
      @qt_total_km_prestacao = qt_total_km_prestacao
    from
      #pc_quilometragem


    --Verifica se existe a despesa quilometragem lançada-------------------------------------
    if not exists ( select top 1 cd_prestacao
                from
                  prestacao_conta_composicao with (nolock) 
                where
                  cd_prestacao      = @cd_prestacao      and
                  cd_tipo_despesa   = @cd_tipo_despesa   and
                  cd_centro_custo   = @cd_centro_custo   and
                  cd_projeto_viagem = @cd_projeto_viagem and
                  nm_projeto_viagem = @nm_projeto_viagem  )

    begin
      --prestacao_conta_composicao
      insert into prestacao_conta_composicao
      select
        @cd_prestacao,
        @cd_item_prestacao + @i,
        @cd_tipo_despesa,
        @qt_total_km_prestacao,
        null,
        @vl_tipo_despesa,
        @qt_total_km_prestacao * @qt_total_km_prestacao,
        null,
        'E',
        null,
        @cd_usuario,
        getdate(),
        null,
        @cd_projeto_viagem,
        null,
        @nm_projeto_viagem,
        null,
        null,
        'N',
        @cd_centro_custo,
        'N',
        'N',
        null,
        null
   
    end

    --Atualização do Valor da Quilometragem 
        
    update
      prestacao_conta_composicao
    set
      qt_item_despesa   = @qt_total_km_prestacao,
      vl_total_despesa  = @qt_total_km_prestacao * vl_item_despesa,
      cd_centro_custo   = @cd_centro_custo,
      cd_projeto_viagem = @cd_projeto_viagem,
      nm_projeto_viagem = @nm_projeto_viagem
    from
      prestacao_conta_composicao pcc with (nolock) 
      inner join tipo_despesa td on td.cd_tipo_despesa = pcc.cd_tipo_despesa  
    where
      cd_prestacao = @cd_prestacao 
      and isnull(td.ic_sel_km_tipo_despesa,'N')='S'
      and isnull(cd_centro_custo,0)    = case when @cd_centro_custo   = 0  then isnull(cd_centro_custo,0)    else @cd_centro_custo   end
      and isnull(cd_projeto_viagem,0)  = case when @cd_projeto_viagem = 0  then isnull(cd_projeto_viagem,0)  else @cd_projeto_viagem end
      and isnull(nm_projeto_viagem,'') = case when @nm_projeto_viagem = '' then isnull(nm_projeto_viagem,'') else @nm_projeto_viagem end
    --Deleta o Registro

    delete from #pc_quilometragem
    where
      @i                     = cd_item           and
      @cd_centro_custo       = cd_centro_custo   and
      @cd_projeto_viagem     = cd_projeto_viagem and
      @nm_projeto_viagem     = nm_projeto_viagem


  
  end
 
end

--select * from prestacao_conta_composicao

