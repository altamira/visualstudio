CREATE TABLE [dbo].[Plano_Financeiro_Movimento] (
    [cd_movimento]              INT          NOT NULL,
    [cd_plano_financeiro]       INT          NULL,
    [cd_tipo_lancamento_fluxo]  INT          NULL,
    [dt_movto_plano_financeiro] DATETIME     NULL,
    [vl_plano_financeiro]       FLOAT (53)   NULL,
    [nm_historico_movimento]    VARCHAR (40) NULL,
    [cd_historico_financeiro]   INT          NULL,
    [cd_tipo_operacao]          INT          NULL,
    [cd_moeda]                  INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_lancamento_automatico]  CHAR (1)     NULL,
    [cd_modulo]                 INT          NULL,
    [cd_lancamento_padrao]      INT          NULL,
    [cd_centro_custo]           INT          NULL,
    [cd_item_centro_custo]      INT          NULL,
    [cd_documento]              INT          NULL,
    [cd_item_documento]         INT          NULL,
    [cd_conta_debito]           INT          NULL,
    [cd_conta_credito]          INT          NULL,
    [cd_lote]                   INT          NULL,
    [cd_lancamento_contabil]    INT          NULL,
    [dt_contabilizacao]         DATETIME     NULL,
    CONSTRAINT [PK_Plano_Financeiro_Movimento] PRIMARY KEY CLUSTERED ([cd_movimento] ASC) WITH (FILLFACTOR = 90)
);


GO

create trigger tU_plano_financeiro_movimento
on Plano_Financeiro_Movimento
after update, insert

as
---------------------------------------------------
--tU_plano_financeiro_movimento
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva/Igor Gama
--Banco de Dados: EgisSql
--Objetivo   : Trigger para atualização da tabela Plano_Financeiro_Saldo
--             qdo modificações em Plano_Financeiro_Movimento
--Data       : 27/06/2002
--Atualizado : 08.03.2006
---------------------------------------------------

begin

  declare @dt_movto_plano_financeiro datetime
  declare @cd_plano_financeiro       int
  declare @cd_tipo_lancamento_fluxo  int
  declare @cd_usuario                int
  declare @cd_contador               int

  Set @cd_contador = 1


  Select
    IDENTITY( int, 1, 1) as cd_contador,
    dt_movto_plano_financeiro,
    cd_plano_financeiro,
    cd_tipo_lancamento_fluxo,
    cd_usuario
  Into
    #Tabela
  from
    inserted

  While Exists (select top 1 * from #tabela)
  Begin
      
    Select
      @dt_movto_plano_financeiro = dt_movto_plano_financeiro,
      @cd_plano_financeiro       = cd_plano_financeiro,
      @cd_tipo_lancamento_fluxo  = cd_tipo_lancamento_fluxo,
      @cd_usuario                = cd_usuario
    From
      #Tabela
    Where
      cd_contador = @cd_contador

    exec pr_atualiza_plano_financeiro_saldo @cd_plano_financeiro,
                                            @cd_tipo_lancamento_fluxo,
                                            @dt_movto_plano_financeiro,
                                            @cd_usuario

    Delete #Tabela
    Where cd_contador = @cd_contador
    
    Set @cd_contador = @cd_contador + 1
    
  End

end

GO

create trigger tU_plano_financeiro_movimento_delete
on Plano_Financeiro_Movimento
For Delete
-- instead of Delete

as

--tU_plano_financeiro_movimento_delete
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva/Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Trigger para atualização da tabela Plano_Financeiro_Saldo
--          qdo modificações em Plano_Financeiro_Movimento
--Data: 27/06/2002
--Atualizado: 
--Observações : A trigger só funciona para um único registro, 
--              caso ocorra de deletar a tabela inteira  a trigger dispara
--              apenas para o primeiro registro, por isso criei uma tabela
--              temporária para trabalhar com todos os registros.
---------------------------------------------------

begin

  declare @dt_movto_plano_financeiro datetime
  declare @cd_plano_financeiro int
  declare @cd_tipo_lancamento_fluxo int
  declare @cd_usuario int
  declare @cd_contador int

  Set @cd_contador = 1


  Select
    IDENTITY( int, 1, 1) as cd_contador,
    dt_movto_plano_financeiro,
    cd_plano_financeiro,
    cd_tipo_lancamento_fluxo,
    cd_usuario
  Into
    #Tabela
  from
    deleted

  While Exists (select * from #tabela)
  Begin
      
    Select
      @dt_movto_plano_financeiro = dt_movto_plano_financeiro,
      @cd_plano_financeiro = cd_plano_financeiro,
      @cd_tipo_lancamento_fluxo = cd_tipo_lancamento_fluxo,
      @cd_usuario = cd_usuario
    From
      #Tabela
    Where
      cd_contador = @cd_contador

    exec pr_atualiza_plano_financeiro_saldo @cd_plano_financeiro,
                                            @cd_tipo_lancamento_fluxo,
                                            @dt_movto_plano_financeiro,
                                            @cd_usuario

    Delete #Tabela
    Where cd_contador = @cd_contador
    
    Set @cd_contador = @cd_contador + 1
    
  End
end

