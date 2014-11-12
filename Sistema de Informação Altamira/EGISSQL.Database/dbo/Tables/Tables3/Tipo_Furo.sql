CREATE TABLE [dbo].[Tipo_Furo] (
    [cd_tipo_furo]           INT          NOT NULL,
    [nm_tipo_furo]           VARCHAR (40) NOT NULL,
    [sg_tipo_furo]           CHAR (10)    NOT NULL,
    [qt_tempofuro_tipo_furo] FLOAT (53)   NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Furo] PRIMARY KEY CLUSTERED ([cd_tipo_furo] ASC) WITH (FILLFACTOR = 90)
);

