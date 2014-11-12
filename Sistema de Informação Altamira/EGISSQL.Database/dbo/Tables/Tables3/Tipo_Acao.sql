CREATE TABLE [dbo].[Tipo_Acao] (
    [cd_tipo_acao] INT          NOT NULL,
    [nm_tipo_acao] VARCHAR (40) NULL,
    [sg_tipo_acao] CHAR (10)    NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Acao] PRIMARY KEY CLUSTERED ([cd_tipo_acao] ASC) WITH (FILLFACTOR = 90)
);

