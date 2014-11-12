CREATE TABLE [dbo].[Tipo_Aplicacao] (
    [cd_tipo_aplicacao]           INT          NOT NULL,
    [nm_tipo_aplicacao]           VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_aplicacao]           CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]                  INT          NOT NULL,
    [dt_usuario]                  DATETIME     NOT NULL,
    [ic_embalagem_tipo_aplicacao] CHAR (1)     NULL,
    [ic_emb_tipo_aplicacao]       CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Aplicacao] PRIMARY KEY CLUSTERED ([cd_tipo_aplicacao] ASC) WITH (FILLFACTOR = 90)
);

