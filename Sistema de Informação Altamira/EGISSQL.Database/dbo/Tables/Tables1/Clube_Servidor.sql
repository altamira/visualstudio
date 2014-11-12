CREATE TABLE [dbo].[Clube_Servidor] (
    [cd_servidor]        INT          NOT NULL,
    [nm_servidor]        VARCHAR (60) NULL,
    [qt_acesso_servidor] INT          NULL,
    [cd_local_servidor]  INT          NULL,
    [ic_ativo_servidor]  CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Clube_Servidor] PRIMARY KEY CLUSTERED ([cd_servidor] ASC),
    CONSTRAINT [FK_Clube_Servidor_Local_Servidor] FOREIGN KEY ([cd_local_servidor]) REFERENCES [dbo].[Local_Servidor] ([cd_local_servidor])
);

