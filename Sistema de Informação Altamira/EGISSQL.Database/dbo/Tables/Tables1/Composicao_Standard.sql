CREATE TABLE [dbo].[Composicao_Standard] (
    [cd_composicao_standard] INT           NOT NULL,
    [nm_composicao_standard] VARCHAR (40)  NOT NULL,
    [cd_tipo_projeto]        INT           NULL,
    [nm_desenho]             VARCHAR (50)  NULL,
    [nm_caminho_desenho]     VARCHAR (200) NULL,
    [cd_projetista]          INT           NULL,
    [ds_composicao_standard] TEXT          NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_cd_composicao_standard] PRIMARY KEY CLUSTERED ([cd_composicao_standard] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projetista] FOREIGN KEY ([cd_projetista]) REFERENCES [dbo].[Projetista] ([cd_projetista]),
    CONSTRAINT [FK_Tipo_Projeto] FOREIGN KEY ([cd_tipo_projeto]) REFERENCES [dbo].[Tipo_Projeto] ([cd_tipo_projeto])
);

