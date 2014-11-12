CREATE TABLE [dbo].[Grau_Risco] (
    [cd_grau_risco] INT          NOT NULL,
    [nm_grau_risco] VARCHAR (40) NULL,
    [sg_grau_risco] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Grau_Risco] PRIMARY KEY CLUSTERED ([cd_grau_risco] ASC) WITH (FILLFACTOR = 90)
);

