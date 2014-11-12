CREATE TABLE [dbo].[Tipo_Auditor] (
    [cd_tipo_auditor] INT          NOT NULL,
    [nm_tipo_auditor] VARCHAR (40) NULL,
    [sg_tipo_auditor] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Auditor] PRIMARY KEY CLUSTERED ([cd_tipo_auditor] ASC) WITH (FILLFACTOR = 90)
);

