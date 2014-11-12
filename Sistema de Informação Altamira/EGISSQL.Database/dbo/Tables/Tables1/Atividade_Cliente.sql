CREATE TABLE [dbo].[Atividade_Cliente] (
    [cd_atividade_cliente]     INT          NOT NULL,
    [nm_atividade_cliente]     VARCHAR (60) NOT NULL,
    [ds_atividade_cliente]     TEXT         NULL,
    [nm_obs_atividade_cliente] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Atividade_Cliente] PRIMARY KEY CLUSTERED ([cd_atividade_cliente] ASC) WITH (FILLFACTOR = 90)
);

