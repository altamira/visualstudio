CREATE TABLE [dbo].[Unidade_Negocio] (
    [cd_unidade_negocio]       INT          NOT NULL,
    [nm_unidade_negocio]       VARCHAR (60) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_fantasia_unidade]      VARCHAR (15) NULL,
    [sg_unidade_negocio]       CHAR (10)    NULL,
    [ds_unidade_negocio]       TEXT         NULL,
    [ic_ativo_unidade_negocio] CHAR (1)     NULL,
    CONSTRAINT [PK_Unidade_Negocio] PRIMARY KEY CLUSTERED ([cd_unidade_negocio] ASC) WITH (FILLFACTOR = 90)
);

