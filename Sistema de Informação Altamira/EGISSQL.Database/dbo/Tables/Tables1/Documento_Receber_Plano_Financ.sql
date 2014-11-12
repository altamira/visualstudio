CREATE TABLE [dbo].[Documento_Receber_Plano_Financ] (
    [cd_documento_receber] INT        NOT NULL,
    [cd_plano_financeiro]  INT        NOT NULL,
    [pc_plano_financeiro]  FLOAT (53) NULL,
    [vl_plano_financeiro]  FLOAT (53) NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [cd_nota_saida]        INT        NULL,
    CONSTRAINT [PK_Documento_Receber_Plano_Financ] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC, [cd_plano_financeiro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Receber_Plano_Financ_Documento_Receber] FOREIGN KEY ([cd_documento_receber]) REFERENCES [dbo].[Documento_Receber] ([cd_documento_receber])
);

