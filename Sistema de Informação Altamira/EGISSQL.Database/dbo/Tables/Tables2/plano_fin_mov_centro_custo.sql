CREATE TABLE [dbo].[plano_fin_mov_centro_custo] (
    [cd_plano_fin_mov_centro_custo] INT        NOT NULL,
    [cd_movimento]                  INT        NOT NULL,
    [cd_centro_custo]               INT        NOT NULL,
    [cd_usuario]                    INT        NULL,
    [pc_centro_custo]               FLOAT (53) NOT NULL,
    [vl_centro_custo]               FLOAT (53) NOT NULL,
    [dt_usuario]                    DATETIME   NULL,
    CONSTRAINT [PK_plano_fin_mov_centro_custo] PRIMARY KEY CLUSTERED ([cd_plano_fin_mov_centro_custo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_plano_fin_mov_centro_custo_Usuario] FOREIGN KEY ([cd_usuario]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

