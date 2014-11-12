CREATE TABLE [dbo].[Menu_Procedimento] (
    [cd_menu]                   INT      NOT NULL,
    [cd_procedimento]           INT      NOT NULL,
    [ic_abre_procedimento_form] CHAR (1) NULL,
    [cd_modulo]                 INT      NOT NULL,
    [cd_usuario_atualiza]       INT      NULL,
    [dt_atualiza]               DATETIME NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Menu_Procedimento] PRIMARY KEY CLUSTERED ([cd_menu] ASC, [cd_procedimento] ASC) WITH (FILLFACTOR = 90)
);

