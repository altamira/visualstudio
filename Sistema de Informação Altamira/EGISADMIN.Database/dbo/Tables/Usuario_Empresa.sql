CREATE TABLE [dbo].[Usuario_Empresa] (
    [cd_usuario]             INT          NOT NULL,
    [cd_empresa]             INT          NOT NULL,
    [cd_usuario_empresa]     INT          NULL,
    [dt_atualiza]            DATETIME     NULL,
    [nm_obs_usuario_empresa] VARCHAR (40) NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_acesso_padrao]       CHAR (1)     NULL,
    [ic_bloqueio_acesso]     CHAR (1)     NULL
);

