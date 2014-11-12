CREATE TABLE [dbo].[NivelAcesso] (
    [cd_nivel_acesso]     INT          NOT NULL,
    [nm_nivel_acesso]     VARCHAR (40) NULL,
    [ic_menu_visivel]     CHAR (1)     NULL,
    [ic_senha_acesso]     CHAR (1)     NULL,
    [ic_inclusao]         CHAR (1)     NULL,
    [ic_alteracao]        CHAR (1)     NULL,
    [ic_consulta]         CHAR (1)     NULL,
    [ic_exclusao]         CHAR (1)     NULL,
    [ic_relatorio]        CHAR (1)     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [CD_USUARIO_ATUALIZA] INT          NULL,
    [DT_ATUALIZA]         DATETIME     NULL,
    CONSTRAINT [PK_NivelAcesso] PRIMARY KEY CLUSTERED ([cd_nivel_acesso] ASC) WITH (FILLFACTOR = 90)
);

