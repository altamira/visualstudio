CREATE TABLE [dbo].[Fase_Producao] (
    [cd_fase_producao]         INT          NOT NULL,
    [nm_fase_producao]         VARCHAR (50) NULL,
    [sg_fase_producao]         CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_cliente_fase_producao] CHAR (1)     NULL,
    [nm_idioma_fase_producao]  VARCHAR (50) NULL,
    CONSTRAINT [PK_Fase_Producao] PRIMARY KEY CLUSTERED ([cd_fase_producao] ASC) WITH (FILLFACTOR = 90)
);

