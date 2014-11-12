CREATE TABLE [dbo].[Usuario_Log] (
    [cd_usuario_log] INT          IDENTITY (1, 1) NOT NULL,
    [cd_empresa]     INT          NOT NULL,
    [cd_usuario]     INT          NOT NULL,
    [cd_modulo]      INT          NOT NULL,
    [cd_funcao]      INT          NOT NULL,
    [cd_menu]        INT          NOT NULL,
    [nm_estacao]     VARCHAR (40) NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Usuario_Log] PRIMARY KEY CLUSTERED ([cd_usuario_log] ASC) WITH (FILLFACTOR = 90)
);

