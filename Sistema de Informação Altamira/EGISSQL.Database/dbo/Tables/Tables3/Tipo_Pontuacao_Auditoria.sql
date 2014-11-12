CREATE TABLE [dbo].[Tipo_Pontuacao_Auditoria] (
    [cd_tipo_pontuacao] INT          NOT NULL,
    [nm_tipo_pontuacao] VARCHAR (40) NULL,
    [sg_tipo_pontuacao] CHAR (10)    NULL,
    [qt_faixa_inicial]  FLOAT (53)   NULL,
    [qt_faixa_final]    FLOAT (53)   NULL,
    [qt_tipo_pontuacao] FLOAT (53)   NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Pontuacao_Auditoria] PRIMARY KEY CLUSTERED ([cd_tipo_pontuacao] ASC) WITH (FILLFACTOR = 90)
);

