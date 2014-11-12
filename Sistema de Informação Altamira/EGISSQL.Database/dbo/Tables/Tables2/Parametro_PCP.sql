CREATE TABLE [dbo].[Parametro_PCP] (
    [cd_empresa]        INT      NOT NULL,
    [ic_valor_mapa_fab] CHAR (1) NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Parametro_PCP] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

