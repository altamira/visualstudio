CREATE TABLE [dbo].[Processo_Juridico_Cliente] (
    [cd_processo_cliente]     INT          NOT NULL,
    [cd_processo_juridico]    INT          NOT NULL,
    [cd_cliente]              INT          NULL,
    [nm_obs_processo_cliente] VARCHAR (40) NULL,
    CONSTRAINT [PK_Processo_Juridico_Cliente] PRIMARY KEY CLUSTERED ([cd_processo_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Juridico_Cliente_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

