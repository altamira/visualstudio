CREATE TABLE [dbo].[Tecnica_Auditoria] (
    [cd_tecnica_auditoria] INT          NOT NULL,
    [nm_tecnica_auditoria] VARCHAR (40) NULL,
    [sg_tecnica_autidoria] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tecnica_Auditoria] PRIMARY KEY CLUSTERED ([cd_tecnica_auditoria] ASC) WITH (FILLFACTOR = 90)
);

