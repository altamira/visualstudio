CREATE TABLE [dbo].[Tipo_Coface] (
    [cd_tipo_coface]            INT           NOT NULL,
    [nm_tipo_coface]            VARCHAR (100) NULL,
    [cd_referencia_tipo_coface] VARCHAR (3)   NOT NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_Tipo_Coface] PRIMARY KEY CLUSTERED ([cd_tipo_coface] ASC) WITH (FILLFACTOR = 90)
);

