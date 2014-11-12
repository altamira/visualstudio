CREATE TABLE [dbo].[Contrato_Manutencao_Composicao] (
    [cd_contrato_manutencao] INT          NOT NULL,
    [cd_item_contrato_manut] INT          NOT NULL,
    [cd_equipamento]         INT          NOT NULL,
    [nm_obs_contrato_manut]  VARCHAR (40) NOT NULL,
    [cd_departamento]        INT          NOT NULL,
    [cd_planta]              INT          NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Contrato_Manutencao_Composicao] PRIMARY KEY CLUSTERED ([cd_contrato_manutencao] ASC, [cd_item_contrato_manut] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contrato_Manutencao_Composicao_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Contrato_Manutencao_Composicao_Equipamento] FOREIGN KEY ([cd_equipamento]) REFERENCES [dbo].[Equipamento] ([cd_equipamento])
);

