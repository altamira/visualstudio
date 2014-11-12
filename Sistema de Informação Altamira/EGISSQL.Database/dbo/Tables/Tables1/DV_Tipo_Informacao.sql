CREATE TABLE [dbo].[DV_Tipo_Informacao] (
    [cd_diario_venda]    INT      NOT NULL,
    [cd_tipo_informacao] INT      NOT NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_DV_Tipo_Informacao] PRIMARY KEY CLUSTERED ([cd_diario_venda] ASC, [cd_tipo_informacao] ASC) WITH (FILLFACTOR = 90)
);

