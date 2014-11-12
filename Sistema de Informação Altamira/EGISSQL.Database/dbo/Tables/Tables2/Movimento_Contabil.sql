CREATE TABLE [dbo].[Movimento_Contabil] (
    [cd_empresa]             INT        NOT NULL,
    [cd_exercicio]           INT        NOT NULL,
    [cd_lote]                INT        NOT NULL,
    [cd_lancamento_contabil] INT        NOT NULL,
    [dt_lancamento_contabil] DATETIME   NOT NULL,
    [cd_reduzido_debito]     INT        NULL,
    [cd_reduzido_credito]    INT        NULL,
    [vl_lancamento_contabil] FLOAT (53) NOT NULL,
    [cd_historico_contabil]  INT        NULL,
    [ds_historico_contabil]  TEXT       NULL,
    [cd_usuario]             INT        NOT NULL,
    [dt_usuario]             DATETIME   NOT NULL,
    [cd_lancamento_padrao]   INT        NULL,
    [cd_centro_custo]        INT        NULL,
    [cd_centro_receita]      INT        NULL,
    [cd_modulo]              INT        NULL,
    [cd_conta_credito]       INT        NULL,
    [cd_conta_debito]        INT        NULL,
    CONSTRAINT [PK_Movimento_Contabil] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_exercicio] ASC, [cd_lote] ASC, [cd_lancamento_contabil] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Movimento_Contabil_dt_lancamento_contabil]
    ON [dbo].[Movimento_Contabil]([dt_lancamento_contabil] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Movimento_Contabil_cd_reduzido_debito]
    ON [dbo].[Movimento_Contabil]([cd_reduzido_debito] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Movimento_Contabil_cd_reduzido_credito]
    ON [dbo].[Movimento_Contabil]([cd_reduzido_credito] ASC) WITH (FILLFACTOR = 90);


GO
--tr_apagar_movimento_contabil
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Movimento Contábil
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
create trigger tr_apagar_movimento_contabil on dbo.Movimento_Contabil
for delete
as
begin
  declare @cd_empresa int
  declare @cd_exercicio int
  declare @cd_lote int
  select 
    @cd_empresa = cd_empresa, 
    @cd_exercicio = cd_exercicio,
    @cd_lote = @cd_lote
  from 
    deleted
  if ((select
         ic_consistencia_lote
       from
         Lote_contabil
       where
         cd_empresa = @cd_empresa and
         cd_exercicio = @cd_exercicio and
         cd_lote = @cd_lote) = 'S')
    begin
      raiserror('Deleçao nao Permitida. Lote Contábil Consistente e Liberado.',16,1)
      rollback transaction
    end
end
