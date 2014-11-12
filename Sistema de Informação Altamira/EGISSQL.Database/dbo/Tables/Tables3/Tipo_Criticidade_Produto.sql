CREATE TABLE [dbo].[Tipo_Criticidade_Produto] (
    [cd_tipo_criticidade]          INT          NOT NULL,
    [nm_tipo_criticidade]          VARCHAR (40) NULL,
    [nm_fantasia_tipo_criticidade] VARCHAR (15) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Criticidade_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_criticidade] ASC) WITH (FILLFACTOR = 90)
);

