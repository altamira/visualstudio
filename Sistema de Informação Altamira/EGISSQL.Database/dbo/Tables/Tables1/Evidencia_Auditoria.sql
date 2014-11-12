CREATE TABLE [dbo].[Evidencia_Auditoria] (
    [cd_evidencia] INT          NOT NULL,
    [nm_evidencia] VARCHAR (40) NULL,
    [sg_evidencia] CHAR (10)    NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Evidencia_Auditoria] PRIMARY KEY CLUSTERED ([cd_evidencia] ASC) WITH (FILLFACTOR = 90)
);

