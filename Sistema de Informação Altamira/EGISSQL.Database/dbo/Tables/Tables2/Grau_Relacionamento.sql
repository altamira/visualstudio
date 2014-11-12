CREATE TABLE [dbo].[Grau_Relacionamento] (
    [cd_grau_relacionamento] INT          NOT NULL,
    [nm_grau_relacionamento] VARCHAR (40) NULL,
    [sg_grau_relacionamento] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Grau_Relacionamento] PRIMARY KEY CLUSTERED ([cd_grau_relacionamento] ASC) WITH (FILLFACTOR = 90)
);

