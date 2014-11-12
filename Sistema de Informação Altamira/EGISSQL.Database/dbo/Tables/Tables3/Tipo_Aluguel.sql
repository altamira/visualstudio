CREATE TABLE [dbo].[Tipo_Aluguel] (
    [cd_tipo_aluguel]       INT          NOT NULL,
    [nm_tipo_aluguel]       VARCHAR (30) NULL,
    [sg_tipo_aluguel]       CHAR (10)    NULL,
    [vl_diaria_aluguel]     FLOAT (53)   NULL,
    [qt_dia_cobrar_aluguel] INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Aluguel] PRIMARY KEY CLUSTERED ([cd_tipo_aluguel] ASC) WITH (FILLFACTOR = 90)
);

