CREATE TABLE [dbo].[Politica_Viagem_Composicao] (
    [cd_politica_viagem]      INT      NOT NULL,
    [cd_item_politica_viagem] INT      NOT NULL,
    [cd_tipo_politica_viagem] INT      NULL,
    [ds_comp_politica_viagem] TEXT     NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Politica_Viagem_Composicao] PRIMARY KEY CLUSTERED ([cd_politica_viagem] ASC, [cd_item_politica_viagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Politica_Viagem_Composicao_Tipo_Politica_Viagem] FOREIGN KEY ([cd_tipo_politica_viagem]) REFERENCES [dbo].[Tipo_Politica_Viagem] ([cd_tipo_politica_viagem])
);

