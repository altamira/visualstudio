CREATE TABLE [dbo].[Acao_Prospeccao] (
    [cd_acao_prospeccao]       INT          NOT NULL,
    [nm_acao_prospeccao]       VARCHAR (40) NULL,
    [sg_acao_prospeccao]       CHAR (10)    NULL,
    [ic_pad_acao_prospeccao]   CHAR (1)     NULL,
    [ic_ativo_acao_prospeccao] CHAR (1)     NULL,
    [nm_obs_acao_prospeccao]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Acao_Prospeccao] PRIMARY KEY CLUSTERED ([cd_acao_prospeccao] ASC) WITH (FILLFACTOR = 90)
);

