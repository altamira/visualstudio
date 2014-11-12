CREATE TABLE [dbo].[Tipo_Mapa_Categoria] (
    [cd_tipo_mapa_categoria] INT          NOT NULL,
    [nm_tipo_mapa_categoria] VARCHAR (40) NULL,
    [sg_tipo_mapa_categoria] CHAR (10)    NULL,
    [ic_vendas_faturamento]  CHAR (1)     NULL,
    [ic_mensal_anual]        CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Mapa_Categoria] PRIMARY KEY CLUSTERED ([cd_tipo_mapa_categoria] ASC) WITH (FILLFACTOR = 90)
);

