CREATE TABLE [dbo].[Adiantamento_Baixa] (
    [cd_adiantamento]           INT        NOT NULL,
    [cd_item_adiantamento]      INT        NOT NULL,
    [dt_item_baixa_adiantament] DATETIME   NULL,
    [vl_item_adiantamento]      FLOAT (53) NULL,
    [cd_reembolso_despesa]      INT        NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Adiantamento_Baixa] PRIMARY KEY CLUSTERED ([cd_adiantamento] ASC, [cd_item_adiantamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Adiantamento_Baixa_Reembolso_Despesa] FOREIGN KEY ([cd_reembolso_despesa]) REFERENCES [dbo].[Reembolso_Despesa] ([cd_reembolso_despesa])
);

