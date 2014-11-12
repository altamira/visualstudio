CREATE TABLE [dbo].[Tipo_Acesso] (
    [cd_tipo_acesso] INT          NOT NULL,
    [nm_tipo_acesso] VARCHAR (40) NULL,
    [sg_tipo_acesso] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Acesso] PRIMARY KEY CLUSTERED ([cd_tipo_acesso] ASC) WITH (FILLFACTOR = 90)
);

