CREATE TABLE [dbo].[Clube_Responsavel] (
    [cd_clube_responsavel] INT           NOT NULL,
    [nm_responsavel]       VARCHAR (60)  NULL,
    [nm_email_responsavel] VARCHAR (150) NULL,
    [cd_senha_responsavel] VARCHAR (10)  NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    CONSTRAINT [PK_Clube_Responsavel] PRIMARY KEY CLUSTERED ([cd_clube_responsavel] ASC)
);

