CREATE TABLE [dbo].[Causa_Manutencao] (
    [cd_causa_manutencao] INT          NOT NULL,
    [nm_causa_manutencao] VARCHAR (30) NOT NULL,
    [sg_causa_manutencao] CHAR (10)    NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Causa_Manutencao] PRIMARY KEY CLUSTERED ([cd_causa_manutencao] ASC) WITH (FILLFACTOR = 90)
);

