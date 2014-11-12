CREATE TABLE [dbo].[Tipo_Canal_DI] (
    [cd_tipo_canal_di]     INT          NOT NULL,
    [nm_tipo_canal_di]     VARCHAR (40) NULL,
    [sg_tipo_canal_di]     CHAR (15)    NULL,
    [nm_cor_tipo_canal_di] VARCHAR (20) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Canal_DI] PRIMARY KEY CLUSTERED ([cd_tipo_canal_di] ASC) WITH (FILLFACTOR = 90)
);

