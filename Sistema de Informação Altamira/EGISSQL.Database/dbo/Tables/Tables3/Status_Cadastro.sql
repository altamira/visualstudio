CREATE TABLE [dbo].[Status_Cadastro] (
    [cd_status_cadastro] INT          NOT NULL,
    [nm_status_cadastro] VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Status_Cadastro] PRIMARY KEY CLUSTERED ([cd_status_cadastro] ASC)
);

