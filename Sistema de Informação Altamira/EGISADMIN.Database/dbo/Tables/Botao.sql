CREATE TABLE [dbo].[Botao] (
    [cd_botao]          INT          NOT NULL,
    [nm_botao]          VARCHAR (40) NULL,
    [nm_fantasia_botao] VARCHAR (15) NULL,
    [cd_classe]         INT          NULL,
    [ic_visivel_botao]  CHAR (1)     NULL,
    [ic_ativo_botao]    CHAR (1)     NULL,
    [ds_evento_botao]   TEXT         NULL,
    [cd_menu]           INT          NULL,
    [nm_obs_botao]      VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [cd_imagem]         INT          NULL,
    [nm_hint_botao]     VARCHAR (50) NULL,
    [cd_procedimento]   INT          NULL,
    [cd_botao_pai]      INT          NULL,
    CONSTRAINT [PK_Botao] PRIMARY KEY CLUSTERED ([cd_botao] ASC) WITH (FILLFACTOR = 90)
);

