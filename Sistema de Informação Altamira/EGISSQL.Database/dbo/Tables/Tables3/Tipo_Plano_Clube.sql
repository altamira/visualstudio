CREATE TABLE [dbo].[Tipo_Plano_Clube] (
    [cd_tipo_plano]           INT          NOT NULL,
    [nm_tipo_plano]           VARCHAR (50) NULL,
    [qt_dia_vencimento_plano] INT          NULL,
    [nm_fantasia_plano]       VARCHAR (15) NULL,
    [vl_tipo_plano]           FLOAT (53)   NULL,
    [ds_tipo_plano]           TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Plano_Clube] PRIMARY KEY CLUSTERED ([cd_tipo_plano] ASC)
);

