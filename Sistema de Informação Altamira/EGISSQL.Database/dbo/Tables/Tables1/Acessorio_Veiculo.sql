CREATE TABLE [dbo].[Acessorio_Veiculo] (
    [cd_acessorio_veiculo] INT          NOT NULL,
    [nm_acessorio_veiculo] VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Acessorio_Veiculo] PRIMARY KEY CLUSTERED ([cd_acessorio_veiculo] ASC) WITH (FILLFACTOR = 90)
);

