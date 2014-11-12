CREATE TABLE [dbo].[Tipo_Grade] (
    [cd_tipo_grade]            INT          NOT NULL,
    [nm_tipo_grade]            VARCHAR (30) NULL,
    [sg_tipo_grade]            CHAR (10)    NULL,
    [ic_tipo_grade]            CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_orientacao_tipo_grade] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Grade] PRIMARY KEY CLUSTERED ([cd_tipo_grade] ASC) WITH (FILLFACTOR = 90)
);

