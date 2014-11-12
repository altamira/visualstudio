CREATE TABLE [dbo].[Indice_Reajuste_Valor] (
    [cd_indice_reajuste]      INT        NOT NULL,
    [dt_base_indice_reajuste] DATETIME   NOT NULL,
    [pc_indice_reajuste]      FLOAT (53) NULL,
    [vl_indice_reajuste]      FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Indice_Reajuste_Valor] PRIMARY KEY CLUSTERED ([cd_indice_reajuste] ASC, [dt_base_indice_reajuste] ASC) WITH (FILLFACTOR = 90)
);

