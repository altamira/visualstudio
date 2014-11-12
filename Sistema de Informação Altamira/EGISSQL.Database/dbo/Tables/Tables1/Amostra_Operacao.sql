CREATE TABLE [dbo].[Amostra_Operacao] (
    [cd_amostra]              INT          NOT NULL,
    [cd_amostra_operacao]     INT          NOT NULL,
    [cd_amostra_produto]      INT          NOT NULL,
    [cd_operacao]             INT          NULL,
    [nm_obs_amostra_operacao] VARCHAR (40) NULL,
    [cd_ordem]                INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Amostra_Operacao] PRIMARY KEY CLUSTERED ([cd_amostra] ASC, [cd_amostra_operacao] ASC, [cd_amostra_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Amostra_Operacao_Operacao] FOREIGN KEY ([cd_operacao]) REFERENCES [dbo].[Operacao] ([cd_operacao])
);

