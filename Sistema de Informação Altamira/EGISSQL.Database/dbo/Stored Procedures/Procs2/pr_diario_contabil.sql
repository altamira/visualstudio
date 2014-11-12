


/****** Object:  Stored Procedure dbo.pr_diario_contabil    Script Date: 13/12/2002 15:08:26 ******/
--pr_diario_contabil
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Diário Contábil
--Data         : 01.06.2001
--Atualizado   : 11.07.2001 - Inclusao de comando SQL para deleçao de procedure 
--                            dentro dos padroes Polimold - Elias
--               11.07.2001 - Acertos de nomes de campos da Tabela de Movimento 
--                            Contabil - Elias
--               11.07.2001 - Inclusao de Parametro que Indícam o Tipo do Diário 
--                            (Simplificado/Detalhado) - Elias
--               09.10.2001 - Filtro dos Movimentos p/ Lote Ativo 'ic_lote_ativo = 'S'' 
--               01.09.2003 - RAFAEL M. SANTIAGO
--			      Inserico o campo de Classificação da Contrapartida
-----------------------------------------------------------------------------------
CREATE  procedure pr_diario_contabil
@ic_parametro         int,      -- Parametros Usados nesta SProcedure
@cd_empresa           int,      -- Empresa
@dt_inicial_exercicio datetime, -- Data Inicial do Relatório
@dt_final_exercicio   datetime  -- Data Final do Relatório
as
  declare @cd_exercicio           int -- Código do Exercicio (Chave em #Aux_Movimento_contabil)
  declare @cd_lote                int -- Código do Lote (Chave em #Aux_Movimento_contabil)
  declare @cd_lancamento_contabil int -- Código do Lançamento (Chave em #Aux_Movimento_contabil)
  declare @cd_reduzido_debito     int -- Código Reduzido Débito em #Aux_Movimento_contabil
  declare @cd_reduzido_credito    int -- Código Reduzido Credito em #Aux_Movimento_contabil
  declare @cd_mascara_conta       varchar(20)  -- Classificaçao da Conta guardado em #Aux_Diario_contabil
  declare @nm_conta               varchar(40)  -- Nome da Conta guardado em #Aux_Diario_contabil
  declare @cd_mascara_contra      varchar(20)  -- Classificaçao da ContraPartida guardado em #Aux_Diario_contabil
  set @cd_exercicio           = 0
  set @cd_lote                = 0
  set @cd_lancamento_contabil = 0
  set @cd_reduzido_debito     = 0
  set @cd_reduzido_credito    = 0
  set @cd_mascara_conta       = ''
  set @nm_conta               = ''
  set @cd_mascara_contra       = '' -- Inserido Por RAFAEL
 
  -- Tabela Temporária onde é guardado o resultado do processamento qdo
  -- pedido um Diário Detalhado
  create table #Aux_Diario_Contabil (
    Conta varchar(40),
    Classificacao varchar(20),
    Codigo int,
    Contrapartida int,
    ClassifContra varchar(20),
    Data datetime,
    Lancamento varchar(17),
    CodHistorico int,
    Historico text,
    Debito float,
    Credito float)

  if @ic_parametro = 1          -- Diário Simplificado
    begin
      select
        a.dt_lancamento_contabil as 'Data',
        cast(isnull(a.cd_lancamento_contabil,0) as varchar(8))+'-'+cast(isnull(a.cd_lote,0) as varchar(8)) as 'Lancamento',
        case when isnull(a.cd_reduzido_debito  ,0) > 0 then (select b.cd_mascara_conta from plano_conta b where b.cd_conta_reduzido=a.cd_reduzido_debito and @cd_empresa = b.cd_empresa) else '' end as 'Debito',
 
        case when isnull(a.cd_reduzido_credito ,0) > 0 then (select b.cd_mascara_conta from plano_conta b where b.cd_conta_reduzido=a.cd_reduzido_credito and @cd_empresa = b.cd_empresa) else '' end as 'Credito',
        a.cd_historico_contabil  as 'Codhis',
        a.ds_historico_contabil  as 'Historico',
        a.vl_lancamento_contabil as 'Valor'
      from
        Movimento_contabil a 
      where
        a.cd_empresa = @cd_empresa and
        a.dt_lancamento_contabil between @dt_inicial_exercicio and 
                                         @dt_final_exercicio   and     
        'N' not in (select l.ic_ativa_lote from Lote_contabil l where a.cd_lote = l.cd_lote)
      order by
        a.dt_lancamento_contabil, a.cd_lancamento_contabil      
    end
  
  if @ic_parametro = 2
    begin
      -- Diário Detalhado -@ic_parametro = 2
      select
        a.cd_exercicio,
        a.cd_lote,
        a.cd_lancamento_contabil,
        a.dt_lancamento_contabil,
        a.cd_reduzido_debito,
        a.cd_reduzido_credito,
        a.vl_lancamento_contabil,
        a.cd_historico_contabil,
        a.ds_historico_contabil  
      into 
        #Aux_Movimento_contabil 
      from 
        Movimento_Contabil a
      where
        @cd_empresa = a.cd_empresa and
        a.dt_lancamento_contabil between @dt_inicial_exercicio and 
                                         @dt_final_exercicio and
        'N' not in (select l.ic_ativa_lote from Lote_contabil l where a.cd_lote = l.cd_lote)
        
      while exists(select * from #Aux_Movimento_contabil)
        begin
          select
            @cd_exercicio           = cd_exercicio,
            @cd_lote                = cd_lote,
            @cd_lancamento_contabil = cd_lancamento_contabil,
            @cd_reduzido_debito     = cd_reduzido_debito,
            @cd_reduzido_credito    = cd_reduzido_credito
          from
            #Aux_Movimento_contabil

          if (isnull(@cd_reduzido_debito, 0) <> 0)
            begin
            
              -- CONTA PRINCIPAL    **RAFAEL**
              select
                @cd_mascara_conta = cd_mascara_conta,
                @nm_conta         = nm_conta
              from
                Plano_Conta
              where
                cd_empresa = @cd_empresa and
                cd_conta_reduzido = @cd_reduzido_debito

              -- CONTRAPARTIDA
              select
                @cd_mascara_contra = cd_mascara_conta
              from
                Plano_Conta
              where
                cd_empresa = @cd_empresa and
                cd_conta_reduzido = @cd_reduzido_credito
/******************************************************************************/            
              insert into 
                #Aux_Diario_Contabil
              select 
                @nm_conta,
                @cd_mascara_conta,
                isnull(@cd_reduzido_debito,0),
                isnull(@cd_reduzido_credito,0),
                @cd_mascara_contra, -- RAFAEL
                dt_lancamento_contabil,
                cast(isnull(cd_lote,0) as varchar(8))+'-'+cast(isnull(cd_lancamento_contabil,0) as varchar(8)),
                isnull(cd_historico_contabil,0),
                ds_historico_contabil,
                vl_lancamento_contabil,
                0
              from
                #Aux_Movimento_contabil
              where
                cd_exercicio = @cd_exercicio and
                cd_lote = @cd_lote and
                cd_lancamento_contabil = @cd_lancamento_contabil
            end
          if (isnull(@cd_reduzido_credito,0) <> 0)
            begin
/********************************* RAFAEL ******************************************/
             -- Conta Principal             
              select 
                @cd_mascara_conta = cd_mascara_conta,
                @nm_conta         = nm_conta
              from
                Plano_Conta
              where
                cd_empresa = @cd_empresa and
                cd_conta_reduzido = @cd_reduzido_credito

              -- CONTRAPARTIDA
              select
                @cd_mascara_contra = cd_mascara_conta
              from
                Plano_Conta
              where
                cd_empresa = @cd_empresa and
                cd_conta_reduzido = @cd_reduzido_debito
/*******************************************************************************/
              insert into 
                #Aux_Diario_Contabil
              select 
                @nm_conta,
                @cd_mascara_conta,
                isnull(@cd_reduzido_credito,0),
                isnull(@cd_reduzido_debito,0),
                @cd_mascara_contra, -- RAFAEL
                dt_lancamento_contabil,
                cast(isnull(cd_lote,0) as varchar(8))+'-'+cast(isnull(cd_lancamento_contabil,0) as varchar(8)),
                isnull(cd_historico_contabil,0),
                ds_historico_contabil,
                0,
                vl_lancamento_contabil
              from
                #Aux_Movimento_contabil
              where
                cd_exercicio = @cd_exercicio and
                cd_lote = @cd_lote and
                cd_lancamento_contabil = @cd_lancamento_contabil
            end 
          delete from 
            #Aux_Movimento_Contabil 
          where 
            @cd_exercicio = cd_exercicio and
            @cd_lote = cd_lote and
            @cd_lancamento_contabil = cd_lancamento_contabil   
 
        end                 
      drop table #Aux_Movimento_Contabil
      select * from #Aux_Diario_Contabil order by Data, Classificacao, Lancamento
      drop table #Aux_Diario_Contabil 
    end                              



