CREATE TABLE [dbo].[Celula_Produtiva_Composicao] (
    [cd_planta]                INT          NOT NULL,
    [cd_celula_produtiva]      INT          NOT NULL,
    [cd_item_celula_produtiva] INT          NOT NULL,
    [cd_maquina]               INT          NOT NULL,
    [cd_operador]              INT          NOT NULL,
    [nm_obs_celula_produtiva]  VARCHAR (40) NOT NULL,
    [cd_operacao]              INT          NOT NULL,
    [cd_turno]                 INT          NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Celula_Produtiva_Composicao] PRIMARY KEY CLUSTERED ([cd_planta] ASC, [cd_celula_produtiva] ASC, [cd_maquina] ASC, [cd_operador] ASC, [cd_operacao] ASC, [cd_turno] ASC) WITH (FILLFACTOR = 90)
);

