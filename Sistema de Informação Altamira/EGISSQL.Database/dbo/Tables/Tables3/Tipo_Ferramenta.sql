CREATE TABLE [dbo].[Tipo_Ferramenta] (
    [cd_tipo_ferramenta]            INT          NOT NULL,
    [nm_tipo_ferramenta]            VARCHAR (40) NOT NULL,
    [sg_tipo_ferramenta]            VARCHAR (5)  NOT NULL,
    [cd_usuario]                    INT          NOT NULL,
    [dt_usuario]                    DATETIME     NOT NULL,
    [ds_tipo_ferramenta]            TEXT         NULL,
    [ic_calibracao_tipo_ferramenta] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Ferramenta] PRIMARY KEY CLUSTERED ([cd_tipo_ferramenta] ASC) WITH (FILLFACTOR = 90)
);

