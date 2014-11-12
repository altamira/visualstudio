CREATE TABLE [dbo].[Plano_Academia_Reajuste] (
    [cd_plano_reajuste] INT        NOT NULL,
    [cd_plano]          INT        NOT NULL,
    [dt_plano_reajuste] DATETIME   NULL,
    [vl_plano_reajuste] FLOAT (53) NULL,
    [cd_usuario]        INT        NULL,
    [dt_usuario]        DATETIME   NULL,
    CONSTRAINT [PK_Plano_Academia_Reajuste] PRIMARY KEY CLUSTERED ([cd_plano_reajuste] ASC) WITH (FILLFACTOR = 90)
);

