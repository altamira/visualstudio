CREATE TABLE [dbo].[Tipo_Texto_Processo] (
    [cd_tipo_texto_processo]  INT          NOT NULL,
    [nm_tipo_texto_processo]  VARCHAR (30) NULL,
    [sg_tipo_texto_processo]  CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_pad_texto_processo]   CHAR (1)     NULL,
    [ic_lista_texto_processo] CHAR (1)     NULL,
    [cd_ordem_tipo_texto]     INT          NULL,
    CONSTRAINT [PK_Tipo_Texto_Processo] PRIMARY KEY CLUSTERED ([cd_tipo_texto_processo] ASC) WITH (FILLFACTOR = 90)
);

