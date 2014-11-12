CREATE TABLE [dbo].[Tipo_Admissao] (
    [cd_tipo_admissao]       INT          NOT NULL,
    [nm_tipo_admissao]       VARCHAR (40) NULL,
    [sg_tipo_admissao]       CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_cadeg_tipo_admissao] CHAR (2)     NULL,
    CONSTRAINT [PK_Tipo_Admissao] PRIMARY KEY CLUSTERED ([cd_tipo_admissao] ASC) WITH (FILLFACTOR = 90)
);

