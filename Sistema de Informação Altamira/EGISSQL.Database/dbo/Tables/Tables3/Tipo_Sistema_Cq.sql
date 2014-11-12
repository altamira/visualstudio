CREATE TABLE [dbo].[Tipo_Sistema_Cq] (
    [cd_tipo_sistema]           INT          NOT NULL,
    [nm_tipo_sistema]           VARCHAR (60) NULL,
    [sg_tipo_sistema]           CHAR (20)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_valvulado_tipo_sistema] CHAR (1)     NULL,
    [ic_importa_componente_orc] CHAR (1)     NULL,
    [ic_orcamento_calculado]    CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Sistema_Cq] PRIMARY KEY NONCLUSTERED ([cd_tipo_sistema] ASC) WITH (FILLFACTOR = 90)
);

