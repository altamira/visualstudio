CREATE TABLE [dbo].[Email_Servidor] (
    [cd_servidor]               INT           NOT NULL,
    [cd_usuario]                INT           NOT NULL,
    [qt_email_usuario_servidor] INT           NULL,
    [dt_email_usuario_servidor] DATETIME      NULL,
    [ic_usuario_avisado]        CHAR (1)      NULL,
    [nm_correio_interno]        VARCHAR (20)  NULL,
    [nm_email_externo]          VARCHAR (100) NULL,
    [cd_usuario_alteracao]      INT           NULL,
    [dt_usuario_alteracao]      DATETIME      NULL,
    CONSTRAINT [PK_Email_servidor] PRIMARY KEY NONCLUSTERED ([cd_servidor] ASC, [cd_usuario] ASC) WITH (FILLFACTOR = 90)
);

