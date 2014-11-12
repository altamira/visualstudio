CREATE TABLE [dbo].[Orgao_Credito] (
    [cd_orgao_credito] INT          NOT NULL,
    [nm_orgao_credito] VARCHAR (30) NOT NULL,
    [sg_orgao_credito] CHAR (10)    NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL,
    CONSTRAINT [PK_Orgao_Credito] PRIMARY KEY CLUSTERED ([cd_orgao_credito] ASC) WITH (FILLFACTOR = 90)
);

