CREATE TABLE [dbo].[Codigo] (
    [cd_tabela]  INT          NOT NULL,
    [nm_tabela]  VARCHAR (50) NOT NULL,
    [cd_atual]   INT          NOT NULL,
    [sg_status]  CHAR (1)     NOT NULL,
    [cd_usuario] INT          NOT NULL,
    [dt_usuario] DATETIME     NOT NULL,
    CONSTRAINT [PK_Codigo] PRIMARY KEY CLUSTERED ([cd_tabela] ASC) WITH (FILLFACTOR = 90)
);

