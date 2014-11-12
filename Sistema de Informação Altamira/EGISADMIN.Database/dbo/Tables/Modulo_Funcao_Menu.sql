CREATE TABLE [dbo].[Modulo_Funcao_Menu] (
    [cd_modulo]    INT      NOT NULL,
    [cd_funcao]    INT      NOT NULL,
    [cd_menu]      INT      NOT NULL,
    [cd_indice]    INT      NOT NULL,
    [cd_usuario]   INT      NULL,
    [dt_usuario]   DATETIME NULL,
    [ic_alteracao] CHAR (1) NULL
);

