CREATE TABLE [dbo].[Politica_Viagem] (
    [cd_politica_viagem]   INT          NOT NULL,
    [nm_politica_viagem]   VARCHAR (40) NULL,
    [ds_politica_viagem]   TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_estrutura_empresa] INT          NULL,
    CONSTRAINT [PK_Politica_Viagem] PRIMARY KEY CLUSTERED ([cd_politica_viagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Politica_Viagem_Estrutura_Empresa] FOREIGN KEY ([cd_estrutura_empresa]) REFERENCES [dbo].[Estrutura_Empresa] ([cd_estrutura_empresa])
);

