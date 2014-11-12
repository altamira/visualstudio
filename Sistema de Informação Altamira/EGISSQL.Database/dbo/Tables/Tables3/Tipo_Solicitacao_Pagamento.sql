CREATE TABLE [dbo].[Tipo_Solicitacao_Pagamento] (
    [cd_tipo_solicitacao] INT          NOT NULL,
    [nm_tipo_solicitacao] VARCHAR (40) NULL,
    [sg_tipo_solicitacao] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Solicitacao_Pagamento] PRIMARY KEY CLUSTERED ([cd_tipo_solicitacao] ASC) WITH (FILLFACTOR = 90)
);

