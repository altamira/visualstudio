CREATE TABLE [dbo].[Parametro_Suporte] (
    [cd_empresa]       INT           NOT NULL,
    [nm_email_suporte] VARCHAR (100) NULL,
    [cd_usuario]       INT           NULL,
    [dt_usuario]       DATETIME      NULL,
    CONSTRAINT [PK_Parametro_Suporte] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

