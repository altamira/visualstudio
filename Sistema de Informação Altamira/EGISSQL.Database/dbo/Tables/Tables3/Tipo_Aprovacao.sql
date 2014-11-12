CREATE TABLE [dbo].[Tipo_Aprovacao] (
    [cd_tipo_aprovacao]        INT          NOT NULL,
    [nm_tipo_aprovacao]        VARCHAR (30) NOT NULL,
    [sg_tipo_aprovacao]        CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_padrao_tipo_aprovacao] CHAR (1)     NULL,
    [ic_teto_tipo_aprovacao]   CHAR (1)     NULL,
    [qt_ordem_tipo_aprovacao]  INT          NULL,
    [ic_auto_tipo_aprovacao]   CHAR (1)     NULL,
    [ic_escala_tipo_aprovacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Aprovacao] PRIMARY KEY CLUSTERED ([cd_tipo_aprovacao] ASC) WITH (FILLFACTOR = 90)
);

