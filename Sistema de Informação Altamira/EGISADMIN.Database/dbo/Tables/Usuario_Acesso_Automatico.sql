CREATE TABLE [dbo].[Usuario_Acesso_Automatico] (
    [cd_usuario_acesso]          INT          NOT NULL,
    [cd_modulo]                  INT          NOT NULL,
    [cd_menu]                    INT          NOT NULL,
    [nm_obs_usuario_acesso]      VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_saida_automatica_modulo] CHAR (1)     NULL,
    [ic_deleta_acesso]           CHAR (1)     NULL,
    CONSTRAINT [PK_Usuario_Acesso_Automatico] PRIMARY KEY CLUSTERED ([cd_usuario_acesso] ASC, [cd_modulo] ASC, [cd_menu] ASC) WITH (FILLFACTOR = 90)
);

