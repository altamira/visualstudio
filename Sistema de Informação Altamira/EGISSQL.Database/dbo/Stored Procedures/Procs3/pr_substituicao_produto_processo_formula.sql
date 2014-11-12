
-------------------------------------------------------------------------------
--pr_substituicao_produto_processo_formula
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 24.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_substituicao_produto_processo_formula
@cd_processo_padrao  int = 0,
@cd_produto_anterior int = 0,
@cd_produto_atual    int = 0,
@cd_usuario          int = 0

as


if @cd_produto_anterior>0 and @cd_produto_atual>0 
begin

  --select * from processo_padrao_produto

  --Montagem da Tabela auxiliar com todos os produtos

  select
    cd_processo_padrao,
    cd_produto_proc_padrao,
    cd_produto
  into
    #PP_Produto
  from
    processo_padrao_produto    
  where 
    cd_processo_padrao = case when @cd_processo_padrao=0 then cd_processo_padrao else @cd_processo_padrao end and
    cd_produto         = @cd_produto_anterior

  --select * from #PP_Produto

  --Processo de alteração do Produto no Processo Padrão

  declare @cd_processo       int 
  declare @cd_produto        int
  declare @cd_item_alteracao int
 
  while exists ( select top 1 cd_processo_padrao from #PP_Produto )
  begin

    select 
      top 1
      @cd_processo = cd_processo_padrao,
      @cd_produto  = cd_produto

    from #PP_Produto 

    --Atualiza o Produto

    update
      processo_padrao_produto
    set
      cd_produto          = @cd_produto_atual,
      cd_produto_anterior = @cd_produto_anterior
    where     
      cd_processo_padrao = @cd_processo and
      cd_produto         = @cd_produto

    --Montagem da Tabela Histórico

   --select * from processo_padrao_produto_alteracao
   
   select @cd_item_alteracao = 
       isnull( (select max(cd_item_alteracao)+1
       from 
         processo_padrao_produto_alteracao 
        where  
         cd_processo_padrao  = @cd_processo       and
         cd_produto          = @cd_produto),1)                  

    --select @cd_item_alteracao

    select
      pp.cd_processo_padrao,
      pp.cd_produto_proc_padrao,
      @cd_item_alteracao                   as cd_item_alteracao, 
      getdate()                            as dt_alteracao_processo,
      pp.cd_produto_anterior,
      pp.cd_produto,
      'Substituição Automática de Produto' as nm_obs_processo_alteracao,
      @cd_usuario                          as cd_usuario,
      getdate()                            as dt_usuario
    into
      #AuxProcesso
    from
      processo_padrao_produto pp
    where
      pp.cd_processo_padrao = @cd_processo      and
      pp.cd_produto          = @cd_produto_atual

     
    insert into Processo_Padrao_Produto_Alteracao
      select * from #AuxProcesso

   drop table #AuxProcesso

   --select * from #AuxProcesso

    --delete registro da tabela auxiliar

    delete from #PP_Produto 
    where 
      cd_processo_padrao = @cd_processo and
      cd_produto         = @cd_produto

  end

  --select * from #PP_Produto

end



--select * from processo_padrao_produto_alteracao

