CREATE TABLE [dbo].[Impedimento_Manutencao] (
    [cd_impedimento_manutencao] INT          NOT NULL,
    [nm_impedimento_manutencao] VARCHAR (30) NOT NULL,
    [sg_impedimento_manutencao] CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Impedimento_Manutencao] PRIMARY KEY CLUSTERED ([cd_impedimento_manutencao] ASC) WITH (FILLFACTOR = 90)
);

