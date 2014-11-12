CREATE TABLE [dbo].[Parametro_RNC] (
    [cd_empresa]    INT      NOT NULL,
    [ic_layout_rnc] CHAR (1) NULL,
    [cd_usuario]    INT      NULL,
    [dt_usuario]    DATETIME NULL,
    CONSTRAINT [PK_Parametro_RNC] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

