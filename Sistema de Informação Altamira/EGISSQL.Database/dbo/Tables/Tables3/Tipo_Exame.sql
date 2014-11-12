CREATE TABLE [dbo].[Tipo_Exame] (
    [cd_tipo_exame]          INT          NOT NULL,
    [nm_tipo_exame]          VARCHAR (40) NULL,
    [sg_tipo_exame]          CHAR (10)    NULL,
    [ic_validade_tipo_exame] CHAR (1)     NULL,
    [qt_dia_tipo_exame]      INT          NULL,
    [ds_tipo_exame]          TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Exame] PRIMARY KEY CLUSTERED ([cd_tipo_exame] ASC) WITH (FILLFACTOR = 90)
);

