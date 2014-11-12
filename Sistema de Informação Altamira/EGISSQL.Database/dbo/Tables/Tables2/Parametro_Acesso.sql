CREATE TABLE [dbo].[Parametro_Acesso] (
    [cd_empresa]                INT      NOT NULL,
    [ic_tipo_fechamento_acesso] CHAR (1) NULL,
    [ic_atualiza_captura_video] CHAR (1) NULL,
    [ic_visualiza_imagem]       CHAR (1) NULL,
    [ic_catraca_acesso]         CHAR (1) NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Parametro_Acesso] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

