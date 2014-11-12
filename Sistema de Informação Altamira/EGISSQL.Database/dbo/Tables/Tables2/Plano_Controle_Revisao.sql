CREATE TABLE [dbo].[Plano_Controle_Revisao] (
    [cd_plano_controle]         INT      NULL,
    [cd_item_revisao_plano]     INT      NOT NULL,
    [dt_revisao_plano_controle] DATETIME NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Plano_Controle_Revisao] PRIMARY KEY CLUSTERED ([cd_item_revisao_plano] ASC) WITH (FILLFACTOR = 90)
);

