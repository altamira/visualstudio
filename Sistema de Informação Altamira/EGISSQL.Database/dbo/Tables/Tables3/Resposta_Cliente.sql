CREATE TABLE [dbo].[Resposta_Cliente] (
    [cd_resposta_cliente] INT          NOT NULL,
    [nm_resposta_cliente] VARCHAR (50) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Resposta_Cliente] PRIMARY KEY CLUSTERED ([cd_resposta_cliente] ASC) WITH (FILLFACTOR = 90)
);

