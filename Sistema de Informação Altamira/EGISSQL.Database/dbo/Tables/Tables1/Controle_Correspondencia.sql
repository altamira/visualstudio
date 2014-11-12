CREATE TABLE [dbo].[Controle_Correspondencia] (
    [cd_correspondencia]   INT           NOT NULL,
    [cd_tipo_destinatario] INT           NULL,
    [cd_destinatario]      INT           NULL,
    [nm_assunto]           VARCHAR (30)  NULL,
    [nm_observacao]        TEXT          NULL,
    [ic_tipo_transmissao]  CHAR (1)      NULL,
    [dt_envio]             DATETIME      NULL,
    [cd_departamento]      INT           NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    [nm_arquivo]           VARCHAR (200) NULL,
    CONSTRAINT [PK_Controle_Correspondencia] PRIMARY KEY CLUSTERED ([cd_correspondencia] ASC) WITH (FILLFACTOR = 90)
);

